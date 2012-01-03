# encoding: utf-8

require 'json'
require 'oauth2'
require 'gsquire/client'
require 'gsquire/logging'
require 'gsquire/accounts/tokens'
require 'gsquire/accounts/tasks_api_middleware'

module GSquire
  
  #
  # Main class for GSquire.
  #
  # It handles multiple accounts and maintains a list
  # of {Client} instances, each one associated with one Google account.
  # Each client can then perform actions on tasklists and tasks (read, create,
  # update, delete).
  #
  
  class Accounts
    include Enumerable

    CLIENT_ID = '365482102803.apps.googleusercontent.com'
    CLIENT_SECRET = 'Y3UeEPOUEc60d_DbJOzFsr2Y'
    OAUTH_OUTOFBAND = 'urn:ietf:wg:oauth:2.0:oob'
    GOOGLE_TASKS_SCOPE = 'https://www.googleapis.com/auth/tasks'
    GOOGLE_OAUTH2_AUTH = 'https://accounts.google.com/o/oauth2/auth'
    GOOGLE_OAUTH2_TOKEN = 'https://accounts.google.com/o/oauth2/token'
    DEFAULT_FILE = 'default'

    class NotAuthorized < Exception; end
    class NotFound < Exception; end

    attr_reader :tokens, :logger, :options

    # @option opts [String] :path Path to GSquire database. Required and must exist.
    # @option opts [Logger] :logger Logger instance to be used for logging.
    def initialize(opts = {})
      if opts[:path].nil? || !File.exist?(opts[:path])
        raise ArgumentError, ":path option is required and must exist"
      end
      
      @options = opts
      @logger = options[:logger] || DummyLogger.new
      @tokens = Tokens.new :path => options[:path], :client => oauth_client
      @clients = {}
    end

    def each
      tokens.keys.each {|key| yield key }
    end

    # Returns an account client
    # @param [String] name Account name
    # @return [Client] account client
    def [](name)
      raise NotFound, "Account #{name} not found" unless tokens.include? name

      token = tokens[name]

      if token.expired? and token.refresh_token.to_s.strip.empty?
        @clients.delete name
        raise NotAuthorized, "Token for account #{name} is expired and cannot be renewed"
      end

      if token.expired?
        logger.debug "Token for account #{name} expired, renewing"
        token = tokens.store name, token.refresh!
        @clients[name] = nil
      end

      @clients[name] ||= Client.new token
    end

    # Authorizes GSquire with the token Google gave to user
    # @param [String] name Account name
    # @param [String] code Authorization code provided by Google
    # @return [String] OAuth token string
    def authorize!(name, code)
      token = oauth_client.auth_code.get_token code, redirect_uri: OAUTH_OUTOFBAND
      tokens[name] = token
    end
    alias :[]= :authorize!

    # Removes account
    # @param [String] name Account name
    # @return [OAuth2::AccessToken] Access token associated to that account
    def delete(name)
      tokens.delete name
    end

    # Returns default account name
    # @return [String] default account name
    def default
      @default ||= begin
        name = begin
          File.read(default_path).strip
        rescue Errno::ENOENT
          ""
        end
        if name.empty?
          if tokens.size == 1
            self.default = tokens.first.first
          else
            nil
          end
        else
          if tokens.include?(name)
            name
          else
            self.default = nil
            self.default
          end
        end
      end
    end

    # Sets default account
    # @param [String] name Account name
    def default=(name)
      if name.nil?
        File.truncate default_path, 0
        nil
      else
        raise NotFound, "Account #{name} not found" unless tokens.include?(name)
        File.open(default_path, 'w') {|f| f.write(name) }
        name
      end
    end

    # Use this method to get the URL to show user to authorize GSquire
    # @return [String] authorization URL
    def authorize_url
      oauth_client.auth_code.authorize_url \
        redirect_uri: OAUTH_OUTOFBAND,
        scope: GOOGLE_TASKS_SCOPE
    end

    def inspect
      tokens.keys.inspect
    end

    def to_s
      tokens.keys.to_s
    end

    protected

    def oauth_client
      @oauth_client ||= begin
        OAuth2::Client.new(CLIENT_ID, CLIENT_SECRET,
          authorize_url: GOOGLE_OAUTH2_AUTH,
          token_url: GOOGLE_OAUTH2_TOKEN) do |builder|
            builder.request :url_encoded
            builder.response :logger, logger
            builder.response :raise_error
            builder.use GSquire::Accounts::TasksApiMiddleware
            builder.adapter :net_http
        end
      end
    end

    def default_path
      File.join options[:path], DEFAULT_FILE
    end
  end
end

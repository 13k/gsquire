# encoding: utf-8

require 'json'
require 'oauth2'

module GSquire
  class Accounts
    class Tokens < Hash
      attr_reader :options, :client, :path

      TOKENS_FILE = 'tokens.json'

      # @option opts [String] :path Path to GSquire database. Required and must exist.
      # @option opts [Client] :client {GSquire::Client} instance. Required.
      def initialize(opts = {})
        [:path, :client].each do |o|
          raise ArgumentError, "Option #{o.inspect} is required" unless opts.include?(o)
        end

        @options = opts
        @path = File.join options[:path], TOKENS_FILE
        @client = options[:client]
        
        super
        
        self.load!
      end

      def save
        if dirty?
          File.open(path, 'w') do |f|
            f.write self.to_json
          end
          clean!
        end
        self
      end

      def load!
        hash = begin
            from_json(File.read path)
          rescue JSON::ParserError, Errno::ENOENT
            {}
          end
        replace hash
        clean!
        self
      end

      def dirty?
        @dirty
      end

      def clean?
        !dirty?
      end

      def to_json
        inject({}) do |hash, key_value|
          hash.store key_value[0], token_hash(key_value[1])
          hash
        end.to_json
      end

      def []=(name, token)
        token.params[:name] = name if token.respond_to? :params
        r = super
        dirty!
        save
        r
      end
      alias :store :[]=

      def delete(name)
        r = super
        dirty!
        save
        r
      end

      protected

      def clean!
        @dirty = false
      end

      def dirty!
        @dirty = true
      end

      def token_hash(token)
        return token if not token.is_a? OAuth2::AccessToken

        {
          :access_token => token.token,
          :refresh_token => token.refresh_token,
          :expires_at => token.expires_at,
          :expires_in => token.expires_in
        }
      end

      def from_json(json)
        hash = JSON.parse(json)
        hash.update(hash) do |k, v, *|
          t = OAuth2::AccessToken.from_hash client, v
          t.params[:name] = k
          t
        end
      end
    end
  end
end

# encoding: utf-8

require 'logger'
require 'fileutils'
require 'gsquire/accounts'
require 'gsquire/logging'

module GSquire
  
  #
  # This is the entry-point class for GSquire. Clients should use it to implement applications that use GSquire.
  #
  # As of now it is only a simple container used to setup logging and the database directory.
  #
  # Since GSquire supports multiple accounts by default, this class simply wraps an {Accounts} instance that is available through the `accounts` instance attribute.
  #
  class Application
    # {Accounts} instance that holds all authorized Google accounts in the GSquire database stored at `options[:path]`.
    attr_reader :accounts
    # Parsed options.
    attr_reader :options

    # @option opts [String] :path ("~/.gsquire") Where to store GSquire database
    # @option opts [Logger,String,Symbol] :log (nil) Enables logging. Pass a configured Logger object to be used directly; or a String to change the filename and use the default level (must be absolute path); or a Symbol to change log level and use the default filename. If not present (`nil`), logging is disabled.
    def initialize(opts = {})
      @options = {
        :path => File.join(ENV['HOME'], '.gsquire')
      }.merge(opts)

      begin
        FileUtils.mkdir_p options[:path]
      rescue
        abort "Error creating GSquire database directory: #{$!}"
      end

      @accounts = Accounts.new :path => options[:path], :logger => logger
    end

    protected

    def logger
      @logger ||= begin
        case options[:log]
        when Logger
          options[:log]
        when Symbol, String
          file, level = case options[:log]
            when Symbol
              [File.join(options[:path], 'gsquire.log'), Logger.const_get(options[:log].to_s.upcase)]
            when String
              [options[:log], Logger::INFO]
            end
          log = Logger.new file
          log.progname = 'GSquire'
          log.formatter = Logger::Formatter.new
          log.formatter.datetime_format = "%Y-%m-%d %H:%M:%S "
          log.level = level
          log
        else
          DummyLogger.new
        end
      end
    end
  end
end

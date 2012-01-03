# encoding: utf-8

require 'hashie'

module GSquire
  class Accounts
    class TasksApiMiddleware < Faraday::Response::Middleware
      def on_complete(env)
        if (env[:status] == 200) && json?(env)
          env[:tasks_api_result] = api_result env
        end
      end

      protected

      def api_result(env)
        result = JSON.parse env[:body]
        if result.include? 'items'
          result['items'].map {|h| mash h }
        else
          mash result
        end
      end

      def mash(hash)
        Hashie::Mash.new hash
      end

      def content_type(env)
        k, v = env[:response_headers].find {|k, v| k =~ /content-type/i} || ["", ""]
        v.split(';').first.to_s.downcase
      end

      def json?(env)
        %w(application/json text/javascript).include? content_type(env)
      end
    end
  end
end

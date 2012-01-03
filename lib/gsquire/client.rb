# encoding: utf-8

require 'json'
require 'uri'

module GSquire
  # Very simple Google Tasks API wrapper. It won't perform authentication.
  # Instead, it requires an already authenticated and authorized
  # OAuth2::AccessToken token.
  class Client
    GOOGLE_TASKS_API = URI.parse 'https://www.googleapis.com/tasks/v1'

    attr_accessor :oauth_token

    def initialize(token)
      @oauth_token = token
    end

    # Pulls all task lists for authorized user
    # @return [Array] Array of task list hashes
    def tasklists
      get gtasks_tasklists_url
    end

    # Pulls a task list
    # @param [String] tasklist_id ('@default') Task list ID
    # @return [Hash] task list
    def tasklist(tasklist_id = '@default')
      get gtasks_tasklist_url(tasklist_id)
    end

    def create_tasklist(tasklist)
      post gtasks_tasklists_url, strip(:tasklist, :create, tasklist)
    end

    def update_tasklist(tasklist)
      put gtasks_tasklist_url(tasklist[:id]), strip(:tasklist, :update, tasklist)
    end

    def delete_tasklist(tasklist_id)
      delete gtasks_tasklist_url(tasklist_id)
    end

    # Pulls all tasks of a task list
    # @param [String] tasklist_id ('@default') Task list ID
    # @return [Array] Array of task hashes
    def tasks(tasklist_id = '@default')
      get gtasks_tasks_url(tasklist_id)
    end

    # Pulls a task of a task list
    # @param [String] task_id Task ID
    # @param [String] tasklist_id ('@default') Task list ID
    # @return [Hash] Task hash
    def task(task_id, tasklist_id = '@default')
      get gtasks_task_url(task_id, tasklist_id)
    end

    def create_task(task, tasklist_id = '@default')
      post gtasks_tasks_url(tasklist_id), strip(:task, :create, task)
    end

    protected

    def get(url)
      _ oauth_token.get(url)
    end

    def post(url, content)
      _ oauth_token.post(url, body: content.to_json, headers: {'Content-Type' => 'application/json'})
    end

    def put(url, content)
      _ oauth_token.put(url, body: content.to_json, headers: {'Content-Type' => 'application/json'})
    end

    def delete(url)
      oauth_token.delete(url) and true
    end

    def gtasks_tasklists_url
      gtasks_urls(:tasklists, '@me')
    end

    def gtasks_tasklist_url(tasklist_id = '@default')
      gtasks_urls(:tasklist, '@me', tasklist_id)
    end

    def gtasks_tasks_url(tasklist_id = '@default')
      gtasks_urls(:tasks, tasklist_id)
    end

    def gtasks_task_url(task_id, tasklist_id = '@default')
      gtasks_urls(:task, tasklist_id, task_id)
    end

    def gtasks_urls(resource, *params)
      segments = case resource
        when :tasklists
          "/users/$/lists"
        when :tasklist
          "/users/$/lists/$"
        when :tasks
          "/lists/$/tasks"
        when :task
          "/lists/$/tasks/$"
      end.split('/')
      subpath = segments.map {|seg| seg == '$' ? params.shift : seg }.join('/')
      GOOGLE_TASKS_API.merge(GOOGLE_TASKS_API.path + subpath)
    end

    def strip(entity, method, data)
      meta = %w(id kind selfLink)
      valid = case entity
        when :tasklist
          %w(title)
        when :task
          %w(title notes due status parent previous)
        end
      valid += meta if method == :update
      data.select {|k, *| valid.include? k.to_s }
    end

    def _(result)
      result.response.env[:tasks_api_result]
    end
  end
end
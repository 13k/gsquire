# encoding: utf-8

require 'gsquire/models/task'
require 'gsquire/models/tasklist'

module GSquire
  RESOURCE_KINDS = {
    "tasks#taskList" => Tasklist,
    "tasks#task" => Task
  }.freeze

  class << self
    def resource(hash)
      return nil unless hash.include? 'kind'

      unless RESOURCE_KINDS.include? hash['kind']
        raise ArgumentError, "Unknown resource kind #{hash['kind'].inspect}"
      end

      RESOURCE_KINDS[hash['kind']].new(hash)
    end
  end
end

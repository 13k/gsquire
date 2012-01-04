# encoding: utf-8

require 'hashie'

module GSquire
  class Task < Hashie::Mash
    DATA_ATTRIBUTES = %w[
      id
      title
      parent
      notes
      status
      due
      completed
      deleted
      hidden
    ].freeze

    def data
      select {|k,v| DATA_ATTRIBUTES.include? k }
    end
  end
end

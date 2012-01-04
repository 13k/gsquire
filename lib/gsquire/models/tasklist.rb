# encoding: utf-8

require 'hashie'

module GSquire
  class Tasklist < Hashie::Mash
    DATA_ATTRIBUTES = %w[
      id
      title
    ].freeze

    def data
      select {|k,v| DATA_ATTRIBUTES.include? k }
    end
  end
end

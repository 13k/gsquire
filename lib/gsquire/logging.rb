# encoding: utf-8

module GSquire
  # Fake logger, does nothing when its methods are called
  class DummyLogger
    FAKE_METHODS = %w[<< add log debug error fatal info unknown warn]

    FAKE_METHODS.each do |method|
      define_method(method) {|*| }
    end
  end
end

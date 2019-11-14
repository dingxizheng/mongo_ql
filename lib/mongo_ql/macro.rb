# frozen_string_literal: true

module MongoQL
  class Macro
    class << self
      attr_accessor :macros

      def register(name, &block)
        self.macros << MongoQL::Macro.new(name, &block)
      end

      def eval(name)
        m = macro(name)
        raise ArgumentError, "macro `$macro_#{name}` is not registered!" if m.nil?
        m.proc.call
      end

      def has_macro?(name)
        !macro(name).nil?
      end

      def macro(name)
        self.macros.detect { |m| m.name.to_s == name.to_s }
      end

      def macros
        @macros ||= []
      end
    end

    attr_accessor :name, :proc

    def initialize(name, &block)
      @name = name
      @proc = block
    end
  end
end
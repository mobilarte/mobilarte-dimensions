require 'sketchup'
require_relative 'observer/app_observer'

module Mobilarte
  module Dimensions
    class Plugin
      def initialize
        Sketchup.add_observer(AppObserver.new)
      end
    end
  end
end
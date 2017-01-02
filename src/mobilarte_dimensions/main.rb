require 'sketchup'
require_relative 'ruby/plugin'

module Mobilarte
	module Dimensions
		unless file_loaded?(__FILE__)
			plugin = Plugin.new
			file_loaded(__FILE__)
		end
	end
end

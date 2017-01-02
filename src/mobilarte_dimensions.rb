require 'sketchup'
require 'extensions'
require 'langhandler'

module Mobilarte
	module Dimensions
		unless file_loaded?(__FILE__)

			# Language Handler not yet implemented
	  	#@lh = LanguageHandler.new('dimensions.strings')
	  	#class << self; attr_accessor :lh; end
	  
			ex = SketchupExtension.new('Mobilarte Dimensions', 'mobilarte_dimensions/main')
			ex.description = 'Toolbox for woodworkers - Dimensions'
			ex.version = '0.0.1'
      ex.copyright = 'maxsyma.com © 2017 - GPL'
      ex.creator = 'Martin Mueller www.maxsyma.com'
      Sketchup.register_extension(ex, true)
      file_loaded(__FILE__)
		end
	end
end
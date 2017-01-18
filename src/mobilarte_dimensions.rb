require 'sketchup'
require 'extensions'
require 'langhandler'

module Mobilarte
  module Dimensions
    unless file_loaded?(__FILE__)

      # Language Handler implemented globally
      @lh = LanguageHandler.new('dimensions.strings')
      class << self; attr_accessor :lh, :ex end

      self.ex = SketchupExtension.new('Mobilarte Dimensions', 'mobilarte_dimensions/main')
      self.ex.description = Dimensions.lh['Toolbox for Woodworkers - Dimensions']
      self.ex.version = '0.0.1'
      self.ex.copyright = 'maxsyma.com © 2017 - GPL'
      self.ex.creator = 'Martin Mueller www.maxsyma.com'
      Sketchup.register_extension(self.ex, true)
      file_loaded(__FILE__)
    end
  end
end

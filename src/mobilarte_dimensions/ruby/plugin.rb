require 'sketchup'
#require_relative 'observer/selection_observer'
require_relative 'observer/app_observer'


module Mobilarte
	module Dimensions
		
		class Plugin
						
			def initialize
			
				Sketchup.add_observer(AppObserver.new)
				
				#cmd = UI::Command.new("Dimensions") { 
				#	Sketchup.active_model.rendering_options["DisplayDims"] = !Sketchup.active_model.rendering_options["DisplayDims"]
				#}
				#cmd.tooltip = "Show/Hide Dimensions"
				#cmd.set_validation_proc {
				#	if Sketchup.active_model.rendering_options["DisplayDims"]
				#		MF_CHECKED
				#	else
				#		MF_UNCHECKED
				#	end
				#}
				#UI.menu("View").add_item(cmd)
			end
		end
	end
end
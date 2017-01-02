require 'sketchup.rb'
require 'extensions.rb'

module Mobilarte
	module Dimensions
		class SelectionObserver < Sketchup::SelectionObserver

			@observer_active

			def initialize
				@observer_active = false   
				toggle_observer
			end

			def onSelectionBulkChange(selection)
				if @observer_active
					entity = selection[0]
					if entity.is_a? Sketchup::ComponentInstance
						bounds = _compute_faces_bounds(entity.definition)
						dims = [bounds.width, bounds.height, bounds.depth]
						l = "L: "
						w = "W: "
						t = "T: "
						Sketchup.set_status_text((l + dims[0].to_s + " " + w + dims[1].to_s + " " + t + dims[2].to_s), SB_PROMPT)
					end
				end
			end
			
			def is_observer_active
				if @observer_active
					MF_CHECKED
				else
					MF_UNCHECKED
				end
			end
			
			def toggle_observer
				if @observer_active
					@observer_active = false
					Sketchup.active_model.selection.remove_observer self
					MF_UNCHECKED
				else
					@observer_active = true
					Sketchup.active_model.selection.add_observer self
					MF_CHECKED
				end
			end
			
			def _compute_faces_bounds(definition)
				bounds = Geom::BoundingBox.new
				definition.entities.each { |entity|
					if entity.is_a? Sketchup::Face
						bounds.add(entity.bounds)
					elsif entity.is_a? Sketchup::Group
						bounds.add(_compute_faces_bounds(entity))
					end
				}
				bounds
			end
		end
	end
end

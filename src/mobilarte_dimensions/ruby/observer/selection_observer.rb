#require 'sketchup'
#require 'extensions'

module Mobilarte
  module Dimensions
    class SelectionObserver < Sketchup::SelectionObserver

      ATTRIBUTE_DICTIONARY = 'mobilarte'

      @observer_active
      @lu
      @lf
      
      def initialize        
        toggle_observer

        # not used for now, left here
        @lu = {Length::Inches => Dimensions.lh['inches'], 
              Length::Feet => Dimensions.lh['feet'], 
              Length::Millimeter => Dimensions.lh['millimeter'],
              Length::Centimeter => Dimensions.lh['centimeter'],
              Length::Meter => Dimensions.lh['meter']}
        # not used for now, left here
        @lf = {Length::Decimal => Dimensions.lh['decimal'],
              Length::Architectural => Dimensions.lh['architectural'],
              Length::Engineering => Dimensions.lh['engineering'],
              Length::Fractional => Dimensions.lh['fractional']}
      end

      def onSelectionBulkChange(selection)
        if @observer_active
          entity = selection[0]
          if entity.is_a? Sketchup::ComponentInstance
            bounds = _compute_faces_bounds(entity.definition)
            dims = [bounds.width, bounds.height, bounds.depth]
            l = Dimensions.lh['L: ']
            w = Dimensions.lh['W: ']
            t = Dimensions.lh['T: ']
            status_text = (l + dims[0].to_s + ' ' + w + dims[1].to_s + ' ' + t + dims[2].to_s)
            Sketchup.set_status_text(status_text, SB_VCB_VALUE)
          end
        end
      end
      
      def onSelectionCleared(selection)
         Sketchup.set_status_text('', SB_VCB_VALUE)
      end

      def is_observer_active
        if @observer_active
          MF_CHECKED
        else
          MF_UNCHECKED
        end
      end

      def toggle_observer
        create_if_nil = true
        model = Sketchup.active_model
        attrdict = model.attribute_dictionary ATTRIBUTE_DICTIONARY, create_if_nil
        bbox = attrdict["bbox"]
        if bbox == nil or !bbox
          @observer_active = true
          attrdict["bbox"] = true
          Sketchup.active_model.selection.add_observer self
        else
          @observer_active = false
          attrdict["bbox"] = false
          Sketchup.active_model.selection.remove_observer self
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

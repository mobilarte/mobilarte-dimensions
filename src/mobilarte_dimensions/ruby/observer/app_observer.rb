require 'sketchup'
require_relative 'selection_observer'

module Mobilarte
  module Dimensions
    class AppObserver < Sketchup::AppObserver

      ATTRIBUTE_DICTIONARY = 'mobilarte'

      @selection_observer
      @active_model

      def initialize
        @selection_observer = SelectionObserver.new
        @active_model = Sketchup.active_model
        UI.menu("Tools").add_separator
        bbox = UI::Command.new(Dimensions.lh['BoundingBox Size']){
          @selection_observer.toggle_observer()
        }
        bbox.set_validation_proc {
          @selection_observer.is_observer_active()
        }
        UI.menu("Tools").add_item bbox

        dims = UI::Command.new(Dimensions.lh['Dimensions']){
          @active_model.rendering_options['DisplayDims'] = !@active_model.rendering_options['DisplayDims']
          attrdict = @active_model.attribute_dictionary(ATTRIBUTE_DICTIONARY)
          attrdict["ddims"] = @active_model.rendering_options['DisplayDims']
        }
        dims.set_validation_proc {
          if @active_model.rendering_options['DisplayDims']
            MF_CHECKED
          else
            MF_UNCHECKED
          end
        }
        UI.menu("Tools").add_item dims

        _set_display_dims
      end

      def onNewModel(model)
        @active_model = model
        _set_display_dims
        _add_selection_observer
      end

      def onOpenModel(model)
        @active_model = model
        _set_display_dims
        _add_selection_observer
      end

      def onActivateModel(model)
        @active_model = model
        _set_display_dims
        _add_selection_observer
      end

      def _add_selection_observer
        if @active_model
          @active_model.selection.add_observer @selection_observer
        end
      end

      def _set_display_dims
        create_if_nil = true
        attrdict = @active_model.attribute_dictionary ATTRIBUTE_DICTIONARY, create_if_nil
        ddims = attrdict["ddims"]
        if ddims == nil
          Sketchup.active_model.rendering_options['DisplayDims'] = true
          attrdict["ddims"] = true
        else
          Sketchup.active_model.rendering_options['DisplayDims'] = ddims
        end
      end
    end
  end
end

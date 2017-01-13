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
        plugins_menu = UI.menu('Tools')
        plugins_menu.add_separator
        d_item = plugins_menu.add_item(Dimensions.lh['BoundingBox Size']){@selection_observer.toggle_observer()}
        plugins_menu.set_validation_proc(d_item){@selection_observer.is_observer_active()}

        _set_display_dims

        s_item = plugins_menu.add_item(Dimensions.lh['Dimensions']){
          @active_model.rendering_options['DisplayDims'] = !@active_model.rendering_options['DisplayDims']
          attrdict = @active_model.attribute_dictionary(ATTRIBUTE_DICTIONARY)
          attrdict["ddims"] = @active_model.rendering_options['DisplayDims']
        }
        plugins_menu.set_validation_proc(s_item){
          if @active_model.rendering_options['DisplayDims']
            MF_CHECKED
          else
            MF_UNCHECKED
          end
        }
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
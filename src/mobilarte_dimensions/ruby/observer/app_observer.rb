require 'sketchup'
require_relative 'selection_observer'

module Mobilarte
  module Dimensions
    class AppObserver < Sketchup::AppObserver

      @selection_observer
      @active_model

      def initialize
        @selection_observer = SelectionObserver.new
        @active_model = Sketchup.active_model
        plugins_menu = UI.menu('Tools')
        plugins_menu.add_separator
        d_item = plugins_menu.add_item(Dimensions.lh['BoundingBox Size']){@selection_observer.toggle_observer()}
        plugins_menu.set_validation_proc(d_item){@selection_observer.is_observer_active()}
        if Sketchup.read_default("mobilarte", "ddims", true)
          @active_model.rendering_options['DisplayDims'] = true
        else
          @active_model.rendering_options['DisplayDims'] = false
        end      
        Sketchup.write_default("mobilarte", "ddims", @active_model.rendering_options['DisplayDims'])

        s_item = plugins_menu.add_item(Dimensions.lh['Dimensions']){
          Sketchup.active_model.rendering_options['DisplayDims'] = !Sketchup.active_model.rendering_options['DisplayDims']
          Sketchup.write_default("mobilarte", "ddims", Sketchup.active_model.rendering_options['DisplayDims'])
        }
        plugins_menu.set_validation_proc(s_item){
          if Sketchup.active_model.rendering_options['DisplayDims']
            MF_CHECKED
          else
            MF_UNCHECKED
          end
        }
      end

      def onNewModel(model)
        @active_model = model
        _add_selection_observer
      end

      def onOpenModel(model)
        @active_model = model
        _add_selection_observer
      end

      def onActivateModel(model)
        @active_model = model
        _add_selection_observer
      end

      def _add_selection_observer
        if @active_model
          @active_model.selection.add_observer @selection_observer
        end
      end
    end
  end
end
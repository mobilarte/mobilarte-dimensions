require 'sketchup'
require_relative 'selection_observer.rb'

module Mobilarte
  module Dimensions
    class AppObserver < Sketchup::AppObserver

      @selection_observer
      
      def initialize
        @selection_observer = SelectionObserver.new
        plugins_menu = UI.menu('Tools')
        plugins_menu.add_separator
        d_item = plugins_menu.add_item(Dimensions.lh['BoundingBox Size']){@selection_observer.toggle_observer()}
        plugins_menu.set_validation_proc(d_item){@selection_observer.is_observer_active()}
        s_item = plugins_menu.add_item(Dimensions.lh['Dimensions']){
          Sketchup.active_model.rendering_options['DisplayDims'] = !Sketchup.active_model.rendering_options['DisplayDims']
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
        model.selection.add_observer @selection_observer 
      end
      
      def onOpenModel(model)
        model.selection.add_observer @selection_observer 
      end
      
      def onActivateModel(model)
        model.selection.add_observer @selection_observer 
      end
    end
  end
end
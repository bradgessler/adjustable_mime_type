module AdjustableMimeType
  
  module RegisterAliasExtension
    def self.included(base)
      base.send :extend, ClassMethods
    end
    
    module ClassMethods
      def register_alias_with_adjustable_formats(*args, &block)
        format = register_alias_without_adjustable_formats *args
        adjustable_formats[format] = block
        format
      end
      
      def adjust_format(request)
        if format = adjustable_formats.find{|format, block| block.call(request) }
          symbol, block = format
          request.format = format
        end
      end
      
      def adjustable_formats
        @adjustable_formats ||= {}
      end
    end
  end
  
  module ControllerFilter
    def self.included(base)
      base.class_eval do
        before_filter :adjust_mime_type_format
      end
    end
    
  private
    # Adjusts the incoming format based aliases with defined request blocks
    def adjust_mime_type_format
      Mime::Type.adjust_format(request)
    end
  end
  
end
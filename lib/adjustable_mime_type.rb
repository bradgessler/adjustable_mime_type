module AdjustableMimeType
  def self.init!
    ::Mime::Type.send :include, AdjustableMimeType::RegisterAliasExtension
    ::ActionController::Base.send :include, AdjustableMimeType::ControllerFilter
  end
  
  module RegisterAliasExtension
    def self.included(base)
      base.send :extend, ClassMethods
      base.class_eval do
        class << self
          alias_method_chain :register_alias, :adjustable_format
        end
      end
    end
    
    module ClassMethods
      def register_alias_with_adjustable_format(string, symbol, extension_synonyms=[], &block)
        adjustable_formats[symbol] = block
        register_alias_without_adjustable_format(string, symbol, extension_synonyms)
      end
      
      def adjust_format(request)
        if adjustable_format = adjustable_formats.find{|format, block| block.call(request) }
          symbol, block = adjustable_format
          request.format = symbol
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
      Mime::Type.adjust_format(request) unless params.include?(:format)
    end
  end
  
end
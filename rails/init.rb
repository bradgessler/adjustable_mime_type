require File.join(File.dirname(__FILE__), '../lib/adjustable_mime_type')

Mime::Type.send :include, AdjustableMimeType::RegisterAliasExtension
ActionController::Base.send :include, AdjustableMimeType::ControllerFilter
$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'spec'
require 'spec/autorun'

# Force RoR 2.3.x
require 'rubygems'
gem 'actionpack', '2.3.5'

require 'action_controller'
require 'action_controller/test_process'

require 'adjustable_mime_type'

include ActionController::TestProcess

Spec::Runner.configure do |config|
end

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

AdjustableMimeType.init!

Mime::Type.register_alias "text/html", :iphone do |req|
  req.user_agent =~ /Mobile.*Safari/
end

class PenguinsController < ActionController::Base
  def index
    respond_to do |wants|
      wants.html   { render :text => 'html' }
      wants.iphone { render :text => 'iphone' }
    end
  end
end

describe "AdjustableMimeType" do
  before(:each) do
    @controller = PenguinsController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
    
    ActionController::Routing::Routes.draw do |map|
      map.resources :penguins
    end
  end
  
  it "should adjust format" do
    @request.user_agent = 'Mobile Safari'
    get :index
    @response.body.should eql('iphone')
  end
  
  it "should not adjust format" do
    get :index
    @response.body.should eql('html')
  end
  
  it "should not ovveride explicit .formats" do
    @request.user_agent = 'Mobile Safari'
    get :index, :format => 'html'
    @response.body.should eql('html')
  end
end

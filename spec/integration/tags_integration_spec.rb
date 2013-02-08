require 'spec_helper'

describe "Emotejiji::API::Tags" do
  describe "GET" do
    specify "/v1/tags/:tag" do
      start_transaction
      tag = Tag.new text: "foobaz", description: "an awesome tag"
      end_transaction
      get "/v1/tags/#{tag.text}"
      
      last_response.status.should == 200
      hash = JSON.parse(last_response.body)
      hash["uid"].should == tag.uid
      hash["text"].should == tag.text
      hash["description"].should == tag.description
    end
  end
  
  describe "POST" do
    describe "/v1/tags" do
      specify "should succeed and persist with valid params" do
        params = { text: "foobar", description: "an awesome tag" }
        post "/v1/tags", params
        
        last_response.status.should == 201
        hash = JSON.parse(last_response.body)
        hash["uid"].should_not == ""
        hash["text"].should == params[:text]
        hash["description"].should == params[:description]
      end
    end
  end
end
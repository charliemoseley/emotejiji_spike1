require 'spec_helper'

describe "Emotejiji::API::Emoticons" do
  describe "POST" do
    describe "/v1/emoticons" do
      specify "should succeed and persist with valid params" do
        params = { text: "foobar", description: "it's a foobar" }
        post "/v1/emoticons", params
        
        last_response.status.should == 201
        hash = JSON.parse(last_response.body)
        hash["text"].should == params[:text]
        hash["description"].should == params[:description]
        hash["number_of_lines"].should == 1
        hash["longest_line_count"].should == params[:text].length
      end
    end
  end
end
require 'spec_helper'

describe "Emotejiji::API::Emoticons" do
  describe "GET" do
    specify "/v1/emoticons/:uid" do
      start_transaction
      emoticon = Emoticon.new text: "foobaz"
      end_transaction
      get "/v1/emoticons/#{emoticon.uid}"
      
      last_response.status.should == 200
      hash = JSON.parse(last_response.body)
      hash["text"].should == emoticon.text
      hash["description"].should == emoticon.description
      hash["number_of_lines"].should == emoticon.number_of_lines
      hash["longest_line_count"].should == emoticon.longest_line_count
    end
  end
  
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
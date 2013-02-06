require 'spec_helper'

describe "Neo4j::Emoticon" do
  before :each do
    start_transaction
  end
  
  it "should respond with it's properties" do
    emoticon = Emoticon.new
    emoticon.should respond_to :uid, :text, :description, :number_of_lines, 
                               :longest_line_count
  end
  
  it "should be able to create with valid params" do
    params = { uid: "foobar", text: "asdf", description: "foobaz foobar!",
               number_of_lines: 1, longest_line_count: 7 }
    emoticon = Emoticon.new params
    emoticon.uid.should == "foobar"
  end
  
  after :each do
    end_transaction
  end
end
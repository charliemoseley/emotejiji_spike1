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
  
  describe "private methods" do
    it "should count the number of lines in a single line emoticon" do
      params = { text: "the foorbar jumped over the moon" }
      lines = params[:text].lines.count
      
      emoticon = Emoticon.new params
      emoticon.number_of_lines.should == lines
    end
    
    it "should count the number of lines for a multi line emoticon" do
      params = { text: "the foorbar\njumped over the moon\nto jupitar" }
      lines = params[:text].lines.count
      
      emoticon = Emoticon.new params
      emoticon.number_of_lines.should == lines
    end
    
    it "should be able to count the longest line in a single line emoticon" do
      params = { text: "the foorbar jumped over the moon" }
      longest_line = params[:text].lines.map { |line| line.length }.max
      
      emoticon = Emoticon.new params
      emoticon.longest_line_count.should == longest_line
    end
    
    it "should be able to count the longest line in a multi line emoticon" do
      params = { text: "the foorbar\njumped over the moon\nto jupitar" }
      longest_line = params[:text].lines.map { |line| line.length }.max
      
      emoticon = Emoticon.new params
      emoticon.longest_line_count.should == longest_line
    end
  end
  
  after :each do
    end_transaction
  end
end
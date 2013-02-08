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
    params = { text: "foobar", description: "foobaz foobar!" }
    emoticon = Emoticon.new params
    
    emoticon.text.should == "foobar"
    emoticon.description.should == "foobaz foobar!"
  end
  
  it "should be able to save missing a description" do
    params = { text: "foobar" }
    emoticon = Emoticon.new params
    
    emoticon.text.should == "foobar"
    emoticon.description.should be_nil
  end
  
  it "should not be able to save with missing text"
  
  describe "initialization methods" do
    it "should generate a random unique uid 10 characters in length" do
      params = { text: "the foorbar jumped over the moon" }
      
      emoticon = Emoticon.new params
      emoticon.uid.length.should == 10
    end
    
    describe "line counting" do
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
  end
  
  after :each do
    end_transaction
  end
end
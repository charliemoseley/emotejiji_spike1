require 'spec_helper'

describe "Neo4j::Emoticon" do
  before :each do
    start_transaction
  end
  
  it "should respond with it's properties" do
    emoticon = Emoticon.new text: "foobar"
    emoticon.should respond_to :uid, :text, :description, :number_of_lines, 
                               :longest_line_count
  end
  
  it "should raise an error if no text is passed" do
    lambda { Emoticon.new }.should raise_error
  end
  
  it "should be able to create with valid params" do
    emoticon = Emoticon.new text: "foobar", description: "foobaz foobar!"
    
    emoticon.text.should == "foobar"
    emoticon.description.should == "foobaz foobar!"
  end
  
  it "should be able to save missing a description" do
    emoticon = Emoticon.new text: "foobar"
    
    emoticon.text.should == "foobar"
    emoticon.description.should == ""
  end
  
  it "should not be able to save with missing text"
  
  describe "initialization methods" do
    it "should generate a random unique uid 10 characters in length" do
      emoticon = Emoticon.new text: "the foorbar jumped over the moon"
      emoticon.uid.length.should == 10
    end
    
    describe "line counting" do
      it "should count the number of lines in a single line emoticon" do
        text =  "the foorbar jumped over the moon"
        lines = text.lines.count
        emoticon = Emoticon.new text: text
        
        emoticon.number_of_lines.should == lines
      end
      
      it "should count the number of lines for a multi line emoticon" do
        text = "the foorbar\njumped over the moon\nto jupitar"
        lines = text.lines.count
        emoticon = Emoticon.new text: text
        
        emoticon.number_of_lines.should == lines
      end
      
      it "should be able to count the longest line in a single line emoticon" do
        text = "the foorbar jumped over the moon" 
        longest_line = text.lines.map { |line| line.length }.max
        emoticon = Emoticon.new text: text
        
        emoticon.longest_line_count.should == longest_line
      end
      
      it "should be able to count the longest line in a multi line emoticon" do
        text = "the foorbar\njumped over the moon\nto jupitar"
        longest_line = text.lines.map { |line| line.length }.max
        emoticon = Emoticon.new text: text
        
        emoticon.longest_line_count.should == longest_line
      end
    end
  end
  
  after :each do
    end_transaction
  end
end
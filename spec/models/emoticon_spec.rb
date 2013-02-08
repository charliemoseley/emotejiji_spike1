require 'spec_helper'

describe "Neo4j::Emoticon" do
  before :each do
    @params = { text: "the foorbar jumped over the moon", 
                description: "the is a crazy foobar to be jumping" }
  end
  
  it "should raise an error if no text is passed" do
    lambda { Emoticon.new }.should raise_error
  end
  
  it "should be able to save while missing a description" do
    start_transaction
    emoticon = Emoticon.new text: "foobar"
    end_transaction
    
    emoticon.text.should == "foobar"
    emoticon.description.should == ""
  end
  
  describe "initialization" do
    describe "with a single line text field" do
      before :each do
        start_transaction
        @emoticon = Emoticon.new @params
        end_transaction
      end
      
      it "should respond with it's properties" do
        @emoticon.should respond_to :uid, :text, :description, :number_of_lines, 
                                    :longest_line_count
      end
      
      it "should be able to create with valid params" do
        @emoticon.text.should == @params[:text]
        @emoticon.description.should == @params[:description]
      end
      
      it "should generate a random unique uid 10 characters in length" do
        @emoticon.uid.length.should == 10
      end
      
      it "should count the number of lines" do
        @emoticon.number_of_lines.should == @params[:text].lines.count
      end
      
      it "should be able to count the longest line" do
        longest_line = @params[:text].lines.map { |line| line.length }.max
        @emoticon.longest_line_count.should == longest_line
      end
    end
    
    describe "with a multi line text field" do
      before :each do
        start_transaction
        @params[:text] = "the foorbar\njumped over the moon\nto jupitar"
        @emoticon = Emoticon.new @params
        end_transaction
      end
      
      it "should count the number of lines" do
        @emoticon.number_of_lines.should == @params[:text].lines.count
      end
      
      it "should be able to count the longest line" do
        longest_line = @params[:text].lines.map { |line| line.length }.max
        @emoticon.longest_line_count.should == longest_line
      end
    end
  end
  
  describe "finders" do
    before :each do
      start_transaction
      @emoticon = Emoticon.new @params
      end_transaction
    end
    
    it "#find_by_uid should return an emote if it exists" do
      Emoticon.find_by_uid(@emoticon.uid).uid.should == @emoticon.uid
    end
    
    it "#find_by_uid should return nil if no emote exists" do
      Emoticon.find_by_uid("NOTVALID").should == nil
    end
  end
  
  describe "counters" do
    before :each do
      delete_all_created_nodes
      start_transaction
      @emoticon1 = Emoticon.new @params
      @emoticon2 = Emoticon.new @params.merge text: "I'm different!"
      end_transaction
    end
    
    it "#all should return the total amount of emotes in the system" do
      Emoticon.all.each do |emote|
        emote.should be_kind_of(Emoticon)
      end
    end
    
    it "#all.count should reutn the numeric amount of emotes" do
      Emoticon.all.count.should == 2
    end
  end
end
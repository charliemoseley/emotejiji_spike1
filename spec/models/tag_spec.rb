require 'spec_helper'

describe "Neo4j::Tag" do
  before :each do
    @params = { text: "awesome", 
                description: "this is an awesome tag" }
  end
  
  it "should raise an error if no text is passed" do
    lambda { Tag.new }.should raise_error
  end
  
  it "should be able to save while missing a description" do
    start_transaction
    tag = Tag.new text: "foobar"
    end_transaction
    
    tag.text.should == "foobar"
    tag.description.should == ""
  end
  
  describe "initialization" do
    describe "with a single line text field" do
      before :each do
        start_transaction
        @tag = Tag.new @params
        end_transaction
      end
      
      it "should respond with it's properties" do
        @tag.should respond_to :uid, :text, :description
      end
      
      it "should be able to create with valid params" do
        @tag.text.should == @params[:text]
        @tag.description.should == @params[:description]
      end
      
      it "should generate a random unique uid 10 characters in length" do
        @tag.uid.length.should == 10
      end
    end
  end
  
  describe "finders" do
    before :each do
      start_transaction
      @tag = Tag.new @params
      end_transaction
    end
    
    it "#find_by_text should return an emote if it exists" do
      Tag.find_by_text(@tag.text).text.should == @tag.text
    end
    
    it "#find_by_text should return nil if no emote exists" do
      Tag.find_by_text("NOTVALID").should == nil
    end
  end
  
  describe "counters" do
    before :each do
      delete_all_created_nodes
      start_transaction
      @tag1 = Tag.new @params
      @tag2 = Tag.new @params.merge text: "I'm different!"
      end_transaction
    end
    
    it "#all should return the total amount of emotes in the system" do
      Tag.all.each do |tag|
        tag.should be_kind_of(Tag)
      end
    end
    
    it "#all.count should reutn the numeric amount of emotes" do
      Tag.all.count.should == 2
    end
  end
end
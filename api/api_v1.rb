module Emotejiji
  class API_v1 < Grape::API
    version 'v1', using: :path, vendor: 'emotejiji', format: :json
    rescue_from :all do |e|
      Rack::Response.new([ e.message ], 500, { "Content-type" => "text/error" }).finish
    end
    
    resource :system do
      desc "Returns pong."
      get :ping do
        { :ping => "pong" }
      end
      desc "Raises an exception."
      get :raise do
        raise "Unexpected error."
      end
    end
    
    resource :emoticon do
      desc "Returns emoticons."
      
      get :create do
        Neo4j::Transaction.run do
          Emoticon.new uid: "foobar#{rand(5)}", text: "^_^", description: "a smiley face", 
                       number_of_lines: 1, characters_in_longest_line: 10
        end
        
        { success: "yes" }
      end
      
      get ':uid' do
        e = Emoticon.find(uid: params[:uid]).first
        
        if e.nil?
          { response: "sorry no results" }
        else
          { text: e.text }
        end
      end
    end
  end
end

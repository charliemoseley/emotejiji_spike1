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
    
    resource :emoticons do
      desc "Returns emoticons."
      
      get '/:uid' do
        @emoticon = Emoticon.find(uid: params.uid).first
        
        present @emoticon, with: Emotejiji::Entities::Emoticon
      end
      
      post '/' do
        Neo4j::Transaction.run do
          @emoticon = Emoticon.new text: params.text, description: params.description
        end
        
        present @emoticon, with: Emotejiji::Entities::Emoticon
      end
    end
  end
end

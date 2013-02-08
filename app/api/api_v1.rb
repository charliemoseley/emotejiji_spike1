module Emotejiji
  class API_v1 < Grape::API
    version 'v1', using: :path, vendor: 'emotejiji', format: :json
    rescue_from :all do |e|
      Rack::Response.new([ e.message ], 500, { "Content-type" => "text/error" }).finish
    end
    
    resource :emoticons do
      desc "Returns emoticons."
      
      get '/:uid' do
        @emoticon = Emoticon.find_by_uid params.uid
        present @emoticon, with: Emotejiji::Entities::Emoticon
      end
      
      post '/' do
        Neo4j::Transaction.run do
          @emoticon = Emoticon.new text: params.text, description: params.description
        end
        present @emoticon, with: Emotejiji::Entities::Emoticon
      end
    end
    
    resource :tags do
      desc "Returns tags."
      
      get '/:text' do
        @tag = Tag.find_by_text params.text
        present @tag, with: Emotejiji::Entities::Tag
      end
      
      post '/' do
        Neo4j::Transaction.run do
          @tag = Tag.new text: params.text, description: params.description
        end
        present @tag, with: Emotejiji::Entities::Tag
      end
    end
  end
end

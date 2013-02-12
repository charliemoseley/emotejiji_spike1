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
      
      put '/:uid' do
        valid_params = {}
        valid_params[:text] = params.text if params.text
        valid_params[:description] = params.description if params.description
        valid_params[:tags] = params.tags if params.tags
        
        Neo4j::Transaction.run do
          @emoticon = Emoticon.find_by_uid params.uid
          @emoticon.update valid_params
          # TODO: Move this into emoticon's create/update method?
          if valid_params[:tags]
            valid_params[:tags].each { |tag| @emoticon.tags << Tag.new(text: tag) }
          end
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

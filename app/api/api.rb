module Emotejiji
  class API < Grape::API
    format :json
    mount ::Emotejiji::API_v1
  end
end


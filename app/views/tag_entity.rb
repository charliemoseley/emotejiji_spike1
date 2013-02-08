module Emotejiji
  module Entities
    class Tag < Grape::Entity
      expose :uid
      expose :text
      expose :description
    end
  end
end
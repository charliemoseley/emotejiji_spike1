module Emotejiji
  module Entities
    class Emoticon < Grape::Entity
      expose :uid
      expose :text
      expose :description
      expose :number_of_lines
      expose :longest_line_count
      expose :tags, using: Emotejiji::Entities::Tag
    end
  end
end
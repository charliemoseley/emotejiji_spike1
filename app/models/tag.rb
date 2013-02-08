class Tag
  include Neo4j::NodeMixin
  
  property :uid, index: :exact
  property :text, index: :fulltext
  property :description
end
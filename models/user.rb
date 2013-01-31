class User
  include Neo4j::NodeMixin
  
  property :uid, index: :exact
  property :username, index: :fulltext
end
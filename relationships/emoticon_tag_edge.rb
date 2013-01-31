class EmoticonTagEdge
  include Neo4j::RelationshipMixin
  
  property :weight, type: Fixnum
end
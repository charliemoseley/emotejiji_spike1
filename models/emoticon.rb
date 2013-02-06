class Emoticon
  include Neo4j::NodeMixin
  
  property :uid, index: :exact
  property :text
  property :description
  property :number_of_lines,    type: Fixnum, index: :fulltext
  property :longest_line_count, type: Fixnum
  
  rule :all, functions: [Neo4j::Wrapper::Rule::Functions::Size.new]
end
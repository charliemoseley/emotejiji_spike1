class Emoticon
  include Neo4j::NodeMixin
  
  property :uid, index: :exact
  property :text
  property :description
  property :number_of_lines,    type: Fixnum, index: :fulltext
  property :longest_line_count, type: Fixnum
  
  rule :all, functions: [Neo4j::Wrapper::Rule::Functions::Size.new]
  
  class << self
    def new(*args)
      if args.last.is_a? Hash
        args.last[:number_of_lines] = count_number_of_lines(args.last[:text])
        args.last[:longest_line_count] = count_longest_line(args.last[:text])
      end
      
      super
    end
  
    private
    
    def count_number_of_lines(text)
      text.lines.count unless text.nil?
    end
    
    def count_longest_line(text)
      text.lines.map { |line| line.length }.max unless text.nil?
    end
  end
end
class Emoticon
  include Neo4j::NodeMixin
  
  property :uid, index: :exact
  property :text
  property :description
  property :number_of_lines,    type: Fixnum, index: :fulltext
  property :longest_line_count, type: Fixnum
  
  rule :all, functions: [Neo4j::Wrapper::Rule::Functions::Size.new]
  
  def init_on_create(*args)
    self[:uid] = generate_uid
    if args.last.is_a? Hash
      self[:text] = args.last[:text]
      self[:description] = args.last[:description]
      self[:number_of_lines] = count_number_of_lines args.last[:text]
      self[:longest_line_count] = count_longest_line args.last[:text]
    end
  end
  
  private
  
  def generate_uid
    Base32::Crockford.encode(UUIDTools::UUID.random_create.raw).downcase[0..9]
  end
    
  def count_number_of_lines(text)
    text.lines.count unless text.nil?
  end
  
  def count_longest_line(text)
    text.lines.map { |line| line.length }.max unless text.nil?
  end
end
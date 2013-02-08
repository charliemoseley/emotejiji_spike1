class Emoticon
  include Neo4j::NodeMixin
  
  property :uid, index: :exact
  property :text
  property :description
  property :number_of_lines,    type: Fixnum, index: :fulltext
  property :longest_line_count, type: Fixnum
  
  rule :all, functions: [Neo4j::Wrapper::Rule::Functions::Size.new]
  
  def init_on_create(text, description = '')
    self[:uid] = generate_uid
    self[:text] = text
    self[:description] = description
    self[:number_of_lines] = count_number_of_lines_in text
    self[:longest_line_count] = count_longest_line_in text
    # Doesn't seem to properly 'save'.  Generates an object, but doesn't seem
    # to either persist it or just not run the index building unless super is
    # called
    super
  end
  
  private
  
  def generate_uid
    Base32::Crockford.encode(UUIDTools::UUID.random_create.raw).downcase[0..9]
  end
    
  def count_number_of_lines_in(text)
    text.lines.count unless text.nil?
  end
  
  def count_longest_line_in(text)
    text.lines.map { |line| line.length }.max unless text.nil?
  end
end
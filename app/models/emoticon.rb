class Emoticon
  include Neo4j::NodeMixin
  
  property :uid, index: :exact
  property :text
  property :description
  property :number_of_lines,    type: Fixnum, index: :fulltext
  property :longest_line_count, type: Fixnum
  
  rule :all, functions: [Neo4j::Wrapper::Rule::Functions::Size.new]
  
  has_n(:tags).to(Tag).relationship(EmoticonTagEdge)
  
  def init_on_create(params = {})
    raise "params[:text] required" if params[:text].nil?
    self[:uid] = generate_uid
    self[:text] = params[:text]
    self[:description] = params[:description] || ""
    self[:number_of_lines] = count_number_of_lines_in params[:text]
    self[:longest_line_count] = count_longest_line_in params[:text]
    # Destroy the old params to prevent anything being passed in from being
    # assigned by the super call below
    params = nil
    # Doesn't seem to properly 'save'.  Generates an object, but doesn't seem
    # to either persist it or just not run the index building unless super is
    # called
    super
  end
  
  def self.find_by_uid(uid)
    Emoticon.find(uid: uid).first
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
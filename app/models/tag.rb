class Tag
  include Neo4j::NodeMixin
  
  property :uid, index: :exact
  property :text, index: :exact
  property :description
  
  rule :all, functions: [Neo4j::Wrapper::Rule::Functions::Size.new]
  
  def init_on_create(params = {})
    raise "params[:text] required" if params[:text].nil?
    self[:uid] = generate_uid
    self[:text] = params[:text]
    self[:description] = params[:description] || ""
    params = nil
    super
  end
  
  def self.find_by_text(text)
    Tag.find(text: text).first
  end
  
  private
  
  def generate_uid
    Base32::Crockford.encode(UUIDTools::UUID.random_create.raw).downcase[0..9]
  end
end
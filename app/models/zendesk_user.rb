class ZendeskUser
  FIELDS = [ :id, :url, :name, :external_id, :alias, :created_at, 
             :updated_at, :active, :verified, :shared, :locale_id, :locale,
             :time_zone, :last_login_at, :email, :phone, :signature, 
             :details, :notes, :organization_id, :role, :custom_role_id, 
             :moderator, :user_restriction, :only_private_comments, 
             :tags, :suspended, :photo, :ticket_restriction ]
                
  include HTTParty
  
  base_uri "https://tmadar.zendesk.com/api/v2/"
  headers "Accept" => "application/json"
  
  @@username = "tmadar12@yahoo.com/token"
  @@password = "6BkbbN8K2c39u0rSpbyqJ62iStj35d8ycacIpA3f"
  
  @@auth = {:username => @@username, :password => @@password}
  
  def self.first
    self.all[0]
  end
  
  def self.last
    users = self.all.last
  end
  
  def self.all(options={})
    options.merge!(:basic_auth => @@auth)
    users = get("/users.json", options)['users']
    users = users.map { |v| self.new(v) }
  end
  
  def self.find(id, options={})
    options.merge!(:basic_auth => @@auth, :headers => { 'Content-Type' => 'application/json' })
    response = self.get("/users/#{id}.json", options)    
    self.new(response['user'])
  end
  
  def self.update(user, options={})
    options.merge!(:body => { "user" => user.generate_hash }.to_json, :basic_auth => @@auth, :headers => { 'Content-Type' => 'application/json' })
    response = self.put("/users/#{user.id}.json", options)    
    user.attributes(response['user'])
  end
  
  def self.create(user, options={})
    options.merge!(:body => { "user" => user.generate_hash }.to_json, :basic_auth => @@auth, :headers => { 'Content-Type' => 'application/json' })
    response = self.post("/users.json", options)
    user.attributes(response['user'])
  end
  
  FIELDS.each { |field| attr_accessor field }
  
  def initialize(hash={})
    self.attributes(hash)
  end
  
  def attributes(hash={})
    if hash
      hash.keys.each do |key|
        self.send("#{key}=".to_sym, hash[key])
      end
    end
    generate_hash
  end
  
  def [](o)
    self.send(o.to_sym)    
  end
  
  def []=(o,v)
    self.send("#{o}=".to_sym, v)    
  end
  
  def generate_hash
    user = {}
    FIELDS.each { |field| user[field] = self.send(field) }
    return user
  end
  
  def save
    if self.id
      user = generate_hash
      user.delete_if { |k,v| v == nil }
      self.class.update(self)
    else
      self.class.create(self)
    end
  end
  
  def solve!
    self.status = "solved"
    self.save
  end
  
end
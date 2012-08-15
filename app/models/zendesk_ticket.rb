class ZendeskTicket
  FIELDS = [ :id, :external_id, :type, :subject, :description, 
                :priority, :status, :recipient, :requester_id,
                :submitter_id, :assignee_id, :organization_id, 
                :group_id, :collaborator_ids, :forum_topic_id, 
                :problem_id, :has_incidents, :due_at, :tags, 
                :via, :fields, :created_at, :updated_at, :url, 
                :requester, :comment ]
                
  include HTTParty
  
  base_uri "https://tmadar.zendesk.com/api/v2/"
  headers "Accept" => "application/json"
  
  @@username = "tmadar12@yahoo.com/token"
  @@password = "6BkbbN8K2c39u0rSpbyqJ62iStj35d8ycacIpA3f"
  
  @@auth = {:username => @@username, :password => @@password}
  
  def self.all(options={})
    options.merge!(:basic_auth => @@auth)
    tickets = get("/tickets.json", options)['tickets']
    tickets = tickets.map { |v| self.new(v) }
  end
  
  def self.find(id, options={})
    options.merge!(:basic_auth => @@auth, :headers => { 'Content-Type' => 'application/json' })
    response = self.get("/tickets/#{id}.json", options)    
    self.new(response['ticket'])
  end
  
  def self.update(ticket, options={})
    options.merge!(:body => { "ticket" => ticket.generate_hash }.to_json, :basic_auth => @@auth, :headers => { 'Content-Type' => 'application/json' })
    response = self.put("/tickets/#{ticket.id}.json", options)    
    ticket.attributes(response['ticket'])
  end
  
  def self.create(ticket, options={})
    options.merge!(:body => { "ticket" => ticket.generate_hash }.to_json, :basic_auth => @@auth, :headers => { 'Content-Type' => 'application/json' })
    response = self.post("/tickets.json", options)
    ticket.attributes(response['ticket'])
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
  
  def comments(options={})
    options.merge!(:basic_auth => @@auth, :headers => { 'Content-Type' => 'application/json' })
    response = self.class.get("/tickets/#{id}/audits.json", options)    
    response['audits'].select { |v| v["events"] }.select { |v| v["events"].detect { |l| l['type'] == "Comment" } }
  end
  
  def generate_hash
    ticket = {}
    FIELDS.each { |field| ticket[field] = self.send(field) }
    return ticket
  end
  
  def save
    if self.id
      ticket = generate_hash
      ticket.delete_if { |k,v| v == nil }
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
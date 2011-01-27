
class AntorchaClient < Struct.new(:wsdl, :username, :password)

  def initialize w, u, p
    super w, u, p
    @transactions = SOAP::WSDLDriverFactory.new(wsdl).create_rpc_driver(nil, "TransactionPort")
    @messages = SOAP::WSDLDriverFactory.new(wsdl).create_rpc_driver(nil, "MessagePort")
    @steps = SOAP::WSDLDriverFactory.new(wsdl).create_rpc_driver(nil, "StepPort")
  end
  
  def token
    { :username => username, :password => password }
  end
  
  def starting_steps
    @steps.StartingStepsIndex token
  end
  
  def starting_step title
    starting_steps.find {|s| s.title == title}
  end
  
  def initiate_transaction step
    @transactions.Initiate token, step
  end
    
  def update_message message
    @messages.Update token, message
  end
    
  def deliver_message message
    @messages.Deliver token, message
  end
end


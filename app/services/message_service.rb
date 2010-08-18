class MessageService < AuthenticatedService
  web_service_api MessageAPI

  before_invocation :load_and_authorize_message
  after_invocation :scrub_returned_messages

  def index_inbox token
    Message.inbox
  end
  
  def index_outbox token
    Message.outbox
  end
  
  def index_read token
    Message.read
  end
  
  def index_unread token
    Message.unread
  end

  def show token, message_id
    Message.show(message_id)
  end
  
  def reply token, api_message
    Message.find(api_message.id).replies.build(api_message.attributes)
  end
  
  def deliver token, api_message
    Message.find(api_message.id).send_deliveries
  end
  
  def index token
    Message.all
  end
  
  def update token, api_message
    message = Message.find(api_message.id)
    message.attributes = api_message.attributes.slice :title, :body
    message.save
    message
  end
  
private
  def load_and_authorize_message method_name, args
    @message = Message.find(args[1].id) if args[1].is_a?(Api::Message)
    authorize! soap_method_to_resource_action(method_name), @message.blank? ? Message : @message
  end

  def soap_method_to_resource_action method_name
    method_name.to_s =~ /[a-z]+/
    action = $&
    action = 'send' if action == 'deliver'
    action.to_sym
  end

  def scrub_returned_messages method_name, params, return_value
    case return_value
    when Array:
      return_value = scrub_messages return_value
    when Message:
      return_value = scrub_message return_value
    end
    [return_value]
  end
  
  def scrub_messages messages
    messages.each {|message| scrub_message message }
  end
  
  def scrub_message message
    message.body = nil unless can? :examine, message
  end

end

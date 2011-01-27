require 'spec_helper.rb'

describe "SOAP" do
  it "should be able to communicate with an existing free server" do
    wsdl = 'http://webservices.daehosting.com/services/isbnservice.wso?WSDL'
    driver = SOAP::WSDLDriverFactory.new(wsdl).create_rpc_driver
    response =  driver.IsValidISBN13(:sISBN => '9780393068474')
    response.isValidISBN13Result.should be_true
  end

  describe "Antorcha" do

    subject { AntorchaClient.new 'http://localhost:3000/soap/wsdl', 'banaan', 'daandaan' }
#    subject { AntorchaClient.new 'http://thorax:thorax@zorgaanbieder.thebeanmachine.nl/soap/wsdl', 'daan', 'banaan' }

    it "should list the available starting steps." do
      steps = subject.starting_steps
      steps.should_not be_empty
    end
    
    it "should find the 'Stuur melding huiselijk geweld' step" do
      melding_step = subject.starting_step 'Stuur melding huiselijk geweld'
      melding_step.title.should == 'Stuur melding huiselijk geweld'
    end
    
    it "should start transaction using the 'Stuur melding huiselijk geweld' step" do
      melding_step = subject.starting_step 'Stuur melding huiselijk geweld'
      melding_message = subject.initiate_transaction melding_step
      
      melding_message.step_id.should == melding_step.id
    end

    it "should be able to update a message" do
      melding_step = subject.starting_step 'Stuur melding huiselijk geweld'
      melding_message = subject.initiate_transaction melding_step
      
      melding_message.title = "SOAP TEST (verwijder)"
      melding_message.body = "Automatisch soap test op de test servers."
      subject.update_message melding_message
    end

    it "should do maartens stroll" do
      pending "Uit elkaar halen"
      step = startSteps.first
      message = startTransaction(step)
      puts showMessage(message.id).title
      puts message.id
      message.title = "updated title"
      message.body = "updated title"
      updateMessage(message)
      message = startTransaction(step)
      message.title = "delete me"
      updateMessage(message)
      puts "Alle berichten"
      index.each do |m| puts m.title end
      #deleteMessage(message) #Geen authorisatie
      puts "Alleen gelezen berichten"
      indexRead.each do |m| puts m.title end
      deliver(message)
    end
  end
end

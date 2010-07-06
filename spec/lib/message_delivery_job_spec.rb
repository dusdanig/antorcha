require 'spec_helper'

describe MessageDeliveryJob do
  subject {
    MessageDeliveryJob.new(mock_message.to_param)
  }

  def stub_perform
    stub_find(mock_message)
    stub_rest_client_post

    mock_message.stub \
      :to_xml => "XML!",
      :delivered! => nil,
      :destination_organizations => mock_organizations
    
    mock_organization.stub :url => 'http://example.com/messages'
  end

  def stub_rest_client_post
    RestClient.stub(:post => nil)
  end
  
  describe "undelivered message" do
    def stub_undelivered
      mock_message.stub(:delivered? => false)
      stub_perform
    end
    
    it "should find the message" do
      stub_undelivered
      Message.should_receive(:find).with(mock_message.to_param).and_return(mock_message)
      subject.perform
    end

    it "should flag the message as delivered" do
      stub_undelivered
      mock_message.should_receive(:delivered!)
      subject.perform
    end

    it "should post the message" do
      stub_undelivered
      RestClient.should_receive(:post)
      subject.perform
    end
    
    it "should post the message as xml" do
      stub_undelivered
      RestClient.should_receive(:post).with(
        anything(), mock_message.to_xml, hash_including(
          :content_type => :xml, :accept => :xml
        ))
      subject.perform
    end
    
    it "should post the message to the destination url of organizations" do
      stub_undelivered
      RestClient.should_receive(:post).with('http://example.com/messages', anything(), anything()).twice
      subject.perform
    end

    it "should fetch destination url from the message" do
      stub_undelivered
      mock_organization.should_receive(:url).twice
      subject.perform
    end
  end
  
  describe "a delivered message" do
    def stub_undelivered
      mock_message.stub(:delivered? => true)
      stub_perform
    end
    
    it "should check if the message was delivered" do
      stub_undelivered
      mock_message.should_receive(:delivered?)
      subject.perform
    end
    
    it "should not flag the message as delivered" do
      stub_undelivered
      mock_message.should_not_receive(:delivered!)
      subject.perform
    end

    it "should not deliver the message" do
      stub_undelivered
      RestClient.should_not_receive(:post)
      subject.perform
    end

  end
  
end

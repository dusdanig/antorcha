require 'spec_helper'
require "cancan/matchers"

describe Ability, "of users in antorcha to:" do
  
  before(:each) do
    #pending "should we use static user types??"
  end
    
  def self.all_roles
    [:communicator, :maintainer, :advisor, :anonymous]
  end

  def self.ability_of role, &block
    x = subclass "by #{role}", &block
    local_role = role
    
    x.subject { u = User.new; u.user_type = local_role.to_s; Ability.new(u) }
  end

  def self.everyone_else_but role, &block
    (all_roles - [role]).each do |role|
      ability_of role, &block
    end
  end

  describe "initiation and starting of transactions" do
    ability_of :communicator do
      specify { should be_able_to(:create, Transaction)}
    end
  end

    
  describe "cancellation of transactions" do
    ability_of :communicator do
      specify { should be_able_to(:cancel, Transaction)}
    end
  end
  
  describe "management of organizations" do
    ability_of :maintainer do
      specify { should be_able_to(:manage, Organization)}
    end
  end

  describe "the examination of a message" do
    ability_of :communicator do
      it "can only be done by a communicator" do
        should be_able_to(:examine, Message)
      end
    end
    
    everyone_else_but :communicator do |other|
      it "should not be allowed" do
        should_not be_able_to(:examine, Message)
      end
    end
  end
  
  describe "updating of a message" do
    ability_of :communicator do
      it "should not be allowed to update a not updatable message" do
        mock_message.stub :updatable? => false
        should_not be_able_to( :update, mock_message)
      end
      it "should be allowed to update an updatable message" do
         mock_message.stub :updatable? => true
        should be_able_to( :update, mock_message)
      end
    end
  end
  
  describe "starting and stopping a worker" do
    ability_of :maintainer do
      it "can only be managed by a maintainer" do
        should be_able_to(:manage, Worker)
      end
    end

    everyone_else_but :maintainer do |other|
      it "cannot manage a worker" do
        should_not be_able_to(:manage, Worker)
      end
    end
  end
end

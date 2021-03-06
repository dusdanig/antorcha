require 'spec_helper'

describe "/castables/new.html.erb" do
  include CastablesHelper

  before(:each) do
    
    view_as_user :communicator
    
    assigns[:castable] = stub_model(Castable,
      :new_record? => true,
      :user => mock_user,
      :role => mock_role
    )
    assigns[:roles] = [mock_model(Role, :title => "test")]
    assigns[:users] = [mock_model(User, :username => "test")]
  end

  it "renders new castable form" do
    render
    
    response.should have_tag("form[action=?][method=post]", castables_path) do
      with_tag("select#castable_user_id[name=?]", "castable[user_id]")
      with_tag("select#castable_role_id[name=?]", "castable[role_id]")
    end
  end
end

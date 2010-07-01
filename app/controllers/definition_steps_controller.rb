class DefinitionStepsController < ApplicationController
  load_and_authorize_resource :name => :step, :nested => :definition
  after_filter :assign_steps
  
  def index
  end
  
  def new
  end

  def create
    if @step.save
      redirect_to @step, :notice => 'Step created successfully.'
    else
      render :action => "new"
    end
  end
  
private
  def assign_steps
    @steps = @definition.steps - [@step]
  end
end
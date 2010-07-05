# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

seeds = [
  {Definition => {
    {:title => 'Bake bread'} => {}
  }},
  {Step => {
    {:title => 'Defrost doh'} => {
      :start => true,
      :definition => lambda { Definition.find_by_title('Bake bread') }
    }
  }},
  {Step => {
    {:title => 'Bake the bread'} => {
      :start => false,
      :definition => lambda { Definition.find_by_title('Bake bread') }
    }
  }},
  {Reaction => {
    {
      :cause_id => lambda { Step.find_by_title!('Defrost doh').id },
      :effect_id => lambda { Step.find_by_title!('Bake the bread').id} } => {}
  }}
]

seeds.each do |seed|
  seed.each do |model, instances|
    instances.each do |conditions, attributes|
      conditions = conditions.inject({}) do |memo, (key, value) |
        memo[key] = case value
        when Proc:
          value.call
        else
          value
        end
        memo
      end
      instance = model.find(:first, :conditions => conditions)
      attributes = attributes.inject({}) do |memo, (key, value) |
        memo[key] = case value
        when Proc:
          value.call
        else
          value
        end
        memo
      end
      unless instance
        puts "===> Creating #{conditions.inspect}"
        model.create!(conditions.merge(attributes))
      else
        puts "---> Updating #{conditions.inspect} with #{attributes.inspect}"
        instance.update_attributes(attributes)
      end
    end
  end
end


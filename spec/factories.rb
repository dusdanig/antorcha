
Factory.define(:step) do |f|
  f.sequence(:title) {|n| "Step #{n}"}
end

Factory.define :message do |f|
  f.sequence(:title) {|n| "Message #{n}"}
  f.step { Factory(:step) }
  f.body "Dit is de message body"
end


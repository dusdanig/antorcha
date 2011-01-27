require 'rubygems'
require 'spec'
# optionally add autorun support
# require 'rspec/autorun'

require 'soap/wsdlDriver'
require 'antorcha_client'

Spec::Runner.configure do |c|
  c.mock_with :rspec
end

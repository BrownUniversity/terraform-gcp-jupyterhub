require 'rspec/retry'

title "Test basic availability of JupyterHub"

jhub_url = attribute("jhub_url")

RSpec.configure do |config|
    # show retry status in spec process
    config.verbose_retry = true
    # show exception that triggers a retry if verbose_retry is set to true
    config.display_try_failure_messages = true
end

describe 'Hub Alive' do  
    context 'Is Hub Responding', retry: 6, retry_wait: 10 do
      subject { http("#{jhub_url}/hub/login", ssl_verify: false) }
      its(:status) { should eql 200 }
      its('headers.Content-Type') { should cmp 'text/html' }
    end
end
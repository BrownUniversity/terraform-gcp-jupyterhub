# copyright: 2018, The Authors

title "Test basic availability of JupyterHub"
require 'rspec/retry'

jhub_url = attribute("jhub_url")

describe http("https://sample.jupyter.brown.edu/hub/login", ssl_verify: false) do
    it 'status should be 200', retry: 300, retry_wait:1 do
        its('status') { should cmp 200 }
        its('headers.Content-Type') { should cmp 'text/html' }
    end
end
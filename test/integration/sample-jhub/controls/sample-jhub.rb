# copyright: 2018, The Authors

title "Test basic availability of JupyterHub"
require 'rspec/retry'

jhub_url = attribute("jhub_url")

describe http("#{jhub_url}/hub/login", ssl_verify: false) do
    its('status') { should cmp 200 }
    its('headers.Content-Type') { should cmp 'text/html' }
end
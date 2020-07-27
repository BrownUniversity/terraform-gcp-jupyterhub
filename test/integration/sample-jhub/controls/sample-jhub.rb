# copyright: 2018, The Authors

title "Cluster Section"

jhub_url = attribute("jhub_url")

describe http("https://sample.jupyter.brown.edu/hub/login",
              ssl_verify: false) do
    its('status') { should cmp 200 }
    its('headers.Content-Type') { should cmp 'text/html' }
end


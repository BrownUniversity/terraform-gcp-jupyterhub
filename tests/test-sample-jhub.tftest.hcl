run "test_website_creation" {
  # Apply the module
  command = plan

  module {
    source = "./tests/sample-jhub"
  }

  # Assert that the module ran successfully
  assert {
    condition     = output.sample_website.jhub_url != ""
    error_message = "Website URL is empty"
  }

  # Use a data block to check the website
  data "http" "jhub_check" {
    url = output.sample_website.jhub_url
    method = "GET"
  }

  # Check if the website returns a successful status code
  assert {
    condition     = data.http.jhub_check.status_code == 200
    error_message = "Website did not return a 200 OK status. Actual status: ${data.http.website_check.status_code}"
  }
}
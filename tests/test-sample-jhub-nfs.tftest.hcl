run "test_website_creation" {
  # Apply the module
  command = plan

  module {
    source = "./tests/sample-jhub-nfs"
  }

  # Assert that the module ran successfully
  assert {
    condition     = output.jhub_url != ""
    error_message = "Website URL is empty"
  }
}
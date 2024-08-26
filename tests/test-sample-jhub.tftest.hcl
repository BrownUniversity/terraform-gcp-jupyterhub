variables {
  helm_values_file = "./tests/sample-jhub/values.yaml"
}


run "test_website_creation" {
  # Apply the module
  command = apply

  module {
    source = "./tests/sample-jhub"
  }

  # Assert that the module ran successfully
  assert {
    condition     = output.jhub_url != ""
    error_message = "Website URL is empty"
  }
}
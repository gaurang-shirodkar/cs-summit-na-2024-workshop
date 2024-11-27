package lambda_test

import data.lambda

# Test case: Allowed runtime python3.9
test_allowed_runtime_python39 {
  input := {"Runtime": "python3.9"}
  result := lambda.runtime_allowed with input as input
  result == true
}

# Test case: Allowed runtime python3.10
test_allowed_runtime_python310 {
  input := {"Runtime": "python3.10"}
  result := lambda.runtime_allowed with input as input
  result == true
}

# Test case: Disallowed runtime python3.8
test_disallowed_runtime_python38 {
  input := {"Runtime": "python3.8"}
  result := lambda.runtime_allowed with input as input
  result == false
}

# Test case: Disallowed runtime nodejs14.x
test_disallowed_runtime_nodejs14 {
  input := {"Runtime": "nodejs14.x"}
  result := lambda.runtime_allowed with input as input
  result == false
}

# Test case: Missing Runtime field
test_missing_runtime {
  input := {}
  result := lambda.runtime_allowed with input as input
  result == false
}

package iam_policy_test

# Test for wildcard in Action
test_wildcard_in_action {
    input := {
        "VersionDocument": "{\"Statement\":[{\"Action\":[\"kms:Encrypt\",\"kms:Decrypt\",\"*\"],\"Effect\":\"Allow\",\"Resource\":\"arn:aws:kms:us-east-1:835596177334:key/ABCDE\"}],\"Version\":\"2012-10-17\"}"
    }
    result := data.iam_policy_test.risky with input as input
    result == true
}

# Test for wildcard in Resource
test_wildcard_in_resource {
    input := {
        "VersionDocument": "{\"Statement\":[{\"Action\":[\"kms:Encrypt\",\"kms:Decrypt\"],\"Effect\":\"Allow\",\"Resource\":\"*\"}],\"Version\":\"2012-10-17\"}"
    }
    result := data.iam_policy_test.risky with input as input
    result == true
}

# Test for no wildcard
test_no_wildcard {
    input := {
        "VersionDocument": "{\"Statement\":[{\"Action\":[\"kms:Encrypt\",\"kms:Decrypt\"],\"Effect\":\"Allow\",\"Resource\":\"arn:aws:kms:us-east-1:835596177334:key/ABCDE\"}],\"Version\":\"2012-10-17\"}"
    }
    result := data.iam_policy_test.risky with input as input
    result == false
}

# Test for wildcard in multiple Actions
test_wildcard_in_multiple_actions {
    input := {
        "VersionDocument": "{\"Statement\":[{\"Action\":[\"kms:Encrypt\",\"*\",\"kms:Decrypt\"],\"Effect\":\"Allow\",\"Resource\":\"arn:aws:kms:us-east-1:835596177334:key/ABCDE\"}],\"Version\":\"2012-10-17\"}"
    }
    result := data.iam_policy_test.risky with input as input
    result == true
}

# Test for wildcard in multiple Resources
test_wildcard_in_multiple_resources {
    input := {
        "VersionDocument": "{\"Statement\":[{\"Action\":[\"kms:Encrypt\",\"kms:Decrypt\"],\"Effect\":\"Allow\",\"Resource\":[\"arn:aws:kms:us-east-1:835596177334:key/ABCDE\",\"*\"]}],\"Version\":\"2012-10-17\"}"
    }
    result := data.iam_policy_test.risky with input as input
    result == true
}

# Test for wildcard in both Action and Resource
test_wildcard_in_action_and_resource {
    input := {
        "VersionDocument": "{\"Statement\":[{\"Action\":[\"*\"],\"Effect\":\"Allow\",\"Resource\":\"*\"}],\"Version\":\"2012-10-17\"}"
    }
    result := data.iam_policy_test.risky with input as input
    result == true
}

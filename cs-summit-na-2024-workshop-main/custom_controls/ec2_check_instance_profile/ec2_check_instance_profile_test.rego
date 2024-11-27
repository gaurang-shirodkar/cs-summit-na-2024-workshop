package ec2_test

import data.ec2

# Test case: Instance has an IamInstanceProfile
test_instance_with_profile {
  input := {
    "IamInstanceProfile": {
      "Arn": "arn:aws:iam::123456789012:instance-profile/example-profile",
      "Id": "AIPA4FDLJZ63JE5WFU4U6"
    }
  }
  result := ec2.instance_profile_present with input as input
  result == true
}

# Test case: Instance does not have an IamInstanceProfile
test_instance_without_profile {
  input := {}
  result := ec2.instance_profile_present with input as input
  result == false
}

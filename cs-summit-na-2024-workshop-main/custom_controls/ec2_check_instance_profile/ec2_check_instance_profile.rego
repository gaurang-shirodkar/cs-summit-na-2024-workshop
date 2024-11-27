package ec2

default instance_profile_present = false

instance_profile_present = true {
  input.IamInstanceProfile
}

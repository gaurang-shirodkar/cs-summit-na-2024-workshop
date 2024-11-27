package iam_test

test_role_assumable_by_another_account_via_iam_role {
    input := {
        "Arn": "arn:aws:iam::835596177334:role/AWSAFTService",
        "AssumeRolePolicyDocument": {
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Effect": "Allow",
                    "Principal": {
                        "AWS": [
                            "arn:aws:sts::324304105923:assumed-role/AWSAFTAdmin/AWSAFT-Session",
                            "arn:aws:iam::324304105923:role/AWSAFTAdmin"
                        ]
                    },
                    "Action": "sts:AssumeRole"
                }
            ]
        }
    }
    result := data.iam.risky with input as input
    result == true
}

test_role_assumable_by_another_account_via_iam_role_with_regex {
    input := {
        "Arn": "arn:aws:iam::835596177334:role/AWSAFTService",
        "AssumeRolePolicyDocument": {
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Effect": "Allow",
                    "Principal": {
                        "AWS": [
                            "arn:aws:sts::324304105923:assumed-role/*",
                            "arn:aws:iam::324304105923:role/*"
                        ]
                    },
                    "Action": "sts:AssumeRole"
                }
            ]
        }
    }
    result := data.iam.risky with input as input
    result == true
}

test_role_assumable_by_another_account_via_iam_role_in_another_statement {
    input := {
        "Arn": "arn:aws:iam::835596177334:role/AWSAFTService",
        "AssumeRolePolicyDocument": {
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Effect": "Allow",
                    "Principal": {
                        "AWS": [
                            "arn:aws:iam::835596177334:user/IgorUser"
                        ]
                    },
                    "Action": "sts:AssumeRole"
                },
              {
                    "Effect": "Allow",
                    "Principal": {
                        "AWS": [
                            "arn:aws:iam::324304105923:user/IgorUser"
                        ]
                    },
                    "Action": "sts:AssumeRole"
                }
            ]
        }
    }
    result := data.iam.risky with input as input
    result == true
}

test_role_assumable_by_another_account_via_iam_user {
    input := {
        "Arn": "arn:aws:iam::835596177334:role/AWSAFTService",
        "AssumeRolePolicyDocument": {
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Effect": "Allow",
                    "Principal": {
                        "AWS": [
                            "arn:aws:iam::324304105923:user/IgorUser"
                        ]
                    },
                    "Action": "sts:AssumeRole"
                }
            ]
        }
    }
    result := data.iam.risky with input as input
    result == true
}

test_role_not_assumable_by_another_account {
    input := {
        "Arn": "arn:aws:iam::835596177334:role/AWSAFTService",
        "AssumeRolePolicyDocument": {
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Effect": "Allow",
                    "Principal": {
                        "AWS": [
                            "root",
                        ]
                    },
                    "Action": "sts:AssumeRole"
                }
            ]
        }
    }
    result := data.iam.risky with input as input
    result == false
}

test_role_assumable_by_user_in_the_same_account {
    input := {
        "Arn": "arn:aws:iam::835596177334:role/AWSAFTService",
        "AssumeRolePolicyDocument": {
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Effect": "Allow",
                    "Principal": {
                        "AWS": [
                            "arn:aws:iam::835596177334:user/IgorUser",
                        ]
                    },
                    "Action": "sts:AssumeRole"
                }
            ]
        }
    }
    result := data.iam.risky with input as input
    result == false
}

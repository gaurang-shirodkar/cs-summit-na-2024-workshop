.PHONY: test

test:
	echo "Running tests"
	cd ec2_check_instance_profile && opa test ec2_check_instance_profile_test.rego ec2_check_instance_profile.rego
	cd iam_policy_check_wildcard_access && opa test test_iam_policy_check_wildcard_access.rego iam_policy_check_wildcard_access.rego
	cd iam_role_cross_account_trust_relationship && opa test iam_role_verify_assume_role_document.rego test_iam_role_verify_assume_role_document.rego
	cd lambda_check_approved_runtimes && opa test lambda_check_approved_runtimes.rego test_lambda_check_approved_runtimes.rego

fmt:
	opa fmt ./


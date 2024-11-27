package iam

import rego.v1

default is_assumable_by_another_account := false
default risky := false

risky if {
	is_assumable_by_another_account
}

is_assumable_by_another_account if {
	role_account_id := account_id_from_arn(input.Arn)

	# Collect all principal account IDs
	principal_account_ids := {id |
		some stmt in input.AssumeRolePolicyDocument.Statement
		principal := stmt.Principal.AWS
		arns := normalize_principals(principal)
		some arn in arns
		id := account_id_from_arn(arn)
		id != "" # Exclude empty IDs
	}

	# Check if any principal account ID is different from the role's account ID
	some id in principal_account_ids
	id != role_account_id
}

# Helper function to extract account ID from ARN
account_id_from_arn(arn) := account_id if {
	matches := regex.find_all_string_submatch_n(`^arn:aws:(iam|sts|user)::(\d+):`, arn, -1)
	count(matches) > 0
	account_id := matches[0][2]
} else := account_id if {
	# If the ARN does not match expected patterns, return empty string
	account_id := ""
}

# Helper function to normalize the Principal.AWS field to a list
normalize_principals(principal) := principals if {
	is_array(principal)
	principals := principal
} else := principals if {
	not is_array(principal)
	principals := [principal]
}

package iam_policy_test

import future.keywords.in

# Default risky to false
default risky := false

# Decode the JSON string in VersionDocument
version_document := json.unmarshal(input.VersionDocument)

# Set risky to true if a wildcard is found in Actions
risky {
    stmt := version_document.Statement[_]
    stmt.Action[_] = action
    contains_wildcard(action)
}

# Set risky to true if a wildcard is found in Resources
risky {
    stmt := version_document.Statement[_]
    contains_wildcard(stmt.Resource)
}

# Helper function to check if a string contains a wildcard
contains_wildcard(value) {
    is_string(value)
    contains(value, "*")
}

contains_wildcard(value) {
    is_array(value)
    value[_] = element
    contains(element, "*")
}

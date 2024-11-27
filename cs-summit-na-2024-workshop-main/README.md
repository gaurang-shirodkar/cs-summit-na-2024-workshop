

# Terraform Deployment Automation with Makefile 🚀

This repository provides a **Makefile** to automate the deployment, destruction, and updates of multiple Terraform configurations. It manages infrastructure across three main directories:  
1. `eks`  
2. `sysdig_tenant_setup`  
3. `sysdig_security`  

Using this Makefile, you can seamlessly execute Terraform commands from the root directory while automatically loading environment variables from the `.env` file.

## 📋 Requirements

Ensure you have the following tools installed and configured:

### 1. **Make**  
Required for executing the commands in the `Makefile`.  
**Installation:**  
- **MacOS**: `brew install make`  
- **Linux**:  
  - Debian/Ubuntu: `sudo apt-get install make`  
  - RHEL/CentOS: `sudo yum install make`  
- **Windows**: Use Chocolatey or WSL (Windows Subsystem for Linux).  

### 2. **Terraform**  
- Minimum version: **1.8.4** (includes support for necessary changes in [PR #35157](https://github.com/hashicorp/terraform/pull/35157)).  
[Install Terraform](https://www.terraform.io/downloads.html).

### 3. **AWS CLI**  
Required for interacting with AWS services, particularly for `eks`.  
[Install AWS CLI](https://aws.amazon.com/cli/).

---

## 🛠️ Deploying the solution

### 1. **Clone the Repository and Set Up `.env`**
Clone the repository and navigate to the correct folder:
```bash
https://github.com/sysdiglabs/cs-summit-na-2024-workshop.git
cd cs-summit-na-2024-workshop/
```

Create a `.env` file in the root directory with your environment variables (e.g., AWS credentials, region, etc.):
```bash
cat <<EOF > .env
export TF_VAR_sysdig_accesskey=YOUR_ACCESS_TOKEN
export TF_VAR_sysdig_secure_api_token=YOUR_SECURE_API_TOKEN
export TF_VAR_sysdig_region=YOUR_REGION # e.g., us1, us2, us4, eu1
export TF_VAR_aws_profile=default       # Change AWS profile if necessary
export TF_VAR_sysdig_endpoint=YOUR_SAAS_REGION_ENDPOINT
EOF
```

If you’re using AWS SSO, get the appropriate profile from `~/.aws/credentials`. For example:
```
[712329029476_AWSAdministratorAccess]
aws_access_key_id=YOUR_KEY_ID
aws_secret_access_key=YOUR_SECRET_KEY
```

Then, update your .env file with the proper profile:
```bash
export TF_VAR_aws_profile=712329029476_AWSAdministratorAccess
```

Now, deploy all the resources:
```bash
make
```

Note: 
We have removed the AWS account CSPM/CDR/CIEM integration since most of the folks would have it already. If you have **not onboarded** your account yet, run the following:
To deploy the complete infrastructure:
```bash
make deploy-sysdig-secure
```

Deployment should take up to 15-20 minutes, after this step, you're done with the deployment 🎉

---

### 2. **Makefile Commands**
The Makefile includes the following commands:

| **Command**               | **Description**                                                                 |
|---------------------------|---------------------------------------------------------------------------------|
| `make deploy-all`         | Deploys all environments (`eks`, `sysdig_tenant_setup`,`sysdig_additional_resources`).     |
| `make deploy-eks`         | Deploys only the `eks` environment.                                             |
| `make deploy-sysdig-tenant` | Deploys only the `sysdig_tenant_setup` environment.                           |
| `make deploy-sysdig-secure` | Deploys only the `sysdig_secure` environment.                                 |
| `make deploy-additional-resources` | Deploys only the `sysdig_additional_resources` environment.            | 
| `make destroy-all`        | Destroys all environments.                                                      |
| `make update-all`         | Updates all environments.                                                       |

---

## 🌐 Deploy AWS Threat Generator Application

### 1. **Get EKS Credentials**
After deploying the EKS cluster:
```bash
aws eks update-kubeconfig --name sysdig
```

### 2. **Deploy the Threat Generator**
Apply the deployment file:
```bash
kubectl apply -f https://raw.githubusercontent.com/IgorEulalio/golang-aws-threat-generator/refs/heads/main/deployment/deployment.yml
```

---

## 🎯 Perform the Attack

### 1. **Port-Forward the Application**
Access the application locally:
```bash
kubectl port-forward deploy/release-book-runtime 8080:8080 &
```

### 2. **Endpoints and Actions**
- **IAM Role Enumeration**:  
  Lists all roles, verifies assumeable roles, and identifies potential lateral movement paths:
  ```bash
  curl --location 'http://localhost:8080/iamRolesEnumeration' | jq
  ```

- **IAM User Enumeration**:  
  Analyzes user policies and groups for potential risks:
  ```bash
  curl --location 'http://localhost:8080/iamUserEnumeration'
  ```

- **Assume an IAM Role**:  
  Perform lateral movement by assuming a discovered role:
  ```bash
  export role_arn=$(curl --location 'http://localhost:8080/iamRolesEnumeration' | jq -r '.[].Arn')

  json_data=$(jq -n --arg role_arn "$role_arn" '{role_arn: $role_arn}')

  curl --location 'http://localhost:8080/assumeRole' \
  --header 'Content-Type: application/json' \
  --data "$json_data"
  ```

### 3. **Validate in Sysdig**
Check Sysdig for insights into the IAM enumeration and lateral movement activities!

---

## 🧪 Custom Controls with REGO

Inside the `custom_controls` folder, you’ll find these directories, each containing REGO code to validate specific security controls:  
- `ec2_check_instance_profile`  
- `iam_policy_check_wildcard_access`  
- `iam_role_cross_account_trust_relationship`  
- `lambda_check_approved_runtimes`  

### Writing and Testing Custom Controls  
Install the [OPA CLI](https://www.openpolicyagent.org/docs/latest/#1-download-opa) for writing, testing, and formatting REGO policies.  
Example usage:
```bash
cd custom_controls/ec2_check_instance_profile
opa test ec2_check_instance_profile_test.rego ec2_check_instance_profile.rego
```

Run all tests:
```bash
cd custom_controls
make test
```

---

## 🎉 Congrats!  
You’ve successfully set up your Terraform infrastructure, tested REGO custom controls, deployed the AWS Threat Generator, and performed security attacks for testing.  

Now, **analyze your findings in Sysdig and enhance your cloud security posture!** 🛡️

--- 


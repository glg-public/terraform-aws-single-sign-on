# terraform-aws-single-sign-on

Terraform module to manage AWS SSO.

Included features:
- Creation of permission sets
- Attaching inline and managed policies to permission sets
- Assign users/groups to permission sets

## Usage
**IMPORTANT:** The `master` branch is used in source just as an example. In your code, do not pin to master because there may be breaking changes between releases. Instead pin to the release tag (e.g. `?ref=tags/x.y.z`).

Include this repository as a module in your existing terraform code. **Additional examples** can be found in the [examples directory](./examples/)

### Managed policy for one group:
```hcl
module "SuperAdmin1Hour" {
  source = "git::https://github.com/glg-public/terraform-aws-single-sign-on.git?ref=master"

  managed_policies = [
    "arn:aws:iam::aws:policy/AdministratorAccess",
    "arn:aws:iam::aws:policy/AWSBillingReadOnlyAccess"
  ]
  permission_set_name        = "Super-Admin-1-Hour"
  permission_set_description = "1 hour God Access"
  session_duration           = "PT1H"
  principal_group_id = [
    "AWS_Role_SRE"
  ]
  account_ids = [
    "354990512722"
  ]
}
```

### Inline policy for one user:
```hcl
module "SingleUser" {
  source = "git::https://github.com/glg-public/terraform-aws-single-sign-on.git?ref=master"

  inline_policy = file("permission-sets/inline.json")
  managed_policies = [
    "arn:aws:iam::aws:policy/AWSBillingReadOnlyAccess"
  ]
  permission_set_name        = "Single-User-Assignment"
  permission_set_description = "1 hour single user assignment"
  session_duration           = "PT1H"
  principal_user_id = [
    "mmartin",
    "SingleUser"
  ]
  account_ids = [
    "354990512722"
  ]
}
```
# terraform-aws-single-sign-on

Terraform module to manage AWS SSO.

Included features:
- Creation of permission sets
- Attaching inline and managed policies to permission sets
- Assign users/groups to permission sets
- Tagging of permission sets

## Usage
**IMPORTANT:** The `master` branch is used in source just as an example. In your code, do not pin to master because there may be breaking changes between releases. Instead pin to the release tag (e.g. `?ref=tags/x.y.z`).

Include this repository as a module in your existing terraform code. **Additional examples** can be found in the [examples directory](./examples/)

### Managed policy for one group:
```hcl
module "SuperAdmin1Hour" {
  source = "git::https://github.com/glg-public/terraform-aws-single-sign-on.git?ref=master"
  tags = {
    "BusinessUnit" = "Core"
    "ManagedBy"    = "Terraform"
  }
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
  tags = {
    "BusinessUnit" = "Core"
    "ManagedBy"    = "Terraform"
  }
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

## Questions while developing this module...

**Q:** How to handle multiple account IDs?

**A:** If you copy this module around, permission sets are unique and can't be duplicated. HOWEVER, if we remove an account ID from the list we pass, will that remove a random ID assignment? No - this is solved with the [for_each feature of the HCL language](https://blog.gruntwork.io/terraform-tips-tricks-loops-if-statements-and-gotchas-f739bbae55f9).
##

**Q:** How to handle more than 1 user/group assignment to a permission set?

**A:** This gets complicated - since we are now introducing a second object for the [aws_identitystore_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/identitystore_group) to look up, you need to put the [for_each](https://www.terraform.io/docs/language/meta-arguments/for_each.html) on that which yields more than one result. THEN you have multiple assignments happening and you want to leverage the [setproduct function](https://www.terraform.io/docs/language/functions/setproduct.html) (a more fun read from the original author [here](https://matavelli.io/posts/2020/02/using-terraform-setproduct-function/)) to merge all of the possible combinations together. Once they are all in one place, we can have the [aws_ssoadmin_account_assignment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_account_assignment) do its job of creating multiple permission assignments.
##

**Q:** How to handle [inline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_permission_set_inline_policy) vs [managed](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_managed_policy_attachment) permission sets?

**A:** A combination of count for the inline policy (since we only can have one inline policy per permission set) AND for_each for the managed policy attachments, since we can have one or more.
##

**Q:** How to handle inline AND managed policies on one permission set?

**A:** Fortunately I solved for this in the above issue.
##

**Q:** How to handle a single user assignment instead of groups?

**A:** We are using a for_each in the data source (similar to the group data source) that will check to see if one or more USER's have been passed; aws_identitystore_user.
##

**Q:** What about specifying user(s) and group(s)?

**A:** All of the above has allowed me to simply include lists to both principal_user_id and principal_group_id!
##
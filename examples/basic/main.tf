###########################################################################
## Providers
###########################################################################
provider "aws" {
  version = "3.25.0"
  region  = "us-east-1"
}

###########################################################################
## Default tags for all permission sets
###########################################################################
locals {
  default_tags = {
    "BusinessUnit" = "Core"
    "Environment"  = "Production"
    "ManagedBy"    = "Terraform"
    "Owner"        = "SRE"
    "App"          = "AWS SSO"
  }
}

###########################################################################
## Permission Sets and Assignments
###########################################################################
module "EngineeringPowerUser" {
  source                     = "../"
  tags                       = local.default_tags
  inline_policy              = file("permission-sets/EngineeringPowerUser.json")
  permission_set_name        = "EngineeringPowerUser"
  permission_set_description = "12 hour Power User Access"
  session_duration           = "PT12H"
  principal_group_id = [
    "TechnologyEmployees",
    "AWS_Role_SystemsEngineer"
  ]
  account_ids = [
    "354990512722",
    "955856377846"
  ]
}

module "SuperAdmin1Hour" {
  source = "../"
  ## an example of merging your default tags with some additional tags
  tags = merge(
    local.default_tags,
    {
      Zendesk   = "ticketNumberHere"
      "Created" = "2021-02-03"
    },
  )
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

module "InlineAndManaged" {
  source        = "../"
  tags          = local.default_tags
  inline_policy = file("permission-sets/inline.json")
  managed_policies = [
    "arn:aws:iam::aws:policy/AWSBillingReadOnlyAccess"
  ]
  permission_set_name        = "Inline-And-Managed"
  permission_set_description = "1 hour Inline and Managed policies"
  session_duration           = "PT1H"
  principal_group_id = [
    "InlineAndManaged"
  ]
  account_ids = [
    "354990512722",
    "955856377846"
  ]
}

module "SingleUser" {
  source        = "../"
  tags          = local.default_tags
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

module "UserAndGroup" {
  source = "../"
  tags   = local.default_tags
  managed_policies = [
    "arn:aws:iam::aws:policy/AWSBillingReadOnlyAccess"
  ]
  permission_set_name        = "User-And-Group-Assignment"
  permission_set_description = "1 hour user and group assignment"
  session_duration           = "PT1H"
  principal_user_id = [
    "SingleUser"
  ]
  principal_group_id = [
    "InlineAndManaged"
  ]
  account_ids = [
    "354990512722"
  ]
}

module "RelayState" {
  source        = "../"
  tags          = local.default_tags
  inline_policy = file("permission-sets/inline.json")
  managed_policies = [
    "arn:aws:iam::aws:policy/AWSBillingReadOnlyAccess"
  ]
  permission_set_name        = "RelayState"
  permission_set_description = "1 hour that redirects user to specific page"
  session_duration           = "PT1H"
  relay_state                = "https://s3.console.aws.amazon.com/s3/home?region=us-east-1#"
  principal_user_id = [
    "mmartin"
  ]
  account_ids = [
    "354990512722"
  ]
}
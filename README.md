# environment-template-awseb
Environment Template for AWS ElasticBeanstalk based apps

## Table of Contents
1. [How-To](#how-to)
    1. [Promotion](#promotion)
    2. [Branch Creation for Configuration changes](#branch-creation-for-configuration-changes)
2. [Initial Setup](#initial-setup)
    1. [Configuring Backend](#configuring-backend)
    2. [Environment Variables for deployment automation](#environment-variables-for-deployment-automation)
    3. [Create OWNERS file](#create-owners-file)
3. [Promotions / Pull Request Approval Process](#promotions--pull-request-approval-process)
    1. [1st Step](#1st-step)
    2. [Approvals](#approvals)
4. [Pull Request 2nd Day](#pull-request-2nd-day)
    1. [Configuration Changes](#configuration-changes)

## How-To
### Promotion:
Promotion process starts with creating an issue on APP Repository and issue the following comment:
```
/promote version=<version number> env=<this environment suffix> {tracking_d=CUSTOM TRACKING ID}
```
Version suffix stands for the name after `environment-<organization>-` on this repository name.

### Branch Creation for Configuration changes
This will create a new Branch with following naming:
* config-< declarative branch name >
*  Run Following command on the new branch
  ```shell
  make env/config
  ```
* Do all configuration changes on **./values/**

* Commit changes to the branch and push to repository
* Create a new pull request in order to start the deployment, depending if automatic or not will merge the PR to Master branch.

## Initial Setup
### Configuring Backend
First step is to configure the backend configuration for the environment
this is done copying the following file: `backend.tf_template` as `backend.tf`
there is a asample configuration for S3 backend where it can be done but
you can select whatever backend suits for the case. <br/>
Documentation about Terraform Backends can be found **[here](https://developer.hashicorp.com/terraform/language/settings/backends/configuration)**.

### Environment Variables for deployment automation
The second point is to configure the environment variables to
setup this environment and maintain the S3 Bucket and deployment pipeline. <br/>

First step is to run the following command:
```shell
make env/init
```

### Create OWNERS file
This file is require to configure the automation workflow
you have to copy current `OWNERS_template` to `OWNERS
* For this kind of repository you must have the following set:
  ```yaml
  automatic: false
  ```
* Branch protection is set as default for this kind of repository:
  ```yaml
  branchProtection: true
  ```
  Branch will be protected automatically in order to preserve consistency on master branch.
* Protected sources are set as default but can be expanded:
  ```yaml
  protectedSources:
  - "*.tf"
  - "*.tfvars"
  - OWNERS
  - Makefile
  - .github
  ```
  Any changes on these files will fail the checks and invalidate the merge of the pull request.
* Adjust the number of required reviewers, remember that the approvals
  should fulfill the number selected here, the entry is required.
  ```yaml
  requiredReviewers: 2
  ```
* Next you have to configure the valid reviewers/approvers on the workflow
  the entry is required, the users listed are the GitHub Ids.
  ```yaml
  reviewers:
    - user1
    - user2
    - user3
  ```
* When branch protection is enabled, you can configure the owners that can bypass the protection rules:
  the entry is required and the users are listed as GitHub Ids, teams can be specified by org/team-name.
  ```yaml
  owners:
    - user1
    - user2
    - user3
    - org1/team1
  ```
* You can setup forefront the contributors list and their role with the repository.
  This automates the way roles are assigned to the repo.
  It is preferred to have list of groups instead of users.
  To leave a role empty just indicate the empty list `[]`.
  ```yaml
  contributors:
  admin:
    - org1/admins1
  triage: []
  read: []
  write:
    - org1/devs1
  maintain: []
  ```
* Push changes to Master ...
* Proceed with Promotion Process.

## Promotions / Pull Request Approval Process
### 1st step
* After successful processing of workflow, you will obtain the enabled URLS and environment in the comments of the Pull Request.
* All Checks Must be green in order to proceed with the promotion.
### Approvals
* Requirement:
   * Access to the GitHub Repository via Web https://github.com
   * CLI (gh) installed and configured to proceed to the approval.
* With UI proceed this way:
   * Perform the Review of the Pull Request, clicking on the banner on the top of the Pull Request
   * In the Review section, select the Approve option, and write `/approved` in the comment section.
* With the CLI Run the following commands
   * Approve the Pull Request
     ```shell
     gh pr review <PR#> --approved
     ```
   * Comment the Pull request with /approved to evaluate merge
     ```shell
     gh pr comment <PR#> --body "/approved"
     ```

## Pull Request 2nd Day
On each values changes, push into the branch and create a pull request against master branch.~~~~

### Configuration changes
* Do all configuration changes on **./values/**
* Commit changes to the branch and push to repository

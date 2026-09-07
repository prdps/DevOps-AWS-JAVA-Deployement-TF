# Credential handling

## AWS authentication

Terraform reads credentials from the AWS provider's normal credential chain. Keep credentials out of Terraform files, variable files, startup scripts, and Git.

- For local work, prefer an AWS IAM Identity Center (SSO) profile with temporary credentials. The README has the setup commands. If using an existing profile, select it with `AWS_PROFILE`.
- On EC2, use an instance profile with an IAM role. Do not copy personal access keys onto a Jenkins server or agent. Each machine that calls AWS needs its own authorized identity.
- For CI outside AWS, use federation/OIDC with an IAM role when supported. If a tool requires a stored secret, bind it from the CI credential store only for the step that needs it.
- Grant only the permissions needed by each job. Provisioning infrastructure and deploying an application should use separate roles in a shared environment. These learning configurations still require an IAM and network review before production use.

## Jenkins and other tools

- Store Docker Hub access tokens, SonarQube tokens, Nexus credentials, and deployment credentials in Jenkins Credentials or a dedicated secret manager. Reference credential IDs in pipelines.
- Prefer scoped service tokens over personal account passwords. Set expirations where supported and rotate them regularly.
- Use single-quoted Groovy shell blocks for bound secrets, quote shell variables, and disable shell tracing before using them. Never echo passwords, dump credential environment variables, or archive temporary credential files.
- Run credential-bearing jobs only on trusted agents. Jenkins log masking does not prevent malicious build code from reading a bound secret.
- Keep SSH private keys and kubeconfig files private to the account that uses them. Prefer short-lived role authentication for EKS; do not embed static Kubernetes bearer tokens.

## Files and Git

The `.gitignore` excludes common local credential files, private keys, Terraform state, saved plans, and local variable files. It is a safeguard, not a secret scanner: it does not protect already tracked files or stop `git add -f`.

Review staged changes before committing. Commit only placeholders in example files. Do not upload Terraform state, plan files, credentials, or logs containing secrets as public build artifacts. Commit `.terraform.lock.hcl`; it records provider versions and checksums, not AWS keys.

## Previously exposed credentials

Earlier commits contained AWS credentials. The current provider configuration no longer embeds them. Their revocation status has not been verified.

1. Treat exposed keys as compromised. In AWS IAM, deactivate the affected keys promptly, replace dependent access with a role or a new approved credential, and delete the old keys. Do not reuse keys from repository history.
2. Review CloudTrail activity, IAM changes, and unexpected resources or charges. Investigate sessions that may have been created with the exposed keys as well.
3. Coordinate removal of sensitive data from Git history, forks, and cached views using GitHub's guidance. History rewriting changes commit IDs and requires collaborators to resynchronize; it is a separate maintenance action.
4. Keep GitHub secret scanning and push protection enabled; both are enabled for this repository. A clean current branch or rewritten history does not invalidate a leaked credential.

## References

- [Terraform AWS provider authentication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#authentication-and-configuration)
- [AWS guidance for securing access keys](https://docs.aws.amazon.com/IAM/latest/UserGuide/securing_access-keys.html)
- [Jenkins credential handling](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#handling-credentials)
- [Removing sensitive data from GitHub](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/removing-sensitive-data-from-a-repository)

Terraform MCP Server – Developer Techniques

Expression REPL (Terraform Console in the IDE)

Instruction:
“Evaluate this Terraform expression in the current workspace context.”

Example: highlight cidrsubnet(var.vpc_cidr, 3, 5) → get result inline.

Refactor Resource Names Safely

Instruction:
“Rename this Terraform resource and update all references across the repo. Suggest a terraform state mv command to keep state aligned.”

Inline Module Expansion

Instruction:
“Expand this module call into the actual resource code so I can customize it inline.”

Module Extraction

Instruction:
“Extract this repeated block into a new module with main.tf and replace each instance with a module call.”

Auto-insert Providers

Instruction:
“Insert a provider block for any provider required by resources in this file that isn’t declared yet.”

Generate Unit Tests

Instruction:
“Generate a test that asserts the output of this variable matches the expected CIDR / IAM policy / Route53 zone.”

Selective Planning

Instruction:
“Run a plan that only shows changes for this module or resource.”

AWS Core MCP Server – Cloud-Aware Techniques

Check SCPs Before Apply

Instruction:
“List the Service Control Policies applied to this account and tell me if any deny the service or action this resource needs.”

IAM Validation

Instruction:
“Simulate whether my role can actually call this API (e.g., sts:AssumeRole, ec2:RunInstances) before Terraform runs.”

Resource Drift Check

Instruction:
“Check if the actual AWS resource configuration matches what Terraform state expects.”

Sandbox Apply with Guardrails

Instruction:
“Apply just this module into the sandbox account and run post-checks to confirm the resources came up healthy.”

Cross-Account Policy Awareness

Instruction:
“Check if this resource will be blocked by SCPs or permission boundaries in child accounts before I commit.”

Meta / Repo Guidance

Inline Doc Generation

Instruction:
“Generate a Markdown table of inputs/outputs for this module from its variables.tf and outputs.tf.”

Security Lint

Instruction:
“Scan this file for insecure defaults (open CIDRs, overly broad IAM). Suggest safer replacements.”

Architectural Review

Instruction:
“Compare my VPC/subnet/IAM design to AWS Well-Architected and flag misalignments.”

End-to-End Validation

Instruction:
“After applying, run integration checks (e.g., can service A reach service B over private link?).”

How to use this list

Save it as MCP_GUIDE.md in your repo.

While working, highlight a block or file → tell Copilot: “Apply item 2 from MCP_GUIDE.md here”.

Or just ask: “MCP Guide item 8: Check SCPs for this account against my new S3 bucket”.

That way, you have a menu of power moves to keep reminding yourself that you’re not limited to the old Terraform workflow anymore.

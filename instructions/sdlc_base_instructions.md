## Summary
This PR adds new CAPEX-REQUESTS account configurations for SDLC environments.

## Changes Made
- **Added CAPEX-REQUESTS accounts** for all SDLC environments:
  - DEV: `sdlc-dev-capex-requests`
  - QA: `sdlc-qa-capex-requests`
  - UAT: `sdlc-uat-capex-requests`

## Account Details
- **Account Names**: SDLC-DEV-CAPEX-REQUESTS, SDLC-QA-CAPEX-REQUESTS, SDLC-UAT-CAPEX-REQUESTS
- **VPC Configuration**: Small VPCs with application subnets in us-east-2 and us-west-2
- **Harness Integration**: Enabled for all environments
- **Requested By**: William Gustave

## Impact
- New SDLC accounts available for CAPEX-REQUESTS project
- No breaking changes to existing infrastructure

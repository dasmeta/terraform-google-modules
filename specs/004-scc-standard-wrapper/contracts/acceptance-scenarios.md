# Contract: Acceptance Scenarios

## Scenario 1: Baseline onboarding

- Given an eligible project without the prepared baseline
- When the module is applied with the required inputs
- Then required services are enabled and the project converges to the documented prepared baseline while SCC activation remains a separately documented prerequisite

## Scenario 2: Additive IAM only

- Given a project with existing unrelated IAM bindings
- When the module applies approved operator access
- Then required identities are added without removing unrelated project bindings

## Scenario 3: Optional logging enabled

- Given a valid logging destination
- When `logging_integration_enabled` is `true`
- Then the module creates or connects the logging export resources and exposes the resulting references

## Scenario 4: Optional logging disabled

- Given no logging destination
- When `logging_integration_enabled` is `false`
- Then the baseline still converges successfully without logging resources

## Scenario 5: Failure on missing prerequisites

- Given a project where required services, permissions, organization readiness, or logging destination access are unavailable
- When the module is applied
- Then the apply fails clearly before claiming baseline convergence

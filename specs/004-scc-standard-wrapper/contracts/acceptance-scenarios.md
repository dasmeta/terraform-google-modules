# Contract: Acceptance Scenarios

## Scenario 1: Baseline onboarding

- Given an eligible project without the baseline
- When the module is applied with the required inputs
- Then the required services are enabled and the project converges to the documented security baseline

## Scenario 2: Additive IAM only

- Given a project with existing unrelated IAM bindings
- When the module applies required baseline access
- Then required identities are added without removing unrelated project bindings

## Scenario 3: Optional integrations enabled

- Given valid logging and monitoring destinations
- When the corresponding integration flags are enabled
- Then the module creates or connects those integrations and exposes the resulting references

## Scenario 4: Optional integrations disabled

- Given no operational destinations
- When both integration flags are disabled
- Then the baseline still converges successfully without integration resources

## Scenario 5: Failure on missing prerequisites

- Given a project where required services, permissions, or destinations are unavailable
- When the module is applied
- Then the apply fails clearly before claiming baseline convergence

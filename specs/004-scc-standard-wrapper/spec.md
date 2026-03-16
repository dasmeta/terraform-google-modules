# Feature Specification: Project SCC Standard Baseline

**Feature Branch**: `004-scc-standard-wrapper`  
**Created**: 2026-03-16  
**Status**: Draft  
**Input**: User description: "Terraform wrapper module that prepares a Google Cloud project for Google Cloud Security Command Center (SCC) Standard operations at the project level. It uses public modules from terraform-google-modules and the Terraform Google Provider to enable required APIs, configure IAM roles, and integrate logging for a consistent security baseline while documenting SCC tier activation as an external prerequisite."

## Clarifications

### Session 2026-03-16

- Q: Should this module be a focused wrapper that uses public Google modules only where they fit cleanly, with direct provider resources for SCC-specific behavior when no suitable module exists? → A: Yes. Build a focused wrapper that uses public modules for IAM and log export where suitable, and direct provider resources for SCC-specific behavior when no suitable public module exists.
- Q: Should the first release manage only logging export and leave monitoring or alerting artifacts out of scope? → A: Yes. The first release manages logging export only, and monitoring or alerting artifacts are out of scope.
- Q: If Terraform cannot activate SCC Standard tier for a project directly, should the module scope be reduced to prerequisites, IAM, and logging while documenting SCC activation as a manual prerequisite? → A: Yes. The module should manage prerequisites, additive IAM, and optional logging export, and document SCC activation as an external manual prerequisite.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Prepare a project security baseline (Priority: P1)

A platform engineer applies the module to a Google Cloud project and gets the minimum project-level prerequisites required for Security Command Center Standard operations configured consistently.

**Why this priority**: Without a reliable baseline preparation path, teams cannot onboard projects into the organization’s expected security posture.

**Independent Test**: Can be fully tested by applying the module to a new or existing project and confirming the required prerequisites are enabled and the documented manual SCC activation prerequisite is explicit.

**Acceptance Scenarios**:

1. **Given** a project that is not yet prepared for the security baseline, **When** the platform engineer applies the module with the required project inputs, **Then** the required service prerequisites are enabled and the module documents that SCC tier activation remains an external prerequisite.
2. **Given** a project that already has some prerequisites enabled, **When** the platform engineer applies the module, **Then** the project reaches the same target prepared baseline without requiring manual cleanup first.

---

### User Story 2 - Grant the required access safely (Priority: P2)

A platform engineer can assign the minimum required project-level access so the security service and approved operators can function without manually managing multiple bindings after onboarding.

**Why this priority**: Access setup is necessary for the baseline to work in practice, but it is secondary to enabling the baseline itself.

**Independent Test**: Can be fully tested by onboarding a project, verifying the expected access bindings are created, and confirming no unexpected project-wide permissions are introduced.

**Acceptance Scenarios**:

1. **Given** a project ready for onboarding, **When** the platform engineer provides the approved identities for service operation and administration, **Then** the module assigns the documented project-level access required for those identities.
2. **Given** a project with no optional administrator identities provided, **When** the module is applied, **Then** only the baseline-required access is assigned.

---

### User Story 3 - Export security signals to operations (Priority: P3)

A security or platform team can use the module to connect the project’s security findings to the organization’s logging baseline so findings are visible in normal operational workflows.

**Why this priority**: Logging integration improves response and consistency, but baseline activation and access setup deliver the first usable value.

**Independent Test**: Can be fully tested by onboarding a project with logging integration enabled and confirming the expected security signals appear in the designated logging destination.

**Acceptance Scenarios**:

1. **Given** a project being onboarded with logging integration enabled, **When** the module is applied, **Then** security findings are forwarded to the configured logging destination.
2. **Given** a project being onboarded without optional logging integration enabled, **When** the module is applied, **Then** the core security baseline is created without failing because the optional destination is absent.

---

### Edge Cases

- What happens when the target project already has part of the security baseline configured manually?
- How does the module handle a project where one or more required service prerequisites cannot be enabled because of organization policy or insufficient privileges?
- What happens when the logging destination specified by the platform team does not exist or is not accessible?
- How does the module behave when it is applied repeatedly to the same project after onboarding is complete?

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The system MUST allow a platform engineer to prepare a single Google Cloud project for Security Command Center Standard operations using a single reusable project-level baseline configuration.
- **FR-002**: The system MUST ensure all documented project-level prerequisites required for the prepared baseline are enabled during onboarding.
- **FR-003**: The system MUST allow the platform engineer to define the target project that will receive the security baseline.
- **FR-004**: The system MUST assign the documented project-level access managed by this module for approved operator identities after baseline preparation.
- **FR-005**: The system MUST allow the platform engineer to provide additional approved administrator identities that need project-level access for operating the security baseline.
- **FR-006**: The system MUST avoid granting optional administrator access when no optional administrator identities are provided.
- **FR-007**: The system MUST support onboarding projects that are partially configured already and converge them to the documented target prepared baseline without requiring manual rework.
- **FR-008**: The system MUST provide a clear failure outcome when required project-level prerequisites, permissions, or destinations are unavailable.
- **FR-009**: The system MUST allow the platform engineer to enable or disable logging integration for security findings per project.
- **FR-010**: The system MUST direct security findings to the configured logging destination when logging integration is enabled.
- **FR-011**: The system MUST treat monitoring dashboards, alerts, and other monitoring artifacts as out of scope for the first release and document that boundary explicitly.
- **FR-012**: The system MUST complete repeated onboarding runs for the same project without creating duplicate access assignments or duplicate logging integrations.
- **FR-013**: The system MUST document the expected inputs, optional settings, and resulting project-level baseline so a platform engineer can onboard a project without external tribal knowledge.
- **FR-014**: The system MUST prefer composition of suitable public `terraform-google-modules` components for adjacent concerns such as IAM and log export, and MUST use direct Google provider resources for SCC-specific behavior when no suitable public module exists.
- **FR-015**: The system MUST document that SCC Standard tier activation itself is an external manual prerequisite and MUST NOT claim to automate that activation if provider support is unavailable.

### Key Entities *(include if feature involves data)*

- **Project Security Baseline**: The target prepared state applied to a Google Cloud project, including required prerequisites, approved access assignments, optional logging integration, and documentation of external SCC activation requirements.
- **Approved Identity**: A service identity or administrator identity that is allowed to receive project-level access needed to operate or observe the security baseline.
- **Operational Destination**: A logging endpoint designated to receive security findings for visibility and response.
- **Onboarding Request**: The set of project-specific inputs a platform engineer provides to apply the baseline to one project.

### Assumptions

- The module is intended for one project at a time and is reused across many projects rather than managing an entire organization in one deployment.
- Security Command Center Standard is the intended service tier for the first release of this baseline.
- Logging integration is optional, but baseline security enablement and required access are mandatory.
- Monitoring dashboards, alerts, and other monitoring artifacts are handled outside this module for the first release.
- The organization already has a preferred logging destination pattern, and this feature only needs to connect a project to that destination.
- The caller has sufficient organization and project permissions to onboard the target project when prerequisites are allowed by policy.
- Public `terraform-google-modules` components are used selectively where they match the project-scoped use case; the module does not wrap broader project lifecycle modules wholesale when a narrower direct-provider implementation is cleaner.
- Project-level SCC tier activation remains a manual or external step outside this module until official Terraform coverage supports it safely.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A platform engineer can prepare a net-new project for the documented security baseline in one execution path using only the required project inputs plus the separately documented manual SCC activation step.
- **SC-002**: At least 95% of onboarding attempts for eligible projects complete without any manual post-configuration steps.
- **SC-003**: Re-applying the baseline to an already onboarded project results in no duplicate access assignments or duplicate logging integrations in 100% of validation runs.
- **SC-004**: Platform teams can connect a project’s security findings to their chosen logging destination in under 15 minutes of configuration time.
- **SC-005**: At least 90% of pilot users can onboard a project using the module documentation without needing repository-specific verbal guidance.

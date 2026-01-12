---
name: generate-prd
description: Generate a structured PRD (Product Requirements Document) with user stories from a natural language project description
license: MIT
compatibility: opencode
---

# Generate PRD Skill

You are a product manager creating a PRD (Product Requirements Document) from a user's description.

## Input

The user will provide a natural language description of what they want to build.

## Output

Create a comprehensive PRD in markdown format with the following structure:

```markdown
# PRD: [Project Name]

## Overview

[2-3 sentence description of the project]

## Goals

- [Goal 1]
- [Goal 2]
- [Goal 3]

## User Stories

### STORY-001: [Title]
**Priority:** 1 (highest)
**Description:** [What needs to be done]

**Acceptance Criteria:**
- [ ] [Criterion 1]
- [ ] [Criterion 2]
- [ ] [Criterion 3]

---

### STORY-002: [Title]
**Priority:** 2
**Description:** [What needs to be done]

**Acceptance Criteria:**
- [ ] [Criterion 1]
- [ ] [Criterion 2]

---

[Continue for all stories...]

## Technical Notes

- [Any technical considerations]
- [Dependencies]
- [Constraints]

## Out of Scope

- [What this PRD does NOT cover]
```

## Guidelines

### Story Sizing

Each story should be:
- **Small enough** to implement in one AI context window (~30 min of work)
- **Self-contained** with clear acceptance criteria
- **Independently testable**

If a feature is too large, break it into multiple stories.

### Priority Rules

- **Priority 1**: Foundation/setup stories (must be done first)
- **Priority 2-3**: Core functionality
- **Priority 4-5**: Secondary features
- **Priority 6+**: Nice-to-haves, polish

### Story ID Format

Use format: `STORY-001`, `STORY-002`, etc.

### Acceptance Criteria

Each criterion should be:
- **Specific** and testable
- **Binary** (either done or not done)
- Written as "When X, then Y" or imperative statements

### Good Examples

```markdown
### STORY-001: Initialize project structure
**Priority:** 1
**Description:** Set up the basic project structure with necessary configuration files.

**Acceptance Criteria:**
- [ ] package.json exists with project name and dependencies
- [ ] TypeScript configured with tsconfig.json
- [ ] Basic folder structure created (src/, tests/)
- [ ] .gitignore configured for Node.js project
```

### Bad Examples

```markdown
### STORY-001: Build the app
**Description:** Make the whole application work

**Acceptance Criteria:**
- [ ] App works
```

(Too vague, too large, not testable)

## After Generation

After generating the PRD, inform the user:

1. The PRD has been created
2. They should review and adjust priorities/stories as needed
3. To convert to Ralph's JSON format, run: `/convert-to-json`
4. Then run `ralph` to start autonomous implementation

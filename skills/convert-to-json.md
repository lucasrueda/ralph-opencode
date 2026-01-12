# Convert PRD to JSON Skill

You convert a markdown PRD document into Ralph's `prd.json` format.

## Input

Look for a PRD in one of these locations (in order):
1. A file the user specifies
2. `PRD.md` in the current directory
3. `prd.md` in the current directory
4. `docs/PRD.md`
5. The most recently created `.md` file that looks like a PRD

## Output Format

Create a `prd.json` file with this exact structure:

```json
{
  "project": "Project Name",
  "branchName": "feature/project-name",
  "description": "Brief project description",
  "userStories": [
    {
      "id": "STORY-001",
      "title": "Story title",
      "description": "Detailed description of what needs to be done",
      "acceptanceCriteria": [
        "First criterion",
        "Second criterion"
      ],
      "priority": 1,
      "passes": false,
      "notes": ""
    }
  ]
}
```

## Field Mappings

| PRD Markdown | prd.json |
|-------------|----------|
| `# PRD: Name` | `project` |
| Overview section | `description` |
| `### STORY-XXX: Title` | `id`, `title` |
| Description under story | `description` |
| `**Priority:** N` | `priority` |
| Acceptance Criteria list | `acceptanceCriteria` array |

## Rules

1. **All stories start with `passes: false`** - Ralph marks them true as it completes them
2. **All stories start with empty `notes`** - Ralph fills these in
3. **Branch name** - Generate from project name: lowercase, hyphenated, prefixed with `feature/`
4. **Preserve priority order** - Keep the priority numbers from the PRD
5. **Clean acceptance criteria** - Remove markdown checkboxes `- [ ]` from criteria text

## Example Conversion

### Input (PRD.md):
```markdown
# PRD: User Authentication System

## Overview
A secure authentication system with login, registration, and password reset.

## User Stories

### STORY-001: Setup authentication framework
**Priority:** 1
**Description:** Initialize the auth module with necessary dependencies

**Acceptance Criteria:**
- [ ] Auth module created in src/auth/
- [ ] JWT library installed and configured
- [ ] Environment variables documented
```

### Output (prd.json):
```json
{
  "project": "User Authentication System",
  "branchName": "feature/user-authentication-system",
  "description": "A secure authentication system with login, registration, and password reset.",
  "userStories": [
    {
      "id": "STORY-001",
      "title": "Setup authentication framework",
      "description": "Initialize the auth module with necessary dependencies",
      "acceptanceCriteria": [
        "Auth module created in src/auth/",
        "JWT library installed and configured",
        "Environment variables documented"
      ],
      "priority": 1,
      "passes": false,
      "notes": ""
    }
  ]
}
```

## After Conversion

After creating `prd.json`:

1. Confirm the file was created
2. Show a summary: project name, number of stories, priority breakdown
3. Remind user to run `ralph` to start autonomous implementation
4. Optionally create `progress.txt` if it doesn't exist:

```markdown
# Progress Log: [Project Name]

This file tracks Ralph's progress through the PRD.
Each completed story will be logged below.

---
```

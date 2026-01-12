# Ralph for OpenCode

An autonomous AI agent that implements PRD (Product Requirements Document) stories one by one until your project is complete.

Ralph is inspired by [snarktank/ralph](https://github.com/snarktank/ralph), adapted for [OpenCode](https://opencode.ai).

## How It Works

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│   You describe what you want to build                           │
│                    ↓                                            │
│   /generate-prd creates a structured PRD                        │
│                    ↓                                            │
│   /convert-to-json creates prd.json                             │
│                    ↓                                            │
│   ralph loops until all stories are complete                    │
│      ↓                                                          │
│      ├── Pick highest priority incomplete story                 │
│      ├── Implement it                                           │
│      ├── Run tests (optional)                                   │
│      ├── Commit changes                                         │
│      ├── Mark story as complete                                 │
│      ├── Log learnings to progress.txt                          │
│      └── Repeat...                                              │
│                    ↓                                            │
│   All stories complete!                                         │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## Installation

### One-liner (recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/lucasrueda/ralph-opencode/main/install.sh | bash
```

### Manual

```bash
git clone https://github.com/lucasrueda/ralph-opencode.git ~/.opencode/ralph-opencode
cd ~/.opencode/ralph-opencode
./install.sh
```

### Requirements

- [OpenCode](https://opencode.ai) installed and configured
- `jq` for JSON parsing
- `git` for version control

## Quick Start

```bash
# 1. Navigate to your project (or create a new one)
mkdir my-project && cd my-project
git init

# 2. Generate a PRD from your idea
opencode "/generate-prd Build a CLI tool that converts CSV files to JSON"

# 3. Review the generated PRD.md and adjust if needed

# 4. Convert to Ralph's JSON format
opencode "/convert-to-json"

# 5. Run Ralph - it will autonomously implement all stories
ralph
```

## Commands

### `/generate-prd <description>`

Generates a structured PRD from a natural language description.

```bash
opencode "/generate-prd A REST API for managing todo items with authentication"
```

Creates a `PRD.md` file with:
- Project overview
- User stories with priorities
- Acceptance criteria for each story
- Technical notes

### `/convert-to-json`

Converts a markdown PRD to Ralph's `prd.json` format.

```bash
opencode "/convert-to-json"
```

### `ralph`

Runs the autonomous loop that implements stories one by one.

```bash
ralph                      # Run with defaults
ralph -m 20                # Max 20 iterations
ralph -p ./docs/prd.json   # Custom PRD path
ralph -d                   # Dry run (show what would happen)
ralph -h                   # Show help
```

## File Structure

When running Ralph, your project will have:

```
my-project/
├── prd.json          # PRD in JSON format (Ralph reads/updates this)
├── progress.txt      # Learnings log (Ralph appends to this)
├── PRD.md            # Original markdown PRD (optional)
└── ... your code
```

### prd.json Format

```json
{
  "project": "My Project",
  "branchName": "feature/my-project",
  "description": "Project description",
  "userStories": [
    {
      "id": "STORY-001",
      "title": "Initialize project",
      "description": "Set up the basic structure",
      "acceptanceCriteria": ["criterion 1", "criterion 2"],
      "priority": 1,
      "passes": false,
      "notes": ""
    }
  ]
}
```

- **priority**: Lower number = higher priority (1 is highest)
- **passes**: `false` = incomplete, `true` = done
- **notes**: Ralph fills this with implementation details

## Configuration

Ralph uses OpenCode's skills system. After installation, skills are located at:

```
~/.opencode/skills/
├── ralph.md            # Core agent behavior
├── generate-prd.md     # PRD generation
└── convert-to-json.md  # JSON conversion
```

You can customize these skills to change Ralph's behavior.

## Tips

### Writing Good PRDs

- **Keep stories small**: Each story should be completable in ~30 minutes
- **Clear acceptance criteria**: Binary pass/fail conditions
- **Proper priorities**: Foundation work first (priority 1), features later

### Monitoring Progress

Watch Ralph work:
```bash
# In another terminal
tail -f progress.txt
```

Check status:
```bash
jq '.userStories[] | {id, title, passes}' prd.json
```

### Resuming Work

Ralph is stateless between runs. Just run `ralph` again to continue where you left off.

### Handling Failures

If a story fails repeatedly:
1. Check `progress.txt` for learnings
2. Manually fix the blocker
3. Run `ralph` again

## Uninstalling

```bash
~/.opencode/ralph-opencode/uninstall.sh
```

Or manually:
```bash
rm -rf ~/.opencode/ralph-opencode
rm ~/.opencode/skills/{ralph,generate-prd,convert-to-json}.md
rm ~/.local/bin/ralph
```

## Credits

- Original Ralph concept: [snarktank/ralph](https://github.com/snarktank/ralph)
- Built for: [OpenCode](https://opencode.ai)

## License

MIT

# Clean Code Standards — Skeleton

Generate a project-specific clean code rule file. The output must be a complete `.claude/rules/clean-code.md` with YAML frontmatter (`paths` matching the project's source files) and markdown body.

Tailor every section to the project's actual language, framework, and conventions. Use the project's real directory names, file patterns, and idioms — not generic placeholders.

## Required Sections

### DRY (Don't Repeat Yourself)

Cover these scenarios with project-specific extraction targets:

- Repeated logic → where to extract utilities (use actual project paths)
- Repeated UI patterns → where to extract components (if applicable)
- Repeated data access → where to extract services/hooks/repositories
- Repeated validation → where to centralize

Include a before/after code example in the project's primary language.

### SOLID Principles

Cover all applicable principles with project-specific examples:

- **SRP**: Max module size, how to split responsibilities in this stack
- **Open/Closed**: Extension patterns idiomatic to the framework
- **Interface Segregation**: Minimal interfaces/props/contracts
- **Dependency Inversion**: DI patterns used in this stack (if applicable)

Skip principles that don't apply to the stack (e.g., DI in a simple script project).

### Naming Conventions

Define naming rules for the project's language and framework:

- Variables, functions, classes/components, constants
- Booleans (`is*`, `has*`, etc.)
- Event handlers, async functions, hooks/decorators (if applicable)
- File naming conventions (kebab-case, PascalCase, etc.)

Use a table format.

### Forbidden Patterns

List anti-patterns specific to the stack:

- Type safety violations (e.g., `any` in TS, `object` in Java)
- Debug artifacts (console.log, print, etc.)
- Framework-specific anti-patterns (e.g., useEffect for data fetching in React, N+1 queries in ORM)
- Code style violations (nested ternaries, magic numbers, deep nesting)

Use a table with columns: Pattern | Why | Alternative.

### File Organization

Describe the project's actual directory structure and conventions:

- Where shared/reusable code lives
- Where feature-specific code goes
- Import ordering rules specific to the stack
- Module/component internal structure template

### Testing Requirements

Define what needs tests based on the project's test setup:

- Unit test expectations
- Integration/E2E expectations
- Bug fix regression test rule

### Code Review Checklist

Provide a checkbox list of items to verify before committing, tailored to the stack.

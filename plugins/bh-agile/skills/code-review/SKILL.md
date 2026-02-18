---
name: code-review
description: Review code for DRY, SOLID, and Clean Code violations. Use when the user asks to "review code", "code review", "check code quality", "/code-review". Also activates during /implement Phase 3.5 when code-simplifier agent is invoked.
argument-hint: "[file-or-directory]"
---

# Code Quality Review

You are a senior code quality engineer. Review the specified code (or recent changes) against our Clean Code standards.

## Review Process

1. **Identify the scope**: If no file specified, review files changed in the current session or ask user
2. **Read the code** using the Read tool
3. **Analyze** against each category below
4. **Report findings** with severity, line numbers, and specific fixes

## Review Categories

### 1. DRY Violations (Don't Repeat Yourself)

Look for:
- Duplicated logic across functions/components
- Copy-pasted code blocks
- Similar patterns that could be abstracted

```
🔴 DRY Violation: Lines 45-52 and 78-85 contain identical logic
   → Extract to shared utility function
```

### 2. SOLID Violations

**Single Responsibility**:
- Components doing too many things (>150 lines is a smell)
- Functions with multiple unrelated operations

**Open/Closed**:
- Hard-coded conditionals that should be configurable
- Switch statements that grow with each new type

**Interface Segregation**:
- Props interfaces with many optional fields
- Passing entire objects when only few fields needed

```
🟠 SRP Violation: Dashboard.tsx (245 lines) handles fetching, filtering, AND rendering
   → Split into: useFilters hook + DashboardView component
```

### 3. Naming Convention Violations

Check against our conventions:
| Type | Pattern | Example |
|------|---------|---------|
| Booleans | `is*`, `has*`, `can*` | `isLoading` |
| Event handlers (props) | `on*` | `onClick` |
| Event handlers (impl) | `handle*` | `handleClick` |
| Hooks | `use*` | `useData` |

```
🟡 Naming: Line 23 - `loading` should be `isLoading`
🟡 Naming: Line 45 - `clickHandler` should be `handleClick` or `onClick`
```

### 4. Forbidden Patterns

Flag these immediately:
- `any` type usage
- `console.log` statements
- Inline styles (should use CSS classes or utility framework)
- `useEffect` for data fetching (prefer server-side or library solutions)
- Index as React key
- Nested ternaries (>2 levels)
- Magic numbers without constants

```
🔴 Forbidden: Line 67 - `any` type used, replace with `unknown` + type guard
🔴 Forbidden: Line 89 - console.log should use logger utility
```

### 5. Type Safety Issues

- Missing return types on functions
- Implicit `any` from untyped imports
- Non-null assertions (`!`) without justification
- Type assertions (`as`) that could be narrowed properly

```
🟠 Type Safety: Line 34 - Add explicit return type to `formatDate` function
🟠 Type Safety: Line 56 - Replace `as Event` with type guard
```

## Output Format

```markdown
## Code Review: [filename]

### Summary
- 🔴 Critical: X issues
- 🟠 Important: X issues
- 🟡 Minor: X issues
- ✅ Good practices observed: [list]

### Critical Issues (Must Fix)

#### 1. [Issue Title]
**Location**: `file.tsx:45-52`
**Category**: DRY / SOLID / Naming / Forbidden / Type Safety
**Problem**: [Description]
**Fix**:
```typescript
// Before
[problematic code]

// After
[fixed code]
```

### Important Issues (Should Fix)
[...]

### Minor Issues (Nice to Fix)
[...]

### Recommendations
- [Architectural suggestions]
- [Refactoring opportunities]
```

## Example Usage

User: `/code-review src/components/Card.tsx`
User: `/code-review` (reviews recent changes)
User: `/code-review --all src/utils/` (reviews directory)

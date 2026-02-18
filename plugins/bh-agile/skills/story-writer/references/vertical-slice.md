# Vertical Slice Architecture

## What is a Vertical Slice?

A cross-cutting piece of functionality that delivers complete user value:

```
┌─────────────────────────────────────────┐
│           VERTICAL SLICE                │
├─────────────────────────────────────────┤
│  UI Layer      │ Component              │
│  Logic Layer   │ Validation             │
│  API Layer     │ Endpoint / Action      │
│  Data Layer    │ Database Query         │
├─────────────────────────────────────────┤
│  + Unit Tests + E2E Tests               │
└─────────────────────────────────────────┘
```

## Vertical vs Horizontal

### Horizontal (BAD)
```
❌ "Implement TODO API" - Only API layer
❌ "Create TODO UI components" - Only UI layer
❌ "Design TODO database schema" - Only data layer
```

### Vertical (GOOD)
```
✅ "User can add a new TODO"
   └── UI + API + DB + Tests
```

## Story Decomposition

**Feature:** TODO Management

**Horizontal (WRONG):**
- S001: TODO Database Schema
- S002: TODO API Endpoints
- S003: TODO UI Components
- S004: TODO Tests

**Vertical (CORRECT):**
- S001: User can view their TODO list
- S002: User can add a new TODO
- S003: User can mark a TODO as complete
- S004: User can edit a TODO
- S005: User can delete a TODO

Each story delivers a working feature the user can interact with end-to-end.

## Checklist

- [ ] Has user-facing component
- [ ] Data flows from DB to UI
- [ ] User can perform complete action
- [ ] Can write E2E test for the flow
- [ ] Can deploy independently

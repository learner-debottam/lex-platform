# Commit Message Guidelines

## Conventional Commits Format

All commit messages must follow the Conventional Commits specification:

```
<type>(<scope>): <subject>

<body>

<footer>
```

## Commit Types

- **feat**: A new feature
  - Example: `feat(bot): add finance bot with loan application intent`
  
- **fix**: A bug fix
  - Example: `fix(intents): resolve slot type reference for AMAZON.Date`
  
- **docs**: Documentation only changes
  - Example: `docs(readme): update deployment instructions`
  
- **style**: Changes that don't affect code meaning (formatting, whitespace)
  - Example: `style(terraform): format HCL files`
  
- **refactor**: Code change that neither fixes a bug nor adds a feature
  - Example: `refactor(locals): simplify slot type lookup logic`
  
- **perf**: Performance improvement
  - Example: `perf(workflow): parallelize terraform plans`
  
- **test**: Adding or updating tests
  - Example: `test(module): add validation tests for bot creation`
  
- **build**: Changes to build system or dependencies
  - Example: `build(terraform): upgrade to version 1.6.0`
  
- **ci**: Changes to CI/CD configuration
  - Example: `ci(github): add checkov security scanning`
  
- **chore**: Other changes that don't modify src or test files
  - Example: `chore(gitignore): add terraform state files`
  
- **revert**: Reverts a previous commit
  - Example: `revert: feat(bot): add finance bot`

## Scope (Optional)

The scope provides additional context:
- `bot` - Bot configuration changes
- `module` - Terraform module changes
- `workflow` - GitHub Actions changes
- `iam` - IAM role/policy changes
- `intents` - Intent configuration
- `slots` - Slot configuration

## Examples

### Good Commit Messages ✅
```
feat(bot): add restaurant bot with multi-locale support

fix(slots): correct slot_type_id reference for custom types

docs(readme): add GitHub Actions setup instructions

refactor(locals): use locale-specific slot type lookup

ci(checkov): add security scanning to pipeline
```

### Bad Commit Messages ❌
```
Added new bot                    # Missing type
FIX: bug in slots                # Wrong case for type
feat: updates                    # Subject too vague
Feature: Add new bot feature     # Wrong format
```

## Rules

1. **Type is required** and must be lowercase
2. **Subject is required** and should be sentence case
3. **Maximum header length**: 100 characters
4. Use imperative mood ("add" not "added" or "adds")
5. Don't end subject with a period

## Setup Git Commit Template

```bash
git config commit.template .gitmessage
```

## Validation

Commit messages are automatically validated on pull requests. Invalid commits will fail the CI check.

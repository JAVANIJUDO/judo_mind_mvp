# Judo Mind AI Development Rules

Version:
2.0

Status:
Active Development Standard

---

# 1. Project Identity

Project Name:

Judo Mind Super App


Platform:

Flutter Mobile Application


Product Type:

Global Digital Judo Ecosystem


Purpose:

A professional digital ecosystem connecting:

- Athletes
- Coaches
- Clubs
- Federations
- Fans
- Administrators


Main Vision:

Train Your Body, Master Your Mind.


---

# 2. Development Philosophy

All development decisions must follow:

- Professional software architecture
- Clean Architecture principles
- Modular development
- Scalability
- Security-first approach
- Localization-first approach
- CMS-first content strategy
- Performance optimization
- Excellent user experience
- Documentation synchronization


Judo Mind must always be developed as a commercial international product.


---

# 3. AI Assistant Role

AI assistant is considered a development partner.

Before generating or modifying code:

Required process:

Analysis

↓

Architecture Check

↓

Dependency Review

↓

Design Decision

↓

Implementation

↓

Testing

↓

Documentation Update

↓

Git Commit


AI must not:

- Guess missing project structure
- Break existing features
- Create duplicate architecture
- Ignore documentation
- Replace approved decisions without review


---

# 4. Coding Rules

Before changing important files:

1. Analyze existing architecture.
2. Check dependencies.
3. Check related documentation.
4. Preserve existing functionality.
5. Avoid unnecessary modifications.


Coding requirements:

- Clean Dart and Flutter standards
- Reusable components
- Modular files
- Meaningful naming
- Readable structure
- Low technical debt
- Testable code


---

# 5. Flutter Architecture Rules

The project must gradually move toward Feature-Based Architecture.


Target:

lib/

core/

features/

shared/


Each module should be:

- Independent
- Expandable
- Testable
- Maintainable


---

# 6. Localization Rules

Internationalization is mandatory.

No user-facing text should be permanently hardcoded.


Wrong:

Text("Training")


Correct:

Text(context.l10n.training)


Supported languages:

- English
- Persian
- Japanese
- French
- German
- Spanish
- Russian
- Arabic


Requirements:

- RTL support
- LTR support
- Runtime language switching
- Localized content
- Localized CMS data


---

# 7. Technique Data Rules

Technique Module is a core competitive advantage.


Each technique should support:


Identity:

- English name
- Japanese name
- Persian translation
- Category
- Difficulty
- Belt level


Technical Layer:

- Kuzushi
- Tsukuri
- Kake
- Execution steps
- Key points
- Common mistakes


Biomechanics Layer:

- Movement analysis
- Force direction
- Center of gravity
- Muscle activation


Training Layer:

- Shadow training
- Uchikomi
- Nagekomi
- Conditioning
- Mobility


Competition Layer:

- Tactical application
- Combinations
- Counters
- Match analysis


AI Layer:

- Recommendations
- Progress analysis
- Personalized training


Sources:

Official sources must be prioritized.

---

# 8. CMS and Content Management Rules

Application content must not depend on Flutter code changes.


Administrators must be able to manage:

- Text
- Images
- Videos
- Audio
- Techniques
- Quiz
- Courses
- News
- Champions
- Translations


All content should be prepared for:

Flutter App

↓

API

↓

Backend

↓

CMS


---

# 9. Design System Rules

All UI development must follow the Judo Mind Design System.


Avoid:

- Random colors
- Random spacing
- Duplicate widgets


Use:

- Theme
- Colors
- Typography
- Spacing
- Radius
- Components


---

# 10. Security Rules

Security must exist from the beginning.


Rules:

- Never store private keys in app code.
- Never expose sensitive data.
- Use secure authentication.
- Protect user information.
- Prepare backend security.
- Validate input.
- Control permissions.


---

# 11. Git Workflow

Before major changes:


1. Test application.
2. Run:

flutter analyze


3. Run:

flutter run


4. Update documentation.
5. Create Git commit.


Commit messages must describe changes.


Example:

Good:

feat(techniques): add dashboard architecture


Bad:

Update


---

# 12. Documentation Rules

No important decision should exist only in conversation.


Required updates:

- ARCHITECTURE.md
- PROJECT_STATUS.md
- CHANGELOG.md
- DECISION_LOG.md
- PRODUCT_REQUIREMENTS.md


Documentation and code must always remain synchronized.


---

# 13. Product Development Rules

Judo Mind is not only software.

Every decision must consider:

- Judo expertise
- Athlete experience
- Coach requirements
- Federation requirements
- Business model
- Competitive advantage
- International scalability


---

# 14. Final Development Rule

Before creating any feature, ask:


1. Is it defined in Product Requirements?

2. Is the architecture location clear?

3. Does it support multilingual users?

4. Can CMS manage it in the future?

5. Is security considered?

6. Is it documented?


Only after these answers:

Development begins.


---

# Final Goal

Build the world's most complete digital Judo ecosystem powered by:

- Judo knowledge
- Sports science
- Artificial intelligence
- Data
- Professional software architecture
---

# 11. Continuous Documentation Synchronization

## Purpose

To ensure that the Judo Mind project remains maintainable, scalable, and understandable throughout its lifecycle, all development activities must be synchronized with the project documentation.

---

## Mandatory Rules

Every significant change to the project must update the related documentation before the task is considered complete.

No architecture, feature, module, or technical decision is allowed to exist only in the source code.

Documentation is considered part of the implementation.

---

## Required Documentation Updates

### Feature Development

Update:

- CHANGELOG.md
- PROJECT_STATUS.md

---

### Architecture Changes

Update:

- ARCHITECTURE.md
- DECISION_LOG.md

---

### Product Changes

Update:

- PRODUCT_REQUIREMENTS.md

---

### Development Process Changes

Update:

- AI_DEVELOPMENT_RULES.md

---

## Completion Checklist

A development task is complete only when all of the following are finished:

- Source code implemented
- Flutter Analyze passed
- Documentation updated
- Decision Log updated (if needed)
- Changelog updated
- Project Status updated

---

## Version Control Philosophy

Documentation is treated as a first-class project asset.

The documentation must always represent the latest approved architecture and implementation.

Project knowledge must never depend solely on conversation history.

---

Status:
Approved

Effective From:
2026-07-31

Project:
Judo Mind Super App

# Design System Rules

All UI components must use the centralized Design Tokens.

Forbidden:

- Hard-coded colors
- Hard-coded spacing
- Hard-coded radius
- Hard-coded animation duration
- Hard-coded icon sizes

Required:

JudoColors

JudoSpacing

JudoRadius

JudoButtonHeight

JudoAnimation

This guarantees visual consistency across all 17 modules.

## Typography Rules

All application text styles must use:

- JudoTypography
- Theme typography derived from JudoTypography

Forbidden:

- Hard-coded font sizes inside feature widgets
- Hard-coded font weights without design-system approval
- Feature-specific typography systems
- Fixed language-specific fonts inside reusable widgets

Typography must support:

- LTR languages
- RTL languages
- Japanese characters
- Cyrillic characters
- Responsive mobile and tablet layouts
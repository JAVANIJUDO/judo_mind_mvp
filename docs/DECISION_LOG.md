# Judo Mind Decision Log

All important architectural, product and technical decisions are recorded here.

---

# JM-DEC-001

Date:
2026-07-30

Status:
Approved

Category:
Architecture

Title:
Evolution of Judo Mind Architecture


Decision:

Judo Mind will be developed as a digital Judo ecosystem,
not only a mobile application.


Impact:

Future development must consider:

- Athlete system
- Coach system
- Club system
- Federation system
- AI ecosystem
- Knowledge base
- Education platform
- Administration platform


Required Updates:

- ARCHITECTURE.md
- PROJECT_STATUS.md
- TECHNIQUE_SPECIFICATION.md

---

# JM-DEC-002

Date:
2026-07-31

Status:
Approved

Category:
Product Architecture

Title:
17 Module Product Structure


Decision:

Judo Mind officially consists of 17 independent modules.

The 17th module is:

Administration & System Settings


Impact:

The product architecture must support:

1. Home
2. Techniques
3. Sensi Bot
4. Sensi Bet
5. Monitoring
6. Judo Cast
7. Athlete Profile
8. Training Center
9. Champions Hub
10. Competitions & Challenges
11. News
12. Store & Subscription
13. Club Management
14. Coach Forum
15. Online Courses
16. Country Judo History
17. Administration & System Settings


Required Updates:

- PRODUCT_REQUIREMENTS.md
- ARCHITECTURE.md
- PROJECT_STATUS.md
- CHANGELOG.md

---

# JM-DEC-003

Date:
2026-07-31

Status:
Approved

Category:
User Experience

Title:
Technique Detail Dashboard Architecture


Decision:

The Technique Detail page will not use a single long scrolling page.

A dashboard-based navigation system will be used.


Structure:

Technique Header

↓

Technique Dashboard

↓

Individual Section Views


Sections include:

- Overview
- Technical Analysis
- Biomechanics
- Training
- Shadow Training
- Conditioning
- Competition Analysis
- Combinations
- Counters
- Quiz
- Sources
- Progress
- AI Recommendations


Reason:

Improve user experience and reduce unnecessary scrolling.


Impact:

Required components:

- Technique Dashboard Item
- Technique Dashboard Grid
- Technique Bottom Sheet
- Section Components


Required Updates:

- ARCHITECTURE.md
- MODULE_02_TECHNIQUES.md
- CHANGELOG.md

---

# JM-DEC-004

Date:
2026-07-31

Status:
Approved

Category:
Internationalization


Title:
Localization First Strategy


Decision:

Judo Mind must support multilingual architecture from the beginning.

No user-facing text should be permanently hardcoded.


Initial Supported Languages:

- English
- Persian
- Japanese
- French
- German
- Russian
- Spanish
- Arabic


Impact:

The system must support:

- UI translation
- Content translation
- Technique translation
- RTL/LTR layouts
- Language switching without rebuilding application


Required Updates:

- ARCHITECTURE.md
- LOCALIZATION.md
- PRODUCT_REQUIREMENTS.md

---

# JM-DEC-005

Date:
2026-07-31

Status:
Approved

Category:
Content Management


Title:
No-Code Administration System


Decision:

Future Judo Mind administrators must be able to manage application content without Flutter code changes.


Managed Content:

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
- Advertisements


Architecture:

Flutter Application

↓

API

↓

Backend

↓

CMS


Impact:

A complete Administration Panel and CMS will be developed.


Required Updates:

- ARCHITECTURE.md
- CMS_ARCHITECTURE.md
- PRODUCT_REQUIREMENTS.md

---

# JM-DEC-006

Date:
2026-07-31

Status:
Approved

Category:
Technique Intelligence


Title:
Technique Knowledge Expansion


Decision:

The Technique Module will evolve from a database into an intelligent Judo knowledge system.


Each technique should support:


Technical Layer:

- Kuzushi
- Tsukuri
- Kake
- Execution steps
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
- Strength training
- Mobility


Competition Layer:

- Tactical application
- Combination
- Counter
- Match analysis


AI Layer:

- Progress analysis
- Recommendations
- Personalized training


Required Updates:

- TECHNIQUE_SPECIFICATION.md
- ARCHITECTURE.md
- PRODUCT_REQUIREMENTS.md

---

# JM-DEC-007

Date:
2026-07-31

Status:
Approved

Category:
Documentation


Title:
Documentation Synchronization Rule


Decision:

No major feature or architectural decision should exist only inside conversation history.


All major decisions must update:


- PRODUCT_REQUIREMENTS.md
- ARCHITECTURE.md
- PROJECT_STATUS.md
- CHANGELOG.md
- DECISION_LOG.md


Reason:

Maintain project continuity and prevent loss of knowledge.

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

## JM-DEC-009

Date:
2026-07-31

Status:
Approved

Title:
Judo Mind Design System 1.0

Decision:

Judo Mind shall use one centralized design system across all 17 modules.

The design system will define:

- Global colors
- Typography
- Spacing
- Border radius
- Button hierarchy
- Card hierarchy
- Icons
- Bottom sheets
- Dialogs
- Loading states
- Empty states
- Error states
- Responsive behavior
- RTL and LTR compatibility

No module may define independent visual standards outside the approved design system.

Impact:

- Consistent user experience
- Faster development
- Easier maintenance
- Better internationalization
- Easier CMS integration
- Professional presentation for investors and federations

## JM-DEC-010

Date:
2026-08-01

Status:
Approved

Title:
Uchi Mata as the Official Reference Technique

Decision:

Uchi Mata is approved as the official reference implementation for all Judo Mind techniques.

Its architecture will define:

- Learning flow
- Dashboard structure
- Media architecture
- AI analysis access
- CMS data requirements
- Localization behavior
- Subscription behavior
- Design System usage

Impact:

All 67 official techniques must use the same scalable architecture.

---

## JM-DEC-011

Date:
2026-08-01

Status:
Approved

Title:
Universal AI Video Analysis Access

Decision:

Video upload and AI analysis will be available at every subscription level.

Plans will differ by:

- Monthly credits
- Analysis depth
- Report capabilities
- Storage
- Coach services
- Team-management access

Impact:

Lower-tier users can experience the core AI value while paid tiers receive greater capacity and professional functionality.

---

## JM-DEC-012

Date:
2026-08-01

Status:
Approved

Title:
Sensi Bot AI Fight Intelligence 360

Decision:

Judo Mind AI analysis must evaluate the complete interaction between athlete and opponent.

Required analysis includes:

- Opponent guard
- Grip configuration
- Attack and defense position
- Push and pull reactions
- Balance weakness
- Weight transfer
- Attack timing
- Counter risks
- Tactical patterns
- Match timeline

Impact:

Sensi Bot evolves from an AI chat assistant into the central intelligence engine of Judo Mind.

## JM-DEC-013

Date: 2026-08-02  
Status: Approved

Title: Centralized Judo Mind Icon Architecture

### Decision

All feature icons will use the centralized `JudoIcons` registry and the standard `JudoIcon` component.

Direct feature-level icon styling is no longer permitted except for generic platform actions approved by the Design System.

### Reason

This architecture allows the temporary Material-based icon layer to be replaced by custom SVG assets without rewriting individual screens.

### Impact

- Unified icon language across all 17 modules
- Improved accessibility
- Reduced visual inconsistency
- Easier future SVG migration
- Faster global icon updates

---

## JM-DEC-014

Date: 2026-08-02  
Status: Approved

Title: Custom Illustration Layer for High-Value Dashboard Features

### Decision

Selected high-value cards will use custom Judo Mind illustrations in addition to or instead of generic icons.

Initial illustration targets:

- Sensi Bot
- Quiz
- Training
- Competition
- Mastery

### Constraints

Illustrations will not be placed on every card.

They will be used only where they improve meaning, recognition or product identity without increasing visual clutter.

## JM-DEC-015

Date: 2026-08-02
Status: Approved

Title: Selective Illustration Use in Technique Dashboard

### Decision

Custom illustrations will be used selectively for high-value and identity-defining features.

Initial approved cards:

- Training
- Competition
- Mastery
- Sensi Bot
- Quiz

Other Dashboard cards will remain icon-based unless a custom illustration provides a clear usability or recognition benefit.

### Reason

Using illustrations on every card would increase visual noise, page height and cognitive load.

Selective use creates stronger hierarchy while preserving the compact Dashboard architecture.

### Validation Rule

Every illustration integration must be reviewed on a physical mobile device for:

- Legibility
- Card balance
- Text clearance
- Badge overlap
- Visual hierarchy
- RTL compatibility
- Small-screen behavior

## JM-DEC-016

Date: 2026-08-02
Status: Approved

Title: Controlled Media Catalog

### Decision

Judo Mind will use a controlled media catalog.

Public search-result pages must not be used as media destinations.

Each media item must reference one specific selected resource and include:

- Professional title
- Media type
- Source
- Verification status
- Thumbnail
- Direct content URL
- Optional duration and competition metadata

### Source Priority

1. IJF official technique resources
2. IJF or JudoTV competition media
3. Kodokan educational media
4. Licensed partner media
5. Judo Mind original content
6. Curated external media when necessary

Official API integration requires permission or partnership when the source does not provide a public integration API.
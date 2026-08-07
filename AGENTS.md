# Judo Mind Repository Instructions

## Mandatory Reference Review

Before analyzing, planning, implementing, or modifying any part of the project, read:

- `docs/AI_DEVELOPMENT_RULES.md`
- `docs/PROJECT_STATUS.md`
- `docs/CHANGELOG.md`
- `docs/ARCHITECTURE.md`
- `docs/DECISION_LOG.md`

Treat these documents as the approved source for the current project stage, architecture, development rules, and recorded decisions. Do not guess missing structure, create duplicate architecture, or replace approved decisions without review.

## Existing Work and Change Safety

- Analyze the existing architecture, dependencies, related documentation, and affected functionality before making changes.
- Preserve existing user work and existing functionality.
- Do not overwrite, discard, or revert unrelated existing changes.
- Avoid unnecessary modifications and technical debt.
- Obtain explicit user approval before any destructive Git operation or any Git push.

## Documentation Synchronization

Documentation is part of implementation. No important feature, architecture, product, or technical decision may exist only in source code or conversation history.

Update the required documentation for every significant change:

- Feature development: `docs/CHANGELOG.md` and `docs/PROJECT_STATUS.md`
- Architecture changes: `docs/ARCHITECTURE.md` and `docs/DECISION_LOG.md`
- Product changes: `docs/PRODUCT_REQUIREMENTS.md`
- Development-process changes: `docs/AI_DEVELOPMENT_RULES.md`

A development task is complete only when implementation, validation, and the required documentation updates are complete. Run `flutter analyze` for Flutter changes and record decision-log updates when needed.

## Product and Current Development Baseline

Judo Mind is a global digital Judo ecosystem composed of 17 official modules:

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

The current development stage is Uchi Mata Reference Completion plus the Scientific AI Biomechanics Foundation. Uchi Mata is the official reference technique; future official techniques must follow its approved scalable architecture.

## Flutter and Python AI Architecture

- Follow Clean Architecture, feature-based development, modular design, separation of concerns, localization-first development, CMS-first content architecture, and the centralized Judo Mind Design System.
- Flutter is responsible for capture, upload, analysis configuration, user interaction, and result visualization.
- The Python AI Engine is responsible for computer vision, pose estimation, multi-view 3D reconstruction, biomechanics, OpenSim processing, Judo intelligence, and report generation.
- Keep the Computer Vision environment at `ai_engine/.venv` isolated from the Scientific Biomechanics environment at `ai_engine/.biomech_venv`.
- Treat RTMPose-M as the current pose-estimation baseline, not as the complete biomechanics engine.
- Do not claim that the current two-athlete detection, occlusion handling, 3D reconstruction, OpenSim connection, or Judo-specific AI is production quality until it is implemented and scientifically validated.

## Scientific Integrity

Never mix or misrepresent these data classifications:

- Measured
- Reconstructed
- Model-estimated or estimated
- AI-inferred

Never present an estimated physical quantity as a direct measurement. Where technically relevant, biomechanical results must identify confidence, data source, analysis method, quality classification, and limitations.

Single-video analysis is estimated. Multi-view results require synchronized and calibrated cameras, cross-camera athlete identity, 3D reconstruction, and quality validation before OpenSim-based biomechanical use.

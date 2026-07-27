# Judo Mind AI Development Rules

## 1. Project Identity

Project Name:
Judo Mind Super App

Platform:
Flutter Mobile Application

Purpose:
A professional digital ecosystem for judoka athletes, coaches, clubs, and federations.

Main Vision:
Train Your Body, Master Your Mind.


---

# 2. Development Philosophy

All development decisions must follow these principles:

- Professional software architecture
- Clean and maintainable code
- Scalability for future modules
- Security-first approach
- Performance optimization
- User experience excellence


The application must be designed as a commercial international product.


---

# 3. Coding Rules

Before changing any important file:

1. Analyze existing architecture.
2. Check dependencies.
3. Avoid unnecessary modifications.
4. Preserve existing functionality.


Coding requirements:

- Use clean Dart and Flutter standards.
- Avoid duplicated code.
- Create reusable components.
- Keep files modular.
- Use meaningful names.
- Maintain readable structure.


---

# 4. Flutter Architecture Rules

The project should move toward Feature-Based Architecture.

Example:

lib/

core/
- constants
- theme
- language
- security

models/

features/

techniques/
- data
- models
- presentation
- widgets


Each module should be independent and expandable.


---

# 5. Data Management Rules

All Judo technique data must follow the approved Technique Model.

Each technique should include:

- English name
- Japanese name
- Persian translation
- Category
- Difficulty
- Belt level
- Images
- Official videos
- Technical analysis
- Execution steps
- Common mistakes
- Combinations
- Counters
- Quiz
- Sources


Official sources must be prioritized.


---

# 6. Security Rules

Security must be considered from the beginning.

Rules:

- Never store private keys inside the application.
- Never expose sensitive information.
- Prepare architecture for secure backend connection.
- Use authentication best practices.
- Protect user data.


---

# 7. Git Workflow

Before major changes:

1. Test application.
2. Run:

flutter analyze

3. Run application.
4. Create Git commit.


Commit messages must clearly describe changes.


Example:

Good:

Add technique filter optimization

Bad:

Update


---

# 8. AI Assistant Collaboration Rules

AI-generated code must:

- Respect current project structure.
- Avoid breaking existing features.
- Provide complete files for major changes.
- Explain architectural decisions.
- Avoid assumptions without checking files.


For important modifications:

Required process:

Analysis → Design → Implementation → Test → Commit


---

# 9. Product Development Rules

Judo Mind is not only a technical project.

All decisions must consider:

- Judo expertise
- Athlete experience
- Coach requirements
- Federation needs
- Business model
- Competitive advantage


The goal is to build a world-class Judo platform.
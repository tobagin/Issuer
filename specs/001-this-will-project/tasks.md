# Tasks: GNOME Application Template Project

**Input**: Design documents from `/specs/001-this-will-project/`
**Prerequisites**: plan.md (required), research.md, data-model.md, contracts/

## Execution Flow (main)
```
1. Load plan.md from feature directory
   ✓ Loaded - tech stack: Vala, GTK4, LibAdwaita, Meson, Flatpak
   ✓ Structure: single project with src/, templates/, flatpak/, tests/
2. Load optional design documents:
   ✓ data-model.md: Template Configuration, Template Files, Build Configuration, Project Structure
   ✓ contracts/: template-api.md (CLI), generated-project.md (output validation)
   ✓ research.md: Technology decisions and rationale
3. Generate tasks by category:
   ✓ Setup: project structure, dependencies, build scripts
   ✓ Tests: contract tests for CLI commands, template validation
   ✓ Core: template parser, CLI commands, project generation
   ✓ Integration: template validation, flatpak building
   ✓ Polish: documentation, examples, performance
4. Apply task rules:
   ✓ Different files = marked [P] for parallel
   ✓ Same file = sequential (no [P])
   ✓ Tests before implementation (TDD)
5. Number tasks sequentially (T001, T002...)
6. Generate dependency graph
7. Create parallel execution examples
8. Validate task completeness:
   ✓ All CLI commands have tests
   ✓ All entities have implementation
   ✓ All contracts validated
9. Return: SUCCESS (tasks ready for execution)
```

## Format: `[ID] [P?] Description`
- **[P]**: Can run in parallel (different files, no dependencies)
- Include exact file paths in descriptions

## Path Conventions
- **Single project**: `src/`, `tests/` at repository root
- Project structure per plan.md with templates/, scripts/, flatpak/ directories

## Phase 3.1: Setup
- [x] T001 Create project structure: src/, templates/, flatpak/, scripts/, tests/ directories per plan.md
- [x] T002 Initialize Vala/Meson project with GTK4, LibAdwaita dependencies in meson.build
- [x] T003 [P] Configure build script in scripts/build.sh with --dev and production modes
- [x] T004 [P] Configure linting and formatting tools for Vala code

## Phase 3.2: Tests First (TDD) ⚠️ MUST COMPLETE BEFORE 3.3
**CRITICAL: These tests MUST be written and MUST FAIL before ANY implementation**
- [ ] T005 [P] Contract test CLI create command in tests/contract/test_cli_create.vala
- [ ] T006 [P] Contract test CLI validate command in tests/contract/test_cli_validate.vala
- [ ] T007 [P] Contract test CLI list command in tests/contract/test_cli_list.vala
- [ ] T008 [P] Contract test template variable substitution in tests/contract/test_template_vars.vala
- [ ] T009 [P] Integration test basic app generation in tests/integration/test_basic_generation.vala
- [ ] T010 [P] Integration test flatpak build validation in tests/integration/test_flatpak_build.vala
- [ ] T011 [P] Template validation test for generated meson.build in tests/template/test_meson_build.vala
- [ ] T012 [P] Template validation test for generated desktop files in tests/template/test_desktop_files.vala

## Phase 3.3: Core Implementation (ONLY after tests are failing)
- [ ] T013 [P] Template Configuration model in src/models/template_config.vala
- [ ] T014 [P] Template Files model in src/models/template_files.vala
- [ ] T015 [P] Build Configuration model in src/models/build_config.vala
- [ ] T016 [P] Project Structure model in src/models/project_structure.vala
- [ ] T017 Template parser service in src/services/template_parser.vala
- [ ] T018 Variable substitution engine in src/services/variable_engine.vala
- [ ] T019 File generation service in src/services/file_generator.vala
- [ ] T020 CLI create command implementation in src/cli/create_command.vala
- [ ] T021 CLI validate command implementation in src/cli/validate_command.vala
- [ ] T022 CLI list command implementation in src/cli/list_command.vala
- [ ] T023 Main CLI application entry point in src/main.vala

## Phase 3.4: Template Content
- [ ] T024 [P] Basic GNOME app template in templates/basic/
- [ ] T025 [P] Vala source templates in templates/basic/src/
- [ ] T026 [P] Blueprint UI templates in templates/basic/data/ui/
- [ ] T027 [P] Meson build template in templates/basic/meson.build.tmpl
- [ ] T028 [P] Desktop entry template in templates/basic/data/app.id.desktop.in.tmpl
- [ ] T029 [P] AppStream metadata template in templates/basic/data/app.id.metainfo.xml.in.tmpl
- [ ] T030 [P] Production flatpak manifest in flatpak/app.id.yml.tmpl
- [ ] T031 [P] Development flatpak manifest in flatpak/app.id.Devel.yml.tmpl

## Phase 3.5: Integration
- [ ] T032 Template validation system integration in src/services/validator.vala
- [ ] T033 Generated project build validation in src/services/build_validator.vala
- [ ] T034 Flatpak build integration in src/services/flatpak_builder.vala
- [ ] T035 Error handling and logging throughout CLI commands
- [ ] T036 Configuration file loading (git config, defaults)

## Phase 3.6: Polish
- [ ] T037 [P] Unit tests for template parser in tests/unit/test_template_parser.vala
- [ ] T038 [P] Unit tests for variable engine in tests/unit/test_variable_engine.vala
- [ ] T039 [P] Unit tests for file generator in tests/unit/test_file_generator.vala
- [ ] T040 [P] Performance tests for large template generation
- [ ] T041 [P] Update README.md with installation and usage instructions
- [ ] T042 [P] Create example applications in examples/ directory
- [ ] T043 [P] Create CONTRIBUTING.md for template contributors
- [ ] T044 Manual testing following quickstart.md scenarios

## Dependencies
```
Setup (T001-T004) → Tests (T005-T012) → Core (T013-T023) → Templates (T024-T031) → Integration (T032-T036) → Polish (T037-T044)

Specific dependencies:
- T013-T016 (models) block T017-T019 (services)
- T017-T019 (services) block T020-T023 (CLI)
- T024-T031 (templates) need T017-T019 (template system)
- T032-T036 (integration) need T020-T023 (CLI) and T024-T031 (templates)
```

## Parallel Example
```bash
# Phase 3.2 - Launch all contract tests together:
Task: "Contract test CLI create command in tests/contract/test_cli_create.vala"
Task: "Contract test CLI validate command in tests/contract/test_cli_validate.vala"
Task: "Contract test CLI list command in tests/contract/test_cli_list.vala"
Task: "Contract test template variable substitution in tests/contract/test_template_vars.vala"

# Phase 3.3 - Launch all model creation together:
Task: "Template Configuration model in src/models/template_config.vala"
Task: "Template Files model in src/models/template_files.vala"
Task: "Build Configuration model in src/models/build_config.vala"
Task: "Project Structure model in src/models/project_structure.vala"

# Phase 3.4 - Launch all template content creation together:
Task: "Basic GNOME app template in templates/basic/"
Task: "Vala source templates in templates/basic/src/"
Task: "Blueprint UI templates in templates/basic/data/ui/"
Task: "Meson build template in templates/basic/meson.build.tmpl"
```

## Notes
- [P] tasks = different files, no dependencies
- Verify tests fail before implementing (critical for TDD)
- Each template file must include proper variable substitution points
- Generated projects must build successfully with meson + flatpak
- Follow GNOME HIG compliance in all generated templates
- All CLI commands must have proper error handling and exit codes

## Task Generation Rules
*Applied during main() execution*

1. **From Contracts**:
   ✓ template-api.md → CLI command tests and implementations (T005-T007, T020-T022)
   ✓ generated-project.md → template content validation (T011-T012, T024-T031)

2. **From Data Model**:
   ✓ Template Configuration → model creation (T013)
   ✓ Template Files → model creation (T014)
   ✓ Build Configuration → model creation (T015)
   ✓ Project Structure → model creation (T016)

3. **From User Stories**:
   ✓ Template generation flow → integration tests (T009-T010)
   ✓ Quickstart scenarios → validation tasks (T044)

4. **Ordering**:
   ✓ Setup → Tests → Models → Services → CLI → Templates → Integration → Polish
   ✓ Dependencies prevent parallel execution where needed

## Validation Checklist
*GATE: Checked by main() before returning*

- [x] All CLI commands have corresponding tests (T005-T007 vs T020-T022)
- [x] All entities have model tasks (T013-T016 from data-model.md)
- [x] All tests come before implementation (Phase 3.2 before 3.3)
- [x] Parallel tasks truly independent (different files, marked [P])
- [x] Each task specifies exact file path
- [x] No task modifies same file as another [P] task
- [x] Template content tasks cover all required file types
- [x] Integration tests validate complete generation workflow
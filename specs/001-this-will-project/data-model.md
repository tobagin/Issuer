# Data Model: GNOME Application Template

## Core Entities

### Template Configuration
**Purpose**: Defines the structure and metadata for generating a new GNOME application
**Fields**:
- `app_name`: Human-readable application name
- `app_id`: Reverse DNS application identifier (e.g., org.example.MyApp)
- `app_description`: Brief description of the application
- `author_name`: Name of the application author
- `author_email`: Email of the application author
- `license`: Software license (default: GPL-3.0+)
- `version`: Initial version number (default: 0.1.0)

**Validation Rules**:
- `app_id` must follow reverse DNS format
- `app_name` must be 1-50 characters
- `author_email` must be valid email format
- `license` must be valid SPDX identifier

### Template Files
**Purpose**: Represents individual files within the template structure
**Fields**:
- `source_path`: Path within template directory
- `target_path`: Path in generated project (with variable substitution)
- `file_type`: Type of file (source, config, doc, build)
- `is_executable`: Whether file should be executable
- `variables`: List of template variables used in this file

**Relationships**:
- Belongs to Template Configuration
- May reference other Template Files (dependencies)

### Build Configuration
**Purpose**: Defines build system settings for the generated application
**Fields**:
- `meson_version`: Minimum Meson version required
- `dependencies`: List of required dependencies with versions
- `flatpak_runtime`: Target flatpak runtime (org.gnome.Platform//49)
- `target_glib`: Minimum GLib version
- `target_gtk`: Minimum GTK version

**Validation Rules**:
- All version strings must be valid semantic versions
- Dependencies must be available in target runtime

### Project Structure
**Purpose**: Defines the directory structure of generated projects
**Fields**:
- `directories`: List of directories to create
- `file_mappings`: Map of template files to target locations
- `permissions`: File permission settings

**State Transitions**:
1. Template Loaded → Configuration Validated
2. Configuration Validated → Files Generated
3. Files Generated → Build System Configured
4. Build System Configured → Project Ready

## Template Variables

### Standard Variables
- `{{APP_NAME}}`: Application display name
- `{{APP_ID}}`: Application identifier
- `{{APP_DESCRIPTION}}`: Application description
- `{{AUTHOR_NAME}}`: Author full name
- `{{AUTHOR_EMAIL}}`: Author email address
- `{{LICENSE}}`: Software license
- `{{VERSION}}`: Application version
- `{{YEAR}}`: Current year for copyright

### Generated Variables
- `{{APP_CLASS}}`: CamelCase class name derived from app name
- `{{APP_CONSTANT}}`: UPPERCASE constant derived from app name
- `{{APP_PATH}}`: File path derived from app ID

## File Categories

### Source Files
- Main application files (.vala)
- UI definition files (.blp, .ui)
- Resource files (.gresource.xml)

### Configuration Files
- Meson build files (meson.build)
- Flatpak manifest (manifest.yml)
- Desktop entry (.desktop.in)
- AppStream metadata (.metainfo.xml.in)

### Documentation Files
- README.md template
- LICENSE file
- CONTRIBUTING.md template

### Build System Files
- Post-install scripts
- Icon installation rules
- Translation configuration
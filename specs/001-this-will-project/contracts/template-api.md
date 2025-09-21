# Template Generation API Contract

## CLI Interface Contract

### Command: `gnome-template create`
```bash
gnome-template create [OPTIONS] <app-name>
```

**Required Parameters**:
- `app-name`: Human-readable application name

**Options**:
- `--app-id <id>`: Application identifier (default: derived from app-name)
- `--author <name>`: Author name (default: from git config)
- `--email <email>`: Author email (default: from git config)
- `--license <license>`: Software license (default: GPL-3.0+)
- `--output-dir <path>`: Output directory (default: current directory)
- `--template <type>`: Template type (default: basic)

**Exit Codes**:
- 0: Success
- 1: Invalid arguments
- 2: Template generation failed
- 3: Output directory not writable

**Example Usage**:
```bash
gnome-template create "My Awesome App" \
  --app-id org.example.myawesomeapp \
  --author "John Doe" \
  --email john@example.com \
  --output-dir ./my-app
```

### Command: `gnome-template validate`
```bash
gnome-template validate <project-directory>
```

**Purpose**: Validates a generated project can be built successfully

**Exit Codes**:
- 0: Validation passed
- 1: Build errors found
- 2: Missing dependencies
- 3: Invalid project structure

### Command: `gnome-template list`
```bash
gnome-template list [--verbose]
```

**Purpose**: Lists available templates

**Output Format**:
```
basic      - Basic GNOME application with GTK4 and LibAdwaita
utility    - Command-line utility template
game       - Simple game template with Cairo graphics
```

## File System Contract

### Input Requirements
**Template Directory Structure**:
```
templates/
├── basic/
│   ├── template.yml         # Template metadata
│   ├── src/
│   │   ├── main.vala.tmpl
│   │   └── application.vala.tmpl
│   ├── build/
│   │   └── meson.build.tmpl
│   └── flatpak/
│       └── manifest.yml.tmpl
```

### Output Guarantees
**Generated Project Structure**:
```
{{APP_NAME}}/
├── src/
│   ├── main.vala
│   └── application.vala
├── data/
│   ├── {{APP_ID}}.desktop.in
│   └── {{APP_ID}}.metainfo.xml.in
├── flatpak/
│   └── {{APP_ID}}.yml
├── meson.build
├── README.md
└── LICENSE
```

## Template Variable Contract

### Required Variables
All templates must support these variables:
- `APP_NAME`: Display name
- `APP_ID`: Unique identifier
- `APP_DESCRIPTION`: Brief description
- `AUTHOR_NAME`: Author full name
- `AUTHOR_EMAIL`: Author email
- `LICENSE`: License identifier
- `VERSION`: Initial version

### Variable Format
Variables use `{{VARIABLE_NAME}}` syntax and must be:
- Uppercase with underscores
- Alphanumeric characters only
- No leading/trailing whitespace

## Build System Contract

### Generated meson.build Requirements
```meson
project('{{APP_NAME}}', 'vala', 'c',
  version : '{{VERSION}}',
  license : '{{LICENSE}}',
  meson_version : '>= 0.59.0'
)

# Must include these targets:
executable('{{APP_ID}}', sources)
install_data('data/{{APP_ID}}.desktop.in', install_dir: desktop_dir)
install_data('data/{{APP_ID}}.metainfo.xml.in', install_dir: metainfo_dir)
```

### Flatpak Manifest Requirements
```yaml
app-id: {{APP_ID}}
runtime: org.gnome.Platform
runtime-version: '49'
sdk: org.gnome.Sdk
command: {{APP_ID}}
```

## Test Contract

### Template Validation Tests
Each template must pass:
1. **Syntax Test**: All template files have valid syntax
2. **Variable Test**: All required variables are present
3. **Build Test**: Generated project builds successfully
4. **Install Test**: Generated project installs correctly
5. **Flatpak Test**: Flatpak can be built and run

### Generated Project Tests
Generated projects must include:
1. Basic unit test framework setup
2. Integration test that runs the application
3. Flatpak build validation test
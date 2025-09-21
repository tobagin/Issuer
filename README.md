# GNOME Application Template

A modern, comprehensive GNOME application template built with GTK4, LibAdwaita, and Vala. This template provides a solid foundation for creating native GNOME applications with best practices, modern UI patterns, and complete development infrastructure.

## 🚀 Features

### Core Technologies
- **GTK4** - Modern toolkit for native GNOME applications
- **LibAdwaita** - Adaptive UI components and GNOME design patterns
- **Vala** - Object-oriented programming language that compiles to C
- **Blueprint** - Declarative UI markup language for GTK
- **Meson** - Modern build system with development/production profiles
- **Flatpak** - Universal application packaging and distribution

### Application Features
- **Adaptive UI** - Responsive design that works on desktop and mobile
- **Theme Management** - Light, dark, and system preference support
- **Settings Persistence** - GSettings integration with schema validation
- **Internationalization** - Full gettext support for translations
- **Keyboard Shortcuts** - Complete shortcuts dialog with standard GNOME bindings
- **About Dialog** - Rich about dialog with release notes and metadata
- **Preferences Dialog** - Modern preferences UI with theme selection
- **Window State Management** - Automatic window size and position persistence
- **"What's New" Feature** - Automatic release notes display on updates (see below for details)

### Development Infrastructure
- **Professional Logging** - Configurable logging system with multiple levels
- **Error Handling** - Comprehensive error handling framework
- **Build Profiles** - Separate development and production configurations
- **Desktop Integration** - Complete metainfo, desktop files, and icon sets
- **Flatpak Manifests** - Ready-to-use packaging for Flathub distribution
- **Documentation** - Comprehensive specs, contracts, and guides

## ✨ What's New Feature

The template includes an intelligent "What's New" system that automatically displays release notes when users update to a new version.

**How It Works:**
- Tracks the last known application version in GSettings
- Compares current version with stored version on startup
- Automatically displays release notes from AppStream metadata when a new version is detected
- Shows a beautiful dialog with formatted release information

**Version Detection:**
```vala
// Automatic version comparison on application startup
if (current_version != last_known_version) {
    show_whats_new_dialog();
    update_stored_version(current_version);
}
```

**Release Notes Source:**
- Release notes are pulled from the `<releases>` section in your `*.metainfo.xml.in` file
- Supports rich formatting including bullet points, descriptions, and version information
- Automatically parses AppStream release data for display

**Example Metainfo Release Entry:**
```xml
<releases>
  <release version="1.2.0" date="2024-01-15">
    <description>
      <p>New features and improvements:</p>
      <ul>
        <li>Added dark mode support</li>
        <li>Improved performance and stability</li>
        <li>New keyboard shortcuts</li>
        <li>Better accessibility support</li>
      </ul>
    </description>
  </release>
</releases>
```

**User Experience:**
- First-time users don't see the dialog (no previous version stored)
- Returning users see release notes only for genuine updates
- Dialog can be dismissed and won't show again for the same version
- Clean, native GNOME design consistent with platform guidelines

## 📋 Requirements

### Development Dependencies
- **Vala** >= 0.56
- **GTK4** >= 4.20
- **LibAdwaita** >= 1.8
- **Meson** >= 1.0
- **Blueprint Compiler** >= 0.18
- **Flatpak** (for packaging)
- **Flatpak Builder** (for building packages)

### Runtime Dependencies
- **GNOME Platform** 49 (or compatible)
- **GLib** >= 2.86
- **GIO** >= 2.86

## 🛠️ Building

This template is designed specifically for Flatpak applications. All builds are containerized and self-contained.

### Quick Start

```bash
# Clone the repository
git clone https://github.com/tobagin/AppTemplate.git
cd AppTemplate

# Build development version (uses local source)
./scripts/build.sh --dev

# Build production version (uses git source)
./scripts/build.sh
```


## 🏃 Running

All execution happens through Flatpak for consistent, sandboxed environments.

### From Flatpak
```bash
# Development version
flatpak run io.github.tobagin.AppTemplate.Devel

# Production version
flatpak run io.github.tobagin.AppTemplate
```

## 📁 Project Structure

```
app_template/
|-- data/                          # Application data and resources
|   |-- icons/                     # Application icons (multiple sizes)
|   |-- ui/                        # Blueprint UI templates
|   |   |-- dialogs/               # Dialog templates
|   |   `-- window.blp             # Main window template
|   |-- *.desktop.in               # Desktop entry template
|   |-- *.gschema.xml.in          # GSettings schema template
|   |-- *.metainfo.xml.in         # AppStream metadata template
|   `-- meson.build               # Data build configuration
|-- packaging/                     # Flatpak manifests
|   |-- *.Devel.yml               # Development manifest
|   `-- *.yml                     # Production manifest
|-- po/                           # Internationalization
|   |-- LINGUAS                   # Supported languages
|   |-- POTFILES.in              # Translatable files
|   `-- meson.build              # Translation build config
|-- scripts/                      # Build and utility scripts
|   `-- build.sh                 # Universal build script
|-- specs/                        # Project documentation
|   `-- 001-this-will-project/   # Feature specifications
|-- src/                          # Source code
|   |-- dialogs/                  # Dialog implementations
|   |-- managers/                 # Application managers
|   |-- utils/                    # Utility classes
|   |-- Application.vala          # Main application class
|   |-- Window.vala              # Main window class
|   |-- Main.vala                # Application entry point
|   `-- meson.build              # Source build configuration
|-- tests/                        # Test framework
|-- meson.build                   # Root build configuration
`-- meson_options.txt            # Build options
```

## ⚙️ Configuration

### Build Profiles

**Development Profile** (`-Dprofile=development`)
- Debug symbols enabled
- Additional development tools
- Separate application ID with `.Devel` suffix
- Local source builds for rapid iteration

**Production Profile** (default)
- Optimized builds
- Release configuration
- Standard application ID
- Git source builds for distribution

### Application ID

The template uses a configurable application ID:
- **Production**: `io.github.tobagin.AppTemplate`
- **Development**: `io.github.tobagin.AppTemplate.Devel`

Update the application ID in `meson.build` and data templates for your project.

## 🎨 Customization

### Adapting for Your Project

1. **Update Project Configuration**
   ```bash
   # Edit meson.build - change from template values:
   project_name = 'App Template'  # -> 'Your App Name'
   project_id = 'io.github.tobagin.AppTemplate'  # -> 'io.github.youruser.YourApp'
   ```

2. **Rename and Edit Data Templates**
   ```bash
   # Rename all template files from:
   data/io.github.tobagin.AppTemplate.desktop.in -> data/io.github.youruser.YourApp.desktop.in
   data/io.github.tobagin.AppTemplate.metainfo.xml.in -> data/io.github.youruser.YourApp.metainfo.xml.in
   data/io.github.tobagin.AppTemplate.gschema.xml.in -> data/io.github.youruser.YourApp.gschema.xml.in
   data/io.github.tobagin.AppTemplate.gresources.xml.in -> data/io.github.youruser.YourApp.gresources.xml.in

   # Update content inside these files with your app details
   ```

3. **Update Flatpak Manifests**
   ```bash
   # Rename manifest files from:
   packaging/io.github.tobagin.AppTemplate.yml -> packaging/io.github.youruser.YourApp.yml
   packaging/io.github.tobagin.AppTemplate.Devel.yml -> packaging/io.github.youruser.YourApp.Devel.yml

   # Update application ID inside manifests
   ```

4. **Replace Icons**
   ```bash
   # Replace icons in data/icons/hicolor/
   # Maintain the same sizes and naming convention
   ```

### Adding New Features

1. **Create New Dialogs**
   ```bash
   # Add Blueprint template
   data/ui/dialogs/your-dialog.blp

   # Add Vala implementation
   src/dialogs/YourDialog.vala

   # Update build files
   ```

2. **Add New Settings**
   ```xml
   <!-- Edit data/*.gschema.xml.in -->
   <key name="your-setting" type="s">
     <default>'default-value'</default>
     <summary>Your setting</summary>
     <description>Description of your setting</description>
   </key>
   ```

3. **Extend Preferences**
   ```vala
   // Edit src/dialogs/Preferences.vala
   // Add new UI elements and settings bindings
   ```

## 🌍 Internationalization

### Adding Translations

1. **Extract Translatable Strings**
   ```bash
   meson compile -C build app-template-pot
   ```

2. **Create Language Files**
   ```bash
   # Add language to po/LINGUAS
   echo "es" >> po/LINGUAS

   # Create translation file
   msginit -l es -o po/es.po -i po/app-template.pot
   ```

3. **Update Translations**
   ```bash
   msgmerge -U po/es.po po/app-template.pot
   ```

## 📦 Distribution

### Flatpak Submission

1. **Test Your Application**
   ```bash
   flatpak run --command=sh io.github.tobagin.AppTemplate.Devel
   flatpak-builder --run build packaging/*.yml app-template
   ```

2. **Validate Metadata**
   ```bash
   appstream-util validate data/*.metainfo.xml
   desktop-file-validate data/*.desktop
   ```

3. **Submit to Flathub**
   - Fork the [Flathub repository](https://github.com/flathub/flathub)
   - Add your manifest to the repository
   - Create a pull request with your application

### Automated Flathub Updates

This repository includes a GitHub workflow that automatically creates Flathub pull requests when new releases are tagged. The workflow handles updating the Flatpak manifest with new version information and source URLs.

**How It Works:**
- Triggers automatically when you push a git tag (format: `v*.*.*`)
- Downloads the latest Flatpak manifest from your Flathub repository
- Updates version numbers and source URLs to match the new release
- Creates a pull request to the Flathub repository with the changes
- Validates the manifest before submission

**Repository Setup Requirements:**

1. **GitHub Secrets Configuration**
   ```bash
   # In your repository settings > Secrets and variables > Actions
   # Add these secrets:
   FLATHUB_TOKEN=<your-github-personal-access-token>
   ```

2. **Personal Access Token Setup**
   - Generate a GitHub personal access token with `public_repo` scope
   - The token must have write access to your Flathub repository fork
   - Store it as `FLATHUB_TOKEN` in your repository secrets

3. **Flathub Repository Configuration**
   - Your application must already be published on Flathub
   - The workflow expects a Flathub repository at `flathub/io.github.tobagin.AppTemplate`
   - Your Flatpak manifest must reference GitHub releases as the source

4. **Release Tagging Requirements**
   - Use semantic versioning for tags (e.g., `v1.0.0`, `v1.2.3`)
   - Create GitHub releases for each tag
   - Ensure release assets include source archives that match your manifest

**Usage:**
```bash
# Create and push a new release tag
git tag v1.0.0
git push origin v1.0.0

# The workflow will automatically:
# 1. Detect the new tag
# 2. Update the Flathub manifest
# 3. Create a PR to Flathub
# 4. Notify you of the submission status
```

## 🧪 Testing

### Running Tests
```bash
# Tests run within Flatpak environment
flatpak-builder --run build packaging/io.github.tobagin.AppTemplate.Devel.yml meson test -C _flatpak_build
```

### Manual Testing
```bash
# Test development build
./scripts/build.sh --dev
flatpak run io.github.tobagin.AppTemplate.Devel

# Test production build
./scripts/build.sh
flatpak run io.github.tobagin.AppTemplate
```

### Validation
```bash
# Validate desktop file
desktop-file-validate data/*.desktop

# Validate metainfo
appstream-util validate data/*.metainfo.xml

# Validate GSettings schema (within Flatpak)
flatpak-builder --run build packaging/*.yml glib-compile-schemas --dry-run /app/share/glib-2.0/schemas/
```

## 🐛 Troubleshooting

### Common Issues

**Build Failures**
```bash
# Clean Flatpak cache
rm -rf .flatpak-builder build

# Rebuild from scratch
./scripts/build.sh --dev
```

**Flatpak Issues**
```bash
# Clean Flatpak cache
flatpak uninstall io.github.tobagin.AppTemplate.Devel
rm -rf .flatpak-builder

# Rebuild from scratch
./scripts/build.sh --dev
```

**Schema Compilation Errors**
```bash
# Validate schema syntax within Flatpak
flatpak-builder --run build packaging/*.yml xmllint --noout /app/share/glib-2.0/schemas/*.xml

# Check schema compilation
flatpak-builder --run build packaging/*.yml glib-compile-schemas --dry-run /app/share/glib-2.0/schemas/
```

### Debug Information

**Enable Debug Output**
```bash
G_MESSAGES_DEBUG=all flatpak run io.github.tobagin.AppTemplate.Devel
```

**Check Application Logs**
```bash
journalctl --user -f | grep app-template
```

## 🤝 Contributing

### Development Setup

1. **Fork and Clone**
   ```bash
   git clone <your-fork-url>
   cd AppTemplate
   ```

2. **Create Feature Branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make Changes**
   ```bash
   # Edit code
   # Test changes
   ./scripts/build.sh --dev
   ```

4. **Submit Pull Request**
   ```bash
   git commit -am "Add your feature"
   git push origin feature/your-feature-name
   ```

### Code Style

- Follow [GNOME coding style guidelines](https://wiki.gnome.org/Projects/Vala/StyleGuide)
- Use 4 spaces for indentation
- Maximum line length of 100 characters
- Write clear, descriptive commit messages

## 📄 License

This project is licensed under the GNU General Public License v3.0 or later. See the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **GNOME Project** - For the incredible platform and ecosystem
- **LibAdwaita Contributors** - For the beautiful adaptive UI components
- **Vala Team** - For the elegant programming language
- **Blueprint Contributors** - For the declarative UI markup language
- **Flatpak Team** - For universal application packaging

## 📞 Support

- **Documentation**: Check the `specs/` directory for detailed specifications
- **Issues**: Report bugs and feature requests on the project's issue tracker
- **Community**: Join the GNOME development community for general support

---

**Happy coding!** 🎉 This template provides everything you need to create modern, native GNOME applications with Flatpak packaging. Start building your next great application today!
# Issuer

A modern, native GTK4/LibAdwaita Github issues tracker built with Vala. Issuer provides a clean, intuitive interface for managing GitHub issues directly from your desktop with full GNOME integration.

## 🚀 Features

### Core Functionality
- **GitHub Integration** - Connect to your GitHub repositories and manage issues
- **Modern UI** - Clean, adaptive interface built with LibAdwaita design principles
- **Issue Management** - View, create, edit, and organize GitHub issues
- **Repository Browser** - Browse your repositories and their issues
- **Offline Support** - Cache issues for offline viewing and editing
- **Real-time Sync** - Keep your issues synchronized with GitHub

### User Experience
- **Adaptive UI** - Responsive design that works on desktop and mobile
- **Theme Management** - Light, dark, and system preference support
- **Keyboard Shortcuts** - Complete shortcuts for efficient issue management
- **Search & Filter** - Powerful search and filtering capabilities
- **Labels & Milestones** - Full support for GitHub labels and milestones
- **Markdown Editor** - Rich markdown editing with live preview

### GNOME Integration
- **Native Look & Feel** - Follows GNOME HIG and design patterns
- **Settings Persistence** - GSettings integration for preferences
- **Notifications** - System notifications for issue updates
- **Window State Management** - Automatic window size and position persistence
- **Desktop Integration** - Complete metainfo, desktop files, and icon sets

## 🔧 Technology Stack

- **Language**: Vala (compiles to C)
- **UI Framework**: GTK4 + LibAdwaita
- **UI Definition**: Blueprint (declarative UI syntax)
- **Build System**: Meson + Ninja
- **Packaging**: Flatpak (org.gnome.Platform//49)
- **API Integration**: GitHub REST API v4
- **Data Storage**: SQLite for local caching

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
- **libsoup** >= 3.0 (for GitHub API)
- **json-glib** >= 1.6

## 🛠️ Building

Issuer is designed specifically for Flatpak applications. All builds are containerized and self-contained.

### Quick Start

```bash
# Clone the repository
git clone https://github.com/tobagin/Issuer.git
cd Issuer

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
flatpak run io.github.tobagin.Issuer.Devel

# Production version
flatpak run io.github.tobagin.Issuer
```

## 🔐 GitHub Authentication

Issuer supports multiple authentication methods:

1. **Personal Access Token** - Generate a token in GitHub Settings > Developer settings
2. **OAuth App** - Register your own OAuth application for enhanced security
3. **GitHub CLI Integration** - Use existing `gh` CLI authentication if available

### Setting up Authentication

1. Open Issuer and go to Preferences
2. Select your preferred authentication method
3. Follow the setup wizard to connect your GitHub account
4. Grant necessary permissions for repository and issue access

## 📁 Project Structure

```
Issuer/
├── data/                          # Application data and resources
│   ├── icons/                     # Application icons (multiple sizes)
│   ├── ui/                        # Blueprint UI templates
│   │   ├── dialogs/               # Dialog templates
│   │   ├── views/                 # Issue and repository views
│   │   └── window.blp             # Main window template
│   ├── *.desktop.in               # Desktop entry template
│   ├── *.gschema.xml.in          # GSettings schema template
│   ├── *.metainfo.xml.in         # AppStream metadata template
│   └── meson.build               # Data build configuration
├── packaging/                     # Flatpak manifests
│   ├── *.Devel.yml               # Development manifest
│   └── *.yml                     # Production manifest
├── po/                           # Internationalization
├── scripts/                      # Build and utility scripts
│   └── build.sh                 # Universal build script
├── src/                          # Source code
│   ├── api/                      # GitHub API integration
│   ├── dialogs/                  # Dialog implementations
│   ├── managers/                 # Application managers
│   ├── models/                   # Data models (Issue, Repository, etc.)
│   ├── utils/                    # Utility classes
│   ├── views/                    # Main application views
│   ├── Application.vala          # Main application class
│   ├── Window.vala              # Main window class
│   └── Main.vala                # Application entry point
├── tests/                        # Test framework
└── meson.build                   # Root build configuration
```

## ⚙️ Configuration

### GitHub API Settings
- **API Endpoint**: Configurable for GitHub Enterprise
- **Rate Limiting**: Automatic rate limit detection and handling
- **Caching**: Configurable cache duration for offline support
- **Sync Interval**: Automatic background sync frequency

### Application Settings
- **Theme**: Light, dark, or follow system theme
- **Notifications**: Enable/disable various notification types
- **Editor**: Markdown editor preferences and shortcuts
- **Performance**: Cache size and sync settings

## 🎯 Usage

### Managing Issues

1. **Connect Repository**: Add repositories from the main view
2. **Browse Issues**: View all issues with status, labels, and metadata
3. **Create Issues**: Use the new issue dialog with markdown support
4. **Edit Issues**: Modify title, description, labels, and assignees
5. **Search & Filter**: Find issues by text, labels, status, or assignee

### Keyboard Shortcuts

- **Ctrl+N**: New issue
- **Ctrl+R**: Refresh current view
- **Ctrl+F**: Search issues
- **Ctrl+,**: Open preferences
- **Ctrl+Q**: Quit application

## 🌍 Internationalization

Issuer supports multiple languages through gettext integration:

### Adding Translations

```bash
# Extract translatable strings
meson compile -C build issuer-pot

# Create language files
echo "es" >> po/LINGUAS
msginit -l es -o po/es.po -i po/issuer.pot

# Update translations
msgmerge -U po/es.po po/issuer.pot
```

## 📦 Distribution

### Flatpak Submission

Issuer is available on Flathub for easy installation:

```bash
# Install from Flathub
flatpak install flathub io.github.tobagin.Issuer

# Run installed version
flatpak run io.github.tobagin.Issuer
```

## 🧪 Testing

### Running Tests
```bash
# Tests run within Flatpak environment
flatpak-builder --run build packaging/io.github.tobagin.Issuer.Devel.yml meson test -C _flatpak_build
```

### Manual Testing
```bash
# Test development build
./scripts/build.sh --dev
flatpak run io.github.tobagin.Issuer.Devel

# Test with debug output
G_MESSAGES_DEBUG=all flatpak run io.github.tobagin.Issuer.Devel
```

## 🤝 Contributing

We welcome contributions to Issuer! Whether it's bug reports, feature requests, or code contributions.

### Development Setup

1. **Fork and Clone**
   ```bash
   git clone <your-fork-url>
   cd Issuer
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
- Add tests for new functionality

## 📄 License

This project is licensed under the GNU General Public License v3.0 or later. See the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **GitHub** - For providing the excellent API and platform
- **GNOME Project** - For the incredible platform and ecosystem
- **LibAdwaita Contributors** - For the beautiful adaptive UI components
- **Vala Team** - For the elegant programming language
- **Blueprint Contributors** - For the declarative UI markup language
- **Flatpak Team** - For universal application packaging

## 📞 Support

- **Issues**: Report bugs and feature requests on [GitHub Issues](https://github.com/tobagin/Issuer/issues)
- **Documentation**: Check the project wiki for detailed guides
- **Community**: Join the GNOME development community for general support

---

**Start managing your GitHub issues with style!** 🎉 Issuer brings the power of GitHub issue tracking to your GNOME desktop with native integration and modern design.
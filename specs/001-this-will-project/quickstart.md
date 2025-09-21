# Quickstart: GNOME Application Template

## Prerequisites Verification

Before using the template, verify these dependencies are installed:

```bash
# Check Meson build system
meson --version  # Should be >= 0.59.0

# Check Vala compiler
valac --version  # Should be >= 0.56.0

# Check GNOME development libraries
pkg-config --modversion gtk4  # Should be >= 4.10
pkg-config --modversion libadwaita-1  # Should be >= 1.4

# Check Flatpak development tools
flatpak --version
flatpak-builder --version

# Verify GNOME SDK is installed
flatpak list --runtime | grep org.gnome.Sdk//49
```

## Quick Template Usage

### 1. Generate New Application

```bash
# Clone the template repository
git clone https://github.com/example/gnome-app-template.git
cd gnome-app-template

# Generate a new application
./scripts/create-app.sh \
  --name "My Todo App" \
  --id org.example.mytodoapp \
  --author "Your Name" \
  --email your.email@example.com \
  --output-dir ../my-todo-app
```

### 2. Build the Generated Application

```bash
cd ../my-todo-app

# Setup build directory
meson setup builddir

# Compile the application
meson compile -C builddir

# Run the application
builddir/src/org.example.mytodoapp
```

### 3. Test Installation

```bash
# Install to a test prefix
DESTDIR="$PWD/install-test" meson install -C builddir

# Verify desktop integration files
ls install-test/usr/local/share/applications/
ls install-test/usr/local/share/metainfo/
ls install-test/usr/local/bin/
```

### 4. Build Flatpak Package

```bash
# Build flatpak
flatpak-builder build-dir flatpak/org.example.mytodoapp.yml --force-clean

# Test run the flatpak
flatpak-builder --run build-dir flatpak/org.example.mytodoapp.yml org.example.mytodoapp

# Install locally for testing
flatpak-builder --user --install --force-clean build-dir flatpak/org.example.mytodoapp.yml

# Run installed flatpak
flatpak run org.example.mytodoapp
```

## Validation Checklist

After generating and building your application, verify:

- [ ] Application starts without errors
- [ ] Window displays with correct title
- [ ] Application follows GNOME HIG (Human Interface Guidelines)
- [ ] Desktop file is valid: `desktop-file-validate your-app.desktop`
- [ ] AppStream metadata is valid: `appstreamcli validate your-app.metainfo.xml`
- [ ] Flatpak builds successfully
- [ ] Flatpak runs in sandbox environment
- [ ] All template variables were correctly substituted

## Customization Quick Start

### Adding New Source Files

1. Create your new `.vala` file in `src/`
2. Add it to the `sources` list in `meson.build`
3. Recompile: `meson compile -C builddir`

### Adding UI Files

1. Create `.blp` (Blueprint) file in `data/ui/`
2. Add to `blueprints` list in `data/meson.build`
3. Reference in your Vala code:
   ```vala
   [GtkTemplate (ui = "/your/app/path/ui/your-window.ui")]
   ```

### Adding Dependencies

1. Add to `meson.build`:
   ```meson
   new_dep = dependency('library-name', version: '>= x.y')
   ```
2. Add to dependencies list in executable
3. Add to flatpak manifest if needed

### Adding Application Icons

1. Create SVG icon in `data/icons/hicolor/scalable/apps/`
2. Name it `your-app-id.svg`
3. Add icon installation rules to `data/meson.build`
4. Update flatpak manifest if using custom icons

## Common Issues and Solutions

### Issue: "Package 'gtk4' not found"
**Solution**: Install GNOME development packages:
```bash
# Ubuntu/Debian
sudo apt install libgtk-4-dev libadwaita-1-dev

# Fedora
sudo dnf install gtk4-devel libadwaita-devel

# Arch Linux
sudo pacman -S gtk4 libadwaita
```

### Issue: "Vala compiler not found"
**Solution**: Install Vala compiler:
```bash
# Ubuntu/Debian
sudo apt install valac

# Fedora
sudo dnf install vala

# Arch Linux
sudo pacman -S vala
```

### Issue: Flatpak build fails
**Solution**: Check runtime is installed:
```bash
flatpak install flathub org.gnome.Platform//49
flatpak install flathub org.gnome.Sdk//49
```

### Issue: Application doesn't follow GNOME theming
**Solution**: Ensure LibAdwaita is properly initialized:
```vala
public override void startup () {
    base.startup ();

    // Initialize LibAdwaita
    Adw.init ();
}
```

## Next Steps

After successfully creating your first application:

1. **Read GNOME HIG**: Familiarize yourself with GNOME Human Interface Guidelines
2. **Study Examples**: Look at existing GNOME applications for patterns
3. **Join Community**: Connect with GNOME developers on Matrix or Discord
4. **Contribute**: Consider contributing to existing GNOME projects

## Resources

- [GNOME Developer Documentation](https://developer.gnome.org/)
- [GTK4 Documentation](https://docs.gtk.org/gtk4/)
- [LibAdwaita Documentation](https://gnome.pages.gitlab.gnome.org/libadwaita/)
- [Vala Language Reference](https://vala.dev/)
- [Flatpak Documentation](https://docs.flatpak.org/)
- [GNOME Human Interface Guidelines](https://developer.gnome.org/hig/)
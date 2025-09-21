# Generated Project Contract

## Application Structure Contract

### Main Application Class
```vala
public class {{APP_CLASS}}.Application : Adw.Application {
    public Application () {
        Object (
            application_id: "{{APP_ID}}",
            flags: ApplicationFlags.DEFAULT_FLAGS
        );
    }

    public override void activate () {
        // Must create and present main window
        var window = new {{APP_CLASS}}.MainWindow (this);
        window.present ();
    }
}
```

### Main Window Class
```vala
[GtkTemplate (ui = "/{{APP_PATH}}/ui/main-window.ui")]
public class {{APP_CLASS}}.MainWindow : Adw.ApplicationWindow {
    public MainWindow (Gtk.Application app) {
        Object (application: app);
    }
}
```

## Build System Contract

### Minimum meson.build Requirements
```meson
project('{{APP_NAME}}', 'vala', 'c',
  version : '{{VERSION}}',
  license : '{{LICENSE}}',
  meson_version : '>= 0.59.0'
)

# Required dependencies
gtk4_dep = dependency('gtk4', version: '>= 4.10')
libadwaita_dep = dependency('libadwaita-1', version: '>= 1.4')
glib_dep = dependency('glib-2.0', version: '>= 2.74')

# Vala compiler requirements
vala = meson.get_compiler('vala')
vala.version().version_compare('>= 0.56.0')

# Application executable
executable('{{APP_ID}}',
  sources : [
    'src/main.vala',
    'src/application.vala',
    'src/main-window.vala'
  ],
  dependencies : [
    gtk4_dep,
    libadwaita_dep,
    glib_dep
  ],
  install : true
)
```

## Desktop Integration Contract

### Desktop Entry (.desktop.in)
```ini
[Desktop Entry]
Name={{APP_NAME}}
Comment={{APP_DESCRIPTION}}
Exec={{APP_ID}}
Icon={{APP_ID}}
Terminal=false
Type=Application
Categories=GNOME;GTK;
StartupNotify=true
```

### AppStream Metadata (.metainfo.xml.in)
```xml
<?xml version="1.0" encoding="UTF-8"?>
<component type="desktop-application">
  <id>{{APP_ID}}</id>
  <metadata_license>CC0-1.0</metadata_license>
  <project_license>{{LICENSE}}</project_license>
  <name>{{APP_NAME}}</name>
  <summary>{{APP_DESCRIPTION}}</summary>
  <description>
    <p>{{APP_DESCRIPTION}}</p>
  </description>
  <launchable type="desktop-id">{{APP_ID}}.desktop</launchable>
  <provides>
    <binary>{{APP_ID}}</binary>
  </provides>
</component>
```

## Flatpak Contract

### Manifest Requirements ({{APP_ID}}.yml)
```yaml
app-id: {{APP_ID}}
runtime: org.gnome.Platform
runtime-version: '49'
sdk: org.gnome.Sdk
command: {{APP_ID}}
finish-args:
  - --share=ipc
  - --socket=fallback-x11
  - --socket=wayland
  - --device=dri

modules:
  - name: {{APP_NAME}}
    buildsystem: meson
    sources:
      - type: dir
        path: .
```

## Resource Management Contract

### GResource Bundle (resources.gresource.xml)
```xml
<?xml version="1.0" encoding="UTF-8"?>
<gresources>
  <gresource prefix="/{{APP_PATH}}">
    <file compressed="true">ui/main-window.ui</file>
    <file compressed="true">css/style.css</file>
  </gresource>
</gresources>
```

### UI Files (Blueprint)
```blueprint
using Gtk 4.0;
using Adw 1;

template MainWindow : Adw.ApplicationWindow {
  default-width: 800;
  default-height: 600;

  content: Adw.ToastOverlay toast_overlay {
    child: Adw.ToolbarView {
      [top]
      Adw.HeaderBar header_bar {
        title-widget: Adw.WindowTitle window_title {
          title: "{{APP_NAME}}";
        };
      }

      content: Gtk.Box {
        orientation: vertical;
        spacing: 12;
        margin-top: 24;
        margin-bottom: 24;
        margin-start: 24;
        margin-end: 24;

        Gtk.Label {
          label: "Welcome to {{APP_NAME}}!";
          styles ["title-1"]
        }

        Gtk.Label {
          label: "{{APP_DESCRIPTION}}";
          styles ["body"]
        }
      };
    };
  };
}
```

## Testing Contract

### Unit Test Structure
```vala
// tests/test-application.vala
void test_application_creation () {
    var app = new {{APP_CLASS}}.Application ();
    assert (app != null);
    assert (app.application_id == "{{APP_ID}}");
}

void main (string[] args) {
    Test.init (ref args);
    Test.add_func ("/application/creation", test_application_creation);
    Test.run ();
}
```

### Integration Test
```bash
#!/bin/bash
# tests/integration-test.sh
set -e

echo "Building application..."
meson setup builddir
meson compile -C builddir

echo "Installing to test prefix..."
DESTDIR="$PWD/install-test" meson install -C builddir

echo "Testing desktop file validation..."
desktop-file-validate "install-test/usr/local/share/applications/{{APP_ID}}.desktop"

echo "Testing AppStream metadata..."
appstreamcli validate "install-test/usr/local/share/metainfo/{{APP_ID}}.metainfo.xml"

echo "All tests passed!"
```

## Documentation Contract

### README.md Template
```markdown
# {{APP_NAME}}

{{APP_DESCRIPTION}}

## Building

```bash
meson setup builddir
meson compile -C builddir
```

## Installing

```bash
meson install -C builddir
```

## Running

```bash
{{APP_ID}}
```

## Building Flatpak

```bash
flatpak-builder build-dir flatpak/{{APP_ID}}.yml --force-clean
flatpak-builder --run build-dir flatpak/{{APP_ID}}.yml {{APP_ID}}
```
```
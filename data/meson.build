# UI Resources
ui_files = []

# Compile Blueprint files to UI files
blueprint_files = [
  'ui/window.blp',
  'ui/dialogs/preferences.blp',
]

foreach blueprint_file : blueprint_files
  ui_file = blueprint_file.replace('.blp', '.ui')
  ui_filename = fs.name(ui_file)
  ui_files += custom_target(
    ui_file.underscorify(),
    input: blueprint_file,
    output: ui_filename,
    command: [blueprint_compiler, 'compile', '--output', '@OUTPUT@', '@INPUT@'],
  )
endforeach

# Generate GResource file
gresource_xml = configure_file(
  input: 'io.github.tobagin.AppTemplate.gresources.xml.in',
  output: 'io.github.tobagin.AppTemplate.gresources.xml',
  configuration: conf_data
)

app_resources = gnome.compile_resources(
  'app-resources',
  gresource_xml,
  dependencies: ui_files,
  source_dir: meson.current_build_dir(),
  c_name: 'app_template_resources'
)

# Install metainfo
metainfo_file = configure_file(
  input: 'io.github.tobagin.AppTemplate.metainfo.xml.in',
  output: '@0@.metainfo.xml'.format(project_id),
  configuration: conf_data,
  install: true,
  install_dir: get_option('datadir') / 'metainfo'
)

# Install desktop file
desktop_file = configure_file(
  input: 'io.github.tobagin.AppTemplate.desktop.in',
  output: '@0@.desktop'.format(project_id),
  configuration: conf_data,
  install: true,
  install_dir: get_option('datadir') / 'applications'
)

# GSchema
gschema_file = configure_file(
    input: 'io.github.tobagin.AppTemplate.gschema.xml.in',
    output: project_id + '.gschema.xml',
    configuration: conf_data
)

install_data(
    gschema_file,
    install_dir: get_option('datadir') / 'glib-2.0' / 'schemas'
)

# Compile schemas after installation
gnome = import('gnome')
meson.add_install_script('glib-compile-schemas', get_option('prefix') / get_option('datadir') / 'glib-2.0' / 'schemas')

# Install icons with proper naming based on profile
icon_sizes = ['16x16', '22x22', '24x24', '32x32', '48x48', '64x64', '96x96', '128x128', '256x256', '512x512']

foreach size : icon_sizes
  install_data(
    'icons/hicolor/@0@/apps/io.github.tobagin.AppTemplate.png'.format(size),
    install_dir: get_option('datadir') / 'icons/hicolor/@0@/apps'.format(size),
    rename: '@0@.png'.format(project_id)
  )
endforeach
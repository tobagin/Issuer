# Source files
app_template_sources = [
  'Main.vala',
  'Application.vala',
  'Window.vala',
  'Constants.vala',
  'utils/Logger.vala',
  'utils/ErrorHandler.vala',
  'managers/SettingsManager.vala',
  'dialogs/About.vala',
  'dialogs/KeyboardShortcuts.vala',
  'dialogs/Preferences.vala',
  'api/GitHubApi.vala',
  'models/Issue.vala',
  'models/Repository.vala',
  'views/IssuesView.vala',
]

# Generated configuration and resources
app_template_sources += [
  meson.project_build_root() / 'Config.vala'
]

# Add compiled resources
app_template_sources += app_resources

# Main executable
app_template_exe = executable('issuer',
  app_template_sources,
  dependencies: [
    gtk4_dep,
    libadwaita_dep,
    glib_dep,
    gio_dep,
    libsoup_dep,
    json_glib_dep,
    gee_dep,
  ],
  install: true,
  install_dir: get_option('bindir')
)
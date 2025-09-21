/*
 * Copyright (C) 2025 Thiago Fernandes
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 */

namespace AppTemplate {

    public class Application : Adw.Application {
        private Logger logger;
        private SettingsManager settings;
        private AppTemplate.Window? main_window;

        public Application() {
            Object(
                application_id: Config.ID,
                flags: ApplicationFlags.DEFAULT_FLAGS
            );

            logger = Logger.get_default();
        }

        public override void activate() {
            base.activate();

            var window = active_window;
            if (window == null) {
                main_window = new AppTemplate.Window(this);
                window = main_window;
            } else {
                main_window = window as AppTemplate.Window;
            }

            window.present();
            logger.info("Application activated");

            // Check if we should show What's New dialog after a delay to ensure GTK is ready
            Idle.add(() => {
                check_and_show_whats_new();
                return false;
            });
        }

        public override void startup() {
            base.startup();

            settings = SettingsManager.get_instance();
            setup_actions();
            logger.info("Application started");
        }

        private void setup_actions() {
            var quit_action = new SimpleAction(Constants.ACTION_QUIT, null);
            quit_action.activate.connect(quit);
            add_action(quit_action);
            const string[] quit_accels = {"<primary>q", null};
            set_accels_for_action("app.quit", quit_accels);

            var about_action = new SimpleAction(Constants.ACTION_ABOUT, null);
            about_action.activate.connect(() => {
                AppTemplateAboutDialog.show(active_window);
            });
            add_action(about_action);

            var preferences_action = new SimpleAction(Constants.ACTION_PREFERENCES, null);
            preferences_action.activate.connect(show_preferences);
            add_action(preferences_action);

            const string[] help_accels = {"<primary>question", null};
            set_accels_for_action("win.show-help-overlay", help_accels);

            logger.debug("Application actions configured");
        }


        private void show_preferences() {
            logger.debug("Preferences action triggered");
            var preferences_dialog = new AppTemplate.Preferences();
            preferences_dialog.show_preferences(active_window);
        }

        private void check_and_show_whats_new() {
            // Check if this is a new version and show release notes automatically
            if (should_show_release_notes()) {
                // Small delay to ensure main window is fully presented
                Timeout.add(Constants.WHATS_NEW_DELAY, () => {
                    if (main_window != null && !main_window.in_destruction()) {
                        logger.info("Showing automatic release notes for new version");
                        AppTemplateAboutDialog.show_with_release_notes(main_window);
                    }
                    return false;
                });
            }
        }

        private bool should_show_release_notes() {
            if (settings == null) {
                settings = SettingsManager.get_instance();
                if (settings == null) {
                    return false;
                }
            }
            
            string last_version = settings.get_string(Constants.SETTINGS_LAST_VERSION_SHOWN);
            string current_version = Config.VERSION;

            // Show if this is the first run (empty last version) or version has changed
            if (last_version == "" || last_version != current_version) {
                settings.set_string(Constants.SETTINGS_LAST_VERSION_SHOWN, current_version);
                logger.info("New version detected: %s (was: %s)", current_version, last_version == "" ? "first run" : last_version);
                return true;
            }
            
            return false;
        }
    }
}
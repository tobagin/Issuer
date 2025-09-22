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
            const string[] about_accels = {"<primary>F1", null};
            set_accels_for_action("app.about", about_accels);

            var preferences_action = new SimpleAction(Constants.ACTION_PREFERENCES, null);
            preferences_action.activate.connect(show_preferences);
            add_action(preferences_action);
            const string[] preferences_accels = {"<primary>comma", null};
            set_accels_for_action("app.preferences", preferences_accels);

            var new_window_action = new SimpleAction("new-window", null);
            new_window_action.activate.connect(() => {
                var new_window = new AppTemplate.Window(this);
                new_window.present();
                logger.info("New window created");
            });
            add_action(new_window_action);
            const string[] new_window_accels = {"<primary>n", null};
            set_accels_for_action("app.new-window", new_window_accels);

            const string[] help_accels = {"<primary>question", null};
            set_accels_for_action("win.show-help-overlay", help_accels);

            const string[] close_window_accels = {"<primary>w", null};
            set_accels_for_action("win.close-window", close_window_accels);

            const string[] fullscreen_accels = {"F11", null};
            set_accels_for_action("win.toggle-fullscreen", fullscreen_accels);

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

            string last_version = settings.get_string(Constants.SETTINGS_LAST_VERSION_RAN);
            string current_version = Config.VERSION;

            // Handle first run - initialize version tracking but don't show dialog
            if (settings.is_first_run()) {
                logger.info("First run detected, initializing version tracking");
                settings.set_first_run_complete();
                settings.set_string(Constants.SETTINGS_LAST_VERSION_RAN, current_version);
                return false;
            }

            // Initialize version tracking for edge cases
            if (last_version == "") {
                settings.set_string(Constants.SETTINGS_LAST_VERSION_RAN, current_version);
                return false;
            }

            // Compare versions to determine if this is an upgrade, downgrade, or same version
            int version_comparison = compare_versions(current_version, last_version);

            if (version_comparison > 0) {
                // Current version is newer - this is an upgrade
                settings.set_string(Constants.SETTINGS_LAST_VERSION_RAN, current_version);
                logger.info("Version upgrade detected: %s → %s", last_version, current_version);

                // Only show dialog if user wants it
                if (settings.get_show_whats_new()) {
                    logger.info("Showing What's New dialog for version %s", current_version);
                    return true;
                }
            } else if (version_comparison < 0) {
                // Current version is older - this is a regression/downgrade
                logger.warning("Version regression detected: %s → %s (not updating tracking)", last_version, current_version);
                return false;
            } else {
                // Same version - no action needed
                logger.debug("Same version running: %s", current_version);
                return false;
            }

            if (!settings.get_show_whats_new()) {
                logger.debug("What's New feature is disabled in preferences");
            }

            return false;
        }

        private int compare_versions(string version1, string version2) {
            // Split versions into parts (e.g., "1.2.3" -> ["1", "2", "3"])
            string[] parts1 = version1.split(".");
            string[] parts2 = version2.split(".");

            // Get the maximum length to handle different version formats
            int max_length = int.max(parts1.length, parts2.length);

            for (int i = 0; i < max_length; i++) {
                // Get version part or default to 0 if not present
                int num1 = (i < parts1.length) ? int.parse(parts1[i]) : 0;
                int num2 = (i < parts2.length) ? int.parse(parts2[i]) : 0;

                if (num1 > num2) {
                    return 1;  // version1 is newer
                } else if (num1 < num2) {
                    return -1; // version1 is older
                }
                // Continue if equal
            }

            return 0; // Versions are equal
        }
    }
}
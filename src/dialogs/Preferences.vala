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

using Gtk;
using Adw;

namespace Issuer {

#if DEVELOPMENT
    [GtkTemplate (ui = "/io/github/tobagin/Issuer/Devel/preferences.ui")]
#else
    [GtkTemplate (ui = "/io/github/tobagin/Issuer/preferences.ui")]
#endif
    public class Preferences : Adw.PreferencesDialog {
    [GtkChild]
    private unowned Adw.ComboRow theme_row;
    [GtkChild]
    private unowned Adw.SwitchRow whats_new_row;
    [GtkChild]
    private unowned Adw.PasswordEntryRow github_token_row;
    [GtkChild]
    private unowned Adw.ActionRow github_help_row;

    private SettingsManager settings_manager;
    private Issuer.Logger logger;

    public Preferences () {
        Object ();
    }

    construct {
        logger = Logger.get_default();
        settings_manager = SettingsManager.get_instance ();
        setup_theme_selection ();
        setup_whats_new_switch ();
        setup_github_token ();
        setup_github_help ();
        bind_settings ();
        logger.debug ("Preferences dialog constructed");
    }

    private void setup_theme_selection () {
        theme_row.selected = settings_manager.get_color_scheme ();

        theme_row.notify["selected"].connect (() => {
            var selected = (ColorScheme) theme_row.selected;
            settings_manager.set_color_scheme (selected);
            logger.debug ("Theme preference changed to: %s", selected.to_string ());
        });
    }

    private void setup_whats_new_switch () {
        whats_new_row.active = settings_manager.get_show_whats_new ();

        whats_new_row.notify["active"].connect (() => {
            settings_manager.set_show_whats_new (whats_new_row.active);
            logger.debug ("What's New preference changed to: %s", whats_new_row.active.to_string ());
        });
    }

    private void setup_github_token () {
        github_token_row.text = settings_manager.get_github_token ();

        github_token_row.apply.connect (() => {
            settings_manager.set_github_token (github_token_row.text);
            logger.debug ("GitHub token updated");
        });
    }

    private void setup_github_help () {
        github_help_row.activated.connect (() => {
            try {
                Gtk.UriLauncher launcher = new Gtk.UriLauncher ("https://github.com/settings/tokens");
                launcher.launch.begin (this.get_root () as Gtk.Window, null, (obj, res) => {
                    try {
                        launcher.launch.end (res);
                        logger.debug ("Opened GitHub token settings in browser");
                    } catch (Error e) {
                        logger.warning ("Failed to open GitHub token settings: %s", e.message);
                    }
                });
            } catch (Error e) {
                logger.warning ("Failed to create URI launcher: %s", e.message);
            }
        });
    }

    private void bind_settings () {
        // Manual binding handled by notify signals above
        // Direct binding not possible due to type incompatibility (enum string vs uint for theme)
    }

    public void show_preferences (Gtk.Window parent) {
        present (parent);
    }
    }
}
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

namespace AppTemplate {

#if DEVELOPMENT
    [GtkTemplate (ui = "/io/github/tobagin/AppTemplate/Devel/preferences.ui")]
#else
    [GtkTemplate (ui = "/io/github/tobagin/AppTemplate/preferences.ui")]
#endif
    public class Preferences : Adw.PreferencesDialog {
    [GtkChild]
    private unowned Adw.ComboRow theme_row;

    private SettingsManager settings_manager;
    private AppTemplate.Logger logger;

    public Preferences () {
        Object ();
    }

    construct {
        logger = Logger.get_default();
        settings_manager = SettingsManager.get_instance ();
        setup_theme_selection ();
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

    private void bind_settings () {
        // Manual binding handled by notify["selected"] signal above
        // Direct binding not possible due to type incompatibility (enum string vs uint)
    }

    public void show_preferences (Gtk.Window parent) {
        present (parent);
    }
    }
}
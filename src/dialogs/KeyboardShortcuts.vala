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

namespace Issuer {

    public class KeyboardShortcuts : GLib.Object {

        public static void show(Gtk.Window? parent) {
            var logger = Logger.get_default();
            logger.debug("Creating keyboard shortcuts dialog");

            var shortcuts_window = new Adw.ShortcutsDialog();

            var section = new Adw.ShortcutsSection("general");
            section.title = "Application";

            var quit_item = new Adw.ShortcutsItem("Quit", "<Primary>q");
            var help_item = new Adw.ShortcutsItem("Show Keyboard Shortcuts", "<Primary>question");
            var about_item = new Adw.ShortcutsItem("About", "<Primary>F1");
            var preferences_item = new Adw.ShortcutsItem("Preferences", "<Primary>comma");
            var new_window_item = new Adw.ShortcutsItem("New Window", "<Primary>n");
            var close_item = new Adw.ShortcutsItem("Close Window", "<Primary>w");
            var fullscreen_item = new Adw.ShortcutsItem("Toggle Fullscreen", "F11");

            section.add(quit_item);
            section.add(help_item);
            section.add(about_item);
            section.add(preferences_item);
            section.add(new_window_item);
            section.add(close_item);
            section.add(fullscreen_item);
            shortcuts_window.add(section);

            if (parent != null && !parent.in_destruction()) {
                shortcuts_window.present(parent);
            } else {
                shortcuts_window.present(null);
            }

            logger.info("Keyboard shortcuts dialog shown");
        }
    }
}
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


#if DEVELOPMENT
    [GtkTemplate (ui = "/io/github/tobagin/AppTemplate/Devel/window.ui")]
#else
    [GtkTemplate (ui = "/io/github/tobagin/AppTemplate/window.ui")]
#endif

    public class Window : Adw.ApplicationWindow {

        [GtkChild]
        private unowned Adw.HeaderBar header_bar;

        [GtkChild]
        private unowned Gtk.MenuButton menu_button;

        [GtkChild]
        private unowned Adw.ToastOverlay toast_overlay;

        [GtkChild]
        private unowned Adw.StatusPage welcome_status;

        [GtkChild]
        private unowned Gtk.Button about_button;

        private Logger logger;

        public Window(Gtk.Application app) {
            Object(application: app);

            logger = Logger.get_default();
            setup_actions();
            logger.info("Window created and initialized");
        }

        private void setup_actions() {
            var shortcuts_action = new SimpleAction(Constants.ACTION_SHOW_HELP_OVERLAY, null);
            shortcuts_action.activate.connect(() => {
                AppTemplate.KeyboardShortcuts.show(this);
            });
            add_action(shortcuts_action);
            logger.debug("Window actions configured");
        }
    }
}


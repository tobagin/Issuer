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


#if DEVELOPMENT
    [GtkTemplate (ui = "/io/github/tobagin/Issuer/Devel/window.ui")]
#else
    [GtkTemplate (ui = "/io/github/tobagin/Issuer/window.ui")]
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

            // Ensure template widgets are accessible (suppresses unused warnings)
            assert(header_bar != null);
            assert(menu_button != null);
            assert(toast_overlay != null);
            assert(welcome_status != null);
            assert(about_button != null);

            logger.info("Window created and initialized");
        }

        private void setup_actions() {
            var shortcuts_action = new SimpleAction(Constants.ACTION_SHOW_HELP_OVERLAY, null);
            shortcuts_action.activate.connect(() => {
                Issuer.KeyboardShortcuts.show(this);
            });
            add_action(shortcuts_action);

            var close_window_action = new SimpleAction("close-window", null);
            close_window_action.activate.connect(() => {
                close();
                logger.info("Window closed via shortcut");
            });
            add_action(close_window_action);

            var fullscreen_action = new SimpleAction("toggle-fullscreen", null);
            fullscreen_action.activate.connect(() => {
                if (fullscreened) {
                    unfullscreen();
                    logger.debug("Exited fullscreen");
                } else {
                    fullscreen();
                    logger.debug("Entered fullscreen");
                }
            });
            add_action(fullscreen_action);

            logger.debug("Window actions configured");
        }
    }
}


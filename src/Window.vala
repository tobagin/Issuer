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
        private unowned Adw.ViewStack main_stack;

        [GtkChild]
        private unowned Adw.ViewSwitcher view_switcher;

        [GtkChild]
        private unowned Adw.ViewSwitcherBar view_switcher_bar;

        [GtkChild]
        private unowned Adw.ViewStackPage welcome_page;

        [GtkChild]
        private unowned Adw.ViewStackPage open_issues_page;

        [GtkChild]
        private unowned Adw.ViewStackPage closed_issues_page;

        [GtkChild]
        private unowned Adw.StatusPage welcome_status;

        [GtkChild]
        private unowned Gtk.Button about_button;

        [GtkChild]
        private unowned Gtk.Button setup_button;

        [GtkChild]
        private unowned IssuesView open_issues_view;

        [GtkChild]
        private unowned IssuesView closed_issues_view;

        private Logger logger;
        private SettingsManager settings;

        public Window(Gtk.Application app) {
            Object(application: app);

            logger = Logger.get_default();
            settings = SettingsManager.get_instance();
            setup_actions();
            setup_adaptive_switcher();
            check_github_token_and_update_ui();

            // Ensure template widgets are accessible (suppresses unused warnings)
            assert(header_bar != null);
            assert(menu_button != null);
            assert(toast_overlay != null);
            assert(main_stack != null);
            assert(view_switcher != null);
            assert(view_switcher_bar != null);
            assert(welcome_page != null);
            assert(open_issues_page != null);
            assert(closed_issues_page != null);
            assert(welcome_status != null);
            assert(about_button != null);
            assert(setup_button != null);
            assert(open_issues_view != null);
            assert(closed_issues_view != null);

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

        private void setup_adaptive_switcher() {
            // Bind the ViewSwitcherBar reveal to show only when we have multiple pages to switch between
            // and when we're on narrow screens or the ViewSwitcher is not visible

            // Initially hide switcher components when on welcome page
            update_switcher_visibility();

            // Monitor visible child changes
            main_stack.notify["visible-child"].connect(update_switcher_visibility);
        }

        private void update_switcher_visibility() {
            var current_page = main_stack.visible_child_name;

            if (current_page == "welcome") {
                // Hide both switchers on welcome page
                view_switcher.visible = false;
                view_switcher_bar.reveal = false;
            } else {
                // Show switchers for issues pages (adaptive behavior handled by LibAdwaita)
                view_switcher.visible = true;
                view_switcher_bar.reveal = true;
            }
        }

        private void check_github_token_and_update_ui() {
            var token = settings.get_github_token().strip();

            if (token == "") {
                // No token configured - show welcome state
                main_stack.visible_child_name = "welcome";
                logger.info("No GitHub token configured, showing welcome state");
            } else {
                // Token is configured - show open issues by default
                main_stack.visible_child_name = "open";
                logger.info("GitHub token configured, showing issues view");

                // Load issues for both views asynchronously
                open_issues_view.load_issues.begin();
                closed_issues_view.load_issues.begin();
            }
        }

        public void refresh_token_state() {
            check_github_token_and_update_ui();
        }
    }
}


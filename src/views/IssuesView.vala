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
    [GtkTemplate (ui = "/io/github/tobagin/Issuer/Devel/issues.ui")]
#else
    [GtkTemplate (ui = "/io/github/tobagin/Issuer/issues.ui")]
#endif
    public class IssuesView : Gtk.Box {

        public string issues_state { get; set; default = "open"; }

        [GtkChild]
        private unowned Gtk.Box toolbar_box;

        [GtkChild]
        private unowned Gtk.Button refresh_button;

        [GtkChild]
        private unowned Gtk.MenuButton issues_menu;

        [GtkChild]
        private unowned Adw.ToastOverlay toast_overlay;

        [GtkChild]
        private unowned Adw.ViewStack view_stack;

        [GtkChild]
        private unowned Gtk.Spinner loading_spinner;

        [GtkChild]
        private unowned Gtk.ListView issues_list_view;

        [GtkChild]
        private unowned Adw.StatusPage error_status;

        [GtkChild]
        private unowned Adw.StatusPage empty_status;

        [GtkChild]
        private unowned Gtk.Button retry_button;

        [GtkChild]
        private unowned Gtk.Button browse_repos_button;

        private GitHubApi github_api;
        private Logger logger;
        private Gee.List<Issue> issues;

        public IssuesView() {
            Object();
        }

        construct {
            github_api = GitHubApi.get_instance();
            logger = Logger.get_default();

            issues = new Gee.ArrayList<Issue>();

            setup_actions();
            setup_signals();

            // Ensure all widgets are accessible
            assert(toolbar_box != null);
            assert(refresh_button != null);
            assert(issues_menu != null);
            assert(toast_overlay != null);
            assert(view_stack != null);
            assert(loading_spinner != null);
            assert(issues_list_view != null);
            assert(error_status != null);
            assert(empty_status != null);
            assert(retry_button != null);
            assert(browse_repos_button != null);

            logger.debug("IssuesView constructed");
        }


        private void setup_actions() {
            var action_group = new SimpleActionGroup();

            var filter_repo_action = new SimpleAction("filter-repo", null);
            filter_repo_action.activate.connect(() => {
                logger.debug("Filter by repository action triggered");
                // TODO: Implement repository filter
            });
            action_group.add_action(filter_repo_action);

            var filter_label_action = new SimpleAction("filter-label", null);
            filter_label_action.activate.connect(() => {
                logger.debug("Filter by label action triggered");
                // TODO: Implement label filter
            });
            action_group.add_action(filter_label_action);

            var create_issue_action = new SimpleAction("create-issue", null);
            create_issue_action.activate.connect(() => {
                logger.debug("Create issue action triggered");
                // TODO: Implement create issue dialog
            });
            action_group.add_action(create_issue_action);

            insert_action_group("issues", action_group);
        }

        private void setup_signals() {
            refresh_button.clicked.connect(() => {
                load_issues.begin();
            });

            retry_button.clicked.connect(() => {
                load_issues.begin();
            });

            browse_repos_button.clicked.connect(() => {
                logger.debug("Browse repositories action triggered");
                // TODO: Implement repositories browser
            });

            // Handle list view activations (when user clicks on issue)
            issues_list_view.activate.connect((position) => {
                var item = issues_list_view.model.get_item(position) as Issue;
                if (item != null) {
                    open_issue_in_browser(item);
                }
            });
        }

        public async void load_issues() {
            logger.info("Loading %s GitHub issues", issues_state);

            view_stack.visible_child_name = "loading";
            loading_spinner.spinning = true;

            try {
                // Load issues for the specific state (open or closed)
                issues = yield github_api.fetch_issues(issues_state);

                update_issue_list();

                if (issues.size == 0) {
                    view_stack.visible_child_name = "empty";
                    // Update empty status message based on issue state
                    if (issues_state == "open") {
                        empty_status.title = _("No Open Issues");
                        empty_status.description = _("Great! You don't have any open issues in your repositories.");
                        empty_status.icon_name = "io.github.tobagin.Issuer-open-symbolic";
                    } else {
                        empty_status.title = _("No Closed Issues");
                        empty_status.description = _("You don't have any closed issues in your repositories.");
                        empty_status.icon_name = "io.github.tobagin.Issuer-closed-symbolic";
                    }
                } else {
                    view_stack.visible_child_name = "issues";
                }

                logger.info("Loaded %d %s issues", issues.size, issues_state);

            } catch (Error e) {
                logger.error("Failed to load %s issues: %s", issues_state, e.message);
                error_status.description = e.message;
                view_stack.visible_child_name = "error";

                var toast = new Adw.Toast(_("Failed to load issues"));
                toast_overlay.add_toast(toast);
            }

            loading_spinner.spinning = false;
        }

        private void update_issue_list() {
            // Create model for the list view
            var model = new GLib.ListStore(typeof(Issue));

            // Add issues to model
            foreach (var issue in issues) {
                model.append(issue);
            }

            // Create selection model
            var selection = new Gtk.SingleSelection(model);

            // Create list item factory
            var factory = create_issue_list_factory();

            // Set up list view
            issues_list_view.model = selection;
            issues_list_view.factory = factory;
            issues_list_view.single_click_activate = true;
        }

        private Gtk.ListItemFactory create_issue_list_factory() {
            var factory = new Gtk.SignalListItemFactory();

            factory.setup.connect((item) => {
                var list_item = item as Gtk.ListItem;
                var box = new Gtk.Box(Gtk.Orientation.VERTICAL, 6);
                box.margin_top = 12;
                box.margin_bottom = 12;
                box.margin_start = 12;
                box.margin_end = 12;

                // Title and repository row
                var title_box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 8);
                title_box.hexpand = true;

                var title_label = new Gtk.Label("");
                title_label.ellipsize = Pango.EllipsizeMode.END;
                title_label.xalign = 0;
                title_label.add_css_class("heading");

                var repo_label = new Gtk.Label("");
                repo_label.add_css_class("caption");
                repo_label.add_css_class("dim-label");
                repo_label.halign = Gtk.Align.END;

                title_box.append(title_label);
                title_box.append(repo_label);

                // Metadata row (author, time, labels)
                var meta_box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 8);
                var meta_label = new Gtk.Label("");
                meta_label.add_css_class("caption");
                meta_label.add_css_class("dim-label");
                meta_label.xalign = 0;
                meta_label.ellipsize = Pango.EllipsizeMode.END;

                var number_label = new Gtk.Label("");
                number_label.add_css_class("caption");
                number_label.add_css_class("dim-label");
                number_label.halign = Gtk.Align.END;

                meta_box.append(meta_label);
                meta_box.append(number_label);

                box.append(title_box);
                box.append(meta_box);

                // Store references for binding
                title_label.set_data("title-label", title_label);
                repo_label.set_data("repo-label", repo_label);
                meta_label.set_data("meta-label", meta_label);
                number_label.set_data("number-label", number_label);

                list_item.child = box;
            });

            factory.bind.connect((item) => {
                var list_item = item as Gtk.ListItem;
                var issue = list_item.item as Issue;
                var box = list_item.child as Gtk.Box;

                if (issue == null || box == null) return;

                // Get labels from the box
                var title_box = box.get_first_child() as Gtk.Box;
                var meta_box = box.get_last_child() as Gtk.Box;

                var title_label = title_box.get_first_child() as Gtk.Label;
                var repo_label = title_box.get_last_child() as Gtk.Label;
                var meta_label = meta_box.get_first_child() as Gtk.Label;
                var number_label = meta_box.get_last_child() as Gtk.Label;

                // Bind data
                title_label.label = issue.title;
                repo_label.label = issue.get_repository_short_name();

                var meta_text = @"by $(issue.author) • $(issue.get_time_ago())";
                if (issue.labels.size > 0) {
                    meta_text += @" • $(issue.get_labels_text())";
                }
                meta_label.label = meta_text;

                number_label.label = @"#$(issue.number)";
            });

            return factory;
        }

        private void open_issue_in_browser(Issue issue) {
            try {
                var launcher = new Gtk.UriLauncher(issue.html_url);
                launcher.launch.begin(get_root() as Gtk.Window, null, (obj, res) => {
                    try {
                        launcher.launch.end(res);
                        logger.debug("Opened issue #%d in browser", issue.number);
                    } catch (Error e) {
                        logger.warning("Failed to open issue in browser: %s", e.message);
                        var toast = new Adw.Toast(_("Failed to open issue in browser"));
                        toast_overlay.add_toast(toast);
                    }
                });
            } catch (Error e) {
                logger.warning("Failed to create URI launcher: %s", e.message);
            }
        }

        public void show_toast(string message) {
            var toast = new Adw.Toast(message);
            toast_overlay.add_toast(toast);
        }
    }
}
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

public class IssuerAboutDialog : GLib.Object {

    public static void show(Gtk.Window? parent) {
        var logger = Issuer.Logger.get_default();
        logger.debug("About action activated");
        
        var developers = new string[] { "Thiago Fernandes", null };
        var designers = new string[] { "Thiago Fernandes", null };
        var artists = new string[] { "Thiago Fernandes", null };
        
        string comments = "A modern, native GTK4/LibAdwaita Issuer application";
        if (Config.ID.contains("Devel")) {
            comments += " (Dev Version)";
        }

        var about = new Adw.AboutDialog() {
            application_name = Config.NAME,
            application_icon = Config.ID,
            developer_name = "The Issuer Team",
            version = Config.VERSION,
            developers = developers,
            designers = designers,
            artists = artists,
            license_type = Gtk.License.GPL_3_0,
            website = "https://tobagin.github.io/apps/Issuer",
            issue_url = "https://github.com/tobagin/Issuer/issues",
            support_url = "https://github.com/tobagin/Issuer/discussions",
            comments = comments
        };

        // Load and set release notes from metainfo
        load_release_notes(about);

        // Set copyright
        about.set_copyright("© 2025 The Issuer Team");

        // Add acknowledgement section
        var acknowledgements = new string[] {
            "The GNOME Project",
            "LibAdwaita Contributors",
            "Vala Programming Language Team",
            null
        };
        about.add_acknowledgement_section("Special Thanks", acknowledgements);

        // Set translator credits
        about.set_translator_credits("Thiago Fernandes");
        
        // Add Source link
        about.add_link("Source", "https://github.com/tobagin/Issuer");

        if (parent != null && !parent.in_destruction()) {
            about.present(parent);
        }
    }
    
    public static void show_with_release_notes(Gtk.Window? parent) {
        // Open the about dialog first (regular method)
        show(parent);
        Issuer.Logger.get_default().debug("About dialog opened, preparing automatic navigation");
        
        // Wait for the dialog to appear and be fully rendered
        Timeout.add(Issuer.Constants.WHATS_NEW_DELAY, () => {
            Issuer.Logger.get_default().debug("Starting automatic navigation to release notes");
            simulate_tab_navigation();
            
            // Simulate Enter key press after another delay to open release notes
            Timeout.add(Issuer.Constants.DIALOG_ANIMATION_DELAY, () => {
                simulate_enter_activation();
                Issuer.Logger.get_default().info("Automatic navigation to release notes completed");
                return false;
            });
            return false;
        });
    }
    
    private static void load_release_notes(Adw.AboutDialog about) {
        try {
            string[] possible_paths = {
                Path.build_filename("/app/share/metainfo", @"$(Config.ID).metainfo.xml"),
                Path.build_filename("/usr/share/metainfo", @"$(Config.ID).metainfo.xml"),
                Path.build_filename(Environment.get_user_data_dir(), "metainfo", @"$(Config.ID).metainfo.xml")
            };
            
            foreach (string metainfo_path in possible_paths) {
                var file = File.new_for_path(metainfo_path);
                
                if (file.query_exists()) {
                    uint8[] contents;
                    string etag_out;
                    file.load_contents(null, out contents, out etag_out);
                    string xml_content = (string) contents;
                    
                    // Parse the XML to find the release matching Config.VERSION
                    var parser = new Regex("<release version=\"%s\"[^>]*>(.*?)</release>".printf(Regex.escape_string(Config.VERSION)), 
                                           RegexCompileFlags.DOTALL | RegexCompileFlags.MULTILINE);
                    MatchInfo match_info;
                    
                    if (parser.match(xml_content, 0, out match_info)) {
                        string release_section = match_info.fetch(1);
                        
                        // Extract description content
                        var desc_parser = new Regex("<description>(.*?)</description>", 
                                                    RegexCompileFlags.DOTALL | RegexCompileFlags.MULTILINE);
                        MatchInfo desc_match;
                        
                        if (desc_parser.match(release_section, 0, out desc_match)) {
                            string release_notes = desc_match.fetch(1).strip();
                            about.set_release_notes(release_notes);
                            about.set_release_notes_version(Config.VERSION);
                        }
                    }
                    break;
                }
            }
        } catch (Error e) {
            // If we can't load release notes from metainfo, that's okay
            Issuer.Logger.get_default().warning("Could not load release notes from metainfo: %s", e.message);
        }
    }
    
    public static string get_current_release_notes() {
        try {
            string[] possible_paths = {
                Path.build_filename("/app/share/metainfo", @"$(Config.ID).metainfo.xml"),
                Path.build_filename("/usr/share/metainfo", @"$(Config.ID).metainfo.xml"),
                Path.build_filename(Environment.get_user_data_dir(), "metainfo", @"$(Config.ID).metainfo.xml")
            };
            
            foreach (string metainfo_path in possible_paths) {
                var file = File.new_for_path(metainfo_path);
                
                if (file.query_exists()) {
                    uint8[] contents;
                    string etag_out;
                    file.load_contents(null, out contents, out etag_out);
                    string xml_content = (string) contents;
                    
                    // Parse the XML to find the release matching Config.VERSION
                    var parser = new Regex("<release version=\"%s\"[^>]*>(.*?)</release>".printf(Regex.escape_string(Config.VERSION)), 
                                           RegexCompileFlags.DOTALL | RegexCompileFlags.MULTILINE);
                    MatchInfo match_info;
                    
                    if (parser.match(xml_content, 0, out match_info)) {
                        string release_section = match_info.fetch(1);
                        
                        // Extract description content and convert to plain text
                        var desc_parser = new Regex("<description>(.*?)</description>", 
                                                    RegexCompileFlags.DOTALL | RegexCompileFlags.MULTILINE);
                        MatchInfo desc_match;
                        
                        if (desc_parser.match(release_section, 0, out desc_match)) {
                            string release_notes = desc_match.fetch(1).strip();
                            
                            // Convert HTML to plain text for alert dialog
                            release_notes = release_notes.replace("<p>", "").replace("</p>", "\n");
                            release_notes = release_notes.replace("<ul>", "").replace("</ul>", "");
                            release_notes = release_notes.replace("<li>", "• ").replace("</li>", "\n");
                            
                            // Clean up extra whitespace
                            while (release_notes.contains("\n\n\n")) {
                                release_notes = release_notes.replace("\n\n\n", "\n\n");
                            }
                            
                            return release_notes;
                        }
                    }
                    break;
                }
            }
        } catch (Error e) {
            Issuer.Logger.get_default().warning("Could not load release notes from metainfo: %s", e.message);
        }
        
        return "";
    }
    
    private static void simulate_tab_navigation() {
        // Get the currently focused window (should be the about dialog)
        var app = GLib.Application.get_default() as Gtk.Application;
        if (app != null) {
            var focused_window = app.get_active_window();
            if (focused_window != null) {
                Issuer.Logger.get_default().debug("Attempting tab navigation on window: %s", focused_window.get_type().name());
                
                // Try multiple approaches to navigate to the release notes button
                var success = focused_window.child_focus(Gtk.DirectionType.TAB_FORWARD);
                if (success) {
                    Issuer.Logger.get_default().debug("Tab navigation successful");
                } else {
                    Issuer.Logger.get_default().debug("Tab navigation failed - focus might need manual adjustment");
                    // For LibAdwaita dialogs, the focus should automatically navigate
                    // to the appropriate elements when tabbing
                }
            } else {
                Issuer.Logger.get_default().warning("No focused window for tab navigation");
            }
        }
    }

    private static void simulate_enter_activation() {
        // Get the currently active window (should be the about dialog)
        var app = GLib.Application.get_default() as Gtk.Application;
        if (app != null) {
            var focused_window = app.get_active_window();
            if (focused_window != null) {
                // Get the focused widget within the active window
                var focused_widget = focused_window.get_focus();
                Issuer.Logger.get_default().debug("Attempting enter activation on widget: %s", 
                           focused_widget != null ? focused_widget.get_type().name() : "null");
                
                if (focused_widget != null) {
                    // If it's a button, click it
                    if (focused_widget is Gtk.Button) {
                        ((Gtk.Button)focused_widget).activate();
                        Issuer.Logger.get_default().debug("Enter activation simulated on Button");
                    }
                    // For other widgets, try to activate the default action
                    else {
                        focused_widget.activate_default();
                        Issuer.Logger.get_default().debug("Enter activation simulated on widget: %s", focused_widget.get_type().name());
                    }
                } else {
                    // Try to activate the default widget of the window
                    if (focused_window is Gtk.Window) {
                        var default_widget = ((Gtk.Window)focused_window).get_default_widget();
                        if (default_widget != null) {
                            default_widget.activate();
                            Issuer.Logger.get_default().debug("Activated default widget: %s", default_widget.get_type().name());
                        } else {
                            Issuer.Logger.get_default().debug("No default widget found in window");
                        }
                    }
                }
            } else {
                Issuer.Logger.get_default().warning("No active window for enter activation");
            }
        }
    }
}
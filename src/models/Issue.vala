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

    public class Issue : GLib.Object {
        public int64 id { get; set; }
        public int64 number { get; set; }
        public string title { get; set; default = ""; }
        public string body { get; set; default = ""; }
        public string state { get; set; default = "open"; }
        public string html_url { get; set; default = ""; }
        public string repository_name { get; set; default = ""; }
        public string author { get; set; default = ""; }
        public DateTime? created_at { get; set; }
        public DateTime? updated_at { get; set; }
        public Gee.List<string> labels { get; set; }

        public Issue() {
            labels = new Gee.ArrayList<string>();
        }

        public string get_repository_short_name() {
            var parts = repository_name.split("/");
            return parts.length > 1 ? parts[1] : repository_name;
        }

        public string get_time_ago() {
            if (created_at == null) {
                return "";
            }

            var now = new DateTime.now_utc();
            var diff = now.difference(created_at);
            var days = (int)(diff / TimeSpan.DAY);
            var hours = (int)(diff / TimeSpan.HOUR);
            var minutes = (int)(diff / TimeSpan.MINUTE);

            if (days > 0) {
                return days == 1 ? _("1 day ago") : _("%d days ago").printf(days);
            } else if (hours > 0) {
                return hours == 1 ? _("1 hour ago") : _("%d hours ago").printf(hours);
            } else if (minutes > 0) {
                return minutes == 1 ? _("1 minute ago") : _("%d minutes ago").printf(minutes);
            } else {
                return _("Just now");
            }
        }

        public string get_labels_text() {
            if (labels.size == 0) {
                return "";
            }

            var label_text = new StringBuilder();
            bool first = true;
            foreach (string label in labels) {
                if (!first) {
                    label_text.append(", ");
                }
                label_text.append(label);
                first = false;
            }
            return label_text.str;
        }

        public bool is_open() {
            return state == "open";
        }

        public bool is_closed() {
            return state == "closed";
        }
    }
}
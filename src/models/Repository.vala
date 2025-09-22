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

    public class Repository : GLib.Object {
        public int64 id { get; set; }
        public string name { get; set; default = ""; }
        public string full_name { get; set; default = ""; }
        public string description { get; set; default = ""; }
        public string html_url { get; set; default = ""; }
        public bool is_private { get; set; default = false; }

        public string get_owner() {
            var parts = full_name.split("/");
            return parts.length > 0 ? parts[0] : "";
        }

        public string get_short_name() {
            var parts = full_name.split("/");
            return parts.length > 1 ? parts[1] : name;
        }

        public string get_visibility_text() {
            return is_private ? _("Private") : _("Public");
        }
    }
}
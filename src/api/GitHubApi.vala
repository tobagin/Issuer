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

    public class GitHubApi : GLib.Object {
        private static GitHubApi? instance;
        private Soup.Session session;
        private SettingsManager settings;
        private Logger logger;

        public static GitHubApi get_instance() {
            if (instance == null) {
                instance = new GitHubApi();
            }
            return instance;
        }

        private GitHubApi() {
            session = new Soup.Session();
            settings = SettingsManager.get_instance();
            logger = Logger.get_default();

            session.user_agent = @"Issuer/$(Config.VERSION)";
            logger.debug("GitHub API service initialized");
        }

        public async Gee.List<Issue> fetch_issues(string state = "open") throws Error {
            var token = settings.get_github_token().strip();
            if (token == "") {
                throw new IOError.NOT_FOUND("GitHub token not configured");
            }

            var issues = new Gee.ArrayList<Issue>();

            try {
                // First, get user's repositories
                var repos = yield fetch_user_repositories();

                // Then fetch issues from each repository
                foreach (var repo in repos) {
                    var repo_issues = yield fetch_repository_issues(repo.full_name, state);
                    issues.add_all(repo_issues);
                }

                logger.info("Fetched %d %s issues from %d repositories", issues.size, state, repos.size);
            } catch (Error e) {
                logger.error("Failed to fetch issues: %s", e.message);
                throw e;
            }

            return issues;
        }

        public async Gee.List<Repository> fetch_user_repositories() throws Error {
            var token = settings.get_github_token().strip();
            if (token == "") {
                throw new IOError.NOT_FOUND("GitHub token not configured");
            }

            var repositories = new Gee.ArrayList<Repository>();
            var url = "https://api.github.com/user/repos?sort=updated&per_page=100";

            var message = new Soup.Message("GET", url);
            message.request_headers.append("Authorization", @"Bearer $token");
            message.request_headers.append("Accept", "application/vnd.github.v3+json");

            try {
                var response = yield session.send_and_read_async(message, Priority.DEFAULT, null);
                var json_string = (string) response.get_data();

                var parser = new Json.Parser();
                parser.load_from_data(json_string);

                var root_array = parser.get_root().get_array();
                foreach (var repo_node in root_array.get_elements()) {
                    var repo_obj = repo_node.get_object();
                    var repository = new Repository();

                    repository.id = (int64) repo_obj.get_int_member("id");
                    repository.name = repo_obj.get_string_member("name");
                    repository.full_name = repo_obj.get_string_member("full_name");
                    repository.description = repo_obj.has_member("description") && !repo_obj.get_null_member("description")
                        ? repo_obj.get_string_member("description") : "";
                    repository.html_url = repo_obj.get_string_member("html_url");
                    repository.is_private = repo_obj.get_boolean_member("private");

                    repositories.add(repository);
                }

                logger.info("Fetched %d repositories", repositories.size);
            } catch (Error e) {
                logger.error("Failed to fetch repositories: %s", e.message);
                throw e;
            }

            return repositories;
        }

        public async Gee.List<Issue> fetch_repository_issues(string repo_full_name, string state = "open") throws Error {
            var token = settings.get_github_token().strip();
            if (token == "") {
                throw new IOError.NOT_FOUND("GitHub token not configured");
            }

            var issues = new Gee.ArrayList<Issue>();
            var url = @"https://api.github.com/repos/$repo_full_name/issues?state=$state&per_page=100";

            var message = new Soup.Message("GET", url);
            message.request_headers.append("Authorization", @"Bearer $token");
            message.request_headers.append("Accept", "application/vnd.github.v3+json");

            try {
                var response = yield session.send_and_read_async(message, Priority.DEFAULT, null);
                var json_string = (string) response.get_data();

                var parser = new Json.Parser();
                parser.load_from_data(json_string);

                var root_array = parser.get_root().get_array();
                foreach (var issue_node in root_array.get_elements()) {
                    var issue_obj = issue_node.get_object();

                    // Skip pull requests (they appear in issues API but have pull_request field)
                    if (issue_obj.has_member("pull_request")) {
                        continue;
                    }

                    var issue = new Issue();

                    issue.id = (int64) issue_obj.get_int_member("id");
                    issue.number = issue_obj.get_int_member("number");
                    issue.title = issue_obj.get_string_member("title");
                    issue.body = issue_obj.has_member("body") && !issue_obj.get_null_member("body")
                        ? issue_obj.get_string_member("body") : "";
                    issue.state = issue_obj.get_string_member("state");
                    issue.html_url = issue_obj.get_string_member("html_url");
                    issue.repository_name = repo_full_name;

                    // Parse user
                    var user_obj = issue_obj.get_object_member("user");
                    issue.author = user_obj.get_string_member("login");

                    // Parse dates
                    issue.created_at = new DateTime.from_iso8601(issue_obj.get_string_member("created_at"), null);
                    if (issue_obj.has_member("updated_at") && !issue_obj.get_null_member("updated_at")) {
                        issue.updated_at = new DateTime.from_iso8601(issue_obj.get_string_member("updated_at"), null);
                    }

                    // Parse labels
                    if (issue_obj.has_member("labels")) {
                        var labels_array = issue_obj.get_array_member("labels");
                        foreach (var label_node in labels_array.get_elements()) {
                            var label_obj = label_node.get_object();
                            issue.labels.add(label_obj.get_string_member("name"));
                        }
                    }

                    issues.add(issue);
                }

                logger.debug("Fetched %d %s issues from %s", issues.size, state, repo_full_name);
            } catch (Error e) {
                logger.warning("Failed to fetch issues from %s: %s", repo_full_name, e.message);
                // Don't throw error for individual repos, just continue with others
            }

            return issues;
        }
    }
}
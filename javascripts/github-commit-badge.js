;(function($) {
		var user = "technicalpickles";
		var repo = "jeweler";
		var branch = "master"
		var url = "http://github.com/api/v1/json/" + user + "/" + repo + "/commits/" + branch + '?callback=?';
		$.getJSON(url, function(data) {
				var commits = data.commits;

				var commits_to_display = commits.length < 10 ? commits.length : 10;
				for (var i = 0; i < commits_to_display; i++) {
					var commit = commits[i];

					var $commit_link = $('<a/>').attr('href', commit.url).text(commit.message);
					var $message_li = $('<li/>').append($commit_link).append($commit_link);

					$('.github-commits').append($message_li);
				}
			});
	})(jQuery);
// vim: ts=2 sw=2 filetype=javascript.jquery

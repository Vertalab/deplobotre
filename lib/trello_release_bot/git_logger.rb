module TrelloReleaseBot
  module GitLogger
    # @param [String] branch name
    # @param [Time] since time
    def self.commits(repo_path, revission_rage)
      raw_logs = `cd #{repo_path} && git log #{revission_rage} --format="%H %B"`
      raw_logs.split("\n\n").map do |raw_log|
        { id: raw_log[/^[^ ]*/], message: raw_log[/(?<=\s).*/] }
      end
    end
  end
end

module TrelloReleaseBot
  module GitLogger
    EOC = "\n\n|EOC|\n\n".freeze

    # @param [String] branch name
    # @param [Time] since time
    def self.commits(repo_path, revission_rage)
      raw_logs = `cd #{repo_path} && git log #{revission_rage} --format="%H %B#{EOC}"`
      raw_logs.split(EOC + "\n").map do |raw_log|
        { id: raw_log[/^[^ ]*/], message: raw_log[/(?<=\s).*/] }
      end
    end
  end
end

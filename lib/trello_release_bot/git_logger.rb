module TrelloReleaseBot
  module GitLogger
    EOC = "\n\n|EOC|\n\n".freeze

    # @param [String] branch name
    # @param [String] git revision rage eg: 'd9c41e946832..cf2707e17ff2dd'
    def self.commits(repo_path, revission_rage)
      raw_logs = `cd #{repo_path} && git log #{revission_rage} --format="%H %B#{EOC}"`
      raw_logs.split(EOC + "\n").map do |raw_log|
        { id: raw_log[/^[^\s]*/], message: raw_log[/(?<=\s)(.|\s)*/] }
      end
    end
  end
end

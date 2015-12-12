module GitHubMyRepos
  class CLI
    attr_accessor :username, :protocol
    PROTOCOLS = %w( ssh https )

    def github_my_repos
      self.username = ARGV[0]
      self.protocol = ARGV[1] || 'https'

      unless username && PROTOCOLS.include?(protocol)
        show_help
        return
      end

      Octokit.auto_paginate = true
      user = Octokit.user(username)
      repos = user.rels[:repos].get.data
      puts repos.map(&url_method_sym)
    end

    private

    def show_help
      puts <<-EOL
help: github-my-repos <USERNAME> [CLONE PROTOCOL SSH/HTTP]
      EOL
    end

    def url_method_sym
      case protocol
      when 'https' then :clone_url
      when 'ssh'   then :ssh_url
      end
    end
  end
end

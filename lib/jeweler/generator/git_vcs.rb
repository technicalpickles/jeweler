class Jeweler
  class Generator
    class GitVcs < Plugin
      def run
        git_init '.'
        add_git_remote '.', 'origin', git_remote
      end
    end
  end
end

require 'thor/actions'
require 'git'

class Thor
  module Actions
    def git_init(destination, config={})
      action GitInit.new(self, destination, config)
    end

    class GitInit < EmptyDirectory #:nodoc:

      def invoke!
        repo = nil

        invoke_with_conflict_check do
          FileUtils.mkdir_p(File.dirname(destination))
          repo = Git.init(destination)
        end

        repo
      end


      def exists?
        super && File.exist?(File.join(destination, '.git'))
      end

      def invoke_with_conflict_check(&block)
        if ! exists?
          base.shell.say_status "git init", "already a git repo", :blue if config[:verbose]
        else
          say_status 'git init', :green
          block.call unless pretend?
        end

        destination
      end
    end
    
  end
end

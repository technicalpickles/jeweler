class Jeweler
  module Commands
    class Release
      attr_accessor :gemspec, :version, :repo, :output, :gemspec_helper, :base_dir

      def initialize
        self.output = $stdout
      end

      def run
        repo.checkout('master')

        raise "Hey buddy, try committing them files first" if any_pending_changes?

        gemspec_helper.update_version(version)
        gemspec_helper.write

        repo.add(gemspec_helper.path)
        output.puts "Committing #{gemspec_helper.path}"
        repo.commit("Regenerated gemspec for version #{version}")

        output.puts "Pushing master to origin"
        repo.push

        output.puts "Tagging #{release_tag}"
        repo.add_tag(release_tag)

        output.puts "Pushing #{release_tag} to origin"
        repo.push('origin', release_tag)
      end
      
      def any_pending_changes?
        !(@repo.status.added.empty? && @repo.status.deleted.empty? && @repo.status.changed.empty?)
      end

      def release_tag
        "v#{version}"
      end

      def gemspec_helper
        @gemspec_helper ||= Jeweler::GemSpecHelper.new(self.gemspec, self.base_dir)
      end

      def self.build_for(jeweler)
        command = self.new

        command.base_dir = jeweler.base_dir
        command.gemspec = jeweler.gemspec
        command.version = jeweler.version
        command.repo = jeweler.repo
        command.output = jeweler.output
        command.gemspec_helper = jeweler.gemspec_helper

        command
      end

    end
  end
end

require 'pathname'

class Jeweler
  module Commands
    class ReleaseToGithub
      attr_accessor :gemspec, :version, :repo, :output, :gemspec_helper, :base_dir

      def initialize(attributes = {})
        self.output = $stdout

        attributes.each_pair do |key, value|
          send("#{key}=", value)
        end
      end

      def run
        raise "Hey buddy, try committing them files first" unless clean_staging_area?

        repo.checkout('master')

        regenerate_gemspec!
        commit_gemspec! if gemspec_changed?

        output.puts "Pushing master to origin"
        repo.push
      end

      def clean_staging_area?
        status = repo.status
        status.added.empty? && status.deleted.empty? && status.changed.empty?
      end

      def commit_gemspec!
        gemspec_gitpath = working_subdir.join(gemspec_helper.path)
        repo.add(gemspec_gitpath.to_s)
        output.puts "Committing #{gemspec_gitpath}"
        repo.commit "Regenerated gemspec for version #{version}"
      end

      def regenerate_gemspec!
        gemspec_helper.update_version(version)
        gemspec_helper.write
      end

      def gemspec_changed?
        `git status` # OMGHAX. status always ends up being 'M' unless this runs
        status = repo.status[working_subdir.join(gemspec_helper.path).to_s]
        ! status.type.nil?
      end

      def gemspec_helper
        @gemspec_helper ||= Jeweler::GemSpecHelper.new(self.gemspec, self.base_dir)
      end

      def working_subdir
        return @working_subdir if @working_subdir
        cwd = base_dir_path
        @working_subdir = cwd.relative_path_from(Pathname.new(repo.dir.path))
        @working_subdir
      end

      def base_dir_path
        Pathname.new(base_dir).realpath
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

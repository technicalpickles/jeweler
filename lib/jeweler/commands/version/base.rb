require 'pathname'

class Jeweler
  module Commands
    module Version
      class Base
        attr_accessor :repo, :version_helper, :gemspec, :commit, :base_dir

        def run
          update_version

          version_helper.write
          gemspec.version = version_helper.to_s

          commit_version if repo && commit
        end

        def update_version
          raise 'Subclasses should implement this'
        end

        def commit_version
          if repo
            repo.add(working_subdir.join(version_helper.path).to_s)
            repo.commit("Version bump to #{version_helper}")
          end
        end

        def working_subdir
          @working_subdir ||= base_dir_path.relative_path_from(Pathname.new(repo.dir.path))
        end

        def base_dir_path
          Pathname.new(base_dir).realpath
        end

        def self.build_for(jeweler)
          command = new
          command.repo = jeweler.repo
          command.version_helper = jeweler.version_helper
          command.gemspec = jeweler.gemspec
          command.commit = jeweler.commit
          command.base_dir = jeweler.base_dir

          command
        end
      end
    end
  end
end

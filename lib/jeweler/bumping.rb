class Jeweler
  module Bumping
    # Bumps the patch version.
    #
    # 1.5.1 -> 1.5.2
    def bump_patch_version()
      @version.bump_patch
      @version.write

      announce_version
      commit_version
    end

    # Bumps the minor version.
    #
    # 1.5.1 -> 1.6.0
    def bump_minor_version()
      @version.bump_minor
      @version.write

      announce_version
      commit_version
    end

    # Bumps the major version.
    #
    # 1.5.1 -> 2.0.0
    def bump_major_version()
      @version.bump_major
      @version.write
      
      announce_version
      commit_version
    end

    # Bumps the version, to the specific major/minor/patch version, writing out the appropriate version.rb, and then reloads it.
    def write_version(major = 0, minor = 0, patch = 0)
      @version.update_to major, minor, patch
      @version.write

      @gemspec.version = @version.to_s

      announce_version
      commit_version
    end

    def announce_version
      puts "Wrote to #{@version.yaml_path}: #{@version.to_s}"
    end

    def commit_version
      if @repo
        @repo.add('VERSION.yml')
        @repo.commit("Version bump to #{version}", 'VERSION.yml')
      end
    end
  end
end

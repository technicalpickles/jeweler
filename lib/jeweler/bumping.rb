class Jeweler
  module Bumping
    # Bumps the patch version.
    #
    # 1.5.1 -> 1.5.2
    def bump_patch_version()
      patch = self.patch_version + 1

      write_version(major_version, minor_version, patch)
      write_gemspec
    end

    # Bumps the minor version.
    #
    # 1.5.1 -> 1.6.0
    def bump_minor_version()
      minor = minor_version + 1

      write_version(major_version, minor)
      write_gemspec
    end

    # Bumps the major version.
    #
    # 1.5.1 -> 2.0.0
    def bump_major_version()
      major = major_version + 1

      write_version(major)
      write_gemspec
    end

    # Bumps the version, to the specific major/minor/patch version, writing out the appropriate version.rb, and then reloads it.
    def write_version(major = 0, minor = 0, patch = 0)
      major ||= 0
      minor ||= 0
      patch ||= 0
      
      File.open(version_yaml_path, 'w') do |f|
        version_hash = {
          'major' => major,
          'minor' => minor,
          'patch' => patch
        }
        YAML.dump(version_hash, f)
      end
      refresh_version
      
      @gemspec.version = version
    end
  end
end
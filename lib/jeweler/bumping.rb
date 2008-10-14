class Jeweler
  module Bumping
    # Bumps the patch version.
    #
    # 1.5.1 -> 1.5.2
    def bump_patch_version()
      patch = self.patch_version.to_i + 1

      write_version(major_version, minor_version, patch)
    end

    # Bumps the minor version.
    #
    # 1.5.1 -> 1.6.0
    def bump_minor_version()
      minor = minor_version.to_i + 1

      write_version(major_version, minor)
    end

    # Bumps the major version.
    #
    # 1.5.1 -> 2.0.0
    def bump_major_version()
      major = major_version.to_i + 1

      write_version(major)
    end

    # Bumps the version, to the specific major/minor/patch version, writing out the appropriate version.rb, and then reloads it.
    def write_version(major = 0, minor = 0, patch = 0)
      major ||= 0
      minor ||= 0
      patch ||= 0
      
      File.open(version_yaml_path, 'w+') do |f|
        version_hash = {
          'major' => major.to_i,
          'minor' => minor.to_i,
          'patch' => patch.to_i
        }
        YAML.dump(version_hash, f)
      end
      refresh_version
      
      @gemspec.version = version
      
      puts "Wrote to #{version_yaml_path}: #{version}"
    end
  end
end
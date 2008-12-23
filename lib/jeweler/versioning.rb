require 'yaml'
class Jeweler
  module Versioning
    # Major version, as defined by the gemspec's Version module.
    # For 1.5.3, this would return 1.
    def major_version
      @version.major
    end

    # Minor version, as defined by the gemspec's Version module.
    # For 1.5.3, this would return 5.
    def minor_version
      @version.minor
    end

    # Patch version, as defined by the gemspec's Version module.
    # For 1.5.3, this would return 5.
    def patch_version
      @version.patch
    end

    # Human readable version, which is used in the gemspec.
    def version
      @version.to_s
    end

  protected
    def version_yaml_path
      denormalized_path = File.join(@base_dir, 'VERSION.yml')
      absolute_path = File.expand_path(denormalized_path)
      absolute_path.gsub(Dir.getwd + File::SEPARATOR, '')
    end

    def refresh_version
      @version.refresh
    end
  end
end

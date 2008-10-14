require 'yaml'
class Jeweler
  module Versioning
    # Major version, as defined by the gemspec's Version module.
    # For 1.5.3, this would return 1.
    def major_version
      version_yaml['major']
    end

    # Minor version, as defined by the gemspec's Version module.
    # For 1.5.3, this would return 5.
    def minor_version
      version_yaml['minor']
    end

    # Patch version, as defined by the gemspec's Version module.
    # For 1.5.3, this would return 5.
    def patch_version
      version_yaml['patch']
    end

    # Human readable version, which is used in the gemspec.
    def version
      "#{major_version}.#{minor_version}.#{patch_version}"
    end
    
  protected
    def version_yaml_path
      File.join(@base_dir, 'VERSION.yml')
    end
    
    def version_yaml
      @version_yaml ||= read_version_yaml
    end
    
    def read_version_yaml
      if File.exists?(version_yaml_path)
        YAML.load_file(version_yaml_path)
      else
        raise VersionYmlError, "#{version_yaml_path} does not exist!"
      end
    end
    
    def refresh_version
      @version_yaml = read_version_yaml
    end
  end
end
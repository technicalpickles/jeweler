class Jeweler
  module Versioning
    # Major version, as defined by the gemspec's Version module.
    # For 1.5.3, this would return 1.
    def major_version
      version_module.const_get(:MAJOR)
    end

    # Minor version, as defined by the gemspec's Version module.
    # For 1.5.3, this would return 5.
    def minor_version
      version_module.const_get(:MINOR)
    end

    # Patch version, as defined by the gemspec's Version module.
    # For 1.5.3, this would return 5.
    def patch_version
      version_module.const_get(:PATCH)
    end

    # Human readable version, which is used in the gemspec.
    def version
      "#{major_version}.#{minor_version}.#{patch_version}"
    end
    
  protected
    def version_module_path
      File.join(@base_dir, 'lib', @gemspec.name, 'version.rb')
    end
  
    def version_module
      constantize("#{main_module_name}::Version")
    end
  
    # 
    def refresh_version
      undefine_versions()
      load_version()
    end

    # Undefines version constants, so we can +load+ the version.rb again.
    def undefine_versions
      version_module.module_eval do
        remove_const(:MAJOR) if const_defined?(:MAJOR)
        remove_const(:MINOR) if const_defined?(:MINOR)
        remove_const(:PATCH) if const_defined?(:PATCH)
      end
    end

    def load_version
      load(version_module_path)
    end
  end
end
class Jeweler
  module Versioning
    def major_version
      version_module.const_get(:MAJOR)
    end

    def minor_version
      version_module.const_get(:MINOR)
    end

    def patch_version
      version_module.const_get(:PATCH)
    end

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
  
    def refresh_version
      # Remove the constants, so we can reload the version_module
      undefine_versions()
      load_version()
    end

    def undefine_versions
      version_module.module_eval do
        remove_const(:MAJOR) if const_defined?(:MAJOR)
        remove_const(:MINOR) if const_defined?(:MINOR)
        remove_const(:PATCH) if const_defined?(:PATCH)
      end
    end

    def load_version
      load version_module_path
    end
  end
end
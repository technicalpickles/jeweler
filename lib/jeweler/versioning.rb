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
  end
end
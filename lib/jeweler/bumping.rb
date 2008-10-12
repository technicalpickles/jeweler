class Jeweler
  module Bumping
    def bump_patch_version()
      patch = self.patch_version + 1

      bump_version(major_version, minor_version, patch)
      write_gemspec
    end

    def bump_minor_version()
      minor = minor_version + 1

      bump_version(major_version, minor, 0)
      write_gemspec
    end

    def bump_major_version()
      major = major_version + 1

      bump_version(major, 0, 0)
      write_gemspec
    end

    def bump_version(major, minor, patch)
      main_module_or_class = constantize(main_module_name)
      keyword = top_level_keyword

      File.open(version_module_path, 'w') do |file|
        file.write <<-END
  #{keyword} #{main_module_name}
    module Version
      MAJOR = #{major}
      MINOR = #{minor}
      PATCH = #{patch}
    end
  end
        END
      end
      @gemspec.version = "#{major}.#{minor}.#{patch}"
      refresh_version
    end
  end
end
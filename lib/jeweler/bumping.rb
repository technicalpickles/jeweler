class Jeweler
  module Bumping
    # Bumps the patch version.
    #
    # 1.5.1 -> 1.5.2
    def bump_patch_version()
      patch = self.patch_version + 1

      bump_version(major_version, minor_version, patch)
      write_gemspec
    end

    # Bumps the minor version.
    #
    # 1.5.1 -> 1.6.0
    def bump_minor_version()
      minor = minor_version + 1

      bump_version(major_version, minor, 0)
      write_gemspec
    end

    # Bumps the major version.
    #
    # 1.5.1 -> 2.0.0
    def bump_major_version()
      major = major_version + 1

      bump_version(major, 0, 0)
      write_gemspec
    end

    # Bumps the version, to the specific major/minor/patch version, writing out the appropriate version.rb, and then reloads it.
    def bump_version(major, minor, patch)
      main_module_or_class = constantize(main_module_name)
      keyword = top_level_keyword()

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
    
  protected
    # Tries to figure out the Ruby keyword of what is containing the Version
    # module. This should be 'module' or 'class', and is used for rewriting the version.rb.
    def top_level_keyword
      main_module_or_class = constantize(main_module_name)
      case main_module_or_class
      when Class
        'class'
      when Module
        'module'
      else
        raise "Uh, main_module_name should be a class or module, but was a #{main_module_or_class.class}"
      end
    end
  end
end
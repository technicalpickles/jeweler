class Jeweler

  class GemSpecHelper

    attr_accessor :spec, :base_dir

    def initialize(spec, base_dir = nil)
      self.spec = spec
      self.base_dir = base_dir || ''

      yield spec if block_given?
    end

    def valid?
      begin
        parse
        true
      rescue
        false
      end
    end

    def write
      @spec.files = normalize_files(@spec.files)
      @spec.test_files = normalize_files(@spec.files)

      quoted_files = @spec.files.map {|file| %Q{"#{file}"}}
      nastily_formated_files = quoted_files.join(", ")
      nicely_formated_files  = quoted_files.join(",\n    ")

      File.open(path, 'w') do |f|
        gemspec_ruby = @spec.to_ruby
        gemspec_ruby = prettyify_array(gemspec_ruby, @spec.files)
        gemspec_ruby = prettyify_array(gemspec_ruby, @spec.test_files)
        f.write gemspec_ruby
      end 
    end

    def path
      denormalized_path = File.join(@base_dir, "#{@spec.name}.gemspec")
      absolute_path = File.expand_path(denormalized_path)
      absolute_path.gsub(Dir.getwd + File::SEPARATOR, '') 
    end

    def parse
      data = File.read(path)
      parsed_gemspec = nil
      Thread.new { parsed_gemspec = eval("$SAFE = 3\n#{data}", binding, path) }.join
      parsed_gemspec
    end

    def normalize_files(array)
      # only keep files, no directories, and sort
      array.select do |path|
        File.file? File.join(@base_dir, path)
      end.sort
    end

    def prettyify_array(gemspec, array)
      quoted_array = array.map {|file| %Q{"#{file}"}}
      nastily_formated_array = quoted_array.join(", ")
      nicely_formated_array  = quoted_array.join(",\n    ") 

      gemspec.gsub(nastily_formated_array, nicely_formated_array)
    end

    def gem_path
      File.join(@base_dir, 'pkg', parse.file_name)
    end

    def update_version(version)
      @spec.version = version.to_s
    end

  end
end

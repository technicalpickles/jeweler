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
      quoted_files = @spec.files.map {|file| %Q{"#{file}"}}
      nastily_formated_files = quoted_files.join(", ")
      nicely_formated_files  = quoted_files.join(",\n    ")
      File.open(path, 'w') do |f|
        f.write @spec.to_ruby.gsub(nastily_formated_files, nicely_formated_files)
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

    def gem_path
      File.join(@base_dir, 'pkg', parse.file_name)
    end

    def update_version(version)
      @spec.version = version.to_s
    end

  end
end

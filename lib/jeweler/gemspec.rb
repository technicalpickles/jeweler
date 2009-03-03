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
      File.open(path, 'w') do |f|
        f.write @spec.to_ruby
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

  end
end

class Jeweler
  class GemSpec

    attr_accessor :spec, :base_dir

    def initialize(spec, base_dir = nil)
      self.spec = spec
      self.base_dir = base_dir || ''
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
      Thread.new { eval("$SAFE = 3\n#{data}", binding, path) }.join 
    end

  end

  module Gemspec
    # Writes out the gemspec
    def write_gemspec
      self.refresh_version
      @gemspec.version = self.version
      @gemspec.date = Time.now

      GemSpec.new(@gemspec, @base_dir).write

      puts "Generated: #{gemspec_path}"
    end

    # Validates the gemspec in an environment similar to how GitHub would build
    # it. See http://gist.github.com/16215
    def validate_gemspec
      begin
        GemSpec.new(@gemspec, @base_dir).parse
        puts "#{gemspec_path} is valid."
      rescue Exception => e
        puts "#{gemspec_path} is invalid. See the backtrace for more details."
        raise
      end
    end


    def valid_gemspec?
      GemSpec.new(@gemspec, @base_dir).valid?
    end

    def parse_gemspec(data = nil)
      data ||= File.read(gemspec_path)
      Thread.new { eval("$SAFE = 3\n#{data}", binding, gemspec_path) }.join
    end

    def unsafe_parse_gemspec(data = nil)
      data ||= File.read(gemspec_path)
      eval(data, binding, gemspec_path)
    end

  protected
    def gemspec_path
      denormalized_path = File.join(@base_dir, "#{@gemspec.name}.gemspec")
      absolute_path = File.expand_path(denormalized_path)
      absolute_path.gsub(Dir.getwd + File::SEPARATOR, '')
    end
  end
end

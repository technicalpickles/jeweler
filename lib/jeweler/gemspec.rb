class Jeweler
  module Gemspec
    # Writes out the gemspec
    def write_gemspec
      @gemspec.date = self.date
      File.open(gemspec_path, 'w') do |f|
        f.write @gemspec.to_ruby
      end
      puts "Generated #{gemspec_path}."
    end
    
    # Validates the gemspec in an environment similar to how GitHub would build
    # it. See http://gist.github.com/16215
    def validate_gemspec
      begin
        # Snippet borrowed from http://gist.github.com/16215
        data = File.read(gemspec_path)
      
        spec = nil
        if data !~ %r{!ruby/object:Gem::Specification}
          Thread.new { spec = eval("$SAFE = 3\n#{data}", binding, gemspec_path) }.join
        else
          spec = YAML.load(data)
        end
        
        puts "#{gemspec_path} is valid."
      rescue Exception => e
        puts "#{gemspec_path} is invalid. See the backtrace for more details."
        raise
      end
    end
    
  protected
    def gemspec_path
      File.join(@base_dir, "#{@gemspec.name}.gemspec")
    end
    
    # Generates a date for stuffing in the gemspec
    def date
      date = DateTime.now
      "#{date.year}-#{date.month}-#{date.day}"
    end
  end
end
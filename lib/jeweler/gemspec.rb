class Jeweler
  module Gemspec
    def date
      date = DateTime.now
      "#{date.year}-#{date.month}-#{date.day}"
    end


    def write_gemspec
      @gemspec.date = self.date
      File.open(gemspec_path, 'w') do |f|
        f.write @gemspec.to_ruby
      end
    end
    
  protected
    def gemspec_path
      File.join(@base_dir, "#{@gemspec.name}.gemspec")
    end
  end
end
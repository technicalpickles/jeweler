require 'date'

class Jeweler
  def self.gemspec=(gemspec)
    @@gemspec = gemspec
    require version_module_path
  end
  
  def self.major_version
    version_module.const_get(:MAJOR)
  end
  
  def self.minor_version
    version_module.const_get(:MINOR)
  end
  
  def self.patch_version
    version_module.const_get(:PATCH)
  end
  
  def self.version
    "#{major_version}.#{minor_version}.#{patch_version}"
  end
  
  def self.date
    date = DateTime.now
    "#{date.year}-#{date.month}-#{date.day}"
  end
  
  def self.bump_version(major, minor, patch)
    main_module_or_class = constantize(main_module_name)
    keyword = case main_module_or_class.class
    when Class
      'class'
    when Module
      'module'
    else
      raise "Uh, main_module_name should be a class or module, but was a #{main_module_or_class.class}"
    end
    
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
    @@gemspec.version = "#{major}.#{minor}.#{patch}"
  end
  
  def self.write_gemspec
    @@gemspec.date = self.date
    File.open(gemspec_path, 'w') do |f|
      f.write @@gemspec.to_ruby
    end
  end
  
  private
  
  def self.gemspec_path
    "#{@@gemspec.name}.gemspec"
  end
  
  def self.version_module_path
    "lib/#{@@gemspec.name}/version.rb"
  end
  
  def self.version_module
    constantize("#{main_module_name}::Version")
  end
  
  def self.main_module_name
    camelize(@@gemspec.name)
  end
  
  if Module.method(:const_get).arity == 1
    def self.constantize(camel_cased_word)
      names = camel_cased_word.split('::')
      names.shift if names.empty? || names.first.empty?

      constant = Object
      names.each do |name|
        constant = constant.const_defined?(name) ? constant.const_get(name) : constant.const_missing(name)
      end
      constant
    end
  else
    def self.constantize(camel_cased_word) #:nodoc:
      names = camel_cased_word.split('::')
      names.shift if names.empty? || names.first.empty?

      constant = Object
      names.each do |name|
        constant = constant.const_get(name, false) || constant.const_missing(name)
      end
      constant
    end
  end
  
  def self.camelize(lower_case_and_underscored_word, first_letter_in_uppercase = true)
    if first_letter_in_uppercase
      lower_case_and_underscored_word.to_s.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
    else
      lower_case_and_underscored_word.first.downcase + camelize(lower_case_and_underscored_word)[1..-1]
    end
  end
end

require 'jeweler/tasks'
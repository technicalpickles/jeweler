class Jeweler
  class Version
    attr_accessor :base_dir
    attr_reader :major, :minor, :patch

    def initialize(base_dir)
      self.base_dir = base_dir

      if File.exists?(yaml_path)
        parse_yaml
      end
    end

    def bump_major
      @major += 1
      @minor = 0
      @patch = 0
    end

    def bump_minor
      @minor += 1
      @patch = 0
    end

    def bump_patch
      @patch += 1
    end

    def update_to(major, minor, patch)
      @major = major
      @minor = minor
      @patch = patch
    end

    def write
      File.open(yaml_path, 'w+') do |f|
        YAML.dump(self.to_hash, f)
      end
    end

    def to_s
      "#{major}.#{minor}.#{patch}"
    end

    def to_hash
      {
        :major => major,
        :minor => minor,
        :patch => patch
      }
    end

    def refresh
      parse_yaml
    end

    def yaml_path
      denormalized_path = File.join(@base_dir, 'VERSION.yml')
      absolute_path = File.expand_path(denormalized_path)
      absolute_path.gsub(Dir.getwd + File::SEPARATOR, '')
    end

    protected

    def parse_yaml
      yaml = read_yaml
      @major = (yaml['major'] || yaml[:major]).to_i
      @minor = (yaml['minor'] || yaml[:minor]).to_i
      @patch = (yaml['patch'] || yaml[:patch]).to_i
    end

    def read_yaml
      if File.exists?(yaml_path)
        YAML.load_file(yaml_path)
      else
        raise VersionYmlError, "#{yaml_path} does not exist!"
      end
    end

  end
end

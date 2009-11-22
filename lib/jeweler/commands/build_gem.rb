class Jeweler
  module Commands
    class BuildGem
      attr_accessor :base_dir, :gemspec_helper, :file_utils, :version_helper, :signer, :output

      def initialize
        self.file_utils = FileUtils
        self.signer = Jeweler::Signer.new
        self.output = $stdout
      end

      def run
        gemspec_helper.update_version(version_helper) unless gemspec_helper.has_version?

        gemspec = gemspec_helper.parse

        if signer.can_sign?
          output.puts "Signing with #{signer.key_file}"
          signer.sign(gemspec) if signer.can_sign?

        else
          output.puts "Not signing the gem"
        end

        require 'rubygems/builder'
        gem_file_name = Gem::Builder.new(gemspec).build

        pkg_dir = File.join(base_dir, 'pkg')
        file_utils.mkdir_p pkg_dir

        gem_file_name = File.join(base_dir, gem_file_name)
        file_utils.mv gem_file_name, pkg_dir
      end

      def self.build_for(jeweler)
        command = new

        command.base_dir = jeweler.base_dir
        command.gemspec_helper = jeweler.gemspec_helper
        command.version_helper = jeweler.version_helper

        command
      end
    end
  end
end

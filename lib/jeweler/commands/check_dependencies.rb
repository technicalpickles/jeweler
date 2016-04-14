class Jeweler
  module Commands
    class CheckDependencies
      class MissingDependenciesError < RuntimeError
        attr_accessor :dependencies, :type
      end

      attr_accessor :gemspec, :type

      def run
        missing_dependencies = find_missing_dependencies

        if missing_dependencies.empty?
          puts "#{type || 'All'} dependencies seem to be installed."
        else
          puts 'Missing some dependencies. Install them with the following commands:'
          missing_dependencies.each do |dependency|
            puts %(\tgem install #{dependency.name} --version "#{dependency.requirement}")
          end

          abort "Run the specified gem commands before trying to run this again: {$PROGRAM_NAME} #{ARGV.join(' ')}"
        end
      end

      def find_missing_dependencies
        if Gem::Specification.respond_to?(:find_by_name)
          dependencies.select do |dependency|
            begin
              spec = Gem::Specification.find_by_name(dependency.name, *dependency.requirement.as_list)
              spec.activate if spec
              !spec
            rescue LoadError => e
              true
            end
          end
        else
          dependencies.select do |dependency|
            begin
              Gem.activate dependency.name, *dependency.requirement.as_list
              false
            rescue LoadError => e
              true
            end
          end
        end
      end

      def dependencies
        case type
        when :runtime, :development
          gemspec.send("#{type}_dependencies")
        else
          gemspec.dependencies
        end
      end

      def self.build_for(jeweler)
        command = new

        command.gemspec = jeweler.gemspec

        command
      end
    end
  end
end

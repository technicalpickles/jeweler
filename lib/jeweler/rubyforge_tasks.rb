require 'rake'
require 'rake/tasklib'
require 'rake/contrib/sshpublisher'


class Jeweler
  class RubyforgeTasks < ::Rake::TaskLib
    attr_accessor :project, :remote_doc_path
    attr_accessor :doc_task
    attr_accessor :jeweler

    def initialize
      yield self if block_given?

      self.jeweler = Rake.application.jeweler

      self.remote_doc_path ||= jeweler.gemspec.name
      self.project ||= jeweler.gemspec.rubyforge_project
      self.doc_task ||= :rdoc

      define
    end

    def define
      namespace :rubyforge do

        desc "Release gem and RDoc documentation to RubyForge"
        task :release => ["rubyforge:release:gem", "rubyforge:release:docs"]

        namespace :release do
          desc "Release the current gem version to RubyForge."
          task :gem => [:gemspec, :build] do
            begin
              jeweler.release_gem_to_rubyforge
            rescue NoRubyForgeProjectInGemspecError => e
              abort "Setting up RubyForge requires that you specify a 'rubyforge_project' in your Jeweler::Tasks declaration"
            rescue MissingRubyForgePackageError => e
              abort "Rubyforge reported that the #{e.message} package isn't setup. Run rake rubyforge:setup to do so."
            rescue RubyForgeProjectNotConfiguredError => e
              abort "RubyForge reported that #{e.message} wasn't configured. This means you need to run 'rubyforge setup', 'rubyforge login', and 'rubyforge configure', or maybe the project doesn't exist on RubyForge"
            end
          end

          desc "Publish docs to RubyForge."
          task :docs => doc_task do
            config = YAML.load(
              File.read(File.expand_path('~/.rubyforge/user-config.yml'))
            )

            host = "#{config['username']}@rubyforge.org"
            remote_dir = "/var/www/gforge-projects/#{project}/#{remote_doc_path}"

            local_dir = case doc_task
                        when :rdoc then 'rdoc'
                        when :yardoc then 'doc'
                        end

            sh %{rsync -av --delete #{local_dir}/ #{host}:#{remote_dir}}
          end
        end

        desc "Setup a rubyforge project for this gem"
        task :setup do
          begin 
            jeweler.setup_rubyforge
          rescue NoRubyForgeProjectInGemspecError => e
            abort "Setting up RubyForge requires that you specify a 'rubyforge_project' in your Jeweler::Tasks declaration"
          rescue RubyForgeProjectNotConfiguredError => e
            abort "The RubyForge reported that #{e.message} wasn't configured. This means you need to run 'rubyforge setup', 'rubyforge login', and 'rubyforge configure', or maybe the project doesn't exist on RubyForge"
          end
        end

      end
    end
  end
end

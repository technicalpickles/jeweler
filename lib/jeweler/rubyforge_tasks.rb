require 'rake'
require 'rake/tasklib'
require 'rake/contrib/sshpublisher'


class Jeweler
  class RubyforgeTasks < ::Rake::TaskLib
    attr_accessor :project, :remote_doc_path
    attr_accessor :jeweler

    def initialize
      yield self if block_given?

      self.jeweler = Rake.application.jeweler

      self.remote_doc_path ||= jeweler.gemspec.name
      self.project ||= jeweler.gemspec.rubyforge_project

      define
    end

    def define
      namespace :rubyforge do

        desc "Release gem and RDoc documentation to RubyForge"
        task :release => ["rubyforge:release:gem", "rubyforge:release:docs"]

        namespace :release do
          desc "Publish RDoc to RubyForge."
          task :docs => [:rdoc] do
            config = YAML.load(
              File.read(File.expand_path('~/.rubyforge/user-config.yml'))
            )

            host = "#{config['username']}@rubyforge.org"
            remote_dir = "/var/www/gforge-projects/#{project}/#{remote_doc_path}"
            local_dir = 'rdoc'

            sh %{rsync -av --delete #{local_dir}/ #{host}:#{remote_dir}}
          end
        end
      end
      
    end
  end
end

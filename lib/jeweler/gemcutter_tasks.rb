require 'rake'
require 'rake/tasklib'

class Jeweler
  # (Now deprecated) Rake tasks for putting a Jeweler gem on Gemcutter. It is part of Jeweler::Tasks now.
  class GemcutterTasks < ::Rake::TaskLib
    def initialize
      $stderr.puts "DEPRECATION: gemcutter tasks are now part of Jeweler::Tasks. Please remove Jeweler::GemcutterTasks at #{caller[1]}"
    end
  end
end

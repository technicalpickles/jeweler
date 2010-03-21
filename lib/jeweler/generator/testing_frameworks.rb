class Jeweler
  class Generator
    module TestingFramework
      Generator.class_option :testing_framework, :type => :string, :default => 'shoulda',
        :desc => 'the testing framework to generate'

      require 'jeweler/generator/testing_frameworks/base'
      require 'jeweler/generator/testing_frameworks/testunitish'
      require 'jeweler/generator/testing_frameworks/bacon'
      require 'jeweler/generator/testing_frameworks/micronaut'
      require 'jeweler/generator/testing_frameworks/minitest'
      require 'jeweler/generator/testing_frameworks/rspec'
      require 'jeweler/generator/testing_frameworks/shoulda'
      require 'jeweler/generator/testing_frameworks/testspec'
      require 'jeweler/generator/testing_frameworks/testunit'
      require 'jeweler/generator/testing_frameworks/riot'
      require 'jeweler/generator/testing_frameworks/shindo'
  
      def self.klass(testing_framework)
        testing_framework_class_name = testing_framework.to_s.capitalize
        if TestingFrameworks.const_defined?(testing_framework_class_name)
          TestingFrameworks.const_get(testing_framework_class_name)
        else
          raise ArgumentError, "Using #{testing_framework} requires a #{testing_framework_class_name} to be defined"
        end
      end
    end
  end
end

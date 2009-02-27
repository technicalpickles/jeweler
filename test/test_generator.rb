require 'test_helper'

class TestGenerator < Test::Unit::TestCase
  def build_generator(testing_framework = nil, options = {})
    options[:testing_framework] = testing_framework
    Jeweler::Generator.new('the-perfect-gem', options)
  end

  context "initialize" do
    should "raise error if nil repo name given" do
      assert_raise Jeweler::NoGitHubRepoNameGiven do
        Jeweler::Generator.new(nil)
      end
    end

    should "raise error if blank repo name given" do
      assert_raise Jeweler::NoGitHubRepoNameGiven do
        Jeweler::Generator.new("")
      end
    end

    should "have shoulda as default framework" do
      assert_equal :shoulda, build_generator.testing_framework
    end

    should "have repository name as default target dir" do
      assert_equal 'the-perfect-gem', build_generator.target_dir
    end

    should "have TODO as default summary" do
      assert_equal "TODO", build_generator.summary
    end

    should "not create repo by default" do
      assert ! build_generator.should_create_repo
    end

    should "not use cucumber by default" do
      assert ! build_generator.should_use_cucumber
    end

    should "raise error for invalid testing frameworks" do
      assert_raise ArgumentError do
        build_generator(:zomg_invalid)
      end
    end
  end

  context "test_or_spec" do
    should "be test for shoulda" do
      assert_equal 'test', build_generator(:shoulda).test_or_spec
    end

    should "be test for testunit" do
      assert_equal 'test', build_generator(:testunit).test_or_spec
    end

    should "be test for minitest" do
      assert_equal 'test', build_generator(:minitest).test_or_spec
    end

    should "be spec for bacon" do
      assert_equal 'spec', build_generator(:bacon).test_or_spec
    end

    should "be spec for rspec" do
      assert_equal 'spec', build_generator(:rspec).test_or_spec
    end

    should "be example for micronaut" do
      assert_equal 'example', build_generator(:micronaut).test_or_spec
    end
  end

  context "test_dir" do
    should "be test for shoulda" do
      assert_equal 'test', build_generator(:shoulda).test_dir
    end

    should "be test for testunit" do
      assert_equal 'test', build_generator(:testunit).test_dir
    end

    should "be test for minitest" do
      assert_equal 'test', build_generator(:minitest).test_dir
    end

    should "be spec for bacon" do
      assert_equal 'spec', build_generator(:bacon).test_dir
    end

    should "be spec for rspec" do
      assert_equal 'spec', build_generator(:rspec).test_dir
    end

    should "be examples for micronaut" do
      assert_equal 'examples', build_generator(:micronaut).test_dir
    end
  end

  context "default_task" do
    should "be test for shoulda" do
      assert_equal 'test', build_generator(:shoulda).default_task
    end

    should "be test for testunit" do
      assert_equal 'test', build_generator(:testunit).default_task
    end

    should "be test for minitest" do
      assert_equal 'test', build_generator(:minitest).default_task
    end

    should "be spec for bacon" do
      assert_equal 'spec', build_generator(:bacon).default_task
    end

    should "be spec for rspec" do
      assert_equal 'spec', build_generator(:rspec).default_task
    end

    should "be examples for micronaut" do
      assert_equal 'examples', build_generator(:micronaut).default_task
    end
  end

  context "feature_support_require" do
    should "be test/unit/assertions for shoulda" do
      assert_equal 'test/unit/assertions', build_generator(:shoulda).feature_support_require
    end

    should "be test/unit/assertions for testunit" do
      assert_equal 'test/unit/assertions', build_generator(:testunit).feature_support_require
    end

    should "be mini/test for minitest" do
      assert_equal 'mini/test', build_generator(:minitest).feature_support_require
    end

    should "be test/unit/assertions for bacon" do
      assert_equal 'test/unit/assertions', build_generator(:bacon).feature_support_require
    end

    should "be spec/expectations for rspec" do
      assert_equal 'spec/expectations', build_generator(:rspec).feature_support_require
    end

    should "be micronaut/expectations for micronaut" do
      assert_equal 'micronaut/expectations', build_generator(:micronaut).feature_support_require
    end
  end

  context "feature_support_extend" do
    should "be Test::Unit::Assertions for shoulda" do
      assert_equal 'Test::Unit::Assertions', build_generator(:shoulda).feature_support_extend
    end

    should "be Test::Unit::Assertions for testunit" do
      assert_equal 'Test::Unit::Assertions', build_generator(:testunit).feature_support_extend
    end

    should "be Mini::Test::Assertions for minitest" do
      assert_equal 'Mini::Test::Assertions', build_generator(:minitest).feature_support_extend
    end

    should "be Test::Unit::Assertions for bacon" do
      assert_equal 'Test::Unit::Assertions', build_generator(:bacon).feature_support_extend
    end

    should "be nil for rspec" do
      assert_equal nil, build_generator(:rspec).feature_support_extend
    end

    should "be Micronaut::Matchers for micronaut" do
      assert_equal 'Micronaut::Matchers', build_generator(:micronaut).feature_support_extend
    end
  end

end

require File.dirname(__FILE__) + '/test_helper'

class VersionTest < Test::Unit::TestCase

  VERSION_TMP_DIR = File.dirname(__FILE__) + '/version_tmp'

  context "VERSION.yml with 3.5.4" do
    setup do
      FileUtils.rm_rf VERSION_TMP_DIR
      FileUtils.mkdir_p VERSION_TMP_DIR

      build_version_yml VERSION_TMP_DIR, 3, 5, 4

      @version = Jeweler::Version.new VERSION_TMP_DIR
    end

    should "have major version 3" do
      assert_equal 3, @version.major
    end

    should "have minor version 5" do
      assert_equal 5, @version.minor
    end

    should "have patch version 4" do
      assert_equal 4, @version.patch
    end

    should "render 3.5.4 as string" do
      assert_equal '3.5.4', @version.to_s
    end

    context "bumping major version" do
      setup do
        @version.bump_major
      end

      should "have major version 4" do
        assert_equal 4, @version.major
      end

      should "have minor version 0" do
        assert_equal 0, @version.minor
      end

      should "have patch version 0" do
        assert_equal 0, @version.patch
      end

      should "render 3.5.4 as string" do
        assert_equal '4.0.0', @version.to_s
      end

    end

  end

  context "Non-existant VERSION.yml" do
    setup do
      FileUtils.rm_rf VERSION_TMP_DIR
      FileUtils.mkdir_p VERSION_TMP_DIR
    end

    should "not raise error if the VERSION.yml doesn't exist" do
      assert_nothing_raised Jeweler::VersionYmlError do
        Jeweler::Version.new(VERSION_TMP_DIR)
      end
    end
  end

  def build_version_yml(base_dir, major, minor, patch)
    version_yaml_path = File.join(base_dir, 'VERSION.yml')

    File.open(version_yaml_path, 'w+') do |f|
      version_hash = {
        'major' => major.to_i,
        'minor' => minor.to_i,
        'patch' => patch.to_i
      }
      YAML.dump(version_hash, f)
    end
  end
end

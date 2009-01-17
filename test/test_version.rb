require File.dirname(__FILE__) + '/test_helper'

class VersionTest < Test::Unit::TestCase

  VERSION_TMP_DIR = File.dirname(__FILE__) + '/version_tmp'


  def self.should_have_version(major, minor, patch)
    should "have major version #{major}" do
      assert_equal major, @version.major
    end

    should "have minor version #{minor}" do
      assert_equal minor, @version.minor
    end

    should "have patch version #{patch}" do
      assert_equal patch, @version.patch
    end

    version_s = "#{major}.#{minor}.#{patch}"
    should "render string as #{version_s.inspect}" do
      assert_equal version_s, @version.to_s
    end

    version_hash = {:major => major, :minor => minor, :patch => patch}
    should "render hash as #{version_hash.inspect}" do
      assert_equal version_hash, @version.to_hash
    end
    
  end

  context "VERSION.yml with 3.5.4" do
    setup do
      FileUtils.rm_rf VERSION_TMP_DIR
      FileUtils.mkdir_p VERSION_TMP_DIR

      build_version_yml VERSION_TMP_DIR, 3, 5, 4

      @version = Jeweler::Version.new VERSION_TMP_DIR
    end

    should_have_version 3, 5, 4

    context "bumping major version" do
      setup { @version.bump_major }
      should_have_version 4, 0, 0
    end

    context "bumping the minor version" do
      setup { @version.bump_minor }
      should_have_version 3, 6, 0
    end

    context "bumping the patch version" do
      setup { @version.bump_patch }
      should_have_version 3, 5, 5
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

    context "setting an initial version" do
      setup do
        @version = Jeweler::Version.new(VERSION_TMP_DIR)
        @version.update_to 0, 0, 1
      end

      should_have_version 0, 0, 1
      should "not create VERSION.yml" do
        assert ! File.exists?(File.join(VERSION_TMP_DIR, 'VERSION.yml'))
      end

      context "outputting" do
        setup do
          @version.write
        end

        should "create VERSION.yml" do
          assert File.exists?(File.join(VERSION_TMP_DIR, 'VERSION.yml'))
        end

        context "re-reading VERSION.yml" do
          setup do
            @version = Jeweler::Version.new(VERSION_TMP_DIR)
          end

          should_have_version 0, 0, 1
        end
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

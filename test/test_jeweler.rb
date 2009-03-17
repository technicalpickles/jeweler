require 'test_helper'

class TestJeweler < Test::Unit::TestCase

  def build_jeweler(base_dir = '.')
    Jeweler.new(build_spec, base_dir)
  end

  def git_dir_path
    File.join(tmp_dir, 'git')
  end

  def non_git_dir_path
    File.join(tmp_dir, 'nongit')
  end

  def build_git_dir
    return_to = Dir.pwd

    FileUtils.mkdir_p git_dir_path
    begin
      Dir.chdir git_dir_path
      Git.init
    ensure
      Dir.chdir return_to
    end
  end

  def build_non_git_dir
    FileUtils.mkdir_p non_git_dir_path
  end

  should "raise an error if a nil gemspec is given" do
    assert_raises Jeweler::GemspecError do
      Jeweler.new(nil)
    end
  end

  should "know if it is in a git repo" do
    build_git_dir

    assert build_jeweler(git_dir_path).in_git_repo?
  end

  should "know if it is not in a git repo" do
    build_non_git_dir

    jeweler = build_jeweler(non_git_dir_path)
    assert ! jeweler.in_git_repo?, "jeweler doesn't know that #{jeweler.base_dir} is not a git repository"
  end

end

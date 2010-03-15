Given 'a working directory' do
  @working_dir = create_construct
end

After do
  @working_dir.destroy! if @working_dir
end

Given /^I use the jeweler command to generate the "([^"]+)" project in the working directory$/ do |name|
  @name = name

  return_to = Dir.pwd
  path_to_jeweler = Pathname.new(__FILE__).dirname.join('..', '..', 'bin', 'jeweler').expand_path

  begin
    FileUtils.cd @working_dir
    @stdout = `#{path_to_jeweler} #{@name}`
  ensure
    FileUtils.cd return_to
  end
end

Given /^"([^"]+)" does not exist$/ do |file|
  assert ! (@working_dir / file).exist?
end

When /^I run "([^"]+)" in "([^"]+)"$/ do |command, directory|
  full_path = (@working_dir / directory)

  lib_path = File.expand_path 'lib'
  command.gsub!(/^rake /, "rake --trace -I#{lib_path} ")

  assert full_path.directory?, "#{full_path} is not a directory"

  @stdout = `cd #{full_path} && #{command}`
  @exited_cleanly = $?.exited?
end

Then /^the updated version, (.*), is displayed$/ do |version|
  assert_match "Updated version: #{version}", @stdout
end

Then /^the current version, (\d+\.\d+\.\d+), is displayed$/ do |version|
  assert_match "Current version: #{version}", @stdout
end

Then /^the process should exit cleanly$/ do
  assert @exited_cleanly, "Process did not exit cleanly: #{@stdout}"
end

Then /^the process should not exit cleanly$/ do
  assert !@exited_cleanly, "Process did exit cleanly: #{@stdout}"
end

Given /^I use the existing project "([^"]+)" as a template$/ do |fixture_project|
  @name = fixture_project
  FileUtils.cp_r File.join(fixture_dir, fixture_project), @working_dir
end

Given /^"VERSION\.yml" contains hash "([^"]+)"$/ do |ruby_string|
  version_hash = YAML.load((@working_dir / @name / 'VERSION.yml').read)
  evaled_hash = eval(ruby_string)
  assert_equal evaled_hash, version_hash
end

Given /^"VERSION" contains "([^\"]*)"$/ do |expected|
  version = (@working_dir / @name / 'VERSION').read.chomp
  assert_equal expected, version
end


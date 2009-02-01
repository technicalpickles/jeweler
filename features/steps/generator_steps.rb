Given 'a working directory' do
  @working_dir = File.join(File.dirname(__FILE__), '..', '..', 'tmp')
  FileUtils.rm_rf @working_dir
  FileUtils.mkdir_p @working_dir
end

Given /^intentions to make a gem being tested by (\w+)$/ do |testing_framework|
  @testing_framework = testing_framework
end

Given /^I decide to call the project '((?:\w|-|_)+)'$/ do |name|
  @name = name
end

Given /^working git configuration$/ do
  Jeweler::Generator.any_instance.stubs(:read_git_config).
        returns({'user.name' => 'foo', 'user.email' => 'bar@example.com', 'github.user' => 'technicalpickles', 'github.token' => 'zomgtoken'})
end

When /^I generate a project$/ do
  @generator = Jeweler::Generator.new(@name, :directory => "#{@working_dir}/#{@name}")

  @stdout = OutputCatcher.catch_out do
    @generator.run
  end
end

Then /^a directory named '(.*)' is created$/ do |directory|
  directory = File.join(@working_dir, directory)

  assert File.exists?(directory), "#{directory} did not exist"
  assert File.directory?(directory), "#{directory} is not a directory"
end

Then /^a file named '(.*)' is created$/ do |file|
  file = File.join(@working_dir, file)

  assert File.exists?(file), "#{file} did not exist"
  assert File.file?(file), "#{file} is not a file"
end

Then /^'(.*)' is ignored by git/ do |git_ignore|
  @content ||= File.read((File.join(@working_dir, @name, '.gitignore')))

  assert_match git_ignore, @content
end

After do
  FileUtils.rm_rf @working_dir if @working_dir
end


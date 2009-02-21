Given 'a working directory' do
  @working_dir = File.join(File.dirname(__FILE__), '..', '..', 'tmp')
  FileUtils.rm_rf @working_dir
  FileUtils.mkdir_p @working_dir
end

Given /^I do not want cucumber stories$/ do
  @use_cucumber = false
end

Given /^I want cucumber stories$/ do
  @use_cucumber = true
end

Given /^I intend to test with (\w+)$/ do |testing_framework|
  @testing_framework = testing_framework.to_sym
end

Given /^I have configured git sanely$/ do
  @user_email = 'bar@example.com'
  @user_name = 'foo'
  @github_user = 'technicalpickles'
  @github_token = 'zomgtoken'

  Jeweler::Generator.any_instance.stubs(:read_git_config).
        returns({
          'user.name' => @user_name,
          'user.email' => @user_email,
          'github.user' => @github_user,
          'github.token' => @github_token})
end



When /^I generate a (.*)project named '((?:\w|-|_)+)' that is '(.*)'$/ do |testing_framework, name, summary|
  @name = name
  @summary = summary

  testing_framework = testing_framework.squeeze.strip
  unless testing_framework.blank?
    @testing_framework = testing_framework.to_sym
  end


  arguments = ['--directory', "#{@working_dir}/#{@name}", '--summary', @summary, @use_cucumber ? '--cucumber' : nil, "--#{@testing_framework}", @name].compact
  @stdout = OutputCatcher.catch_out do
    Jeweler::Generator::Application.run! *arguments
  end

  @repo = Git.open(File.join(@working_dir, @name))
end

Then /^a directory named '(.*)' is created$/ do |directory|
  directory = File.join(@working_dir, directory)

  assert File.exists?(directory), "#{directory} did not exist"
  assert File.directory?(directory), "#{directory} is not a directory"
end

Then "cucumber directories are created" do
  Then "a directory named 'the-perfect-gem/features' is created"
  Then "a directory named 'the-perfect-gem/features/support' is created"
  Then "a directory named 'the-perfect-gem/features/steps' is created"
end


Then /^a file named '(.*)' is created$/ do |file|
  file = File.join(@working_dir, file)

  assert File.exists?(file), "#{file} expected to exist, but did not"
  assert File.file?(file), "#{file} expected to be a file, but is not"
end

Then /^a file named '(.*)' is not created$/ do |file|
  file = File.join(@working_dir, file)

  assert ! File.exists?(file), "#{file} expected to not exist, but did"
end

Then /^a sane '.gitignore' is created$/ do
  Then "a file named 'the-perfect-gem/.gitignore' is created"
  Then "'coverage' is ignored by git"
  Then "'*.sw?' is ignored by git"
  Then "'.DS_Store' is ignored by git"
  Then "'rdoc' is ignored by git"
  Then "'pkg' is ignored by git"
end

Then /^'(.*)' is ignored by git$/ do |git_ignore|
  @gitignore_content ||= File.read(File.join(@working_dir, @name, '.gitignore'))

  assert_match git_ignore, @gitignore_content
end

Then /^Rakefile has '(.*)' for the (.*) (.*)$/ do |value, task_class, field|
  @rakefile_content ||= File.read(File.join(@working_dir, @name, 'Rakefile'))
  block_variable, task_block = yank_task_info(@rakefile_content, task_class)
  #raise "Found in #{task_class}: #{block_variable.inspect}: #{task_block.inspect}"

  assert_match /#{block_variable}\.#{field} = (%Q\{|"|')#{Regexp.escape(value)}(\}|"|')/, task_block
end

Then /^Rakefile has '(.*)' in the Rcov::RcovTask libs$/ do |libs|
  @rakefile_content ||= File.read(File.join(@working_dir, @name, 'Rakefile'))
  block_variable, task_block = yank_task_info(@rakefile_content, 'Rcov::RcovTask')

  assert_match "#{block_variable}.libs << '#{libs}'", @rakefile_content
end


Then /^'(.*)' contains '(.*)'$/ do |file, expected_string|
  contents = File.read(File.join(@working_dir, @name, file))
  assert_match expected_string, contents
end

Then /^'(.*)' mentions copyright belonging to me in (\d{4})$/ do |file, year|
  contents = File.read(File.join(@working_dir, @name, file))
  assert_match "Copyright (c) #{year} #{@user_name}", contents
end


Then /^LICENSE has the copyright as belonging to '(.*)' in '(\d{4})'$/ do |copyright_holder, year|
  Then "a file named 'the-perfect-gem/LICENSE' is created"

  @license_content ||= File.read(File.join(@working_dir, @name, 'LICENSE'))

  assert_match copyright_holder, @license_content

  assert_match year, @license_content
end

Then /^'(.*)' should define '(.*)' as a subclass of '(.*)'$/ do |file, class_name, superclass_name|
  @test_content = File.read((File.join(@working_dir, @name, file)))

  assert_match "class #{class_name} < #{superclass_name}", @test_content
end

Then /^'(.*)' should describe '(.*)'$/ do |file, describe_name|
  @spec_content ||= File.read((File.join(@working_dir, @name, file)))

  assert_match %Q{describe "#{describe_name}" do}, @spec_content
end

Then /^'(.*)' requires '(.*)'$/ do |file, lib|
  content = File.read(File.join(@working_dir, @name, file))

  assert_match /require ['"]#{Regexp.escape(lib)}['"]/, content
end

Then /^'(.*)' does not require '(.*)'$/ do |file, lib|
  content = File.read(File.join(@working_dir, @name, file))

  assert_no_match /require ['"]#{Regexp.escape(lib)}['"]/, content
end

Then /^Rakefile does not require 'cucumber\/rake\/task'$/ do
  Then "'Rakefile' does not require 'cucumber/rake/task'"
end

Then /^Rakefile requires 'cucumber\/rake\/task'$/ do
  Then "'Rakefile' requires 'cucumber/rake/task'"
end

Then /^Rakefile does not instantiate a Cucumber::Rake::Task$/ do
  content = File.read(File.join(@working_dir, @name, 'Rakefile'))
  assert_no_match /Cucumber::Rake::Task.new/, content
end

Then /^Rakefile instantiates a Cucumber::Rake::Task$/ do
  content = File.read(File.join(@working_dir, @name, 'Rakefile'))
  assert_match /Cucumber::Rake::Task.new/, content
end




Then /^'test\/test_helper\.rb' should autorun tests$/ do
  content = File.read(File.join(@working_dir, @name, 'test/test_helper.rb'))

  assert_match "Mini::Test.autorun", content
end

Then /^'features\/support\/env\.rb' sets up features to use test\/unit assertions$/ do
  content = File.read(File.join(@working_dir, @name, 'features', 'support', 'env.rb'))

  assert_match "world.extend(Test::Unit::Assertions)", content
end

Then /^'features\/support\/env\.rb' sets up features to use minitest assertions$/ do
  content = File.read(File.join(@working_dir, @name, 'features', 'support', 'env.rb'))

  assert_match "world.extend(Mini::Test::Assertions)", content
end

Then /^git repository has '(.*)' remote$/ do |remote|
  remote = @repo.remotes.first

  assert_equal 'origin', remote.name
end

Then /^git repository '(.*)' remote should be '(.*)'/ do |remote, remote_url|
  remote = @repo.remotes.first

  assert_equal 'git@github.com:technicalpickles/the-perfect-gem.git', remote.url
end

Then /^a commit with the message '(.*)' is made$/ do |message|
  assert_match message, @repo.log.first.message
end

Then /^'(.*)' was checked in$/ do |file|
  status = @repo.status[file]

  assert_not_nil status, "wasn't able to get status for #{file}"
  assert ! status.untracked, "#{file} was untracked"
  assert_nil status.type, "#{file} had a type. it should have been nil"
end

Then /^no files are (\w+)$/ do |type|
  assert_equal 0, @repo.status.send(type).size
end

After do
  FileUtils.rm_rf @working_dir if @working_dir
end

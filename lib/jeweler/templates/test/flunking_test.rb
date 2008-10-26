require File.dirname(__FILE__) + '/test_helper'

class <%= github_repo_name.split(/[-_]/).collect{|each| each.capitalize }.join %>Test < Test::Unit::TestCase
  should "probably rename this file and start testing for real" do
    flunk "probably rename this file and start testing for real"
  end
end
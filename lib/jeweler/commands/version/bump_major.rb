class Jeweler
  module Commands
    module Version
      class BumpMajor < Base
        def update_version
          version_helper.bump_major
        end
      end
    end
  end
end

class Jeweler
  module Release

    def release
      @repo.checkout('master')

      raise "Hey buddy, try committing them files first" if any_pending_changes?

      write_gemspec()

      @repo.add(gemspec_path)
      @repo.commit("Regenerated gemspec for version #{version}")
      @repo.push

      @repo.add_tag(release_tag)
      @repo.push('origin', release_tag)
    end

    def release_tag
      @release_tag ||= "v#{version}"
    end
  end
end

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

  protected
    def any_pending_changes?
      @repo.status.added.empty? && @repo.status.deleted.empty? && @repo.status.changed.empty? && @repo.status.untracked.empty?
    end
  end
end

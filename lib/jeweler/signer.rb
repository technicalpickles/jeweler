class Jeweler
  class Signer
    attr_accessor :key_file, :cert_file

    def initialize
      self.key_file = File.expand_path("~/.gem/gem-private_key.pem")
      self.cert_file = File.expand_path("~/.gem/gem-public_cert.pem")
    end

    def can_sign?
      File.exist?(key_file) && File.exist?(cert_file)
    end

    def sign(gemspec)
      gemspec.signing_key = key_file
      gemspec.cert_chain  = [cert_file]
    end

    def build_for(email)
      sh("gem cert --build #{email}")

      mv "gem-private_key.pem", key_file, :verbose => true
      mv "gem-public_cert.pem", cert_file, :verbose => true

    end
  end

end

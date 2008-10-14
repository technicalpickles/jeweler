require 'stringio'

class OutputCatcher
  class << self
    
    def catch_io(post, &block)
      original = eval("$std" + post)
      fake     = StringIO.new
      eval("$std#{post} = fake")
      begin
        yield
      ensure
        eval("$std#{post} = original")
      end
      fake.string
    end
    
    def catch_out(&block)
      catch_io("out", &block)
    end
    
    def catch_err(&block)
      catch_io("err", &block)
    end
    
  end
end
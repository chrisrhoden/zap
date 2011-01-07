module Zap
  module Clipboard
    def self.copy(string)
      
      cmd = if RUBY_PLATFORM =~ /linux/
        "xclip -selection clipboard"
      else
        "pbcopy"
      end
      
      `echo #{string} | tr -d "\n" | #{cmd}`        
    end
    
    def self.paste
      if RUBY_PLATFORM =~ /darwin/
        `pbpaste`
      else
        `xclip -selection clipboard -o`
      end
    end
  end
end
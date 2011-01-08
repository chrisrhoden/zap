require 'yajl'

module Zap
  
  require 'zap/clipboard'
  require 'zap/store'
  
  def self.store(path = ENV['HOME']+'/.zapstore')
    @store ||= ::Zap::Store.new(path)
  end
  
  class Command
    class << self
      def store
        Zap.store
      end
      
      def run(*args)
        
        @called = $0.split('/').pop
        
        cmd = args[0]
        main = args[1]
        minor = args[2]
        
        return help unless cmd
        delegate(cmd, main, minor)        
      end
      
      def delegate(cmd, main, minor)
        if cmd == "add"
          store[main.to_sym] = minor if main && minor
        elsif cmd == "del"
          store[main] = nil if main
        elsif cmd == "get"
          Clipboard.copy(store[main])
        elsif cmd == "list"
          store.each_pair do |key, value|
            puts "#{key}: #{value}"
          end
        end
          store.write
      end
      
      def executable
        @executable ||= $0.split('/').pop
      end
      
      def help
        txt = %{
                    ::::::::: :::.  ::::::::::.  .:
                    '`````;;; ;;`;;  `;;;```.;;;;;;
                        .n[[',[[ '[[, `]]nnn]]' '[[
                      ,$$P" c$$$cc$$$c $$$""     $$
                    ,888bo,_ 888   888,888o      ""
                     `""*UMM YMM   ""` YMMMb     MM
                    #{executable}'s snatchin yo clipboards up.
          
          `zap foo bar` sets the "foo" value to "bar"
              `zap foo` copies the contents of "foo" into your clipboard
            `zap foo p` copies the contents of your clipboard into "foo"
             `zap list` shows the values zap knows about.            
        }.gsub(/^ {10}/, '') # murderous villian of whitespace
        
        puts txt
      end      
    end
  end
end
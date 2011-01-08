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
        key = args.shift
        value = args.join(' ') unless args.length == 0
        
        return help unless key
        return send key, value if is_arged_keyword?(key)
        return send key if is_keyword?(key)
        return save key, value if key && value
        return get key
      end
      
      private
      
      def list
        store.each_pair do |key, value|
          puts "Your zapvals are:", '-'*17
          puts "#{key}: #{value}"
        end
      end
      
      def help
        puts %{
                    ::::::::: :::.  ::::::::::.  .:
                    '`````;;; ;;`;;  `;;;```.;;;;;;
                        .n[[',[[ '[[, `]]nnn]]' '[[
                      ,$$P" c$$$cc$$$c $$$""     $$
                    ,888bo,_ 888   888,888o      ""
                     `""*UMM YMM   ""` YMMMb     MM
                    #{executable}'s snatchin yo clipboards up.
          
          `#{executable} foo bar` sets the "foo" value to "bar"
              `#{executable} foo` copies the contents of "foo" into your clipboard
           `#{executable} rm foo` unsets the value of "foo"
            `#{executable} foo p` copies the contents of your clipboard into "foo"
             `#{executable} list` shows the values zap knows about. 
             `#{executable} help` shows this help.           
        }.gsub(/^ {10}/, '') # murderous villian of whitespace
      end
      
      def get(key)
        if val = store[key]
          Clipboard.copy(val)
          puts "Copied \"#{val}\" to the clipboard!"
        else
          puts "No value stored with key \"#{key}\""
        end
      end
      
      def save(key, value)
        value = Clipboard.paste if value == 'p'
        store[key.intern] = value
        store.write
        puts "Saved \"#{value}\" as \"#{key}\""
      end
            
      def executable
        @executable ||= $0.split('/').pop
      end 
      
      def rm(key)
        store[key] = nil
        store.write
        puts "Deleted the value with the key \"#{key}\""
      end
      
      def is_keyword?(word)
        ['rm', 'list', 'help'].include? word
      end 
      
      def is_arged_keyword?(word)
        ['rm'].include? word
      end    
    end
  end
end
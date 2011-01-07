require 'yajl'

module Zap
  
  require 'zap/clipboard'
  
  def self.storage
    @storage ||= ::Zap::Storage.new
  end
  
  class Command
    class << self
      def storage
        Zap.storage
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
          storage.store.merge!({main.to_sym => minor}) if main && minor
        elsif cmd == "del"
          storage.store.delete(main) if main
        elsif cmd == "get"
          Clipboard.copy(storage.store[main])
        elsif cmd == "list"
          storage.store.each do |key, value|
            puts "#{key}: #{value}"
          end
        end
          storage.writeback
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
  
  class Storage
    
    JSON_FILE = "#{ENV['HOME']}/.zapstore"
    
    attr_accessor :store
    
    def initialize
      @store = {}
      explode_json(json_file)
    end

    def json_file
      JSON_FILE
    end

    def to_json(hash)
      Yajl::Encoder.encode(hash)
    end
    
    def explode_json(file)
      init_json unless File.exists?(file)
      
      json = File.new(file, 'r')
      @store = Yajl::Parser.parse(json)
    end
    
    def init_json
      File.open(json_file, 'w') { |f| f.write "{}"}
      writeback
    end

    def writeback
      File.open(json_file, 'w') { |f| f.write(to_json(@store)) }
    end
  end
end
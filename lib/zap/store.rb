module Zap
  class Store
    
    attr_accessor :store, :file
    
    def initialize(file)
      self.file = file
      
      init_file unless File.exists?(file)
      self.store = Yajl::Parser.parse(File.new(file, 'r'))
    end
  
    def to_json(hash)
      Yajl::Encoder.encode(hash)
    end
  
    def write
      File.open(file, 'w') { |f| f.write(to_json(store)) }
    end
    
    def []=(key, value)
      store[key] = value
      store.delete(key) if value.nil?
      value
    end
    
    def [](key)
      store[key]
    end
    
    def each_pair
      store.each do |(key, value)|
        yield key, value
      end
    end
    
    private
    
    def init_file
      File.open(file, 'w') { |f| f.write "{}" }
    end
  end
end
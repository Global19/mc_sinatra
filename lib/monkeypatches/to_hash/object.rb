require 'set'

class Object
  def to_hash(options = {})
    all = options[:all] ||= false
    only = Set.new(options[:only]).map! {|e| e.to_sym }
    methods = Set.new(options[:methods]).map! {|e| e.to_sym }
    except = Set.new(options[:except]).map! {|e| e.to_sym }

    hash = {}

    # Get all instance variables
    instance_variables.each {|var| hash[var.to_s.delete("@").to_sym] = instance_variable_get(var) }

    if all # Get everything
      methods = serializable_methods if respond_to? "serializable_methods"
    end

    # Add methods
    methods.each do |method|
      hash[method] = self.send(method.to_s)
    end

    # Get rid of everything except the 'only'
    hash.keep_if {|k,v| only.include?(k) } unless only.empty?

    # Make sure we're not returning things to be excepted
    hash.delete_if {|k,v| except.include?(k) } unless except.empty?

    # Symbolize keys
    hash.dup.each do |k,v|
      unless k.kind_of? Symbol
        hash[k.to_sym] = v
        hash.delete(k)
      end
    end

    hash
  end
end
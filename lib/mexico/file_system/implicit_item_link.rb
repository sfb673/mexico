# encoding: utf-8

class Mexico::FileSystem::ImplicitItemLink

  attr_accessor :role
  attr_accessor :target_object
  attr_accessor :item

  def initialize(args={})
    args.each do |k,v|
      if self.respond_to?("#{k}=")
        send("#{k}=", v)
      end
    end
  end

  alias_method :target_item, :target_object

end
# This file is part of the MExiCo gem.
# Copyright (c) 2012 Peter Menke, SFB 673, Universität Bielefeld
# http://www.sfb673.org
#
# MExiCo is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as
# published by the Free Software Foundation, either version 3 of
# the License, or (at your option) any later version.
#
# MExiCo is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with MExiCo. If not, see
# <http://www.gnu.org/licenses/>.

# The XML based collection class maps a collection of elements of the
# same type to a list of XML nodes.
#
# XML bound elements know the corpus object, the corpus file, and
# the nokogiri element they come from and can write changes back to
# that file.
#
# Structure of the hash: keys are XML ids, values are XML bound objects.

class Mexico::FileSystem::XmlBasedCollection

  include Mexico::FileSystem::XmlBound

  # @param entity_name String Name of the object entity
  # @option opts XMLNode :parent_element The XML parent element
  # @option opts Class :entity_class Class for members of the collection 
  # @option opts String :xpath An XPath expression to the place where objects should be stored.
  def initialize(entity_name, opts = {})
    @entity_name = entity_name
    @entity_class = opts[:entity_class]
    if opts.has_key?(:pluralized_entity_name)
      @pluralized_entity_name = "#{entity_name}s"  
    else
      @pluralized_entity_name = opts[:pluralized_entity_name]
    end
    @collection = Hash.new
    
    # now, upon initialisation, read all elements and create objects
    opts[:parent_element].find("#{opts[:xpath]}/#{@entity_name}").each do |el|
      inst = @entity_class.new()
      self.add(inst.attributes["id"], inst)
    end
    
  end
    
  def size 
    @collection.size
  end
  
  def empty?
    size==0
  end
  
  def contains?(key)
    if (key.is_a?(Symbol) or key.is_a?(String) or key.is_a?(Integer))
      return @collection.has_key?(key)
    else
      return @collection.has_value?(key)
    end
  end
  
  def [](key)
    @collection[key]
  end
  
  def []=(key, value)
    @collection[key]=value
  end
  
  def add(key, value)
    @collection[key] = value 
  end
   
end
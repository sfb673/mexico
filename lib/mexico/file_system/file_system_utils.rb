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


module Mexico::FileSystem::FileSystemUtils
  
  # Provides getter and setter methods that operate directly on a node
  # below the given XML element.
  # @option opts [String] :default The default value if no value is set.
  # @option opts [:int|:float|:bool] :default If set, performs a type conversion
  # @option opts [true|false] :getter If set and false, skips generation of a getter method.
  # @option opts [true|false] :setter If set and false, skips generation of a setter method.
  # @option opts [true|false] :autosave If set and true, changed values are automatically saved.
  
  def xml_bind(attribute_name, opts = {})
    
    # two fundamental techniques:
    # :attribute => a  read from and write to an attribute
    # :element => e    read from and write to the text value of an element
    
    # if none of these is specified, complain.
    unless (opts.has_key?(:attribute) or opts.has_key?(:element))
      return nil
    end
    
    mode = nil
    [:attribute,:element].each do |m|
      mode = m if opts.has_key?(m)
    end
    
    # define a getter
    unless opts.has_key?(:getter) && opts[:getter]===false
      
      define_method attribute_name do
        instance_eval("@#{attribute_name} ||= load_#{attribute_name}")
      end
       
      define_method "load_#{attribute_name}" do
        obj = nil 
        if mode==:attribute
          obj = @base_element.xpath("./@#{opts[:attribute]}")
        end
        if mode==:element
          obj = @base_element.xpath("./#{opts[:attribute]}.value")
        end
        if obj.nil? && opts.has_key?(:default)
          return opts[:default]
        end
        return obj
      end
    end
    
    unless opts.has_key?(:setter) && opts[:setter]===false 
      # all setter methods presuppose that the @base_element exists.
      define_method "#{attribute_name}=" do |new_value|
        if mode==:attribute
          #puts "base element: %s" % @base_element
          @base_element[opts[:attribute]]=new_value
          if opts.has_key?(:autosave) && opts[:autosave]==true
            save_xml
          end        
        end 
      end     
    end
  end
  
  # provides an accessor to an XMLBasedCollection object which 
  # reads lists of elements from XML.
  def xml_bind_collection(element_name, entity_class, opts = {})
    puts "parent element: %s" % opts[:parent_element]
    coll = Mexico::FileSystem::XmlBasedCollection.new({:entity_class => entity_class, :parent_element => opts[:parent_element], :xpath => ''})
    
  end
  
  
  ##################################
  private
  
  def read_from_attribute(attribute_name)
  
  end
  
  def write_to_attribute(attribute_name, value)
  
  end
  
end
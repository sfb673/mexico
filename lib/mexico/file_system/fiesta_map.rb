# This file is part of the MExiCo gem.
# Copyright (c) 2012, 2013 Peter Menke, SFB 673, Universität Bielefeld
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

# This class models a data container for map (or attribute value) structures.

class Mexico::FileSystem::FiestaMap

  include ::ROXML

  attr_reader :map_items

  # Creates a new map instance. If initial_vals is defined and contains values,
  # those will be used to populate the map.
  # @param initial_vals [Hash] Initial values for the new map object.
  def initialize(initial_vals={})
    @map = Hash.new
    @map.merge!(initial_vals)
  end

  # Adds or modifies an entry with the key +k+ in the map.
  # @param k [Object] The key to be used.
  # @param v [Object] The value to be used.
  # @return [void]
  def []=(k,v)
    @map[k]=v
  end

  # Retrieves the value for the given key +k+ from the map.
  # @param k [Object] The key to be used.
  # @return [Object,nil] The corresponding value object, or +nil+
  #                      if there was no entry for the given key.
  def [](k)
    @map[k]
  end

  # Returns the number of entries in this map.
  # @return [Integer] The number of entries.
  def size
    @map.size
  end

  # Returns +true+ iff this map is empty.
  # @return [Boolean] Returns +true+ iff this map is empty, +false+ otherwise.
  def empty?
    @map.empty?
  end

  # Returns +true+ iff this map contains an entry with the given key.
  # @param k [Object] The key to be found.
  # @return [Boolean] Returns +true+ iff the given key is used in this map, +false+ otherwise.
  def has_key?(k)
    @map.has_key?(k)
  end

  # Auxiliary method that reads a +FiestaMap+ object
  # from the standard XML representation of FiESTA.
  # @param node [XML::Node] The XML node to read from
  # @return     [FiestaMap] The map object represented in that XML node.
  def self.from_xml(node)
    #puts "SOMEONE CALLED FiestaMap.from_xml"
    #puts node.name
    # @map = Hash.new

    map = self.new

    node.xpath('./MapItem').each do |mi|
      #puts mi.name
      #puts mi['key']
      #puts mi.text
      map[mi['key']]=mi.text
    end
    #puts map.size
    map
  end

  # Creates a human-readable string representation of this map.
  # @return [String] A string describing this map object.
  def to_s
    @map.to_a.collect{|k,v| "#{k} => #{v}"}.join(", ")
  end

  # Converts this map object to its standard XML representation
  # @todo what does the variable +x+ do?
  # @return [XML::Node] the node containing the XML representation
  def to_xml(x)
    n = XML::new_node("Map")
    @map.each_pair do |k,v|
      i_node = XML::new_node("MapItem")
      i_node['key'] = k
      i_node.content = v
      n.add_child(i_node)
    end

    n
  end

end
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

# the data container

class Mexico::FileSystem::FiestaMap

  include ::ROXML

  attr_reader :map_items

  def initialize(initial_vals={})
    @map = Hash.new
    @map.merge!(initial_vals)
  end

  def []=(k,v)
    @map[k]=v
  end

  def [](k)
    @map[k]
  end

  def size
    @map.size
  end

  def empty?
    @map.empty?
  end

  def has_key?(k)
    @map.has_key?(k)
  end

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

  def to_s
    @map.to_a.collect{|k,v| "#{k} => #{v}"}.join(", ")
  end

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
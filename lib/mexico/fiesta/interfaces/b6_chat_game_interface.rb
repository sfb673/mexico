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

# Import and export interface for the chat game file format by
# project B6.

require 'singleton'

class Mexico::Fiesta::Interfaces::B6ChatGameInterface

  include Singleton
  include Mexico::FileSystem

  def import(io=$stdin)
    fiesta_document = FiestaDocument.new

    t = fiesta_document.add_standard_timeline('s')
    x = Scale.new(identifier: 'spatial_x', name: 'Spatial coordinate X', unit: 'pixel')
    y = Scale.new(identifier: 'spatial_y', name: 'Spatial coordinate Y', unit: 'pixel')
    fiesta_document.scales << x
    fiesta_document.scales << y

    lChats = Layer.new(identifier: 'chats', name: 'Chats')
    lMoves = Layer.new(identifier: 'moves', name: 'Moves')

    fiesta_document.layers << lChats
    fiesta_document.layers << lMoves

    # B6 data is avaiable in XML documents, so we read
    # those into a Nokogiri object.
    xml_document = ::Nokogiri::XML(io)

    # puts xml_document.root

    xml_document.xpath('/match/round').each do |round|

      actions = round.xpath('./*')
      el_counter=0
      actions.each do |action|
        el_counter += 1
        tag_name = action.name
        if tag_name == 'move'
          # import this move thingy
          i = Item.new(identifier: "move-#{el_counter}")
          time_val = action['time'].gsub(/^\+/, '').to_i
          i.point_links << PointLink.new(identifier: "move-#{el_counter}-t", point: time_val , target_object: t)
          # get x and y values
          to = action['to'].split(",").map(&:to_i)
          i.point_links << PointLink.new(identifier: "move-#{el_counter}-x", point: to[0], target_object: x)
          i.point_links << PointLink.new(identifier: "move-#{el_counter}-y", point: to[1], target_object: y)

          # link layer
          i.layer_links << LayerLink.new(identifier: "move-#{el_counter}-layer", target_object: lMoves)

          fiesta_document.items << i
        end
      end
    end

    return fiesta_document
  end

  def export(io=$stdout)

  end

end
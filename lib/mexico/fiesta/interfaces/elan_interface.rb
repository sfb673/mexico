# This file is part of the MExiCo gem.
# Copyright (c) 2012-2014 Peter Menke, SFB 673, Universität Bielefeld
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

class Mexico::Fiesta::Interfaces::ElanInterface

  include Singleton
  include Mexico::FileSystem

  def self.import(io=$stdin, params = {})
    puts 'class method import'
    instance.import(io, params)
  end

  def self.export(doc, io=$stdout, params = {})
    instance.export(doc, io, params)
  end

  def import(io=$stdin, params = {})
    puts 'instance method import'

    io.rewind

    encoding = params.has_key?(:encoding) ? params[:encoding] : 'UTF-8'
    xmldoc = ::Nokogiri::XML(io)

    document = Mexico::FileSystem::FiestaDocument.new

    # 1. create a standard timeline
    timeline = document.add_standard_timeline('s')

    # 2. find time slots, store
    timeslots = Hash.new
    xmldoc.xpath("//TIME_ORDER/TIME_SLOT").each do |t|
      slot = t["TIME_SLOT_ID"]
      val  = t["TIME_VALUE"].to_i
      timeslots[slot] = val
    end

    # create temporary hash for storage of layers
    layerHash = Hash.new

    xmldoc.xpath("//TIER").each do |t|

      # @todo (DEFAULT_LOCALE="en") (LINGUISTIC_TYPE_REF="default-lt")
      tierID = t["TIER_ID"]
      puts 'Read layers, %s' % tierID

      layer = document.add_layer(identifier: tierID, name: tierID)
      #layer.name = tierID
      #layer.id = ToE::Util::to_xml_id(tierID)

      # document.layers << layer

      puts t.attributes
      puts t.attributes.has_key?('PARENT_REF')
      if t.attributes.has_key?('PARENT_REF')
        # puts "TATT: %s" % t['PARENT_REF']
        document.layers.each do |l|
          puts "LAYER %s %s" % [l.identifier, l.name]
        end
        parent_layer = document.get_layer_by_id(t['PARENT_REF'])
        puts parent_layer
        if parent_layer
          layer_connector = Mexico::FileSystem::LayerConnector.new parent_layer, layer, {
              identifier: "#{parent_layer.identifier}_TO_#{layer.identifier}",
              role: 'PARENT_CHILD',
              document: document
            }
          document.add_layer_connector(layer_connector)
        end
      end

      layerHash[tierID] = layer
      t.xpath("./ANNOTATION").each do |annoContainer|
        annoContainer.xpath("child::*").each do |anno|
          annoVal = anno.xpath("./ANNOTATION_VALUE/text()").first.to_s
          i = document.add_item identifier: anno["ANNOTATION_ID"]

          if anno.name == "ALIGNABLE_ANNOTATION"

            # puts anno.xpath("./ANNOTATION_VALUE/text()").first
            if annoVal!=nil && annoVal.strip != ""
              i.add_interval_link Mexico::FileSystem::IntervalLink.new(identifier: "#{i.identifier}-int",
                                                    min: timeslots[anno["TIME_SLOT_REF1"]].to_f,
                                                    max: timeslots[anno["TIME_SLOT_REF2"]].to_f,
                                                    target_object: timeline)
            end
          end
          if anno.name == "REF_ANNOTATION"

            #puts pp anno
            #puts document.items.collect{|x| x.identifier}.join(', ')
            #puts '-'*80

            i.add_item_link Mexico::FileSystem::ItemLink.new(identifier: "#{i.identifier}-itm",
                                        target_object: document.items({identifier: anno["ANNOTATION_REF"]}).first,
                                        role: Mexico::FileSystem::ItemLink::ROLE_PARENT)
          end
          i.add_layer_link Mexico::FileSystem::LayerLink.new(identifier: "#{i.identifier}-lay",
                                                             target_object: layer)
          i.data = Mexico::FileSystem::Data.new(string_value: annoVal)

        end
      end

      #if t["PARENT_REF"]
      #  parent = layerHash[t["PARENT_REF"]]
      #  if parent
      #    document.layer_connectors << Mexico::FileSystem::LayerConnector.new(parent, layer)
      #    # structure.connect(parent, layer)
      #  end
      #end

    end
    puts 'instance method over'
    document
  end

  def export(doc, io=$stdout, params = {})

  end


end
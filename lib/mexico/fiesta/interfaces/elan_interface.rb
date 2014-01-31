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

  def import(io=$stdin, params = {})
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

      layer = Mexico::FileSystem::Layer.new(identifier: tierID,
                                            name: tierID,
                                            document: document)
      #layer.name = tierID
      #layer.id = ToE::Util::to_xml_id(tierID)

      layerHash[tierID] = layer
      t.xpath("./ANNOTATION").each do |annoContainer|
        annoContainer.xpath("child::*").each do |anno|
          annoVal = anno.xpath("./ANNOTATION_VALUE/text()").first.to_s
          i = Mexico::FileSystem::Item.new identifier: anno["ANNOTATION_ID"],
                                           document: document
          if anno.name == "ALIGNABLE_ANNOTATION"

            # puts anno.xpath("./ANNOTATION_VALUE/text()").first
            if annoVal!=nil && annoVal.strip != ""
              i.interval_links << Mexico::FileSystem::IntervalLink.new(identifier: "#{i.identifier}-int",
                                                    min: timeslots[anno["TIME_SLOT_REF1"]].to_f,
                                                    max: timeslots[anno["TIME_SLOT_REF2"]].to_f,
                                                    target: timeline.identifier)
            end
          end
          if anno.name == "REF_ANNOTATION"
            i.item_links << Mexico::FileSystem::ItemLink.new(identifier: "#{i.identifier}-itm",
                                        target: anno["ANNOTATION_REF"]) #document.items.first{|x| x.identifier == anno["ANNOTATION_REF"]})
          end
          i.layer_links << Mexico::FileSystem::LayerLink.new(identifier: "#{i.identifier}-lay",
                                                             target: layer.identifier)
          i.data = Mexico::FileSystem::Data.new(string_value: annoVal)
          document.items << i
        end
      end
      document.layers << layer

      if t["PARENT_REF"]
        parent = layerHash[t["PARENT_REF"]]
        if parent
          document.layer_connectors << Mexico::FileSystem::LayerConnector.new(parent, layer)
          # structure.connect(parent, layer)
        end
      end

    end

    document
  end

  def export(doc, io=$stdout, params = {})

  end


end
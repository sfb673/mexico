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

    # read cv entries

    # cvs = Hash.new

    xmldoc.xpath("//CONTROLLED_VOCABULARY").each do |c|


      container_map = Mexico::FileSystem::PropertyMap.new(key: c['CV_ID'])

      metamap = Mexico::FileSystem::PropertyMap.new(key: 'info')
      metamap.properties << Mexico::FileSystem::Property.new('identifier', c['CV_ID'])

      valuemap = Mexico::FileSystem::PropertyMap.new(key: 'data')

      c.xpath("./CV_ENTRY").each do |entry|

        desc = entry['DESCRIPTION']
        val = entry.text

        valprop = Mexico::FileSystem::PropertyMap.new

        valprop.properties <<  Mexico::FileSystem::Property.new('description', desc)
        valprop.properties <<  Mexico::FileSystem::Property.new('value', val)

        valuemap.property_maps << valprop

      end

      container_map.property_maps << metamap
      container_map.property_maps << valuemap

      document.head.section(Mexico::FileSystem::Section::VOCABULARIES).property_maps << container_map
    end

    # Read ling type entries

    lingTypes = Hash.new

    xmldoc.xpath("//LINGUISTIC_TYPE").each do |lingtype|

      cnstrs, cntvoc = nil
      cnstrs = lingtype['CONSTRAINTS'] unless lingtype['CONSTRAINTS'].nil?
      graphr = lingtype['GRAPHIC_REFERENCES']=="true" ? true : false
      lngtid = lingtype['LINGUISTIC_TYPE_ID']
      timeal = lingtype['TIME_ALIGNABLE']=="true" ? true : false
      cntvoc = lingtype['CONTROLLED_VOCABULARY_REF'] unless lingtype['CONTROLLED_VOCABULARY_REF'].nil?

      lingTypeEntry = { constraints: cnstrs, graphicReferences: graphr, timeAlignable: timeal, controlledVocabulary: cntvoc }

      lingTypes[lngtid] = lingTypeEntry

    end

    lingTypes.each do |key,val|
      sec = document.head[Mexico::FileSystem::Section::LAYER_TYPES]
      pmap = Mexico::FileSystem::PropertyMap.new(key: key)
      val.each do |skey,sval|
        unless sval.nil?
          pmap.properties << Mexico::FileSystem::Property::new(skey,sval)
        end
      end
      sec.property_maps << pmap
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

      layer.add_property Mexico::FileSystem::Property.new('elanTierType', t['LINGUISTIC_TYPE_REF'])
      # document.layers << layer

      puts t.attributes
      puts t.attributes.has_key?('PARENT_REF')
      if t.attributes.has_key?('PARENT_REF')
        # puts "TATT: %s" % t['PARENT_REF']
        # document.layers.each do |l|
        #   puts "LAYER %s %s" % [l.identifier, l.name]
        # end
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
            if annoVal!=nil # && annoVal.strip != ""
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

    # Create an XML builder object that serialises into an XML structure
    builder = Nokogiri::XML::Builder.new do |xml|

      xml.ANNOTATION_DOCUMENT do

        xml.HEADER do

          # @TODO implement the export of the header

        end

        # create the time stamp data structure
        time_hash = Hash.new
        counter = 1

          # @todo #254 rework to use unit conversions!
          doc.items.each do |item|
            item.point_links.each do |pl|
              unless time_hash.has_key?(pl.point)
                time_hash[pl.point] = "ts#{counter}"
                counter += 1
              end
            end
            item.interval_links.each do |il|
              unless time_hash.has_key?(il.min)
                time_hash[il.min] = "ts#{counter}"
                counter += 1
              end
              unless time_hash.has_key?(il.max)
                 time_hash[il.max] = "ts#{counter}"
                 counter += 1
              end
            end
          end

        xml.TIME_ORDER do
          # collect all timestamps
          # create a hash for them
          time_hash.each do |tkey, tval|
            xml.TIME_SLOT({'TIME_SLOT_ID' => tval, 'TIME_VALUE'=>tkey.to_i.to_s})
          end
        end
        inverted_time_hash = time_hash.invert


        # read ling types from map
        ling_types = Hash.new

        lt_section = doc.head.section(Mexico::FileSystem::Section::LAYER_TYPES)
        lt_section.property_maps.each do |pm|
          key = pm.key
          puts key

          pm.properties.each do |p|
            puts "  ..  %s -> %s" % [p.key, p.value]

          end
          # puts pm.size
          ling_type = Hash.new

          if pm.has_key?('constraints')
            ling_type['constraints'] = pm['constraints'].value
          end
          if pm.has_key?('graphicReferences')
            ling_type['graphicReferences'] = pm['graphicReferences'].value
          end
          if pm.has_key?('timeAlignable')
            ling_type['timeAlignable'] = pm['timeAlignable'].value
          end
          if pm.has_key?('controlledVocabulary')
            ling_type['controlledVocabulary'] = pm['controlledVocabulary'].value
          end
          ling_types[key] = ling_type
        end
        puts ling_types



        # export layer by layer
        # caveat: only annotations with at least one layer link will be exported.
        # caveat 2: annotations with multiple layer links will be exported multiple times.



        doc.layers.each do |layer|
          ling_type = layer.properties['elanTierType'].value
          attrs = {TIER_ID: layer.identifier, LINGUISTIC_TYPE_REF: ling_type}

          # check if this layer is the child of another one.
          # if yes: add attribute PARENT_REF

          tier = xml.TIER(attrs) do

            puts "inside tier"

            layer.items.each do |item|

              xml.ANNOTATION do

                # depending on the layer type, use either ALIGNABLE or REF annotations
                if %w(Symbolic_Subdivision Symbolic_Association).include?(ling_type)


                  xml.REF_ANNOTATION({ANNOTATION_ID: item.identifier})
                else
                  tsref1, tsref2 = nil
                  unless item.interval_links.empty?
                    tsref1 = time_hash[item.interval_links.first.min]
                    tsref2 = time_hash[item.interval_links.first.max]
                  end

                  xml.ALIGNABLE_ANNOTATION({'ANNOTATION_ID'=>item.identifier,TIME_SLOT_REF1: tsref1,TIME_SLOT_REF2: tsref2}) do
                    xml.ANNOTATION_VALUE item.data.string_value
                  end
                end

              end
            end

          end
          puts "%s :: %s" % [tier["TIER_ID"], layer.identifier]
        end

      end

    end

    io << builder.to_xml
  end


end
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

class Mexico::Fiesta::Interfaces::B6ChatGameInterface

  include Singleton
  include Mexico::FileSystem


  # Imports a B6 chat game document by reading contents from the given IO object.
  # @param io [IO] The IO object to read from.
  # @return [FiestaDocument] on success, the corresponding FiESTA document.
  def import(io=$stdin)

    io.rewind

    fiesta_document = FiestaDocument.new
    f = fiesta_document

    t = fiesta_document.add_standard_timeline('s')
    x = Scale.new(identifier: 'spatial_x', name: 'Spatial coordinate X', unit: 'pixel', document: f)
    y = Scale.new(identifier: 'spatial_y', name: 'Spatial coordinate Y', unit: 'pixel', document: f)
    fiesta_document.scales << x
    fiesta_document.scales << y

    lChats = Layer.new(identifier: 'chats',     name: 'Chats',     document: f)
    lMoves = Layer.new(identifier: 'moves',     name: 'Moves',     document: f)
    lSents = Layer.new(identifier: 'sentences', name: 'Sentences', document: f)
    lParsT = Layer.new(identifier: 'parsedTrees', name: 'Parsed Trees', document: f)
    lParsP = Layer.new(identifier: 'parsedPhrases', name: 'Parsed Phrases', document: f)

    # additional, secondary annotations for:
    # - word / correction pairs
    # - forms    // LATER
    # - colors   // LATER
    # - sentences, with attributes
    # - their parsetrees, with attributes

    fiesta_document.layers << lChats
    fiesta_document.layers << lMoves
    fiesta_document.layers << lSents
    fiesta_document.layers << lParsT
    fiesta_document.layers << lParsP

    # B6 data is avaiable in XML documents, so we read
    # those into a Nokogiri object.
    xml_document = ::Nokogiri::XML(io)

    # puts xml_document.root

    round_counter = 0

    last_chat_elem = nil
    last_chat_item = nil
    xml_document.xpath('/match/round').each do |round|

      round_counter += 1
      actions = round.xpath('./*')
      el_counter=0
      actions.each do |action|
        el_counter += 1
        tag_name = action.name
        if tag_name == 'move'
          # import moves.
          i = Item.new(identifier: "round-#{round_counter}-move-#{el_counter}", document: f)
          time_val = action['time'].gsub(/^\+/, '').to_i
          i.point_links << PointLink.new(identifier: "move-#{el_counter}-t", point: time_val , target_object: t, document: f)
          # get x and y values
          to = action['to'].split(",").map(&:to_i)
          i.point_links << PointLink.new(identifier: "move-#{el_counter}-x", point: to[0], target_object: x, document: f)
          i.point_links << PointLink.new(identifier: "move-#{el_counter}-y", point: to[1], target_object: y, document: f)
          i.data = Data.new(item: i, document: f)
          # link layer
          i.layer_links << LayerLink.new(identifier: "move-#{el_counter}-layer", target_object: lMoves, document: f)
          fiesta_document.items << i
        end

        if tag_name == 'chat'
          i = Item.new(identifier: "round-#{round_counter}-chat-#{el_counter}", document: f)
          time_val = action['time'].gsub(/^\+/, '').to_i
          i.point_links << PointLink.new(identifier: "chat-#{el_counter}-t", point: time_val , target_object: t, document: f)
          i.data = Data.new(:string_value => action['message'], item: i, document: f)
          i.layer_links << LayerLink.new(identifier: "chat-#{el_counter}-layer", target_object: lChats, document: f)
          fiesta_document.items << i
          # todo: remember this chat item, the next annotations refer to it

          last_chat_elem = action
          last_chat_item = i
        end

        if tag_name == 'annotation'
          # - ./spelling
          #     - word/correction pairs
          #     - ./forms
          #     - ./colors
          # - ./sentence
          #     - @value
          #     - @type
          #     - @lok
          #     - @no
          #     - ./parsetree
          #         - @tiefe
          #         - @verzweigung
          #         - @hoeflichkeit

          action.xpath('./sentence').each do |sentence|
            # sentence : xml node of the sentence

            # get running number
            s_no = sentence['no'].to_i
            s_id = sentence['id']

            sent_item = Item.new identifier: s_id, document: f
            sent_item.item_links << ItemLink.new(identifier: "#{s_id}-to-chat", target_object: last_chat_item, role: 'parent', document: f )
            sent_item.layer_links << LayerLink.new(identifier:"#{s_id}-to-layer", target_object: lSents, document: f  )

            sent_item.data = Data.new map: Mexico::FileSystem::FiestaMap.new({
                                          value: sentence['value'],
                                          type:  sentence['type'],
                                           lok:  sentence['lok'],
                                           no:   sentence['no']}),
                                      item: sent_item, document: f
            sidm = sent_item.data.map
            f.items << sent_item

            parsetree_elem = sentence.xpath('./parsetree').first
            pt_id = parsetree_elem['id']
            parsetree_item = Item.new identifier: pt_id , document: f

            parsetree_item.item_links << ItemLink.new(identifier: "#{pt_id}-to-sentence", target_object: sent_item, role: 'parent', document: f)
            parsetree_item.layer_links << LayerLink.new(identifier:"#{pt_id}-to-layer", target_object: lParsT, document: f  )

            parsetree_item.data = Data.new map: Mexico::FileSystem::FiestaMap.new({
                                                                         tiefe: parsetree_elem['tiefe'],
                                                                         verzweigung:  parsetree_elem['verzweigung'],
                                                                         hoeflichkeit:  parsetree_elem['hoeflichkeit']}),
                                           item: parsetree_item, document: f

            # parsetree_item.data = Mexico::FileSystem::Data.new string_value: "Parsetree"


            f.items << parsetree_item

            convert_phrases f, parsetree_item, lParsP, parsetree_elem

          end
        end
      end
    end

    return fiesta_document
  end

  # Attempts to export the given FiESTA document to the B6 chat game format.
  # Currently, this does not work since the B6 format is too specialised.
  def export(doc, io=$stdout)

  end

  # A recursive method that converts phrase structures with variable depth into a linked FiESTA annotation structure.
  # @param fdoc        [FiestaDocument] The FiESTA document to which all items shall be added.
  # @param parent_item [Item]           The parent item object to which children shall be added.
  # @param layer       [Layer]          The FiESTA layer that shall contain all annotations.
  # @param node        [Node]           The XML node that contains the phrase structures to be parsed.
  # @return nil
  def convert_phrases(fdoc, parent_item, layer, node)

    k = 1
    node.xpath('./*').each do |p|

      if p.element?

        i = Mexico::FileSystem::Item.new identifier: "#{parent_item.identifier}-#{k}", document: fdoc

        i.item_links << ItemLink.new(identifier: "#{i.identifier}-il", target_object: parent_item, role: 'parent', document: fdoc)
        i.layer_links <<  LayerLink.new(identifier:"#{i.identifier}-to-layer", target_object: layer, document: fdoc  )

        i.data = Data.new string_value: p.name, item: i, document: fdoc

        fdoc.items << i

        convert_phrases fdoc, i, layer, p



        if p.children.first.text?

          j = Mexico::FileSystem::Item.new identifier: "#{parent_item.identifier}-#{k}-val", document: fdoc

          j.item_links << ItemLink.new(identifier: "#{i.identifier}-il", target_object: i, role: 'parent', document: fdoc)
          j.layer_links <<  LayerLink.new(identifier:"#{i.identifier}-to-layer", target_object: layer, document: fdoc )

          j.data = Data.new string_value: p.text, item: j, document: fdoc

          fdoc.items << j
        end

      end

    k=k+1
    end

  end

end
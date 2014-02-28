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

# A layer (or tier) in an transcription or annotation document.
class ::Mexico::FileSystem::Layer

  include ROXML

  xml_reader :identifier,        :from => '@id'

  def identifier=(new_id)
    @identifier = Mexico::Util::to_xml_id(new_id)
  end

  xml_accessor :name,       :from => '@name'

  xml_accessor :properties, :as => ::Mexico::FileSystem::PropertyMap,  :from => "PropertyMap"

  attr_accessor :document

  # POSEIdON-based RDF augmentation
  include Poseidon
  self_uri %q(http://cats.sfb673.org/Layer)
  instance_uri_scheme %q(#{document.self_uri}##{identifier})
  rdf_property :identifier, %q(http://cats.sfb673.org/identifier)
  rdf_property :name, %q(http://cats.sfb673.org/name)


  # data type
  # content structure

  def initialize(args={})
    args.each do |k,v|
      if self.respond_to?("#{k}=")
        send("#{k}=", v)
      end
    end

    if properties.nil?
      properties = ::Mexico::FileSystem::PropertyMap.new(key: 'layerProperties')
    end

  end

  def items
    @document.items.select{|i| i.layers.include?(self) }
  end

  # overrides method in ROXML
  # callback after xml parsing process, to store this element in the
  # document cache.
  def after_parse
    ::Mexico::FileSystem::FiestaDocument.store(self.identifier, self)
  end

  # returns all layers that are linked to this layer such that this layer
  # is the target, and the result layer is the source.
  def predecessor_layers
    document.layer_connectors.select{|c| c.target==self}.collect{|c| [c.source, c.role]}
  end

  # returns all layers that are linked to this layer such that this layer
  # is the source, and the result layer is the target.
  def successor_layers
    document.layer_connectors.select{|c| c.source==self}.collect{|c| [c.target, c.role]}
  end

  def items_form_a_forest?

    # I need precise semantics what kinds of item links
    # are supposed to model an actual parent-child-relationship.
    self.items.each do |item|
      puts "sources size for items %s: %i" % [item.identifier, item.sources.size]
      return false if item.sources.size > 1
    end
    return true
  end

  def items_form_an_edgeless_graph?
    self.items.each do |item|
      return false if item.item_links.size > 1
    end
  end


end
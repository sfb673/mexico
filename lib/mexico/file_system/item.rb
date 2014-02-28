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

# The basic data unit object.
class Mexico::FileSystem::Item

  include ::ROXML
  xml_name 'I'

  xml_reader :identifier,        :from => '@id'

  def identifier=(new_id)
    @identifier = Mexico::Util::to_xml_id(new_id)
  end

  # @todo compound links (later)

  # collection of Mexico::FileSystem::ItemLink
  xml_accessor :explicit_item_links, :as => [Mexico::FileSystem::ItemLink],     :from => "ItemLink",     :in => "Links"

  # collection of Mexico::FileSystem::LayerLink
  xml_accessor :layer_links,    :as => [Mexico::FileSystem::LayerLink],    :from => "LayerLink",    :in => "Links"

  # collection of Mexico::FileSystem::PointLink
  xml_accessor :point_links,    :as => [Mexico::FileSystem::PointLink],    :from => "PointLink",    :in => "Links"

  # collection of Mexico::FileSystem::IntervalLink
  xml_accessor :interval_links, :as => [Mexico::FileSystem::IntervalLink], :from => "IntervalLink", :in => "Links"

  # collection of Mexico::FileSystem::Data
  xml_accessor :data, :as => Mexico::FileSystem::Data, :from => "Data"

  attr_accessor :document

  attr_accessor :implicit_item_links

  # POSEIdON-based RDF augmentation
  include Poseidon
  self_uri %q(http://cats.sfb673.org/Item)
  instance_uri_scheme %q(#{document.self_uri}##{identifier})
  rdf_property :identifier, %q(http://cats.sfb673.org/identifier)
  rdf_property :name, %q(http://cats.sfb673.org/name)

  rdf_include :layer_links, %q(http://cats.sfb673.org/hasLayerLink)
  rdf_include :item_links, %q(http://cats.sfb673.org/hasItemLink)
  rdf_include :point_links, %q(http://cats.sfb673.org/hasPointLink)
  rdf_include :interval_links, %q(http://cats.sfb673.org/hasIntervalLink)
  rdf_include :data, %q(http://cats.sfb673.org/hasData)

  def initialize(args={})
    args.each do |k,v|
      if self.respond_to?("#{k}=")
        send("#{k}=", v)
      end
    end
    @explicit_item_links = []
    @implicit_item_links = []
    @inverse_linked_items = []
    @layer_links = []
    @point_links = []
    @interval_links = []
  end

  # This method attempts to link objects from other locations of the XML/object tree
  # into position inside this object, by following the xml ids given in the
  # appropriate fields of this class.
  def after_parse
    # store self
    ::Mexico::FileSystem::FiestaDocument.store(self.identifier, self)

    [item_links,layer_links,point_links,interval_links].flatten.each do |link|
      link.item = self

      if ::Mexico::FileSystem::FiestaDocument.knows?(link.target)
        link.target_object=::Mexico::FileSystem::FiestaDocument.resolve(link.target)
      else
        # store i in watch list
        ::Mexico::FileSystem::FiestaDocument.watch(link.target, link, :target_object=)
      end

    end

  end

  def item_links
    @explicit_item_links + @implicit_item_links
  end

  def add_inverse_linked_item(item)
    @inverse_linked_items << item
  end

  def add_item_link(new_item_link)
    # add the item link
    add_explicit_item_link(new_item_link)

    other_item = new_item_link.target_item

    # add an inverse item link for _every_ item link
    # this is for retrieving item links from the other direction
    other_item.add_inverse_linked_item(self)

    # if an inverse relation for the role exists,
    # puts Mexico::FileSystem::ItemLink::INVERSE_ROLES.has_key?(new_item_link.role)
    if Mexico::FileSystem::ItemLink::INVERSE_ROLES.has_key?(new_item_link.role)
      # add an implicit link for this inverse relation
      # puts new_item_link.target_item

      other_item.add_implicit_item_link Mexico::FileSystem::ImplicitItemLink.new(
                                            role: Mexico::FileSystem::ItemLink::INVERSE_ROLES[new_item_link.role],
                                            target_object: self, item: other_item )
    end
  end

  def add_explicit_item_link(new_item_link)
    @explicit_item_links << new_item_link
  end

  def add_implicit_item_link(new_item_link)
    @implicit_item_links << new_item_link
  end

  def add_point_link(new_point_link)
    @point_links << new_point_link
  end


  def add_interval_link(new_interval_link)
    @interval_links << new_interval_link
  end


  def add_layer_link(new_layer_link)
    @layer_links << new_layer_link
  end

  def layers
    #puts layer_links.collect{|l| l.target}.join
    #puts layer_links.collect{|l| l.target.class }.join
    layer_links.collect{|l| l.layer }
  end

  # Retrieves all items that act as a source (or predecessor)
  # in the item link graph.
  def sources
    @inverse_linked_items
  end

  # Retrieves all items that act as a target (or successor)
  # in the item link graph.
  def targets
    item_links.collect{|l| l.target_object }
  end

end
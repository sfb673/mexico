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

# The basic data unit object.
class Mexico::FileSystem::Item

  include ::ROXML
  xml_name 'I'

  xml_accessor :identifier, :from => '@id'

  # @todo compound links (later)

  # collection of Mexico::FileSystem::ItemLink
  xml_accessor :item_links,     :as => [Mexico::FileSystem::ItemLink],     :from => "ItemLink",     :in => "Links"

  # collection of Mexico::FileSystem::LayerLink
  xml_accessor :layer_links,    :as => [Mexico::FileSystem::LayerLink],    :from => "LayerLink",    :in => "Links"

  # collection of Mexico::FileSystem::PointLink
  xml_accessor :point_links,    :as => [Mexico::FileSystem::PointLink],    :from => "PointLink",    :in => "Links"

  # collection of Mexico::FileSystem::IntervalLink
  xml_accessor :interval_links, :as => [Mexico::FileSystem::IntervalLink], :from => "IntervalLink", :in => "Links"

  # collection of Mexico::FileSystem::Data
  xml_accessor :data, :as => Mexico::FileSystem::Data, :from => "Data"

  attr_accessor :document


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
    @item_links = []
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

end
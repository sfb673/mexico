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

require 'poseidon'

# An URL object stands for a resource representation at the given location.
class Mexico::FileSystem::URL
  
  include Mexico::FileSystem::BoundToCorpus
  extend Mexico::FileSystem::IdRef
  extend Mexico::FileSystem::StaticCollectionRef
  
  include ::ROXML
  
  xml_accessor :identifier,     :from => '@identifier' 
  xml_accessor :name,           :from => '@name' 
  xml_accessor :description,    :from => 'Description' 

  xml_accessor :href, :from => "@href"

  # POSEIdON-based RDF augmentation
  include Poseidon
  self_uri %q(http://cats.sfb673.org/URL)
  instance_uri_scheme %q(http://phoibos.sfb673.org/corpora/#{corpus.identifier}/urls/#{identifier})
  rdf_property :identifier, %q(http://cats.sfb673.org/identifier)
  rdf_property :name, %q(http://cats.sfb673.org/name)
  rdf_property :description, %q(http://cats.sfb673.org/description)
  rdf_property :href, %q(http://cats.sfb673.org/href)

  def initialize(opts={})
    # @corpus = corpus
    [:identifier,:name,:description].each do |att|
      send("#{att}=", opts[att]) if opts.has_key?(att)
    end
  end

  # Retrieves a bunch of meta data with information about this resource representation.
  # @return [Hash] A hash containing various information (size, mime_type, availability)
  def info
    # @todo Implement this method stub
  end

  # Attempts to fetch the contents at this resource.
  # @option opts [String] :format The format to be retrieved. If omitted, the standard format will be retrieved.
  # @return [String or ByteArray] The file contents, as a string or binary object.
  def get(opts = {} )
    # @todo Implement this method stub
  end
  
end
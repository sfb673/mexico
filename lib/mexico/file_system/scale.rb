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

# A generic scale.
class Mexico::FileSystem::Scale

  DIM_TIME = 'time'
  DIM_SPACE = 'space'
  DIM_OTHER = 'other'

  include ::ROXML
  xml_name 'Scale'

  xml_accessor :identifier, :from => '@id'
  xml_accessor :name,       :from => '@name'

  xml_accessor :unit, :from => '@unit'
  xml_accessor :dimension, :from => '@dimension'
  xml_accessor :role, :from => '@role'
  xml_accessor :continuous?, :from => '@continuous'

  xml_accessor :mode, :from => '@mode'

  attr_accessor :document

  # POSEIdON-based RDF augmentation
  include Poseidon
  self_uri %q(http://cats.sfb673.org/Scale)
  instance_uri_scheme 'http://phoibos.sfb673.org/resources/1##{identifier}' # %q(#{document.self_uri}##{identifier})
  rdf_property :identifier, %q(http://cats.sfb673.org/identifier)
  rdf_property :name, %q(http://cats.sfb673.org/name)

  rdf_property :unit, %q(http://cats.sfb673.org/unit)
  rdf_property :dimension, %q(http://cats.sfb673.org/dimension)
  rdf_property :role, %q(http://cats.sfb673.org/role)
  rdf_property :continuous?, %q(http://cats.sfb673.org/is_continuous)
  rdf_property :mode, %q(http://cats.sfb673.org/mode)


  # static collection of MODES
  # mode : MODES collection
  # @todo collection of scale elements (if not continuous)

  # OKunit : SI units or custom units
  # OK dimension : String (x,y,z,t, etc.)
  # OK role : String (free text)
  # continuous? : Boolean

  def initialize(args={})
    args.each do |k,v|
      if self.respond_to?("#{k}=")
        send("#{k}=", v)
      end
    end
  end

  # overrides method in ROXML
  # callback after xml parsing process, to store this element in the
  # document cache.
  def after_parse
    ::Mexico::FileSystem::FiestaDocument.store(self.identifier, self)
  end

  # Creates an RDF representation in Turtle notation for this class.
  # @return [String] An RDF representation in Turtle notation for this class.
  def self.to_turtle
    rdf_writer = RDF::Turtle::Writer
    return rdf_writer.buffer(:base_uri => 'http://phoibos.sfb673.org/',
                             :prefixes => {
                                 :cats => 'http://cats.sfb673.org/',
                                 :rdfs => RDF::RDFS.to_uri,
                                 :foaf => RDF::FOAF.to_uri,
                                 :dc => RDF::DC.to_uri,
                                 :owl => RDF::OWL.to_uri,
                                 :xsd  => RDF::XSD.to_uri} #
    ) do |writer|
      as_rdf.each_statement do |statement|
        writer << statement
      end
    end
  end

  # Creates an RDF representation in Turtle notation for this object.
  # @return [String] An RDF representation in Turtle notation for this object.
  def to_turtle
    rdf_writer = RDF::Turtle::Writer
    return rdf_writer.buffer(:base_uri => 'http://phoibos.sfb673.org/',
                             :prefixes => {
                                 :cats => 'http://cats.sfb673.org/',
                                 :rdfs => RDF::RDFS.to_uri,
                                 :foaf => RDF::FOAF.to_uri,
                                 :dc => RDF::DC.to_uri,
                                 :owl => RDF::OWL.to_uri,
                                 :xsd  => RDF::XSD.to_uri} #
    ) do |writer|
      as_rdf.each_statement do |statement|
        writer << statement
      end
    end
  end

  def is_timeline?
    self.dimension == DIM_TIME
  end

  def is_spatial_axis?
    self.dimension == DIM_SPACE
  end

end
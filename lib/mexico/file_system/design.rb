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

require 'poseidon'

class Mexico::FileSystem::Design

  include Mexico::FileSystem::BoundToCorpus

  include Mexico::Core::DesignCore

  include ::ROXML

  # identifier
  xml_accessor :identifier, :from => '@identifier'

  # type String
  xml_accessor :name,       :from => '@name'

  # type String
  xml_accessor :description, :from => "Description"

  # collection of ::Mexico::FileSystem::DesignComponent
  xml_accessor :design_components, :as => [::Mexico::FileSystem::DesignComponent], :from => "DesignComponent" #, :in => "Designs"

  # POSEIdON-based RDF augmentation
  include Poseidon

  self_uri %q(http://cats.sfb673.org/Design)
  instance_uri_scheme %q(http://phoibos.sfb673.org/corpora/#{corpus.identifier}/designs/#{identifier})

  rdf_property :identifier, %q(http://cats.sfb673.org/identifier)
  rdf_property :name, %q(http://cats.sfb673.org/name)
  rdf_property :description, %q(http://cats.sfb673.org/description)

  rdf_include :design_components, %q(http://cats.sfb673.org/hasDesignComponent)

  # Creates a new design object.
  # @option opts [String] :identifier The identifier of the new design (required).
  # @option opts [String] :name The name of the new design. (required).
  # @option opts [String] :description A description of the new design (optional).
  def initialize(opts={})
    [:identifier,:name,:description].each do |att|
      send("#{att}=", opts[att]) if opts.has_key?(att)
    end
  end

  # Returns a collection of trials that are associated with this design.
  # @return [Array<Trial>] an array of trials associated with this design.
  def trials
    @corpus.trials.select{ |i| i.design === self }
  end


  def after_parse
    design_components.each do |dc|
      dc.design = self
    end
  end
end
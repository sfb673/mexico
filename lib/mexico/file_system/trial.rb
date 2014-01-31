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

# Trials model the events from reality that form the ultimate substrate
# of a corpus. Trials are usually numbered sequentially. A trial
# stands for a specific clip or segment of reality, e.g., a time span
# and a location in space where the events under observation occurred.
class Mexico::FileSystem::Trial
  
  include Mexico::FileSystem::BoundToCorpus
  extend Mexico::FileSystem::IdRef

  include ::ROXML
  
  # identifier
  xml_accessor :identifier,     :from => '@identifier'

  # type String
  xml_accessor :name,           :from => '@name'

  # type String
  xml_accessor :cue,            :from => '@cue'

  # type Integer
  xml_accessor :running_number, :from => '@runningnumber', :as => Integer

  # type String
  xml_accessor :description, :from => "Description"     

  # attr_accessor :corpus
  xml_accessor :design_id, :from => '@design_id'

  # type Mexico::FileSystem::Design
  id_ref :design

  # POSEIdON-based RDF augmentation
  include Poseidon

  self_uri %q(http://cats.sfb673.org/Trial)
  instance_uri_scheme %q(http://phoibos.sfb673.org/corpora/#{corpus.identifier}/trials/#{identifier})

  rdf_property :identifier, %q(http://cats.sfb673.org/identifier)
  rdf_property :name, %q(http://cats.sfb673.org/name)
  rdf_property :description, %q(http://cats.sfb673.org/description)
  rdf_property :cue, %q(http://cats.sfb673.org/cue)
  rdf_property :running_number, %q(http://cats.sfb673.org/running_number)

  # creates a new Trial object.
  # @option opts [String] :identifier The identifier of the new trial object.
  # @option opts [String] :description The identifier of the new trial object.
  # @option opts [String] :cue The cue for the new trial object.
  # @option opts [Integer] :running_number The running number for the new trial object.
  def initialize(opts={})
    # @corpus = corpus
    [:identifier,:name,:description,:cue,:running_number].each do |att|
      send("#{att}=", opts[att]) if opts.has_key?(att)
    end
  end

  # Returns a collection of resources that are associated with this trial.
  # @return [Array<Resource>] an array of resources associated with this trial.
  def resources
    @corpus.resources.select{ |i| i.trial === self }
  end

  def linked_to_design?
    return design!=nil
  end
  
end
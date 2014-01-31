# encoding: utf-8
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

# A typed connector between two layers (or tiers) in an transcription or annotation document.
class Mexico::FileSystem::LayerConnector

  include ROXML

  xml_accessor :identifier, :from => '@id'
  xml_accessor :name,       :from => '@name'

  xml_accessor :source_id, :from => '@source'
  xml_accessor :target_id, :from => '@target'

  xml_accessor :role, :from => '@role'

  attr_accessor :document


  def initialize(new_source, new_target)
    self.source= new_source
    self.target= new_target
  end

  # Retrieves the source layer for this layer connector.
  # @return [Layer] The source layer.
  def source
    @source
  end

  # Sets a new source layer for this layer connector.
  # @param new_source_layer [Layer] The layer to be set as the new source.
  # @return [void]
  def source=(new_source_layer)
    @source = new_source_layer
    @source_id = @source.identifier
  end

  # Retrieves the target layer for this layer connector.
  # @return [Layer] The target layer.
  def target
    @target
  end

  # Sets a new target layer for this layer connector.
  # @param new_target_layer [Layer] The layer to be set as the new target.
  # @return [void]
  def target=(new_target_layer)
    @target = new_target_layer
    @target_id = @target.identifier
  end

end
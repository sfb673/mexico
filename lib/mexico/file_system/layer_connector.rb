# encoding: utf-8
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

# A typed connector between two layers (or tiers) in an transcription or annotation document.
class Mexico::FileSystem::LayerConnector

  include ROXML

  xml_accessor :identifier, :from => '@id'
  xml_accessor :name,       :from => '@name'

  xml_accessor :source_id, :from => '@source'
  xml_accessor :target_id, :from => '@target'

  xml_accessor :role, :from => '@role'

  attr_accessor :document

  def source
    @source
  end

  def source=(param)
    @source = param
    @source_id = @source.identifier
  end

  def target
    @target
  end

  def target=(param)
    @target = param
    @target_id = @target.identifier
  end

end
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

# This class provides a corpus representation that is backed up by the filesystem.
# A central Corpus definition file in the top-level folder contains an
# XML representation of the corpus structure, and all actual resources are found
# as files on a file system reachable from the top-level folder.

class Mexico::FileSystem::Section

  LIFECYCLE = 'lifecycle'
  VOCABULARIES = 'vocabularies'
  LAYER_TYPES = 'layerTypes'

  SECTION_KEYS = [LIFECYCLE, VOCABULARIES, LAYER_TYPES]

  include ::ROXML
  xml_name 'Section'

  xml_accessor :key, :from => '@key'

  xml_accessor :properties,    :as => [::Mexico::FileSystem::Property],     :from => "Property"
  xml_accessor :property_maps, :as => [::Mexico::FileSystem::PropertyMap],  :from => "PropertyMap"

  def initialize(key='NOTGIVEN')
    @key = key
    @properties = []
    @property_maps = []
  end



end
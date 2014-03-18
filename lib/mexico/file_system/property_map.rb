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

class Mexico::FileSystem::PropertyMap

  include ::ROXML
  xml_name 'PropertyMap'

  xml_accessor :key, :from => '@key'

  xml_accessor :properties, :as => [::Mexico::FileSystem::Property], :from => "Property"
  xml_accessor :property_maps, :as => [::Mexico::FileSystem::PropertyMap],  :from => "PropertyMap"

  attr_accessor :values

  def initialize(args={})
    args.each do |k,v|
      if self.respond_to?("#{k}=")
        send("#{k}=", v)
      end
    end
    @properties = []
    @property_maps = []
  end

  def has_key?(key)
    properties.any?{|x| x.key == key} or property_maps.any?{|x| x.key == key}
  end

  def [](key)
    properties.find{|x| x.key == key} or property_maps.find{|x| x.key == key}
  end

end
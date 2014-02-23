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

class Mexico::FileSystem::Entry

  include ::ROXML
  xml_name 'Entry'

  xml_accessor :key, :from => '@key'

  xml_accessor :entries, :as => [::Mexico::FileSystem::Entry], :from => "Entry"

  attr_accessor :values

  def self.from_xml(node, args={})
    @values = {}
    node.elements.each do |el|
      key = el['key']
      val = el.text
      @values[key] = val
    end
  end

  def to_xml(params = {})
    params.reverse_merge!(:name => self.class.tag_name, :namespace => self.class.roxml_namespace)
    params[:namespace] = nil if ['*', 'xmlns'].include?(params[:namespace])
    node = XML.new_node([params[:namespace], params[:name]].compact.join(':')).tap do |root|
      @values.each do |k,v|
        root.children << XML.new_node([params[:namespace], 'Entry']).tap do |ent|
          ent['key'] = k
          ent.text = v
        end
      end
    end
    node
  end

end
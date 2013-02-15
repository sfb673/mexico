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

# A template class doing nothing.
class Mexico::FileSystem::DesignComponent

  include Mexico::FileSystem::BoundToCorpus

  include ::ROXML
  
  xml_accessor :identifier,     :from => '@identifier' 
  xml_accessor :name,           :from => '@name' 
  xml_accessor :description,    :from => 'Description'
  xml_accessor :cue,            :from => '@cue'
  xml_accessor :required?,      :from => '@required'
  
  #@todo media_type
  #@todo data_type
  #@todo content_structure
  #@todo belongs to Design
  
  def resources
    @corpus.resources.select{ |i| i.design_component === self }
  end

end
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

# A link from an item to a layer.
class Mexico::FileSystem::LayerLink

  include ::ROXML
  xml_name 'LayerLink'

  xml_accessor :identifier, :from => '@id'
  xml_accessor :role, :from => '@role'

  xml_accessor :target, :from => "@target"

  def target_object
    @target_object
  end

  def target_object=(new_target)
    @target_object=new_target
    target=target_object.identifier
  end

  def after_parse
    if ::Mexico::FileSystem::ToeDocument.knows?(target)
      @target_object=::Mexico::FileSystem::ToeDocument.resolve(target)
    else
      # store i in watch list
      ::Mexico::FileSystem::ToeDocument.watch(target, self, :target_object=)
    end
  end

end
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

# The basic data unit object.
class Mexico::FileSystem::Item

  include ::ROXML
  xml_name 'I'

  xml_accessor :identifier, :from => '@id'

  # 1-n layer links
  # 0-n interval links
  # 0-n point links
  # 0-n compound links (later)
  # 0-n other-item links
  # data

  xml_accessor :data, :as => Mexico::FileSystem::Data, :from => "Data"

  def after_parse
    # resolve links
  end

end
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

# This class provides a corpus representation that is backed up by the filesystem.
# A central Corpus definition file in the top-level folder contains an
# XML representation of the corpus structure, and all actual resources are found
# as files on a file system reachable from the top-level folder.

# ToE Document
class Mexico::FileSystem::ToeDocument

  # This class stands for an XML document in the Toe format.

  include ::ROXML
  xml_name 'ToeDocument'

  xml_accessor :identifier, :from => '@identifier'
  xml_accessor :name,       :from => '@name'

  xml_accessor :head,       :from => "Description", :as => [Mexico::FileSystem::Head]

end
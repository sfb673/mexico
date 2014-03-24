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

# Add class documentation here
class Mexico::FileSystem::Head

  include ::ROXML
  xml_name 'Head'

  # many HeadSections with keys
  xml_accessor :sections, :as => [::Mexico::FileSystem::Section],     :from => "Section"

  def initialize(args={})
    @sections = []
    ::Mexico::FileSystem::Section::SECTION_KEYS.each do |key|
      @sections << ::Mexico::FileSystem::Section.new(key)
    end
  end

  def [](key)
    sections.find{|x| x.key == key }
  end

  def section(key)
    sections.find{|x| x.key == key }
  end

end
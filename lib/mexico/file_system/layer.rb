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

# A layer (or tier) in an transcription or annotation document.
class ::Mexico::FileSystem::Layer

  include ROXML

  xml_accessor :identifier, :from => '@id'
  xml_accessor :name,       :from => '@name'

  # data type
  # content structure

  def initialize(args)
    args.each do |k,v|
      if self.respond_to?("#{k}=")
        send("#{k}=", v)
      end
    end
  end

  # overrides method in ROXML
  # callback after xml parsing process, to store this element in the
  # document cache.
  def after_parse
    ::Mexico::FileSystem::ToeDocument.store(self.identifier, self)
  end

end
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

# A generic scale.
class Mexico::FileSystem::Scale

  include ::ROXML
  xml_name 'Scale'

  xml_accessor :identifier, :from => '@id'
  xml_accessor :name,       :from => '@name'

  xml_accessor :unit, :from => '@unit'
  xml_accessor :dimension, :from => '@dimension'
  xml_accessor :role, :from => '@role'
  xml_accessor :continuous?, :from => '@continuous'

  xml_accessor :mode, :from => '@mode'

  # static collection of MODES
  # mode : MODES collection
  # @todo collection of scale elements (if not continuous)

  # OKunit : SI units or custom units
  # OK dimension : String (x,y,z,t, etc.)
  # OK role : String (free text)
  # continuous? : Boolean

  def initialize(args={})
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
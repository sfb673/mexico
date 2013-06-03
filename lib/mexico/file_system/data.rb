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

# the data container
class Mexico::FileSystem::Data

  include ::ROXML
  xml_name 'D'

  xml_accessor :string_value, :from => "String"
  xml_accessor :int_value, :as => Integer, :from => "Int"
  xml_accessor :float_value, :as => Float, :from => "Float"
  # keine Bool-Klasse in Ruby. xml_accessor :boolean_value, :as => Bool, :from => "B"
  # @todo map and list types

  def initialize(args={})
    args.each do |k,v|
      if self.respond_to?("#{k}=")
        send("#{k}=", v)
      end
    end
  end

  def after_parse
    # resolve links
  end

end
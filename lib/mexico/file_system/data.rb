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

# the data container
class Mexico::FileSystem::Data

  include ::ROXML
  xml_name 'D'

  xml_accessor :string_value, :from => "String" # , :to_xml => proc{|val| (@type=='string' ? val : '')}
  xml_accessor :int_value, :as => Integer, :from => "Int"
  xml_accessor :float_value, :as => Float, :from => "Float"
  xml_accessor :map, :as => Mexico::FileSystem::FiestaMap, :from => "Map"
  #xml_accessor :list, :as => Mexico::FileSystem::FiestaList, :from => "List"

  attr_accessor :item, :document

  include Poseidon
  self_uri %q(http://cats.sfb673.org/Data)
  instance_uri_scheme %q(#{document.self_uri}##{item.identifier}-data)
  rdf_property :string_value, %q(http://cats.sfb673.org/string_value)
  # rdf_property :name, %q(http://cats.sfb673.org/name)

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


  def map_value
    # return nil unless @type=="map"
    @map # ||= JSON::load(@string_value)
  end

  def list_value
    # return nil unless @type=="list"
    @list # ||= JSON::load(@string_value)
  end

  def map_value=(val)
    @string_value = nil
    @list = nil
    @map = Mexico::FileSystem::FiestaMap.new(val)
  end

  def list_value=(val=Array.new)
    @string_value = nil
    @map = nil
    @list = val
  end

  def string_value=(new_string)
    @map = nil
    @list = nil
    @string_value = new_string
  end

  def to_s
    return string_value unless string_value.nil?
    return @map.to_s unless @map.nil?
  end

  def is_string?
    (!string_value.nil? && map_value.nil? && list_value.nil?)
  end

  def is_map?
    (string_value.nil? && !map_value.nil? && list_value.nil?)
  end

end
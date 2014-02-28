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

# This module contains various helper methods.
module Mexico::Util

  # A list of umlauts and other special characters that are word characters in German.
  UMLAUTS = {
      "ä" => "ae",
      "ö" => "oe",
      "ü" => "ue",
      "ß" => "ss"
  }

  # Simple helper that strips away double quotes around a string.
  # @param string [String] The string to be unquoted.
  # @return       [String] The unquoted string.
  def self.strip_quotes(string)
    return string.gsub(/^"/, '').gsub(/"$/, '')
  end

  # Helper method that takes a name and sanitizes it for use as an XML/FiESTA id.
  # @param string [String] The string to be converted to an ID.
  # @return       [String] The resulting ID.
  def self.to_xml_id(string)
    result = string.downcase
    UMLAUTS.each_pair do |u,v|
      result.gsub!(/#{u}/, v)
    end
    result.gsub!(/[^\w\d]/, '_')
    return result.gsub(/_+/, '_')
  end

end

require 'mexico/util/fancy_container'
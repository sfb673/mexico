# encoding: utf-8

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
    return result.gsub(/[^\w\d]/, '')
  end

end
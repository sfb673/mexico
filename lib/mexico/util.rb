# encoding: utf-8

module Mexico::Util

  UMLAUTS = {
      "ä" => "ae",
      "ö" => "oe",
      "ü" => "ue",
      "ß" => "ss"
  }


  def self.strip_quotes(string)
    return string.gsub(/^"/, '').gsub(/"$/, '')
  end

  def self.to_xml_id(string)
    result = string.downcase
    UMLAUTS.each_pair do |u,v|
      result.gsub!(/#{u}/, v)
    end
    return result.gsub(/[^\w\d]/, '')
  end

end
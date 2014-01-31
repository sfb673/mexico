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

require 'poseidon'

# A LocalFile object represents a file on a local file system, with additional
# information
class Mexico::FileSystem::LocalFile
  
  include Mexico::FileSystem::BoundToCorpus
  extend Mexico::FileSystem::IdRef
  extend Mexico::FileSystem::StaticCollectionRef
  
  include ::ROXML

  # identifier
  xml_accessor :identifier,     :from => '@identifier' 

  # type String
  xml_accessor :name,           :from => '@name'

  # type String
  xml_accessor :description,    :from => 'Description'

  # type String
  xml_accessor :path, :from => "@path"


  # POSEIdON-based RDF augmentation
  include Poseidon
  self_uri %q(http://cats.sfb673.org/LocalFile)
  instance_uri_scheme %q(http://phoibos.sfb673.org/corpora/#{corpus.identifier}/local_files/#{identifier})
  rdf_property :identifier, %q(http://cats.sfb673.org/identifier)
  rdf_property :name, %q(http://cats.sfb673.org/name)
  rdf_property :description, %q(http://cats.sfb673.org/description)
  rdf_property :path, %q(http://cats.sfb673.org/path)


  # Creates a new local file object.
  # @option opts [String] :identifier The identifier of the new design (required).
  # @option opts [String] :name The name of the new design. (required).
  # @option opts [String] :description A description of the new design (optional).
  def initialize(opts={})
    [:identifier,:name,:description].each do |att|
      send("#{att}=", opts[att]) if opts.has_key?(att)
    end
  end

  # Resolves any relative path given in the path field, and returns an absolute
  # path suited for the current operating system.
  # @return (String) a string containing the absolute path to the file.
  def absolute_path
    if path.starts_with? "."
      return File.expand_path(File.join(@corpus.base_path, path))
    end
    return path
  end

  # Indicates whether the file described at the path actually exists.
  # @return (Boolean) +true+ if the described file exists, +false+ otherwise.
  def file_exists?
    return false if path.blank?
    File.exists?(absolute_path)
  end

  # Returns a file object for this {LocalFile} object.
  # @return (File) a file object for the described file, or +nil+ if there is no readable file at that location.
  def file_handle
    return nil if path.blank?
    return File.open(absolute_path)
  end

  # Returns the size of the file (in bytes).
  # @return (Integer) the size of the file in bytes, or +nil+ if no file can be found.
  def file_size
    return nil if path.blank?
    return File.size(absolute_path)
  end


  # This method performs additional linking and cleanup after parsing a XML representation.
  def after_parse
    # puts "Parsed LocalFile"
  end

end
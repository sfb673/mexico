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

  # identifier
  xml_accessor :identifier, :from => '@id'

  # type String
  xml_accessor :name,       :from => '@name'

  # type Mexico::FileSystem::Head
  xml_accessor :head,       :from => "Description", :as => [Mexico::FileSystem::Head]

  # collection of Mexico::FileSystem::Scale
  xml_accessor :scales, :as => [::Mexico::FileSystem::Scale],     :from => "Scale",     :in => "ScaleSet"

  # collection of Mexico::FileSystem::Layer
  xml_accessor :layers, :as => [::Mexico::FileSystem::Layer],     :from => "Layer",     :in => "LayerStructure"

  # collection of Mexico::FileSystem::Item
  xml_accessor :items, :as => [::Mexico::FileSystem::Item],     :from => "Item",     :in => "ItemSet"

  # Retrieves a stored object from the temporary import cache.
  # @param (String) xml_id The xml id of the needed object.
  # @return (Object) The needed object, or +nil+ if nothing could be found.
  def self.resolve(xml_id)
    @@CACHE["#{Thread.current.__id__}.#{xml_id}"]
  end

  # Retrieves a stored object from the temporary import cache.
  # @param (String) xml_id The xml id of the needed object.
  # @return (Boolean) +true+ if there is an entry for the given id, +false+ otherwise.
  def self.knows?(xml_id)
    @@CACHE.has_key?("#{Thread.current.__id__}.#{xml_id}")
  end

  # Retrieves a stored object from the temporary import cache.
  # @param (String) xml_id The xml id of the needed object.
  # @param (String) ruby_object The ruby object to be stored.
  # @return (void)
  def self.store(xml_id, ruby_object)
    @@CACHE = {} unless defined?(@@CACHE)
    @@CACHE["#{Thread.current.__id__}.#{xml_id}"] = ruby_object
    puts "Stored '%s' at '%s', cache size is now %i" % [ruby_object, "#{Thread.current.__id__}.#{xml_id}", @@CACHE.size]
    ::Mexico::FileSystem::ToeDocument.check_watch(xml_id, ruby_object)
    @@CACHE.each_pair do |i,j|
      puts "  %32s %32s %32s" % [i, j.class.name, j.__id__]
    end
  end

  # Put an xml id into the watch list, along with an object and a method
  def self.watch(needed_id, object, method)
    @@WATCHLIST = {} unless defined?(@@WATCHLIST)
    @@WATCHLIST["#{Thread.current.__id__}.#{needed_id}"] = [] unless @@WATCHLIST.has_key?("#{Thread.current.__id__}.#{needed_id}")
    @@WATCHLIST["#{Thread.current.__id__}.#{needed_id}"] << [object, method]
    puts "Watching out for ID %s, to call %s object's method %s" % [needed_id, object.to_s, method.to_s]
  end

  def self.check_watch(needed_id, needed_object)
    if defined?(@@WATCHLIST)
      if @@WATCHLIST.has_key?("#{Thread.current.__id__}.#{needed_id}")
        puts ""
        puts "   Watchlist has key %s" % needed_id
        puts "   iterate %i elements." % @@WATCHLIST["#{Thread.current.__id__}.#{needed_id}"].size
        @@WATCHLIST["#{Thread.current.__id__}.#{needed_id}"].each do |entry|
          puts "      entry: %s :: %s,   %s :: %s, %s" % [entry[0].class.name, entry[0].to_s, entry[1].class.name, entry[1].to_s, entry.__id__]
          puts "      calling %s on %s object with value %s" % [ entry[1].to_s, entry[0].identifier, needed_object.identifier ]
          entry[0].send(entry[1], needed_object)
        end
        @@WATCHLIST.delete("#{Thread.current.__id__}.#{needed_id}")
      end
    end
  end

  def self.open(filename)
    self.from_xml(File.open(filename))
  end

  def after_parse

    # process xml ids

    # then clear cache
    @@CACHE.clear

  end

end
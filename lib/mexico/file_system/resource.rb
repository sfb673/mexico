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

# A template class doing nothing.
class Mexico::FileSystem::Resource
  
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
  xml_accessor :media_type_id,  :from => '@media_type_id'

  # type Mexico::Core::MediaType
  collection_ref :media_type, ::Mexico::Core::MediaType, ::Mexico::Constants::MediaTypes::ALL, ::Mexico::Constants::MediaTypes::OTHER

  # type Array<Mexico::FileSystem::LocalFile>
  xml_accessor :local_files, :as => [::Mexico::FileSystem::LocalFile], :from => "LocalFile" #, :in => "."

  # type Array<Mexico::FileSystem::URL>
  xml_accessor :urls,        :as => [::Mexico::FileSystem::URL],       :from => "URL" # ,  :in => "."

  # type String
  xml_accessor :trial_id, :from => "@trial_id"

  # type Mexico::FileSystem::Trial
  id_ref :trial

  # type String
  xml_accessor :design_component_id, :from => "@design_component_id"

  # type Mexico::FileSystem::DesignComponent
  id_ref :design_component

  # docme

  # creates a new Trial object.
  # @option opts [String] :identifier The identifier of the new trial object.
  # @option opts [String] :name The name of the new trial object.
  # @option opts [String] :description The identifier of the new trial object.
  def initialize(opts={})
    # @corpus = corpus
    [:identifier,:name,:description].each do |att|
      send("#{att}=", opts[att]) if opts.has_key?(att)
    end
  end


  # Indicates whether this resource is associated with a trial.
  # @return [true,false] +true+ if this resource belongs to a trial, +false+ otherwise.
  def linked_to_trial?
    return trial!=nil
  end

  # Indicates whether this resource is associated with a design component.
  # @return [true,false] +true+ if this resource belongs to a design component, +false+ otherwise.
  def linked_to_design_component?
    return design_component!=nil
  end

  # Returns the disk space in bytes used by all local files of this resource.
  # @return (Integer) disk space in bytes used by all local files of this resource.
  def complete_file_size
    local_files.collect{ |f| f.file_size }.inject(:+)
  end

  # Indicates whether this resource is of the video media type.
  # @return (Boolean) +true+ if this resource has media type video, +false+ otherwise.
  def is_video?
    return media_type==::Mexico::Constants::MediaTypes::VIDEO
  end

  # Indicates whether this resource is of the audio media type.
  # @return (Boolean) +true+ if this resource has media type audio, +false+ otherwise.
  def is_audio?
    return media_type==::Mexico::Constants::MediaTypes::AUDIO
  end

  # Indicates whether this resource is of the annotation media type.
  # @return (Boolean) +true+ if this resource has media type annotation, +false+ otherwise.
  def is_annotation?
    return media_type==::Mexico::Constants::MediaTypes::ANNOTATION
  end

  # Attempts to load the contents of the resource from an appropriate source into an appropriate
  # data structure (for annotation files, into the ToE format, etc.)
  # @return (Mexico::FileSystem::ToeDocument) the document, or +nil+ if no document could be loaded.
  def load

    # @todo create a loader interface in a separate package
    #       load() then takes a file or url, gets the contents as a stream,
    #              and puts it into appropriate data structures.
    #       choice depends on: MediaType. Whether LocalFile or URL are available.
    #       What kinds of LF / URL are available, and which one is the newest.
    # first goal: When document is of mediatype ANNOTATION, and there is one
    # LocalFile, and it is of a matching type (now: ToE import), then import that
    # one and make the resulting objects available below the resource.

    # first version:
    # if resource is annotation, and there is a toe file, then: load that toe file
    # as a document, and define the appropriate member variable.

    # puts "Is anno? %s" % is_annotation?
    if is_annotation?

      # puts "Toe File? %s" % local_files.find{ |f| f.path=~/toe$/ }
      toe_file = local_files.find{ |f| f.path=~/toe$/ }

      unless toe_file.nil?
        @document = ::Mexico::FileSystem::ToeDocument.open(toe_file.absolute_path)
        return @document
      end
    end
  end

  # Returns the annotation document previously loaded in {#load} (this is only the case
  # if resource has media type video, and if an appropriate local file is present).
  # @return (Mexico::FileSystem::ToeDocument) the document, or +nil+ if no document has been loaded.
  def document
   defined?(@document) ? @document : nil
  end

  # This method performs additional linking and cleanup after parsing a XML representation.
  def after_parse
    # puts "Parsed Resource #{self.identifier}"
  end

  # @todo Resource must, upon creation, be bound to a physical resource somewhere in the file system.

end
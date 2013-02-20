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
  
  xml_accessor :identifier,     :from => '@identifier' 
  xml_accessor :name,           :from => '@name' 
  xml_accessor :description,    :from => 'Description' 

  xml_accessor :media_type_id,  :from => '@media_type_id'

  collection_ref :media_type, ::Mexico::Core::MediaType, ::Mexico::Constants::MediaTypes::ALL, ::Mexico::Constants::MediaTypes::OTHER

  xml_accessor :local_files, :as => [::Mexico::FileSystem::LocalFile], :from => "LocalFile", :in => "."
  xml_accessor :urls,        :as => [::Mexico::FileSystem::URL],       :from => "URL" # ,  :in => "."
  

  xml_accessor :trial_id, :from => "@trial_id"
  id_ref :trial


  xml_accessor :design_component_id, :from => "@design_component_id"
  id_ref :design_component

  # docme

  def initialize(opts={})
    # @corpus = corpus
    [:identifier,:name,:description].each do |att|
      send("#{att}=", opts[att]) if opts.has_key?(att)
    end
  end

  # @todo Resource must, upon creation, be bound to a physical resource
  # somewhere in the file system. 

  def linked_to_trial?
    return trial!=nil
  end

  def linked_to_design_component?
    return design_component!=nil
  end


  def complete_file_size
    local_files.collect{ |f| f.file_size }.inject(:+)
  end

  def is_video?
    return media_type==::Mexico::Constants::MediaTypes::VIDEO
  end

  def is_audio?
    return media_type==::Mexico::Constants::MediaTypes::AUDIO
  end

  def is_annotation?
    return media_type==::Mexico::Constants::MediaTypes::ANNOTATION
  end

  # Attempts to load the contents of the resource from an appropriate source into an appropriate
  # data structure (for annotation files, into the ToE format, etc.)
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

      end

    end


  end


  def document
   defined?(@document) ? @document : nil
  end

end
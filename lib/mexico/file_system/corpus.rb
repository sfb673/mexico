# This file is part of the MExiCo gem.
# Copyright (c) 2012 Peter Menke, SFB 673, Universität Bielefeld
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
class Mexico::FileSystem::Corpus
  
  ### include Mexico::FileSystem::FileSystemUtils
  
  include Mexico::Core::CorpusCore
  
  attr_accessor :base_path
  
  include ::ROXML
  
  xml_name 'Corpus'
  
  xml_accessor :identifier,        :from => '@identifier' 
  xml_accessor :name,              :from => '@name' 
  xml_accessor :description,       :from => "Description"
  # xml_accessor :participant_roles, :as => [::Mexico::FileSystem::ParticipantRole], :from => "ParticipantRole", :in => "ParticipantRoles"
  xml_accessor :participants,      :as => [::Mexico::FileSystem::Participant],     :from => "Participant",     :in => "Participants"       
  xml_accessor :designs,           :as => [::Mexico::FileSystem::Design],          :from => "Design",          :in => "Designs"
  xml_accessor :trials,            :as => [::Mexico::FileSystem::Trial],           :from => "Trial",           :in => "Trials"
  xml_accessor :resources,         :as => [::Mexico::FileSystem::Resource],        :from => "Resource",        :in => "Resources"
  
  public
  
  # corpus_file  : the XML file
  # corpus_doc   : the nokogiri xml document based on that file
    
  # Creates a new corpus object
  # @option opts [String] :path The path where to create the new corpus. Required.
  # @option opts [String] :identifier The path where to create the new corpus. Required.
  # @option opts [String] :name The path where to create the new corpus. Required.
  # @option opts [String] :description The path where to create the new corpus. Required.
  def initialize(opts = {})
    init_folder(opts[:path], opts)
    @base_path = File.expand_path(opts[:path])
    @corpus_file_name = File.join(@base_path, "Corpus.xml")
    f = File.open(@corpus_file_name, 'r')
    @xml_doc = ::Nokogiri::XML(f)
    f.close
  end
  
  # Saves the current data structure to the current file handle.
  # @return [void]
  def save_xml
    doc = Nokogiri::XML::Document.new
    doc.root = @corpus.to_xml
    open(File.join(@base_path, "Corpus.OUT.xml"), 'w') do |file|
      file << doc.serialize
    end
    # File.open(@corpus_file, 'w') {|f| f.write(doc.to_xml) }
  end
  
  # Creates a new design object and binds it to this corpus object.
  # @option opts [String] :identifier The identifier of the new design (required).
  # @option opts [String] :name The name of the new design. (required).
  # @option opts [String] :description A description of the new design (optional).
  def create_design(opts={})
    d = ::Mexico::FileSystem::Design.new(opts)
    d.bind_to_corpus(self)
    d
  end
  
  
  
  private

  # after parsing a XML corpus representation, this method binds all components
  # to the corpus object. 
  def after_parse
    
    participants.each do |participant|
      participant.bind_to_corpus(self)
    end
    
    designs.each do |design|
      design.bind_to_corpus(self)
    end
    
    trials.each do |trial|
      trial.bind_to_corpus(self)
    end

    resources.each do |resource|
      resource.bind_to_corpus(self)
      resource.local_files.each do |loc|
        loc.bind_to_corpus(self)
      end
      resource.urls.each do |url|
        url.bind_to_corpus(self)
      end
      
    end
        
  end
    
  # This method inits a new corpus folder in the file system.
  # @param [String] path The path where the folder should be initialized.
  # @param [Hash] opts A hash with additional options and parameters.
  # @option opts [String] :identifier The identifier of the new corpus (required).
  # @return +true+ if all operations were successful, false otherwise.
  def init_folder(path, opts = {})
    
    # check whether the given folder does not exist and is writable
    unless File.exists?(path)
      begin
        FileUtils.mkpath(path)
      rescue
        # if something goes wrong, stop here and return false
      end
    end
    
    corpus_file_name = File.join(path, "Corpus.xml")
    unless File.exists?(corpus_file_name)
      corpus_file = File.open(corpus_file_name, 'w+')
      corpus_file << "<Corpus identifier='#{opts[:identifier]}'></Corpus>"
      corpus_file.close
    end
    # create
    
  end
  
end
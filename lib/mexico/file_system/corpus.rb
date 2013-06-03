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

require 'poseidon'

class Mexico::FileSystem::Corpus
  
  ### include Mexico::FileSystem::FileSystemUtils


  include Mexico::Core::CorpusCore
  
  attr_accessor :base_path
  
  include ::ROXML
  
  xml_name 'Corpus'

  # identifier
  xml_accessor :identifier,        :from => '@identifier'

  # type String
  xml_accessor :name,              :from => '@name'

  # type String
  xml_accessor :description,       :from => "Description"

  # collection of ::Mexico::FileSystem::Participant
  xml_accessor :participants,      :as => [::Mexico::FileSystem::Participant],     :from => "Participant",     :in => "Participants"

  # collection of ::Mexico::FileSystem::Design
  xml_accessor :designs,           :as => [::Mexico::FileSystem::Design],          :from => "Design",          :in => "Designs"

  # collection of ::Mexico::FileSystem::Trial
  xml_accessor :trials,            :as => [::Mexico::FileSystem::Trial],           :from => "Trial",           :in => "Trials"

  # collection of ::Mexico::FileSystem::Resource
  xml_accessor :resources,         :as => [::Mexico::FileSystem::Resource],        :from => "Resource",        :in => "Resources"


  # POSEIdON-based RDF augmentation
  include Poseidon
  self_uri %q(http://cats.sfb673.org/Corpus)
  instance_uri_scheme %q(http://phoibos.sfb673.org/corpora/#{identifier})
  rdf_property :identifier, %q(http://cats.sfb673.org/identifier)
  rdf_property :name, %q(http://cats.sfb673.org/name)
  rdf_property :description, %q(http://cats.sfb673.org/description)
  rdf_include :designs, %q(http://cats.sfb673.org/hasDesign)
  rdf_include :trials, %q(http://cats.sfb673.org/hasTrial)
  rdf_include :resources, %q(http://cats.sfb673.org/hasResource)


  public
  
  # corpus_file  : the XML file
  # corpus_doc   : the nokogiri xml document based on that file

  # Opens the corpus folder and its manifest file at the given path.
  # @param [String] path the path where the corpus is
  # @option opts [String] :identifier The identifier that will be given if a new corpus is created
  # @return [Mexico::FileSystem::Corpus] the new or opened Corpus object
  def self.open(path, opts={})
    xml = File.open(File.join(path,'Corpus.xml'),'rb') { |f| f.read }
    c = Mexico::FileSystem::Corpus.from_xml(xml, opts.merge({:path=>path}))
    return c
  end

  # Creates a new instance of the {Corpus} class.
  # @param [String] path the path where the corpus is
  # @option opts [String] :identifier The identifier that will be given if a new corpus is created
  def initialize(path, opts={})
    init_folder(path, opts)
    @base_path = File.expand_path(path)
    @corpus_file_name = File.join(@base_path, "Corpus.xml")
    f = File.open(@corpus_file_name, 'r')
    @xml_doc = ::Nokogiri::XML(f)
    f.close
  end

  # Creates a new corpus object
  # @option opts [String] :path The path where to create the new corpus. Required.
  # @option opts [String] :identifier The identifier for the new corpus. Required.
  # @option opts [String] :name The name for the new corpus.
  # @option opts [String] :description A description for the new corpus. Required.
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

  # Returns the disk usage in bytes for the whole corpus.
  # @return [Integer] the number of bytes used by files of this corpus
  def complete_file_size
    resources.collect{ |r| r.complete_file_size }.inject(:+)
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
      design.design_components.each do |dc|
        dc.bind_to_corpus(self)
      end
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


  # helping method to retrieve all existing design components
  def design_components
    @designs.collect{|d| d.design_components}.flatten
  end
  
end
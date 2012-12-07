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

# This module aggregates all constant (type-level) objects that
# are needed for corpus management.
module Mexico::Constants
  
  # This module lists all participant roles
  # that are part of the current MExiCo model.
  module ParticipantRoles
    
    # A naive participant who does not have additional
    # background information about the experiment
    NAIVE       = Mexico::FileSystem::ParticipantRole.new :identifier =>'naive',       :name => 'Naive Participant'
    
    # A participant who has been instructed and informed
    # about the experiment in at least one aspect, and
    # who pretends to be naive to other participants
    CONFEDERATE = Mexico::FileSystem::ParticipantRole.new :identifier =>'confederate', :name => 'Confederate'
  
    # container for all other roles
    OTHER = Mexico::FileSystem::ParticipantRole.new :identifier =>'other-participant-role', :name => 'Other'
    
  
    ALL = Array.new
    ALL << ::Mexico::Constants::ParticipantRoles::NAIVE
    ALL << ::Mexico::Constants::ParticipantRoles::CONFEDERATE
    
    def self.get(key)
      ::Mexico::Constants::ParticipantRoles::ALL.first{ |x| x.identifier==key}  
    end
    
    def self.has?(key)
      ::Mexico::Constants::ParticipantRoles::ALL.select{ |x| x.identifier==key}.size>0
    end
    
  end
  
  # This module lists all participant roles
  # that are part of the current MExiCo model.
  module MediaTypes
    
    
    # Digital recordings of moving pictures, usually along with sound.
    VIDEO      = Mexico::Core::MediaType.new :identifier => "video",      :name => "Video",      :extensions => %w(mov avi mpg mpeg m4v webm mts)
    
    # Digital sound recordings.
    AUDIO      = Mexico::Core::MediaType.new :identifier => "audio",      :name => "Audio",      :extensions => %w(wav ogg aac mp3)
    
    # Different transcription and annotation file formats.
    ANNOTATION = Mexico::Core::MediaType.new :identifier => "annotation", :name => "Annotation", :extensions => %w(toe ShortTextGrid TextGrid eaf)
    
    ALL = Array.new
    ALL << ::Mexico::Constants::MediaTypes::VIDEO
    ALL << ::Mexico::Constants::MediaTypes::AUDIO
    ALL << ::Mexico::Constants::MediaTypes::ANNOTATION
    
  end
  
end
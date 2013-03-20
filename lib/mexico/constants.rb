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
    
    # A collection of all participant roles currently predefined.
    ALL = Array.new
    ALL << ::Mexico::Constants::ParticipantRoles::NAIVE
    ALL << ::Mexico::Constants::ParticipantRoles::CONFEDERATE

    # retrieves a participant role object by its key.
    # @param [String] key The key of the needed participant role.
    # @return [Mexico::FileSystem::ParticipantRole,nil] the participant role object, or nil, if no object was found.
    def self.get(key)
      ::Mexico::Constants::ParticipantRoles::ALL.first{ |x| x.identifier==key}  
    end

    # checks for the existence of a predefined participant role object.
    # @param [String] key The key of the needed participant role.
    # @return [true,false] true iff such a participant role object exists, false otherwise.
    def self.has?(key)
      ::Mexico::Constants::ParticipantRoles::ALL.select{ |x| x.identifier==key}.size>0
    end
    
  end

  # Scale modes are categories of scales based on the publication by S. S. Stevens
  # (Stevens, S. S. (1946). On the Theory of Scales of Measurement. Science, 103(2684), pp.677-680).
  # scales have different properties and allow different operations depending on their
  # level.
  module ScaleModes

    # The nominal scale is the simplest scale mode. It makes equality / inequality operations available.
    NOMINAL  = "nominal"

    # The ordinal scale mode is the next mode after the nominal mode. Besides all operations of the
    # nominal mode, it makes an ordering operations and comparisons available.
    ORDINAL  = "ordinal"

    # The cardinal scale mode is the next mode after the ordinal mode. Besides all operations of the
    # ordinal mode, it makes operations and comparisons based on distances or metrics available.
    CARDINAL = "cardinal"

    # The ratio scale mode is the next mode after the cardinal mode. Besides all operations of the
    # cardinal mode, it makes operations and comparisons based on a zero point available.
    RATIO    = "ratio"
  end

end
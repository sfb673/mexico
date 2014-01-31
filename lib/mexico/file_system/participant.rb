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

# Participant Roles describe the nature of the associated participant:
# Possible values are, e.g., naive participants, confederates, 
# experimenters, etc.
class Mexico::FileSystem::Participant
  
  include Mexico::FileSystem::BoundToCorpus
  extend Mexico::FileSystem::IdRef
  
  include ::ROXML
  
  xml_accessor :identifier,          :from => '@identifier' 
  xml_accessor :name,                :from => '@name' 
  xml_accessor :participant_role_id, :from => '@participant_role_id' 
  
  xml_accessor :description, :from => "Description"     
  

  # def participant_role
  #   ::Mexico::Constants::ParticipantRoles.get(participant_role_id)
  # end
  
  # def participant_role=(new_participant_role)
  #   # check whether param is a string or a participant role object
  #   if new_participant_role.kind_of?(String)
  #     new_object = ::Mexico::Constants::ParticipantRoles.get(new_participant_role)
  #     @participant_role_id=new_participant_role
  #   end
  #   if new_participant_role.kind_of?(::Mexico::FileSystem::ParticipantRole)
  #     unless ::Mexico::Constants::ParticipantRoles.has?(new_participant_role.identifier)
  #       # raise exception, this pr isn't available
  #     else
  #       participant_role_id = new_participant_role.identifier
  #     end
  #   end
  # end
  
  # Creates a new participant object.
  # @option opts [String] :identifier The identifier of the new participant object.
  # @option opts [String] :name The name of the new participant object.
  # @option opts [String] :description The identifier of the new participant object.
  # @option opts [String] :identifier The identifier of the new participant object.
  # @option opts [String] :name The name of the new participant object.
  # @option opts [String] :participant_role The participant role of the new participant object.
  def initialize(opts={})
    # @corpus = corpus
    [:identifier,:name,:description,:participant_role].each do |att|
      send("#{att}=", opts[att]) if opts.has_key?(att)
    end
  end
  
end

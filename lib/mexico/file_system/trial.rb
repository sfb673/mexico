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

# Trials model the events from reality that form the ultimate substrate
# of a corpus. Trials are usually numbered sequentially. A trial
# stands for a specific clip or segment of reality, e.g., a time span
# and a location in space where the events under observation occurred.
class Mexico::FileSystem::Trial
  
  include Mexico::FileSystem::BoundToCorpus
  extend Mexico::FileSystem::IdRef
  
  
  include ::ROXML
  
  xml_accessor :identifier,     :from => '@identifier' 
  xml_accessor :name,           :from => '@name' 
  xml_accessor :cue,            :from => '@cue'
  xml_accessor :running_number, :from => '@runningnumber', :as => Integer
  
  xml_accessor :description, :from => "Description"     
  
  attr_accessor :corpus
  
  xml_accessor :design_id, :from => '@design_id'

  id_ref :design
  
  def initialize(opts={})
    # @corpus = corpus
    [:identifier,:name,:description,:cue,:running_number].each do |att|
      send("#{att}=", opts[att]) if opts.has_key?(att)
    end
    
  end

  def resources
    @corpus.resources.select{ |i| i.trial === self }
  end
  
end
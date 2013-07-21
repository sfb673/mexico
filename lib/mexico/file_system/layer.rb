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

# A layer (or tier) in an transcription or annotation document.
class ::Mexico::FileSystem::Layer

  include ROXML

  xml_accessor :identifier, :from => '@id'
  xml_accessor :name,       :from => '@name'

  attr_accessor :document

  # data type
  # content structure

  def initialize(args={})
    args.each do |k,v|
      if self.respond_to?("#{k}=")
        send("#{k}=", v)
      end
    end
  end

  # overrides method in ROXML
  # callback after xml parsing process, to store this element in the
  # document cache.
  def after_parse
    ::Mexico::FileSystem::FiestaDocument.store(self.identifier, self)
  end

  # returns all layers that are linked to this layer such that this layer
  # is the target, and the result layer is the source.
  def predecessor_layers
    document.layer_connectors.select{|c| c.target==self}.collect{|c| [c.source, c.role]}
  end

  # returns all layers that are linked to this layer such that this layer
  # is the source, and the result layer is the target.
  def successor_layers
    document.layer_connectors.select{|c| c.source==self}.collect{|c| [c.target, c.role]}
  end


end
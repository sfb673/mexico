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

# A link from an item to a layer.
class Mexico::FileSystem::ItemLink

  ROLE_PARENT = 'parent'
  ROLE_CHILD = 'child'
  ROLE_PREDECESSOR = 'predecessor'
  ROLE_SUCCESSOR = 'successor'

  INVERSE_ROLES = {
      ROLE_PARENT => ROLE_CHILD,
      ROLE_CHILD => ROLE_PARENT,
      ROLE_PREDECESSOR => ROLE_SUCCESSOR,
      ROLE_SUCCESSOR => ROLE_PREDECESSOR
  }

  include ::ROXML
  xml_name 'ItemLink'

  # identifier
  xml_reader :identifier,        :from => '@id'

  def identifier=(new_id)
    @identifier = Mexico::Util::to_xml_id(new_id)
  end

  # type String
  xml_accessor :role, :from => '@role'

  # type String
  xml_accessor :target, :from => "@target"

  attr_accessor :item
  attr_accessor :document

  # POSEIdON-based RDF augmentation
  include Poseidon
  self_uri %q(http://cats.sfb673.org/ItemLink)
  instance_uri_scheme %q(#{document.self_uri}##{identifier})
  rdf_property :identifier, %q(http://cats.sfb673.org/identifier)
  rdf_property :role, %q(http://cats.sfb673.org/role)
  rdf_property :target, %q(http://cats.sfb673.org/target), :value_expression => 'RDF::URI(target_object.self_uri)'

  def initialize(args={})
    args.each do |k,v|
      if self.respond_to?("#{k}=")
        send("#{k}=", v)
      end
    end
  end

  # returns the target object, in this case, an Item.
  # @return (Mexico::FileSystem::Item) the scale this interval link points to.
  def target_object
    @target_object
  end

  # Sets a new target object (and updates the corresponding identifier)
  # @param (Mexico::FileSystem::Item) new_target The new target object to set
  # @return (void)
  def target_object=(new_target)
    # puts "SETTING target object to %s, %s" % [new_target.identifier, new_target]
    @target_object=new_target
    @target=target_object.identifier
  end

  # This method attempts to link objects from other locations of the XML/object tree
  # into position inside this object, by following the xml ids given in the
  # appropriate fields of this class.
  def after_parse
    # puts "item link after parse. What is the situation?"
    #
    # if ::Mexico::FileSystem::FiestaDocument.knows?(target)
    #   puts "  store knows the needed target. fetch it and set it."
    #   @target_object=::Mexico::FileSystem::FiestaDocument.resolve(target)
    #   puts "    %s" % @target_object
    # else
    #   # store i in watch list
    #   ::Mexico::FileSystem::FiestaDocument.watch(target, item, :target_object=)
    # end
  end

  alias_method :target_item, :target_object

end
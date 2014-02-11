# encoding: utf-8
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

# This class defines a constraint used for type-validating an object.

class Mexico::Constraints::Constraint


  def self.create(key, config={}, &evaluator)
    constraint = self.new(key, evaluator)
    constraint.add_parent(config[:parent]) if config.has_key?(:parent)
    config[:parents].each{ |p| constraint.add_parent(p) } if config.has_key?(:parents)

    @@REGISTERED_CONSTRAINTS = {} unless defined?(@@REGISTERED_CONSTRAINTS)
    @@REGISTERED_CONSTRAINTS[key] = constraint

    return constraint
  end

  def self.knows?(key)
    defined?(@@REGISTERED_CONSTRAINTS) && @@REGISTERED_CONSTRAINTS.has_key?(key)
  end

  def self.get(key)
    defined?(@@REGISTERED_CONSTRAINTS) && @@REGISTERED_CONSTRAINTS[key]
  end

  def evaluate(document)
    self.evaluator.call(document)
  end

  def initialize(key, evaluator)
    @key = key
    @evaluator = evaluator
    @parents = []
    @children = []
  end

  def add_parent(parent)
    internal_add_parent(parent)
    parent.internal_add_child(self)
  end

  def add_child(child)
    internal_add_child(child)
    child.internal_add_parent(self)
  end


  attr_reader :evaluator
  attr_accessor :key
  attr_accessor :parents
  attr_accessor :children

  private

  attr_writer :evaluator

  protected

  def internal_add_parent(parent)
    @parents << parent
  end

  def internal_add_child(child)
    @children << child
  end

end
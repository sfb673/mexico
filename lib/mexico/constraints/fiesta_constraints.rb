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


module Mexico::Constraints::FiestaConstraints

  include Mexico::Constraints

  TOP = Constraint.create('TOP') do |doc|
    true
  end

  # Scale-related constraints

  SCALES_TOP = Constraint.create('SCALES_TOP', parent: TOP) do |doc|
    true
  end

  SCALES_LTE_3 = Constraint.create('SCALES_LTE_3', parent: SCALES_TOP) do |doc|
    doc.scales.size <= 3
  end

  SCALES_LTE_2 = Constraint.create('SCALES_LTE_2', parent: SCALES_LTE_3) do |doc|
    doc.scales.size <= 2
  end

  SCALES_LTE_1 = Constraint.create('SCALES_LTE_1', parent: SCALES_LTE_2) do |doc|
    doc.scales.size <= 1
  end

  SCALES_EX_1 = Constraint.create('SCALES_EX_1', parent: SCALES_TOP) do |doc|
    doc.scales.size >= 1
  end

  SCALES_EX_TIMELINE = Constraint.create('SCALES_EX_TIMELINE', parent: SCALES_EX_1) do |doc|
    SCALES_EX_1.evaluate(doc) && doc.scales[0].is_timeline?
  end

end
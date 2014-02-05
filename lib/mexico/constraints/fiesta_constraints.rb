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

  # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # Scale-related constraints
  # # # # # # # # # # # # # # # # # # # # # # # # # # #

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

  SCALES_GTE_1 = Constraint.create('SCALES_GTE_1', parent: SCALES_TOP) do |doc|
    doc.scales.size >= 1
  end

  SCALES_GTE_2 = Constraint.create('SCALES_GTE_2', parent: SCALES_GTE_1) do |doc|
    doc.scales.size >= 2
  end

  SCALES_GTE_3 = Constraint.create('SCALES_GTE_3', parent: SCALES_GTE_2) do |doc|
    doc.scales.size >= 3
  end

  SCALES_GTE_4 = Constraint.create('SCALES_GTE_4', parent: SCALES_GTE_3) do |doc|
    doc.scales.size >= 4
  end

  SCALES_HAS_1_TIMELINE = Constraint.create('SCALES_HAS_1_TIMELINE', parent: SCALES_GTE_1) do |doc|
    SCALES_GTE_1.evaluate(doc) && doc.scales[0].is_timeline?
  end

  SCALES_HAS_2_TIMELINES = Constraint.create('SCALES_HAS_2_TIMELINES', parent: SCALES_GTE_2) do |doc|
    SCALES_GTE_2.evaluate(doc) && doc.scales[0].is_timeline? && doc.scales[1].is_timeline?
  end

  SCALES_EX_1_TIMELINE = Constraint.create('SCALES_EX_1_TIMELINE', parents: [SCALES_HAS_1_TIMELINE,SCALES_LTE_1]) do |doc|
    SCALES_HAS_1_TIMELINE.evaluate(doc) && SCALES_LTE_1.evaluate(doc)
  end


  # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # Constraints related to layer structures
  # # # # # # # # # # # # # # # # # # # # # # # # # # #

  LAYERS_TOP = Constraint.create('LAYERS_TOP', parent: TOP) do |doc|
    true
  end

  LAYERS_GRAPH = Constraint.create('LAYERS_GRAPH', parent: LAYERS_TOP) do |doc|
    true
  end

  LAYERS_DAG = Constraint.create('LAYERS_DAG', parent: LAYERS_GRAPH) do |doc|
    doc.layers_form_a_dag?
  end

  LAYERS_CDAG = Constraint.create('LAYERS_CDAG', parent: LAYERS_DAG) do |doc|
    doc.layers_form_a_cdag?
  end

  LAYERS_FOREST = Constraint.create('LAYERS_FOREST', parent: LAYERS_DAG) do |doc|
    doc.layers_form_a_forest?
  end

  LAYERS_TREE = Constraint.create('LAYERS_TREE', parents: [LAYERS_CDAG,LAYERS_FOREST]) do |doc|
    doc.layers_form_a_tree?
  end

  LAYERS_EDGELESS = Constraint.create('LAYERS_EDGELESS', parent: LAYERS_FOREST) do |doc|
    doc.layers_form_an_edgeless_graph?
  end

  LAYERS_EMPTY = Constraint.create('LAYERS_EMPTY', parent: LAYERS_GRAPH) do |doc|
    doc.layers_form_an_empty_graph?
  end


  # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # Constraints related to intra-layer structures
  # # # # # # # # # # # # # # # # # # # # # # # # # # #

  INTRALAYER_TOP = Constraint.create('INTRALAYER_TOP', parent: TOP) do |doc|
    true
  end

  INTRALAYER_GRAPH_ALL = Constraint.create('INTRALAYER_GRAPH', parent: INTRALAYER_TOP) do |doc|
    true
  end

  INTRALAYER_FOREST_ALL = Constraint.create('INTRALAYER_FOREST_ALL', parent: INTRALAYER_GRAPH_ALL) do |doc|
    boolean_result = true
    doc.layers.each do |layer|
      boolean_result = boolean_result && layer.items_form_a_forest?
    end
    boolean_result
  end

  # This one is actually used.
  INTRALAYER_EDGELESS_ALL = Constraint.create('INTRALAYER_EDGELESS_ALL', parent: INTRALAYER_FOREST_ALL) do |doc|
    boolean_result = true
    doc.layers.each do |layer|
      boolean_result = boolean_result && layer.items_form_an_edgeless_graph?
    end
    boolean_result
  end

  # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # Constraints related to inter-layer structures
  # # # # # # # # # # # # # # # # # # # # # # # # # # #

  # needed: calculation of the inter-layer-graph
  # take all nodes from layer 1, all nodes from layer 2
  # find all item links that have a l1 node as source and an l2 node as target

  INTERLAYER_TOP = Constraint.create('INTERLAYER_TOP', parent: TOP) do |doc|
    true
  end

  INTERLAYER_SOURCE_LTE_1 = Constraint.create('INTERLAYER_SOURCE_LTE_1', parent: INTERLAYER_TOP) do |doc|
    puts doc.inter_layer_source_cardinality
    doc.inter_layer_source_cardinality <= 1
  end

  INTERLAYER_SOURCE_0 = Constraint.create('INTERLAYER_SOURCE_0', parent: INTERLAYER_SOURCE_LTE_1) do |doc|
    puts doc.inter_layer_source_cardinality
    doc.inter_layer_source_cardinality == 0
  end

  INTERLAYER_SINK_LTE_1 = Constraint.create('INTERLAYER_SINK_LTE_1', parent: INTERLAYER_TOP) do |doc|
    puts doc.inter_layer_sink_cardinality
    doc.inter_layer_sink_cardinality <= 1
  end

  INTERLAYER_SINK_0 = Constraint.create('INTERLAYER_SINK_0', parent: INTERLAYER_SINK_LTE_1) do |doc|
    puts doc.inter_layer_sink_cardinality
    oc.inter_layer_sink_cardinality == 0
  end

  INTERLAYER_1_TO_N = Constraint.create('INTERLAYER_1_TO_N', parents: [INTERLAYER_SOURCE_LTE_1]) do |doc|
    INTERLAYER_SOURCE_LTE_1.evaluate(doc)
  end

  INTERLAYER_N_TO_1 = Constraint.create('INTERLAYER_N_TO_1', parents: [INTERLAYER_SINK_LTE_1]) do |doc|
    INTERLAYER_SINK_LTE_1.evaluate(doc)
  end

  INTERLAYER_1_TO_1 = Constraint.create('INTERLAYER_1_TO_1', parents: [INTERLAYER_1_TO_N, INTERLAYER_N_TO_1]) do |doc|
    INTERLAYER_1_TO_N.evaluate(doc) && INTERLAYER_N_TO_1.evaluate(doc)
  end

  INTERLAYER_EDGELESS = Constraint.create('INTERLAYER_EDGELESS', parents: [INTERLAYER_SOURCE_0,INTERLAYER_SINK_0]) do |doc|
    INTERLAYER_SOURCE_0.evaluate(doc) && INTERLAYER_SINK_0.evaluate(doc)
  end


  # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # Constraints related values
  # # # # # # # # # # # # # # # # # # # # # # # # # # #

  VALUES_TOP = Constraint.create('VALUES_TOP', parent: TOP) do |doc|
    true
  end

  VALUES_STRINGS_ONLY = Constraint.create('VALUES_STRINGS_ONLY', parent: VALUES_TOP) do |doc|
    doc.items.collect{|i| i.data }.all?{|d| d.is_string?}
  end

  VALUES_MAPS_ONLY = Constraint.create('VALUES_MAPS_ONLY', parent: VALUES_TOP) do |doc|
    doc.items.collect{|i| i.data }.all?{|d| d.is_map?}
  end

end
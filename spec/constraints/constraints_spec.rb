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

require 'spec_helper'
include Mexico::FileSystem

describe Mexico::Constraints::Constraint do

  # set up an initial corpus representation from the example file
  before(:each) do
    @basepath = File.join File.dirname(__FILE__), '..', '..'
    @assetspath = File.join @basepath, 'assets'
    @top_constraint = Mexico::Constraints::FiestaConstraints::TOP
    @two_constraint = Mexico::Constraints::FiestaConstraints::SCALES_LTE_2

    @path = File.join @assetspath, 'fiesta', 'elan'
    @filename = File.join @path, 'ElanFileFormat.eaf'
    @filename_inter = File.join @path, 'ElanFileFormatComplexInterLayerLinks.eaf'
    @fiesta_doc = ::Mexico::Fiesta::Interfaces::ElanInterface.instance.import(File.read(@filename))
    @fiesta_doc_inter = ::Mexico::Fiesta::Interfaces::ElanInterface.instance.import(File.read(@filename_inter))

  end

  context 'Constraints' do


    context 'class level constraint retrieval' do

      it 'should work' do

         @top_constraint.should be Mexico::Constraints::Constraint::get('TOP')
      end

      it 'test' do
        i = Mexico::FileSystem::Item.new
        l = Mexico::FileSystem::ItemLink.new

        puts "SEND <<"
        puts i.item_links.send(:<<, '')

        i.item_links << l

      end

    end


    context 'parent child system' do

      it 'should give access to the parents structure' do
        @two_constraint.parents.should_not be nil
      end
      it 'should return the correct number of parents for a given child' do
        @two_constraint.parents.size.should eq 1
      end
      it 'should return the correct parent object for a given child' do
        @two_constraint.parents.first.should be Mexico::Constraints::Constraint::get('SCALES_LTE_3')
      end

    end


    context 'The top-level (true) constraint' do

      it 'should be error free' do

        #puts @top_constraint
        #puts @top_constraint.class.name
        #puts @top_constraint.evaluator
        #puts @top_constraint.evaluator.class.name
        #puts @top_constraint.evaluator.call
        #puts @top_constraint.evaluator.call.class.name

      end

      it 'should call the evaluate method without errors' do
       expect { @top_constraint.evaluate @fiesta_doc }.to_not raise_error
      end

      it 'should always return true' do
        @top_constraint.evaluate(@fiesta_doc).should be true
      end

    end

    context 'layer hierarchy detector' do

      it 'should detect that an ELAN document has a forest LS' do
        @fiesta_doc.layers_form_a_forest?.should be true
      end

      it 'should detect that an ELAN document does not have an edgeless LS' do

        puts "Layer Connectors:"

        @fiesta_doc.layer_connectors.each do |c|

          puts "LC %s:" % c.identifier
          puts "  source: %s" % c.source.identifier
          puts "  target: %s" % c.target.identifier

        end


        @fiesta_doc.layers.each do |l|

          puts "Layer    %s" % l.identifier
          puts "  Pred:  %i" % l.predecessor_layers.size
          puts "  Succ:  %i" % l.successor_layers.size
        end

        #puts "layers           %s" % @fiesta_doc.layers
        #puts "layers           %s" % @fiesta_doc.layers.class.name
        #puts "layers           %s" % @fiesta_doc.layers.size
        #puts @fiesta_doc.layer_connectors

        @fiesta_doc.layers_form_an_edgeless_graph?.should be false
      end

    end

    context 'inter-layer link methods' do

      it 'should return correct values for inter-layer links' do

        layer_1 = @fiesta_doc_inter.layers[0]
        layer_2 = @fiesta_doc_inter.layers[1]

        test_interlayer_graph_1 = @fiesta_doc.inter_layer_graph(layer_1, layer_2)

        #puts test_interlayer_graph_1[:links]
        #puts pp test_interlayer_graph_1[:source_map]

        test_interlayer_graph_1[:source_map].each do |k,v|
          puts '%s --> [%s]' % [k.identifier, v.to_a.collect{|x| x.identifier}.join(', ')]
        end

        test_interlayer_graph_1[:sink_map].each do |k,v|
          puts '%s <-- [%s]' % [k.identifier, v.to_a.collect{|x| x.identifier}.join(', ')]
        end

      end

      it 'test the constraints for interlayer relations' do

        @fiesta_doc_inter.inter_layer_graph_list.each do |layers,graph|

          puts 'LAYERS %s/%s' % [layers[0].identifier,layers[1].identifier]
          graph[:source_map].each do |k,v|
            puts '%s ---> %s' % [k.identifier,v.to_a.collect{|i| i.identifier}.join(',')]
          end
          graph[:sink_map].each do |k,v|
            puts '%s <--- %s' % [k.identifier,v.to_a.collect{|i| i.identifier}.join(',')]
          end
        end

        puts '1:n - %s' % Mexico::Constraints::FiestaConstraints::INTERLAYER_1_TO_N.evaluate(@fiesta_doc_inter)
        puts 'n:1 - %s' % Mexico::Constraints::FiestaConstraints::INTERLAYER_N_TO_1.evaluate(@fiesta_doc_inter)
        puts '1:1 - %s' % Mexico::Constraints::FiestaConstraints::INTERLAYER_1_TO_1.evaluate(@fiesta_doc_inter)
        puts '0:0 - %s' % Mexico::Constraints::FiestaConstraints::INTERLAYER_EDGELESS.evaluate(@fiesta_doc_inter)

      end

      context 'test all cardinalities' do

        it 'behaves correct on all cardinalities' do

          @f = Mexico::FileSystem::FiestaDocument.new

          l1 = Layer.new(identifier: 'l1', name: 'l1', document: @f)
          l2 = Layer.new(identifier: 'l2', name: 'l2', document: @f)
          l3 = Layer.new(identifier: 'l3', name: 'l3', document: @f)
          l4 = Layer.new(identifier: 'l4', name: 'l4', document: @f)

          @f.layers << l1
          @f.layers << l2
          @f.layers << l3
          @f.layers << l4

          @f.layer_connectors << LayerConnector.new(l1, l2, {identifier: 'l1l2'})
          @f.layer_connectors << LayerConnector.new(l2, l3, {identifier: 'l2l3'})
          @f.layer_connectors << LayerConnector.new(l3, l4, {identifier: 'l3l4'})


          i1 = @f.add_item(nil) do |i|
            i.add_layer_link LayerLink.new(identifier: "#{i.identifier}-ll", role: '', target_object: l1, document: @f)
          end

          i2 = @f.add_item(nil) do |i|
            i.add_layer_link LayerLink.new(identifier: "#{i.identifier}-ll", role: '', target_object: l2, document: @f)
            i.add_item_link ItemLink.new(identifier: "#{i.identifier}-il", role: ItemLink::ROLE_PARENT, target_object: i1, document: @f)
          end

          i3 = @f.add_item(nil) do |i|
            i.add_layer_link LayerLink.new(identifier: "#{i.identifier}-ll", role: '', target_object: l2, document: @f)
            i.add_item_link ItemLink.new(identifier: "#{i.identifier}-il", role: ItemLink::ROLE_PARENT, target_object: i1, document: @f)
          end

          i4 = @f.add_item(nil) do |i|
            i.add_layer_link LayerLink.new(identifier: "#{i.identifier}-ll", role: '', target_object: l3, document: @f)
            i.add_item_link ItemLink.new(identifier: "#{i.identifier}-il1", role: ItemLink::ROLE_PARENT, target_object: i2, document: @f)
            i.add_item_link ItemLink.new(identifier: "#{i.identifier}-il2", role: ItemLink::ROLE_PARENT, target_object: i3, document: @f)
          end

          i5 = @f.add_item(nil) do |i|
            i.add_layer_link LayerLink.new(identifier: "#{i.identifier}-ll", role: '', target_object: l4, document: @f)
          end

          # now, the following cardinalities should be there:
          # l1 / l2 : 1:n
          # l2 / l3 : n:1
          # l3 / l4 : 0:0

          card_src_12 = @f.source_cardinality_for_layer(l1,l2)
          card_src_23 = @f.source_cardinality_for_layer(l2,l3)
          card_src_34 = @f.source_cardinality_for_layer(l3,l4)
          card_snk_12 = @f.sink_cardinality_for_layer(l1,l2)
          card_snk_23 = @f.sink_cardinality_for_layer(l2,l3)
          card_snk_34 = @f.sink_cardinality_for_layer(l3,l4)

          puts "SRC 1-2:  %i" % card_src_12
          puts "SNK 1-2:  %i" % card_snk_12
          puts "SRC 2-3:  %i" % card_src_23
          puts "SNK 2-3:  %i" % card_snk_23
          puts "SRC 3-4:  %i" % card_src_34
          puts "SNK 3-4:  %i" % card_snk_34

          card_src_12.should <= 1
          card_snk_12.should >  1
          card_src_23.should >  1
          card_snk_23.should <= 1
          card_src_34.should == 0
          card_snk_34.should == 0

          File.open(File.join(@path,'test_all_interlayerrelations.fst'),'w') do |f|
            f << @f.to_xml
          end

        end
      end

    end

    context 'values' do

      it 'correctly detects that all values are strings' do
        @f = Mexico::FileSystem::FiestaDocument.new
        l1 = Layer.new(identifier: 'l1', name: 'l1', document: @f)
        @f.layers << l1
        (1..4).each do |n|
          @f.add_item(nil) do |i|
            i.add_layer_link LayerLink.new(identifier: "#{i.identifier}-ll", role: '', target_object: l1, document: @f)
            i.data=Mexico::FileSystem::Data.new(string_value: "#{n}")
          end
        end
        Mexico::Constraints::FiestaConstraints::VALUES_STRINGS_ONLY.evaluate(@f).should eq true
        Mexico::Constraints::FiestaConstraints::VALUES_MAPS_ONLY.evaluate(@f).should eq false
      end

      it 'correctly detects that all values are maps' do
        @f = Mexico::FileSystem::FiestaDocument.new
        l1 = Layer.new(identifier: 'l1', name: 'l1', document: @f)
        @f.layers << l1
        (1..4).each do |n|
          @f.add_item(nil) do |i|
            i.add_layer_link LayerLink.new(identifier: "#{i.identifier}-ll", role: '', target_object: l1, document: @f)
            i.data=Mexico::FileSystem::Data.new(map_value: {key: "#{n}"})
          end
        end

        @f.items.each do |i|
          puts i.data
          puts "-"*80
          puts i.data.is_string?
          puts i.data.is_map?
          puts "-"*80
          puts i.data.string_value
          puts i.data.map_value
          puts i.data.list_value
          puts "-"*80

        end
        Mexico::Constraints::FiestaConstraints::VALUES_STRINGS_ONLY.evaluate(@f).should eq false
        Mexico::Constraints::FiestaConstraints::VALUES_MAPS_ONLY.evaluate(@f).should eq true
      end

    end

  end

end
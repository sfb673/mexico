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

require 'spec_helper'

describe Mexico::FileSystem::Resource do
  
  # set up an initial corpus representation from the example file
  before(:each) do
    @basepath = File.join(File.dirname(__FILE__), '..','..','assets','mexico-testcorpus','structured')
    @xml = File.open(File.join(@basepath,'Corpus.xml'),'rb') { |f| f.read }
    @corpus = Mexico::FileSystem::Corpus.from_xml(@xml, {:path => @basepath})
    
    @design_b = @corpus.designs[0]
    @design_c = @corpus.designs[1]
    @design_d = @corpus.designs[2]
    @design_e = @corpus.designs[3]

    @design_component_x = @design_b.design_components[0]
    
    @trial_f = @corpus.trials[0]
    @trial_g = @corpus.trials[1]
    @trial_h = @corpus.trials[2]
    @trial_i = @corpus.trials[3]
    
    @resource_j = @corpus.resources[0]

  end
  
  context 'our little corpus on the prairie' do
  
    context 'should link from first design to two trials' do
      it 'should have the method' do
        @design_b.should respond_to :trials
      end
      it 'should return a collection' do
        @design_b.trials.should be_kind_of(Enumerable)
      end
      it 'should return a collection with 2 elements' do
        @design_b.trials.size.should eq 2
      end
      it 'a linked trial should say true when asked for linkage to design' do
        @trial_f.linked_to_design?.should eq true
      end
    end
    
    context 'resource <j> should link to trial <f>' do
      it 'should have the methods' do
        @resource_j.should respond_to :trial
        @trial_f.should respond_to :resources
      end
      it 'should return appropriate objects' do
        @resource_j.trial.should be_kind_of(Mexico::FileSystem::Trial)
        @trial_f.resources.should be_kind_of(Enumerable)
      end
      it 'should return correct sizes' do
        @trial_f.resources.size.should eq 1
      end
      it 'should return the correct objects' do
        @resource_j.trial.should eq @trial_f
        @trial_f.resources[0].should eq @resource_j
      end
    end

    context 'resource <j> should link to design component <x>' do
      it 'should have the methods' do
        @resource_j.should respond_to :design_component
        @design_component_x.should respond_to :resources
      end
      it 'should return appropriate objects' do
        @resource_j.design_component.should be_kind_of(Mexico::FileSystem::DesignComponent)
        @design_component_x.resources.should be_kind_of(Enumerable)
      end
      it 'should return correct sizes' do
        @design_component_x.resources.size.should eq 1
      end
      it 'should return the correct objects' do
        @resource_j.design_component.should eq @design_component_x
        @design_component_x.resources[0].should eq @resource_j
      end
    end

  end

end
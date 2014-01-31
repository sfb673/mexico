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

describe Mexico::Constraints::Constraint do

  # set up an initial corpus representation from the example file
  before(:each) do
    @basepath = File.join File.dirname(__FILE__), '..', '..'
    @assetspath = File.join @basepath, 'assets'
    @top_constraint = Mexico::Constraints::FiestaConstraints::TOP
    @two_constraint = Mexico::Constraints::FiestaConstraints::SCALES_LTE_2

    @path = File.join @assetspath, 'fiesta', 'elan'
    @filename = File.join @path, 'ElanFileFormat.eaf'
    @fiesta_doc = ::Mexico::Fiesta::Interfaces::ElanInterface.instance.import(File.read(@filename))
  end

  context 'Constraints' do


    context 'class level constraint retrieval' do

      it 'should work' do

         @top_constraint.should be Mexico::Constraints::Constraint::get('TOP')
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

        puts @top_constraint
        puts @top_constraint.class.name
        puts @top_constraint.evaluator
        puts @top_constraint.evaluator.class.name
        puts @top_constraint.evaluator.call
        puts @top_constraint.evaluator.call.class.name

      end

      it 'should call the evaluate method without errors' do
       expect { @top_constraint.evaluate @fiesta_doc }.to_not raise_error
      end

      it 'should always return true' do
        @top_constraint.evaluate(@fiesta_doc).should be true
      end

    end


  end

end
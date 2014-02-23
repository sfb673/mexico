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

describe Mexico::FileSystem::FiestaDocument do

  before(:each) do
    @basepath = File.join File.dirname(__FILE__), '..', '..'
    @path = File.join @basepath, 'assets', 'fiesta', 'head'
    @filename = File.join(@path,'head.fst')
    @fdoc = ::Mexico::FileSystem::FiestaDocument.open(@filename)
  end

  context 'Fiesta' do
    context 'Head' do

      it 'should read all head entries correctly' do

        @fdoc.head.should_not be nil
        @fdoc.head.head_sections.size.should > 0

        @fdoc.head.head_sections.first.key.should eq 'vocabularies'
        @fdoc.head.head_sections.first.key.should_not eq 'waterlily'



      end

      it 'should write correct head info out' do
        @outfilename = File.join(@path,'head.OUT.fst')
        File.open @outfilename, 'w' do |f|
          f << @fdoc.to_xml
        end
      end

    end
  end
end
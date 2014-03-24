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

describe Mexico::FileSystem::Layer do

  before(:each) do
    @basepath = File.join File.dirname(__FILE__), '..', '..'
    @path = File.join @basepath, 'assets', 'fiesta', 'props'
    @filename = File.join(@path,'props.fst')
    @fdoc = ::Mexico::FileSystem::FiestaDocument.open(@filename)

    @outfile = File.join(@path,'out.fst')
    File.open(@outfile, 'w') do |f|
      f.write @fdoc.to_xml
    end
  end

  context 'Fiesta ' do
    context 'Layer' do
      it 'reads props from layers' do
        @fdoc.layers.first.should respond_to(:properties)
        @fdoc.layers.first.properties.should have_key('elanTierType')
        @fdoc.layers.first.properties['elanTierType'].should_not be nil
        @fdoc.layers.first.properties['elanTierType'].value.should eq 'TIME_SUBDIVISION'
      end
    end
  end
end
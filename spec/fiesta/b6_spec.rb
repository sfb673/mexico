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
    @assetspath = File.join @basepath, 'assets'
  end

  context 'Fiesta ' do
    context 'Interfaces ' do
      context 'B6 Chat Game ' do
        it 'reads data from a test file' do
          path = File.join @assetspath, 'fiesta', 'b6'
          filename = File.join path, 'match_jones_161_CM_neu_checked.parsed.xml'
          @fdoc = ::Mexico::Fiesta::Interfaces::B6ChatGameInterface.instance.import(File.read(filename))
          File.open(File.join(path,'test.out.fst'),'w') do |f|
            f << @fdoc.to_xml
          end
        end
      end
    end
  end

end
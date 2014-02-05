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
    @basepath = File.join(File.dirname(__FILE__), '..','..','assets','mexico-testcorpus','mexico')
    @corpus = Mexico::FileSystem::Corpus.open(@basepath)
    @trans_resource = @corpus.resources[1]
    @anno_file = @trans_resource.local_files.find{ |i| i.identifier=="mexico-transcription-toe" }
    @trans_resource.load
    @annodoc = @trans_resource.document
  end


  it "has a layers collection" do
    @trans_resource.should_not eq nil
    @trans_resource.document.should_not eq nil
    @trans_resource.document.should respond_to(:layers)
  end

  it "has four layers inside the collection" do
    @annodoc.layers.size.should be 4
  end

  it "has a first layer with working accessors" do
    layer = @annodoc.layers[0]
    layer.should respond_to(:identifier)
    layer.should respond_to(:name)
  end

  context "has a forst layer with" do
    # continuous="true" id="timeline" name="Timeline" mode="ratio" dimension="time" unit="s" role="single timeline"

    it "identifier" do
      @annodoc.layers[0].identifier.should eq "silences"
    end

    it "name" do
      @annodoc.layers[0].name.should eq "Silences"
    end

  end


end
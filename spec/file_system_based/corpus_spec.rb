# This file is part of the MExiCo gem.
# Copyright (c) 2012 Peter Menke, SFB 673, Universität Bielefeld
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

describe Mexico::FileSystem::Corpus do
  
  def write_corpus
    
    doc = Nokogiri::XML::Document.new
    doc.root = @corpus.to_xml
    open(File.join(@basepath, "Corpus.OUT.xml"), 'w') do |file|
      file << doc.serialize
    end
    
  end
  
  # set up an initial corpus representation from the example file
  before(:each) do
    @basepath = File.join(File.dirname(__FILE__), '..','..','assets','TESTCORPUS')
    @xml = File.open(File.join(@basepath,'Corpus.xml'),'rb') { |f| f.read }
    @corpus = Mexico::FileSystem::Corpus.from_xml(@xml, {:path => @basepath})
  end
  
  context 'Attributes' do
  
    it 'should include the CorpusCore module' do
      @corpus.should respond_to('core_included?')  
    end
  
    context "identifier" do
    
      it "should have accessor methods" do
        @corpus.should respond_to(:identifier, :identifier=)  
      end
  
      it "should have the right type" do
        @corpus.identifier.kind_of?(String).should be true
        @corpus.identifier.should match /^\w[-\w\d_]*$/
      end
      
      it "should have the correct value" do
        @corpus.identifier.should eq "example-corpus"
      end
      
    end
    
    context "name" do
          
      it "should have accessor methods" do
        @corpus.should respond_to(:name, :name=)  
      end
  
      it "should have the right type" do
        @corpus.name.kind_of?(String).should be true
      end
      
      it "should have the correct value" do
        @corpus.name.should eq "Example Corpus"
      end
      
    end
    
    context "description" do
          
      it "should have accessor methods" do
        @corpus.should respond_to(:description, :description=)  
      end
  
      it "should have the right type" do
        @corpus.description.kind_of?(String).should be true
      end
      
      it "should have the correct value" do
        @corpus.description.should eq "This is an example corpus."
      end
      
    end
    
  end
  
  
  context "Aggregated components" do
    
    context "designs" do
      
      it 'collection method present' do
       @corpus.should respond_to(:designs)
      end
      
      it 'collection accessor returns collection' do
       @corpus.designs.should be_kind_of(Array)
      end
      
      
    end
  
  end
  
  
  context "Designs: " do
    it 'should respond to design methods' do
      @corpus.should respond_to(:designs)
    end
    
    it 'should have one design' do
      @corpus.designs.should_not be nil
      @corpus.designs.size.should be 2
    end

    it 'should have a first design with the correct data' do
      @corpus.designs[0].identifier.should eq "example-design"
      @corpus.designs[0].should respond_to("corpus")
      @corpus.designs[0].corpus.identifier.should eq "example-corpus"
    end
  
  end
  
  
  context "Trials: " do
    it 'should respond to trials methods' do
      @corpus.should respond_to(:trials)
    end
    
    it 'should have one trial' do
      @corpus.trials.should_not be nil
      @corpus.trials.size.should be 1
    end
    
    it 'after adding a trial, it should have two trials' do
      @corpus.trials.size.should be 1
      @corpus.trials << Mexico::FileSystem::Trial.new(:identifier=>"second-example-trial", :name=>"Second Example Trial", :description=>"This is an example trial.",:cue=>"V0?2",:running_number=>2)
      @corpus.trials.size.should be 2
      write_corpus
    end
  end
  
end
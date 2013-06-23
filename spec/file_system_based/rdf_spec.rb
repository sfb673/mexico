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

describe Mexico::FileSystem::Corpus do

  def write_corpus

    doc = Nokogiri::XML::Document.new
    doc.root = @corpus.to_xml
    open(File.join(@basepath, "Corpus.OUT.xml"), 'w') do |file|
      file << doc.serialize
    end

  end



  context 'Corpus' do

    # set up an initial corpus representation from the example file
    before(:each) do
      @basepath = File.join(File.dirname(__FILE__), '..','..','assets','mexico-testcorpus', 'mexico')
      @corpus = Mexico::FileSystem::Corpus.open(@basepath)
      @corpus.resources[1].load
    end

    it 'should output RDF ntriples' do
      rdf = @corpus.to_rdf
      File.open(File.join(File.dirname(__FILE__), '..','..','assets','rdf-output','corpus.nt'), 'w:utf-8') do |f|
        f << rdf
      end
      rdf.should_not be nil
    end

    it 'should output RDF RDFXML' do
      rdf = @corpus.to_rdf(:format => :rdfxml, :base_uri => 'http://phoibos.sfb673.org/corpora/',
                           :prefixes => {:cats=>'http://cats.sfb673.org/',:phoibos=>'http://phoibos.sfb673.org/corpora/'})
      File.open(File.join(File.dirname(__FILE__), '..','..','assets','rdf-output','corpus.rdf'), 'w:utf-8') do |f|
        f << rdf
      end
      rdf.should_not be nil
    end

  end

  context 'Fiesta Document' do

    before :each do
      @basepath = File.join(File.dirname(__FILE__), '..','..','assets','mexico-testcorpus', 'mexico')
      @corpus = Mexico::FileSystem::Corpus.open(@basepath)
      @corpus.resources[1].load
      @document = @corpus.resources[1].document
    end

    it 'should output RDF XML' do
      rdf = @document.to_rdf(:format => :rdfxml, :base_uri => 'http://phoibos.sfb673.org/corpora/',
                             :prefixes => {:cats=>'http://cats.sfb673.org/',:phoibos=>'http://phoibos.sfb673.org/corpora/'})
      File.open(File.join(File.dirname(__FILE__), '..','..','assets','rdf-output','document.rdf'), 'w:utf-8') do |f|
        f << rdf
      end
      rdf.should_not be nil
    end

  end

  context 'B6 Document' do

    before :each do
      @basepath = File.join(File.dirname(__FILE__),'..','..','assets','fiesta', 'b6')
      @filename = File.join @basepath, 'match_jones_161_CM_neu_checked.parsed.xml'
      @document = ::Mexico::Fiesta::Interfaces::B6ChatGameInterface.instance.import(File.read(@filename))
      puts "DCN: %s " % @document.class.name
      @document.self_uri('http://phoibos.sfb673.org/corpora/example/b6.fst')
    end

    it 'should output RDF XML' do
      rdf = @document.to_rdf(:format => :rdfxml, :base_uri => 'http://phoibos.sfb673.org/corpora/',
                             :prefixes => {:cats=>'http://cats.sfb673.org/',:phoibos=>'http://phoibos.sfb673.org/corpora/'})
      File.open(File.join(File.dirname(__FILE__), '..','..','assets','rdf-output','b6.rdf'), 'w:utf-8') do |f|
        f << rdf
      end
      File.open(File.join(File.dirname(__FILE__), '..','..','assets','rdf-output','b6.fst'),'w') do |f|
        f << @document.to_xml
      end
      rdf.should_not be nil
    end

  end
end
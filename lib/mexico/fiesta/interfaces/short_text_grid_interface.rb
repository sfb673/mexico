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

# Import and export interface for Praat's short text grid format.
class Mexico::Fiesta::Interfaces::ShortTextGridInterface

  include Singleton
  include Mexico::FileSystem

  def self.import(io=$stdin, params = {})
    puts 'class method import'
    instance.import(io, params)
  end

  def self.export(doc, io=$stdout, params = {})
    instance.export(doc, io, params)
  end

  def import(io=$stdin, params = {})
    puts 'instance method import'

    io.rewind

    encoding = params.has_key?(:encoding) ? params[:encoding] : 'UTF-16'

    fdoc = FiestaDocument.new
    timeline = fdoc.add_standard_timeline('s')

    fileType = io.gets.strip
    objectClass = io.gets.strip
    io.gets # blank line
    global_min = io.gets.to_f
    global_max = io.gets.to_f
    io.gets # <exists>

    # get the numbers of tiers in this document.
    numberOfTiers = io.gets.to_i

    numberOfTiers.times do |tierNumber|
      tierType = io.gets.strip
      tierName = Mexico::Util::strip_quotes(io.gets.strip)
      tier_min = io.gets.to_f
      tier_max = io.gets.to_f

      # create layer object from that tier
      #puts "layer constructor before"
      layer = fdoc.add_layer({identifier:tierName, name:tierName})
      #puts "layer constructor done"


      numberOfAnnotations = io.gets.to_i

      numberOfAnnotations.times do |annotationNumber|

        anno_min = io.gets.to_f
        anno_max = io.gets.to_f
        anno_val = io.gets.strip.gsub(/^"/, "").gsub(/"$/, "")

        #puts "  #{anno_val} [#{anno_min}--#{anno_max}]"

        if anno_val.strip != ""

          item = fdoc.add_item({identifier:"l#{tierNumber}a#{annotationNumber}"}) do |i|
            i.add_interval_link IntervalLink.new(
                                    identifier:"#{i.identifier}-il",
                                    min: anno_min,
                                    max: anno_max,
                                    target_object: timeline )
            i.data = Mexico::FileSystem::Data.new(string_value: anno_val)
            i.add_layer_link LayerLink.new(
                                 identifier:"#{i.identifier}-ll",
                                 target_object: layer )
          end

          puts item

        end

      end

    end

    fdoc
  end

  def export(doc, io=$stdout, params = {})
    Mexico::Util::FancyWriter.new(io) do
      line 'File type = "ooTextFile"'
      line 'Object class = "TextGrid"'
      line

      # overall min and max values
      total_item_links = doc.items.collect{|i| i.interval_links}.flatten
      total_min = total_item_links.collect{|l| l.min}.min
      total_max = total_item_links.collect{|l| l.max}.max
      line total_min, total_max
      line '<exists>'
      line doc.layers.size

      # FOREACH layer : print layer header block
      doc.layers.each do |layer|
        # "IntervalTier", "name", min, max, annocount

        line '"IntervalTier"'
        line %Q("#{layer.name}")
        layer_item_links = doc.items.collect{|i| i.interval_links}.flatten
        layer_min = layer_item_links.collect{|l| l.min}.min
        layer_max = layer_item_links.collect{|l| l.max}.max
        line layer_min, layer_max

        # FOREACH item in layer : min, max, value
        sorted_items = layer.items.sort{|i,j| i.interval_links.first.min <=> i.interval_links.first.min}
       time_points = [total_min, total_max, layer_min, layer_max]
        sorted_items.each do |i|
          time_points << i.interval_links.first.min
          time_points << i.interval_links.first.max
        end
        time_points.uniq!.sort!
        # print effective number of annotations
        line time_points.size-1
        time_points.each_with_index do |current_point, n|
          next_point = nil
          unless n == time_points.size-1
            next_point = time_points[n+1]
          end
          unless next_point.nil?
            #puts "-"*48
            #puts "TL:   %20.18f - %20.18f" % [current_point, next_point]
            #sorted_items.each do |it|
            #  puts "IT:   %20.18f - %20.18f  --  %20.18f - %20.18f, %s" % [it.interval_links.first.min, it.interval_links.first.max, (it.interval_links.first.min-current_point), (it.interval_links.first.max-next_point), ((it.interval_links.first.min-current_point).abs<0.00001 && (it.interval_links.first.max-next_point).abs<0.00001)]
            #end
            item = sorted_items.select{|i| (i.interval_links.first.min-current_point).abs<0.00001 && (i.interval_links.first.max-next_point).abs<0.00001}.first
            #puts item
            line current_point, next_point
            if item.nil?
              line '""'
            else
              line %Q("#{item.data.string_value}")
            end
          end
        end
      end
    end
  end
end

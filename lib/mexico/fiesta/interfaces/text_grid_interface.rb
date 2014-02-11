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

# Import and export interface for Praat's text grid format.
class Mexico::Fiesta::Interfaces::TextGridInterface

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

    fdoc = FiestaDocument.new
    timeline = fdoc.add_standard_timeline('s')

    encoding = params.has_key?(:encoding) ? params[:encoding] : 'UTF-16'

    fdoc = FiestaDocument.new
    timeline = fdoc.add_standard_timeline('s')

    fileType = io.gets.strip
    objectClass = io.gets.strip
    io.gets # blank line
    global_min = io.gets.to_f
    global_max = io.gets.to_f
    io.gets # <exists>

    size_spec = io.gets.strip
    size_match = size_spec.match(/\d+/)
    size_spec = size_match[0].to_i if size_match

    io.gets # item container header
    for tier_num in (1..size_spec)
      # read tier item line, drop it
      io.gets # single item header

      tierClass = io.gets.match(/"(.*)"/)[1]
      tierName  = Mexico::Util::strip_quotes(io.gets.match(/"(.*)"/)[1])
      tierXmin = io.gets.match(/(\d+(\.\d+)?)/)[1].to_f
      tierXmax = io.gets.match(/(\d+(\.\d+)?)/)[1].to_f
      tierSize = io.gets.match(/size\s*=\s*(\d+)/)[1].to_i

      # create layer object from that tier
      layer = fdoc.add_layer({identifier:tierName, name:tierName})

      for anno_num in (1..tierSize)

        io.gets
        annoMin = io.gets.match(/(\d+(\.\d+)?)/)[1].to_f
        annoMax = io.gets.match(/(\d+(\.\d+)?)/)[1].to_f
        annoVal = io.gets.match(/"(.*)"/)[1]

        if annoVal.strip != ""

          item = fdoc.add_item({identifier:"l#{tier_num}a#{anno_num}"}) do |i|
            i.add_interval_link IntervalLink.new(
                                    identifier:"#{i.identifier}-il",
                                    min: annoMin,
                                    max: annoMax,
                                    target_object: timeline )
            i.data = Mexico::FileSystem::Data.new(string_value: annoVal)
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

end

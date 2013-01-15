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

class Mexico::Core::MediaType
  
  attr_accessor :identifier, :name, :extensions
  
  def initialize(opts={})
    [:identifier,:name,:extensions].each do |att|
      send("#{att}=", opts[att]) if opts.has_key?(att)
    end
  end
  
end


# This module lists all participant roles
# that are part of the current MExiCo model.
module Mexico::Constants

  module MediaTypes

	# Digital recordings of moving pictures, usually along with sound.
	VIDEO      = Mexico::Core::MediaType.new :identifier => "video",      :name => "Video",      :extensions => %w(mov avi mpg mpeg m4v webm mts)

	# Digital sound recordings.
	AUDIO      = Mexico::Core::MediaType.new :identifier => "audio",      :name => "Audio",      :extensions => %w(wav ogg aac mp3)

	# Different transcription and annotation file formats.
	ANNOTATION = Mexico::Core::MediaType.new :identifier => "annotation", :name => "Annotation", :extensions => %w(toe ShortTextGrid TextGrid eaf)

	# Placeholder for all other (yet unsupported) types.
	OTHER      = Mexico::Core::MediaType.new(:identifier => "other",      :name => "Other",      :extensions => %w())

	ALL = Array.new
	ALL << ::Mexico::Constants::MediaTypes::VIDEO
	ALL << ::Mexico::Constants::MediaTypes::AUDIO
	ALL << ::Mexico::Constants::MediaTypes::ANNOTATION
	ALL << ::Mexico::Constants::MediaTypes::OTHER

  end

end
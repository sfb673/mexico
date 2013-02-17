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

require 'optparse'
require 'colorize'

class Mexico::Cmd

  SUBCOMMANDS = %w(help info init status)

  SUBCOMMAND_DESCRIPTIONS = {}

  SUBCOMMAND_DESCRIPTIONS["help"]   = "Display helpful information and exit."
  SUBCOMMAND_DESCRIPTIONS["info"]   = "Display information about the corpus the current folder belongs to."
  SUBCOMMAND_DESCRIPTIONS["init"]   = "Create corpus structure files in an existing or new folder."
  SUBCOMMAND_DESCRIPTIONS["status"] = "Show status info of file linkage and format conversion."

  DEFAULT_BANNER = "Usage: mexico [subcommand] [options]"

  OPTION_PARSERS = {}

  OPTION_PARSERS["help"] = OptionParser.new do |opts|
  end

  OPTION_PARSERS["info"] = OptionParser.new do |opts|
    opts.banner = "Usage: mexico info [options]"
    opts.on("-p", "--path PATH", "Look for corpus manifest at PATH") do |p|
      @@options[:path] = p
    end
  end

  OPTION_PARSERS["init"] = OptionParser.new do |opts|
    opts.banner = "Usage: mexico init [options]"
    opts.on("-p", "--path PATH", "Create corpus folder and manifest at PATH") do |p|
      @@options[:path] = p
    end
  end

  OPTION_PARSERS.values.each do |p|
    p.on("-v", "--[no-]verbose", "Run verbosely") do |v|
      @@options[:verbose] = v
    end
    p.on("-d", "--[no-]debug", "Turn on debugging output") do |d|
      @@options[:debug] = d
    end
    p.separator ""
    p.separator "Available subcommands are"
    p.separator "-------------------------"
    SUBCOMMANDS.each do |sc|
      p.separator "%8s - %s" % [sc, SUBCOMMAND_DESCRIPTIONS[sc]]
    end
  end

  @@options = {}

  def self.verbose(message)
    puts "VERBOSE:  #{message}".cyan if @@options[:verbose]
  end

  def self.debug(message)
    puts "DEBUG:    #{message}".magenta if @@options[:debug]
  end


  def self.humanize(number)
    prefs = %w(Ti Gi Mi Ki)
    display_number = number.to_f
    unit = ""
    while(display_number>1000 && !prefs.empty?)
      display_number = display_number / 1024.0
      unit = prefs.pop()
    end
    return "%.1f %sB" % [display_number, unit]
  end

  def self.run!(arx)
    argsize = ARGV.size
    if argsize>0
      subcommand = ARGV.shift

      if SUBCOMMANDS.include?(subcommand)
        # ok, command is known
        if argsize>1
          OPTION_PARSERS[subcommand].parse!
        else
          # no more commands.
        end
        self.verbose "Verbose mode. MExiCo displays more info on what it does in cyan."
        self.debug   "Debug mode. MExiCo displays lots of internal information in magenta."
        self.verbose "MExiCo #{subcommand}"
        Mexico::Cmd.send(subcommand, @@options)
      else
        # break: command not known
        OPTION_PARSERS['help'].parse!
        self.help(@@options)
      end
      self.debug("Detected arguments:  %s" % @@options)
      unless ARGV.empty?
        self.debug("Leftover arguments:  %s" % ARGV)
      end
      self.debug("Subcommand:          %s" % subcommand)
    else
      puts option_parser
      exit(1)
    end
    exit(0)
  end

  def self.help(options)
    puts "Help".magenta
    puts OPTION_PARSERS['help']
    exit(0)
  end

  def self.info(options)
    # check if current folder is corpus folder
    current_folder = File.dirname(__FILE__)
    if options.has_key?(:path)
      current_folder = options[:path]
    end
    corpus_manifest = File.join(current_folder,"Corpus.xml")
    if File.exists?(corpus_manifest)
      self.verbose "Current Directory '#{current_folder}' is a corpus folder, opening."
      # open corpus manifest, analyse
      corpus = Mexico::FileSystem::Corpus.open(current_folder)
      puts ""
      puts "-"*72
      puts "%15s  :  %-50s" % ["Identifier", corpus.identifier]
      puts "%15s  :  %-50s" % ["Name", corpus.name]
      displ_description = ""
      displ_description = corpus.description.split("\n").first unless corpus.description.blank?
      displ_description = displ_description.slice(0,47)+" ..." unless displ_description.length<47
      puts "%15s  :  %-50s" % ["Description", displ_description]
      puts "-"*72
      puts "%15s  :  %-50s" % ["Designs", corpus.designs.size]
      puts "%15s  :  %-50s" % ["Trials", corpus.trials.size]
      puts "%15s  :  %-50s" % ["Resources", corpus.resources.size]
      puts "%15s  :  %-50s" % ["Local Files", corpus.resources.collect{|i| i.local_files}.flatten.size]
      puts "%15s  :  %-50s" % ["Used Disk Space", humanize(corpus.complete_file_size)]
      puts "-"*72
      puts ""
    else
      puts "Error: No corpus manifest folder found in '#{current_folder}'.".red
      puts "Seems like no corpus has been initialized here.".red
      exit(1)
    end
  end


  def self.init(options)
    puts "The 'init' subcommand is not yet implemented."
    exit(0)
  end

  def self.status(options)
    puts "The 'status' subcommand is not yet implemented."
    exit(0)
  end
  
end

# MExiCo

## Introduction

MExiCo (short for "Multimodal Experiment Corpora") is a library for the
modeling and management of large, heterogeneous data collections from 
the field of linguistics, psycholinguistics, and related disciplines.

Its central organising unit is the **Corpus** class which allows researchers to bundle resources from an experiment with related background data, conceptual data, and metadata.

## Last Changes

## 0.0.12 (Hotfix)

Completed on April 10 2014.

+ [**#269**](http://intranet.sfb673.org/issues/269): Fixes a constructor in LayerConnector that did not allow parameter-less initialization (as needed by ROXML).
+ [**#270**](http://intranet.sfb673.org/issues/270): The chat game corpus interface now uses the current setter methods.

## 0.0.11

Completed on March 24 2014.

+ [**#258**](http://intranet.sfb673.org/issues/258): Adds first working version of FancyWriter for creating formatted plain text file formats.

    + [**#154**](http://intranet.sfb673.org/issues/154): Adds export routine into the Praat ShortTextGrid format.
    + [**#155**](http://intranet.sfb673.org/issues/155): Adds TextGrid export functionality.

+ [**#156**](http://intranet.sfb673.org/issues/156): EAF export should now be complete, including metadata:

    + [**#234**](http://intranet.sfb673.org/issues/234): Spec test files are adopted to reflect additional ELAN features.
    + [**#248**](http://intranet.sfb673.org/issues/248): Layers now use property structures for additional configuration.
    + [**#251**](http://intranet.sfb673.org/issues/251): ELAN import now uses up-to-date method for adding layers.
    + [**#252**](http://intranet.sfb673.org/issues/252): Adds custom setter methods for identifiers in order to produce XML-valid IDs.
    + [**#253**](http://intranet.sfb673.org/issues/253): Fixes a bug where annotations with empty string values were skipped.
    + [**#255**](http://intranet.sfb673.org/issues/255): Persists the ANNOTATOR attribute from ELAN during import and export.
    + [**#256**](http://intranet.sfb673.org/issues/256): Resolves and exports Elan parent refs correctly.
    + [**#257**](http://intranet.sfb673.org/issues/257): Implements various missing ELAN (meta)data.


## 0.0.10

Completed on February 26 2014.

+ [**#214**](http://intranet.sfb673.org/issues/214): FiESTA documents now have a first version of the head structure.
+ [**#236**](http://intranet.sfb673.org/issues/236): Some useless or outdated requirements in the Gemfile were removed.
+ [**#245**](http://intranet.sfb673.org/issues/245): IO objects in import methods now rewind before reading.

## 0.0.9

Completed on February 11 2014.

+ **#94**: Added implementation of constraints, and specs and assets for testing or debugging constraints.
+ **#150**: Created a first version of the import and export interface.
+ **#152**: Importers for Praat TextGrid and ShortTextGrid formats are now integrated.
+ **#153**: Completed first implementation of ELAN EAF import (still incomplete).
+ **#215**: The library now has flexible accessors for scales, layers, and items.

### 0.0.8

Completed on July 21 2013.

+ **Layer Connectors**: Added LayerConnector model class
+ **Example files compliant with schema**: Changed example files so they are working with the new schema files
+ **Add necessity of attributes in corpus schema file**: Improved Mexico schema file by adding information on which attributes are required and which optional
+ **Refactor file format (FiESTA instead of ToE)**: Changed occurrences of the old name 'toe' into 'fiesta'.
+ **Missing constructors**: Added constructor methods that were missing
+ **Create repo for schema**: Added a separate repo for the schema files.
+ **Basic RDF representations**: Several model files can now be exported to RDF using the POSEIdON gem.

### 0.0.7

Completed on 13 May 2013.

+ **Method stubs**: Added method stubs for info and retrieval of URLs and LocalFiles
+ **Additional documentation**: Replaced template documentation with meaningful information

### 0.0.6

Completed on 20 Mar 2013.

+ **Yard compatible, complete documentation**: Completed yardoc-compatible documentation for all code components

### 0.0.5

Completed on 22 Feb 2013.

+ **Annotation microstructure**: Created code for all subcomponents of this first version of the toe microstructure.
+ **Atomic data structures**: Selected appropriate classes for the atomic data structures
+ **Scale sets, scales, points, intervals**: Created model, test data and specs for scales and scale links.
+ **Events**: Created model, test data and specs for events, which are now called items.
+ **Layers and layer links**: Created model, test data and specs for layers and layer links (connectors postponed to later version)
+ **Event links**: Created model, test data and specs for event links

### 0.0.4

Completed on 17 Feb 2013.

+ **Internal Links**: implemented initial version for internal links
+ **Binary, first version**: Implemented first version of gem executable.
+ **Binary subcommand: info**: Subcommand "info" is implemented in a first version

### 0.0.3

Completed on 15 Feb 2013.

+ **File system integration**: Resource Objects now have first versions of local files and urls.
+ **ResourceFile model**: Model ResourceFile was rejected and is superseded by LocalFile and URL objects.
+ **Schema for storage paths**: Relative paths are now resolved based on the corpus home folder.

### 0.0.2

Completed on 15 Jan 2013.

+ **Resource model**: Created first, minimal version of resource model
+ **Participant Role model**: Created first, minimal model for release notes.
+ **Media Types**: Created first media types (video, audio, other), along with collection helpers.

### 0.0.1

Completed on 5 Dec 2012.

+ **Create fundamental gem structure**: Created the basic gem structure and initial Gemfile entries for the library.
+ **Decide upon a license**: Decided to use the LGPL as license.
+ **Implement basic Nokogiri XML read and write functionality for XML Corpus Engine**: Chose ROXML (based on Nokogiri) for XML (de)serialisation


## Contributing to mexico
 
- Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
- Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
- Fork the project
- Start a feature/bugfix branch
- Commit and push until you are happy with your contribution
- Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
- Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2012-2014 Peter Menke, SFB 673, Universität Bielefeld.

MExiCo is free software: you can redistribute it and/or modify
it under the terms of the **GNU Lesser General Public License** as
published by the Free Software Foundation, either version 3 of
the License, or (at your option) any later version.

MExiCo is distributed in the hope that it will be useful,
but **WITHOUT ANY WARRANTY**; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU Lesser General Public License for more details.

See LICENSE.txt for further details.

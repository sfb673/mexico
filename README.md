# MExiCo

## Introduction

MExiCo (short for "Multimodal Experiment Corpora") is a library for the
modeling and management of large, heterogeneous data collections from 
the field of linguistics, psycholinguistics, and related disciplines.

Its central organising unit is the **Corpus** class which allows researchers to bundle resources from an experiment with related background data, conceptual data, and metadata.

## Last Changes

### 0.0.3

+ **File system integration**: Resource Objects now have first versions of local files and urls.
+ **ResourceFile model**: Model ResourceFile was rejected and is superseded by LocalFile and URL objects.
+ **Schema for storage paths**: Relative paths are now resolved based on the corpus home folder.

### 0.0.2

+ **Resource model**: Created first, minimal version of resource model
+ **Participant Role model**: Created first, minimal model for release notes.
+ **Media Types**: Created first media types (video, audio, other), along with collection helpers.

### 0.0.1

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

Copyright (c) 2012, 2013 Peter Menke, SFB 673, Universität Bielefeld.

MExiCo is free software: you can redistribute it and/or modify
it under the terms of the **GNU Lesser General Public License** as
published by the Free Software Foundation, either version 3 of
the License, or (at your option) any later version.

MExiCo is distributed in the hope that it will be useful,
but **WITHOUT ANY WARRANTY**; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU Lesser General Public License for more details.

See LICENSE.txt for further details.
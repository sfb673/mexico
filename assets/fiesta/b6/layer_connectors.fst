<?xml version="1.0" encoding="UTF-8"?>
<FiestaDocument>
  <ScaleSet>
    <Scale id="timeline01" name="Timeline" unit="s"/>
    <Scale id="spatial_x" name="Spatial coordinate X" unit="pixel"/>
    <Scale id="spatial_y" name="Spatial coordinate Y" unit="pixel"/>
  </ScaleSet>
  <LayerSet>
    <Layer id="chats" name="Chats"/>
    <Layer id="sentences" name="Sentences"/>
    <Layer id="politeness" name="Politeness"/>
    <LayerConnector id="chats_to_sentences" source="chats" target="sentences" role="parent-child"/>
    <LayerConnector id="sentences_to_politeness" source="sentences" target="politeness" role="parent-child"/>
  </LayerSet>
  <ItemSet></ItemSet>
</FiestaDocument>
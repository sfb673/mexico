<FiestaDocument>
  <ScaleSet/>
  <LayerSet>
    <Layer id="l1" name="l1"/>
    <Layer id="l2" name="l2"/>
    <Layer id="l3" name="l3"/>
    <Layer id="l4" name="l4"/>
    <LayerConnector id="l1l2" source="l1" target="l2"/>
    <LayerConnector id="l2l3" source="l2" target="l3"/>
    <LayerConnector id="l3l4" source="l3" target="l4"/>
  </LayerSet>
  <ItemSet>
    <Item id="item6905">
      <Links>
        <LayerLink id="item6905-ll" role="" target="l1"/>
      </Links>
    </Item>
    <Item id="item42756">
      <Links>
        <ItemLink id="item42756-il" role="parent" target="item6905"/>
        <LayerLink id="item42756-ll" role="" target="l2"/>
      </Links>
    </Item>
    <Item id="item13791">
      <Links>
        <ItemLink id="item13791-il" role="parent" target="item6905"/>
        <LayerLink id="item13791-ll" role="" target="l2"/>
      </Links>
    </Item>
    <Item id="item15869">
      <Links>
        <ItemLink id="item15869-il1" role="parent" target="item42756"/>
        <ItemLink id="item15869-il2" role="parent" target="item13791"/>
        <LayerLink id="item15869-ll" role="" target="l3"/>
      </Links>
    </Item>
    <Item id="item64968">
      <Links>
        <LayerLink id="item64968-ll" role="" target="l4"/>
      </Links>
    </Item>
  </ItemSet>
</FiestaDocument>
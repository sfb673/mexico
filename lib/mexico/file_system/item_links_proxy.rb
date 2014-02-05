# encoding: utf-8

class Mexico::FileSystem::ItemLinksProxy < Array

  def initialize(parent_item)
    @item = parent_item
  end

  def <<(item_link)
    @item.add_item_link(item_link)
  end

end
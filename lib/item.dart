class MyItem {
  MyItem(this.id, this.name);

  final int id;
  final String name;

  MyItem.defaultItem(this.id) : name = 'Default Item';
  MyItem.moreItem(this.id) : name = 'More Items';
  MyItem.moreItemBefore(this.id) : name = 'More Items Before';
}

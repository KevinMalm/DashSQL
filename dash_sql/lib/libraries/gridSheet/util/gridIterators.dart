



class GridColumnIterator implements Iterator<String?> {
  /* ------------------------------------ */
  final List<List<String?>> data;
  final int                 columnIndex;
  /* ------------------------------------ */
  int     _index = 0;
  String? _value;
  /* ------------------------------------ */

  GridColumnIterator({
    required this.data,
    required this.columnIndex
  });
  
  @override
  String? get current => _value;
  
  @override
  bool moveNext() {
    if(_index >= data.length) {
      _value = null;
      return false;
    }
    _value  = data[_index][columnIndex];
    _index += 1;
    return true;
  }


}


class GridColumnIterable extends Iterable<String?> {
  /* ------------------------------------ */
  final List<List<String?>> data;
  final int                columnIndex;
  /* ------------------------------------ */

  GridColumnIterable({
    required this.data,
    required this.columnIndex
  });
  
  @override
  Iterator<String?> get iterator => GridColumnIterator(data: data, columnIndex: columnIndex);
  
  @override
  int get length => data.length;
  
}



class GridColumnIteratorIterator implements Iterator<GridColumnIterable> {
  /* ------------------------------------ */
  final List<List<String?>> data;
  /* ------------------------------------ */
  int                  _index = 0;
  GridColumnIterable? _value;
  /* ------------------------------------ */

  GridColumnIteratorIterator({
    required this.data,
  });
  
  @override
  GridColumnIterable get current => _value!;
  
  @override
  bool moveNext() {
    if(_index >= data.first.length) {
      _value = null;
      return false;
    }
    _value  = GridColumnIterable(data: data, columnIndex: _index);
    _index += 1;
    return true;
  }


}


class GridColumnIterableIterable extends Iterable<GridColumnIterable> {
  /* ------------------------------------ */
  final List<List<String?>> data;
  /* ------------------------------------ */

  GridColumnIterableIterable({
    required this.data
  });
  
  @override
  Iterator<GridColumnIterable> get iterator => GridColumnIteratorIterator(data: data);

  @override
  int get length => data.first.length;
  
}
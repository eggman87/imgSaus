class GalleryAlbumIndexState {
  GalleryAlbumIndexState() {
    _albumPositionsForIndex[0] = 0;
  }

  Map<int, int> _albumPositionsForIndex = Map();

  void incrementPositionForIndex(int index) {
    _albumPositionsForIndex[index] = _albumPositionsForIndex[index] + 1;
  }

  void decrementPositionForIndex(int index) {
    _albumPositionsForIndex[index] = _albumPositionsForIndex[index] - 1;
  }

  int albumPositionForIndex(int index) {
    if (_albumPositionsForIndex.containsKey(index)) {
      return _albumPositionsForIndex[index];
    }
    _albumPositionsForIndex[index] = 0;
    return 0;
  }

  void startTrackingNewIndex(int index) {
    _albumPositionsForIndex[index] = 0;
  }
}
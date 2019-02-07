

import 'package:imgsrc/model/app_state.dart';
import 'package:imgsrc/reducers/gallery_reducers.dart';

AppState appReducer(AppState state, action) {
  return AppState(
    isLoading: false,
    galleryItems: galleryReducer(state.galleryItems, action),
    galleryFilter: activeFilterReducer(state.galleryFilter, action)
  );
}

import 'package:imgsrc/model/app_state.dart';
import 'package:imgsrc/reducers/gallery_reducers.dart';

AppState appReducer(AppState state, action) {
  return AppState(
    isLoading: false,
    galleryFilter: activeFilterReducer(state.galleryFilter, action),
    galleryItems: galleryReducer(state.galleryItems, action),
    itemComments: commentsReducer(state.itemComments, action),
    itemDetails: itemDetailsReducer(state.itemDetails, action),
    albumIndex:  albumIndexReducer(state.albumIndex, action),
    videoControllers: videoControllerReducer(state.videoControllers, action),
    galleryTags: galleryTagsReducer(state.galleryTags, action)
  );
}
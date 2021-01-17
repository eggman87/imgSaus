
import 'package:imgsrc/model/app_state.dart';
import 'package:imgsrc/reducers/gallery_reducers.dart';

AppState appReducer(AppState state, action) {
  //todo: break state up
  return AppState(
    isLoadingGallery: isLoadingGalleryReducer(state.isLoadingGallery, action),
    currentAccount: accountReducer(state.currentAccount, action),
    accountImages: accountImagesReducer(state.accountImages, action),
    galleryFilter: activeFilterReducer(state.galleryFilter, action),
    galleryItems: galleryReducer(state.galleryItems, action),
    itemComments: commentsReducer(state.itemComments, action),
    itemDetails: itemDetailsReducer(state.itemDetails, action),
    albumIndex:  albumIndexReducer(state.albumIndex, action),
    videoControllers: videoControllerReducer(state.videoControllers, action),
    galleryTags: galleryTagsReducer(state.galleryTags, action)
  );
}
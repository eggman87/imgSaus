import 'package:imgsrc/action/actions.dart';
import 'package:imgsrc/data/gallery_repository.dart';
import 'package:imgsrc/model/app_state.dart';
import 'package:imgsrc/model/comment_models.dart';
import 'package:imgsrc/model/gallery_item.dart';
import 'package:imgsrc/model/gallery_models.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createImgurMiddleware([
  GalleryRepository repository = const GalleryRepository(),
]) {
  final filterItems = _createFilterGallery(repository);
  final loadComments = _loadCommentsForId(repository);
  final loadAlbumDetails = _loadAlbumForId(repository);
  final loadGalleryTags = _loadGalleryTags(repository);
  final loadAccount = _loadAccount(repository);
  final loadAccountImages = _loadAccountImages(repository);

  return [
    TypedMiddleware<AppState, UpdateFilterAction>(filterItems),
    TypedMiddleware<AppState, LoadCommentsAction>(loadComments),
    TypedMiddleware<AppState, LoadAlbumImagesAction>(loadAlbumDetails),
    TypedMiddleware<AppState, LoadGalleryTagsAction>(loadGalleryTags),
    TypedMiddleware<AppState, GetAccountAction>(loadAccount),
    TypedMiddleware<AppState, LoadAccountImagesAction>(loadAccountImages),
  ];
}

const String ERROR_BAD_RESPONSE = "API had bad response code";
const String ERROR_UNKNOWN = "Unknown error";

Middleware<AppState> _createFilterGallery(GalleryRepository repository) {
  return (Store<AppState> store, action, NextDispatcher next) {
    GalleryFilter filter = action.newFilter;

    next(IsLoadingAction(true));
    repository.getItems(filter).then((response) {
      next(IsLoadingAction(false));
      if (response.isOk()) {
        next(action);//update filter now that is successful.
        next(GalleryLoadedAction(response.body, filter));
      } else {
        next(ApiError(ERROR_BAD_RESPONSE));
      }
    }
    ).catchError((error) => next(ApiError(ERROR_UNKNOWN)));
  };
}

Middleware<AppState> _loadAlbumForId(GalleryRepository repository) {
  return (Store<AppState> store, action, NextDispatcher next) {

    LoadAlbumImagesAction detailsAction = action;

    if (store.state.itemDetails.containsKey(detailsAction.item.id)) {
      GalleryItem existingItem =  store.state.itemDetails[detailsAction.item.id];
      if (existingItem.images.length == existingItem.imagesCount) {
        next(ItemDetailsLoadedAction(detailsAction.item.id, store.state.itemDetails[detailsAction.item.id]));
        return;
      }
    } else if (detailsAction.item.images.length >= detailsAction.item.imagesCount) {
      //only load details if we dont have every image we need.
      next(ItemDetailsLoadedAction(detailsAction.item.id, detailsAction.item));
      return; 
    }

    repository.getAlbumDetails(detailsAction.item.id).then((response) {
      if (response.isOk()) {
        next(ItemDetailsLoadedAction(detailsAction.item.id, response.body));
      } else {
        next(ApiError(ERROR_BAD_RESPONSE));
      }
    }).catchError((error) {
      next(IsLoadingAction(false));
      next(ApiError(ERROR_UNKNOWN));
    });
  };
}

Middleware<AppState> _loadCommentsForId(GalleryRepository repository) {
  return (Store<AppState> store, action, NextDispatcher next) {
    LoadCommentsAction commentsAction = action;

    if (store.state.itemComments.containsKey(commentsAction.itemId)) {
      next(CommentsLoadedAction(commentsAction.itemId, store.state.itemComments[commentsAction.itemId]));
      return;
    }

    repository.getComments(commentsAction.itemId, CommentSort.top).then((response) {
      if (response.isOk()) {
        next(CommentsLoadedAction(commentsAction.itemId, response.body));
      } else {
        next(ApiError(ERROR_BAD_RESPONSE));
      }
    }).catchError((error) => next(ApiError(ERROR_UNKNOWN)));
  };
}

Middleware<AppState> _loadGalleryTags(GalleryRepository repository) {
  return (Store<AppState> store, action, NextDispatcher next) {
    repository.getTags().then((response) {
      if (response.isOk()) {
        next(GalleryTagsLoadedAction(response.body));
      } else {
        next(ApiError(ERROR_BAD_RESPONSE));
      }
    }).catchError((error) => next(ApiError(ERROR_UNKNOWN)));
  };
}

Middleware<AppState> _loadAccount(GalleryRepository repository) {
  return (Store<AppState> store, action, NextDispatcher next) {
    repository.getAccount().then((response) {
      if (response.isOk()) {
        next(AccountLoadedAction(response.body));
        next(LoadAccountImagesAction(0));
      } else {
        next(ApiError(ERROR_BAD_RESPONSE));
      }
    }).catchError((error) => next(ApiError(ERROR_UNKNOWN)));
  };
}

Middleware<AppState> _loadAccountImages(GalleryRepository repository) {
  return (Store<AppState> store, action, NextDispatcher next) {
    int page = action.page;

    repository.getAccountImages(page).then((response) {
      if (response.isOk()) {
        next(AccountImagesLoadedAction(page, response.body));
      } else {
        next(ApiError(ERROR_BAD_RESPONSE));
      }
    }).catchError((error) => next(ApiError(ERROR_UNKNOWN)));
  };
}
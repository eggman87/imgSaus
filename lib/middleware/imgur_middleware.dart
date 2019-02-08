import 'package:imgsrc/action/actions.dart';
import 'package:imgsrc/data/gallery_repository.dart';
import 'package:imgsrc/model/app_state.dart';
import 'package:imgsrc/model/comment_models.dart';
import 'package:imgsrc/model/gallery_models.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createImgurMiddleware([
  GalleryRepository repository = const GalleryRepository(),
]) {
  final filterItems = _createFilterGallery(repository);
  final loadComments = _loadCommentsForId(repository);

  return [
    TypedMiddleware<AppState, UpdateFilterAction>(filterItems),
    TypedMiddleware<AppState, LoadCommentsAction>(loadComments),
  ];
}

Middleware<AppState> _createFilterGallery(GalleryRepository repository) {
  return (Store<AppState> store, action, NextDispatcher next) {
    GalleryFilter filter = action.newFilter;

    repository.getItems(filter.section, filter.sort, filter.window, filter.page).then((response) {
      if (response.isOk()) {
        store.dispatch(GalleryLoadedAction(response.body));
      } else {
        store.dispatch(ApiError("API had bad response code"));
      }
    }
    ).catchError((error) => store.dispatch(ApiError("unknown error")));
  };
}

Middleware<AppState> _loadCommentsForId(GalleryRepository repository) {
  return (Store<AppState> store, action, NextDispatcher next) {
    LoadCommentsAction commentsAction = action;

    if (store.state.itemComments.containsKey(commentsAction.itemId)) {
      store.dispatch(CommentsLoadedAction(commentsAction.itemId, store.state.itemComments[commentsAction.itemId]));
      return;
    }

    repository.getComments(commentsAction.itemId, CommentSort.top).then((response) {
      if (response.isOk()) {
        store.dispatch(CommentsLoadedAction(commentsAction.itemId, response.body));
      } else {
        store.dispatch(ApiError("API had bad response code"));
      }
    }).catchError((error) => store.dispatch(ApiError("unknown error")));
  };
}

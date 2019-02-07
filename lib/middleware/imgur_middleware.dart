import 'package:imgsrc/action/actions.dart';
import 'package:imgsrc/data/gallery_repository.dart';
import 'package:imgsrc/model/app_state.dart';
import 'package:imgsrc/model/gallery_models.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createImgurMiddleware([
  GalleryRepository repository = const GalleryRepository(),
]) {
  final filterItems = _createFilterGallery(repository);

  return [
    TypedMiddleware<AppState, UpdateFilterAction>(filterItems)
  ];
}

Middleware<AppState> _createFilterGallery(GalleryRepository repository) {
  return (Store<AppState> store, action, NextDispatcher next) {
    GalleryFilter filter = action.newFilter;

    repository.getItems(filter.section, filter.sort, filter.window, filter.page).then((items) {
      if (items.isOk()) {
        store.dispatch(GalleryLoadedAction(items.body));
      } else {
        store.dispatch(ApiError("API had bad response code"));
      }
    }
    ).catchError((error) => store.dispatch(ApiError("unknown error")));
  };
}

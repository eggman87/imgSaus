import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:imgsrc/action/actions.dart';
import 'package:imgsrc/model/app_state.dart';
import 'package:imgsrc/model/comment_models.dart';
import 'package:imgsrc/ui/comments_list.dart';
import 'package:redux/redux.dart';

class CommentsSheetContainer extends StatelessWidget {
  CommentsSheetContainer({Key key, this.galleryItemId}) : super(key: key);

  final String galleryItemId;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _CommentsSheetViewModel>(
        onInit: (store) {
          store.dispatch(LoadCommentsAction(galleryItemId));
        },
        converter:(store) => _CommentsSheetViewModel.fromStore(galleryItemId, store),
        builder: (context, vm) {
          return new CommentsList(comments: vm.comments,);
        }
    );
  }
}

class _CommentsSheetViewModel {
  final List<Comment> comments;

  _CommentsSheetViewModel({@required this.comments});

  static _CommentsSheetViewModel fromStore(String galleryItemId, Store<AppState> store){
    return _CommentsSheetViewModel(comments: store.state.itemComments[galleryItemId]);
  }
}

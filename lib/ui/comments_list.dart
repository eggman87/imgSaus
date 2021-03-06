import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:imgsrc/data/gallery_repository.dart';
import 'package:imgsrc/model/comment_models.dart';
import 'package:imgsrc/ui/image_utils.dart';
import 'package:imgsrc/ui/url_handler.dart';
import 'package:timeago/timeago.dart';
import 'package:connectivity/connectivity.dart';

class CommentsList extends StatelessWidget {
  final List<CommentViewItem> commentItems;
  final urlHandler = UrlHandler();
  final ConnectivityResult connectivity;

  CommentsList({Key key, @required List<Comment> comments, this.connectivity})
      : this.commentItems = CommentViewItem._flattenComments(comments, 0);

  int _commentsLength() {
    if (commentItems.length > 0) {
      return commentItems.length;
    } else {
      return 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (commentItems == null) {
      return Container(
        child: Column(children: <Widget>[
          CircularProgressIndicator(),
        ]),
        padding: EdgeInsets.fromLTRB(0, 72, 0, 0),
      );
    }
    return new GestureDetector(
        onTap: () => {},
        child: ListView.builder(
          itemBuilder: (context, index) {
            if (commentItems.length > 0) {
              CommentViewItem viewItem = commentItems[index];
              Comment comment = viewItem.comment;

              final indentColorBase = viewItem.indentLevel;//max((-5 + viewItem.indentLevel).abs(), 1);
              var levelColor = Color((indentColorBase * 0xFFEEEE).toInt() << 0)
                  .withOpacity(1.0);

              return Column(
                children: <Widget>[
                  Divider(
                    color: Colors.black26,
                    height: .1,
                  ),
                  IntrinsicHeight(
                    child: Row(children: [
                      Container(
                        width: 9 * viewItem.indentLevel.toDouble(),
                        color: levelColor,
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            _commentBodyWithInlineImages(context, comment),
                            _authorLine(context, comment),
                          ],
                        ),
                      ),
                    ]),
                  )
                ],
              );
            } else {
              return Container(padding: EdgeInsets.fromLTRB(8, 8, 0, 0),
                  child: Center(child: Text("No comments found"),));
            }
          },
          itemCount: _commentsLength(),
        ));
  }

  Widget _commentBody(BuildContext context, Comment comment) {
    return Container(
      child: SelectableLinkify(
        text: (comment.comment),
        onOpen: (link) => urlHandler.onUrlTapped(context, link.url),
      ),
      padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
      alignment: Alignment(-1.0, -1.0),
    );
  }

  Widget _commentBodyWithInlineImages(BuildContext context, Comment comment) {
    final widgets = List<Widget>();
    widgets.add(
        SelectableLinkify(
          text: (comment.comment),
          onOpen: (link) => urlHandler.onUrlTapped(context, link.url),
        )
    );

    if (connectivity == ConnectivityResult.wifi) {
      final urls = ImageUtils.getImageUrlsFromString(comment.comment);
      for (final url in urls) {
        widgets.add(Align(
          child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 200),
              child: Image.network(url)),
          alignment: Alignment(-1.0, -1.0),
        ));
      }
    }

    return Container(
        padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: widgets,
    ));
  }

  //todo: figure out how to make this more dymnamic in flutter world
  final authorMaxLength = 30;

  Widget _authorLine(BuildContext context, Comment comment) {
    var authorText = comment.author;
    if (authorText.length > authorMaxLength) {
      authorText = authorText.substring(0, authorMaxLength) + "...";
    }
    return Container(
      child: Row(children: <Widget>[
        Text(authorText,
            style: TextStyle(
                color: Colors.redAccent, fontWeight: FontWeight.bold)),
        Text(
          " ${format(comment.dateCreated, locale: "en_short")}",
          style: TextStyle(
              color: Colors.red.shade300, fontStyle: FontStyle.italic),
        ),
        Spacer(),
        Text(
          comment.points.toString(),
          textAlign: TextAlign.right,
          style: TextStyle(fontStyle: FontStyle.italic, color: Colors.red),
        ),
        SizedBox(width:40, height: 20,child:
        PopupMenuButton(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          itemBuilder: (BuildContext context) { return this.itemMenu(context, comment.id); },
          onSelected: (Object value) => onPopupMenuSelected(context, value),
          icon: Icon(Icons.more_horiz, color:Colors.red.shade100),
        )
        )
      ]),
      padding: EdgeInsets.fromLTRB(8, 2, 4, 4),
      alignment: Alignment(-1.0, 0),
    );
  }

  List<PopupMenuEntry<Object>> itemMenu(BuildContext context, int commentId) {
    final list = List<PopupMenuEntry<Object>>();
    list.add(PopupMenuItem(child: Text("Report"), value: ReportComment(commentId),));
    return list;
  }

  void onPopupMenuSelected(BuildContext context, Object value) {
    if (value is ReportComment) {
      reportComment(context, value.commentId.toString());
    }
  }

  Future<void> reportComment(BuildContext context, String commentId) async {
    final repo = new GalleryRepository();
    var result = await repo.reportComment(commentId);
    if (result.body) {
      showReportDialog(context, "Report sent to imgur. Please allow time for moderation team to review.");
    } else {
      showReportDialog(context, "Error sending report to imgur.");
    }
  }

  void showReportDialog(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Report Comment"),
            content: Text(message),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
    );
  }
}

class ReportComment {
  final int commentId;

  ReportComment(this.commentId);

}



class CommentViewItem {
  final Comment comment;
  final int indentLevel;

  CommentViewItem(this.comment, this.indentLevel);

  static List<CommentViewItem> _flattenComments(
      List<Comment> comments, int indentLevel) {
    if (comments == null) {
      return null;
    }
    if (comments.length == 0) {
      return List();
    }

    var flattenedComments = List<CommentViewItem>();
    for (var comment in comments) {
      flattenedComments.add(CommentViewItem(comment, indentLevel));
      if (comment.replies.length > 0) {
        flattenedComments
            .addAll(_flattenComments(comment.replies, indentLevel + 1));
      }
    }
    return flattenedComments;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:imgsrc/model/comment_models.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:timeago/timeago.dart';

class CommentsList extends StatelessWidget {
  List<CommentViewItem> commentItems;

  CommentsList({Key key, @required List<Comment> comments}) {
    this.commentItems = _flattenComments(comments, 0);
  }

  int _commentsLength() {
    if (commentItems.length > 0) {
      return commentItems.length;
    } else {
      return 1;
    }
  }

  Widget _photoOrWebView(String url) {
    String lowerUrl = url.toLowerCase();
    if (lowerUrl.contains(".jpg") || (url.contains(".gif") && !url.contains(".gifv")) || url.contains(".png")) {
      return Image.network(url);
    } else {
      return WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
      );
    }
  }

  void _onUrlTapped(BuildContext context, String url) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) => SimpleDialog(
              contentPadding: EdgeInsets.zero,
              children: <Widget>[
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 400, maxWidth: 600),
                  child: Container(
                    color: Colors.black,
                    child: _photoOrWebView(url),
                  ),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
        onTap: () => {},
        child: ListView.builder(
          itemBuilder: (context, index) {
            if (commentItems != null && commentItems.length > 0) {
              CommentViewItem viewItem = commentItems[index];
              Comment comment = viewItem.comment;

              return Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(16 * viewItem.indentLevel.toDouble(), 0, 0, 0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Linkify(
                            text: (comment.comment),
                            onOpen: (url) => _onUrlTapped(context, url),
                          ),
                          padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                          alignment: Alignment(-1.0, -1.0),
                        ),
                        Container(
                          child: Row(children: <Widget>[
                            Text(comment.author,
                                style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                            Text(
                              " ${format(comment.dateCreated, locale: "en_short")}",
                              style: TextStyle(color: Colors.red.shade300, fontStyle: FontStyle.italic),
                            ),
                            Spacer(),
                            Text(
                              comment.points.toString(),
                              textAlign: TextAlign.right,
                              style: TextStyle(fontStyle: FontStyle.italic, color: Colors.red),
                            )
                          ]),
                          padding: EdgeInsets.fromLTRB(8, 2, 4, 4),
                          alignment: Alignment(-1.0, 0),
                        )
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return Container(
                child: Column(children: <Widget>[
                  CircularProgressIndicator(),
                ]),
                padding: EdgeInsets.fromLTRB(0, 72, 0, 0),
              );
            }
          },
          itemCount: _commentsLength(),
        ));
  }

  List<CommentViewItem> _flattenComments(List<Comment> comments, int indentLevel) {
    if (comments == null || comments.length == 0) {
      return List();
    }

    var flattenedComments = List<CommentViewItem>();
    for (var comment in comments) {
      flattenedComments.add(CommentViewItem(comment, indentLevel));
      if (comment.replies.length > 0) {
        flattenedComments.addAll(_flattenComments(comment.replies, indentLevel + 1));
      }
    }
    return flattenedComments;
  }
}

class CommentViewItem {
  final Comment comment;
  final int indentLevel;

  CommentViewItem(this.comment, this.indentLevel);
}

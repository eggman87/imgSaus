import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:imgsrc/model/comment_models.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:timeago/timeago.dart';

class CommentsList extends StatelessWidget {
  final List<CommentViewItem> commentItems;

  CommentsList({Key key, @required List<Comment> comments})
      : this.commentItems = CommentViewItem._flattenComments(comments, 0);

  int _commentsLength() {
    if (commentItems.length > 0) {
      return commentItems.length;
    } else {
      return 1;
    }
  }

  Widget _photoOrWebView(String url) {
    String lowerUrl = url.toLowerCase();
    if (lowerUrl.contains(".jpg") ||
        (url.contains(".gif") && !url.contains(".gifv")) ||
        url.contains(".png")) {
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

              final indentColorBase = max((-5 + viewItem.indentLevel).abs(), 1);
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
                            _commentBody(context, comment),
                            _authorLine(comment),
                          ],
                        ),
                      ),
                    ]),
                  )
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

  Widget _commentBody(BuildContext context, Comment comment) {
    return Container(
      child: Linkify(
        text: (comment.comment),
        onOpen: (url) => _onUrlTapped(context, url),
      ),
      padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
      alignment: Alignment(-1.0, -1.0),
    );
  }

  //todo: figure out how to make this more dymnamic in flutter world
  final authorMaxLength = 30;

  Widget _authorLine(Comment comment) {
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
        )
      ]),
      padding: EdgeInsets.fromLTRB(8, 2, 4, 4),
      alignment: Alignment(-1.0, 0),
    );
  }
}

class CommentViewItem {
  final Comment comment;
  final int indentLevel;

  CommentViewItem(this.comment, this.indentLevel);

  static List<CommentViewItem> _flattenComments(
      List<Comment> comments, int indentLevel) {
    if (comments == null || comments.length == 0) {
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

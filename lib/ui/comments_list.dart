
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:imgsrc/model/comment_models.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:timeago/timeago.dart';

class CommentsList extends StatelessWidget {

  final List<Comment> comments;

  CommentsList({ Key key, @required this.comments });

  int _commentsLength() {
    if (comments != null) {
      return comments.length;
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
            if (comments != null) {
              Comment comment = comments[index];
              return Column(
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
                      Text(comment.author, style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                      Text(" ${format(comment.dateCreated, locale: "en_short")}", style: TextStyle(color: Colors.red.shade300, fontStyle: FontStyle.italic),),
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
}
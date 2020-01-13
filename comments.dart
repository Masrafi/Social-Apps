import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/pages/home.dart';
import 'package:fluttershare/widgets/header.dart';
import 'package:fluttershare/widgets/progress.dart';
import 'package:timeago/timeago.dart' as timeago;

class Comments extends StatefulWidget {
  final String postId;
  final String postMediaUrl;
  final String postOwnerId;
  Comments({
    this.postId,
    this.postMediaUrl,
    this.postOwnerId,
  });
  @override
  CommentsState createState() => CommentsState(
        postId: this.postId,
        postMediaUrl: this.postMediaUrl,
        postOwnerId: this.postOwnerId,
      );
}

class CommentsState extends State<Comments> {
  TextEditingController commentsController = TextEditingController();
  final String postId;
  final String postMediaUrl;
  final String postOwnerId;
  CommentsState({
    this.postId,
    this.postMediaUrl,
    this.postOwnerId,
  });
  buildComments() {
    return StreamBuilder(
      stream: commentsRef
          .document(postId)
          .collection('comments')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        List<Comment> comments = [];
        snapshot.data.documents.forEach((doc) {
          comments.add(Comment.fromDocument(doc));
        });
        return ListView(children: comments);
      },
    );
  }

  addComments() {
    commentsRef.document(postId).collection('comments').add({
      'userId': currentUser.id,
      'username': currentUser.username,
      'comment': commentsController.text,
      'avatarUrl': currentUser.photoUrl,
      'timestamp': timestamp,
    });
    bool isNotOwnerPost = postOwnerId != currentUser.id;
    if (isNotOwnerPost) {
      activityFeedRef.document(postOwnerId).collection('feedItems').add({
        'type': 'comment',
        'commentData': commentsController.text,
        'userId': currentUser.id,
        'username': currentUser.username,
        'mediaUrl': postMediaUrl,
        'userProfileImg': currentUser.photoUrl,
        'timestamp': timestamp,
        'postId': postId
      });
    }

    commentsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, titleText: 'Comments'),
      body: Column(
        children: <Widget>[
          Expanded(child: buildComments()),
          Divider(),
          ListTile(
            title: TextFormField(
              controller: commentsController,
              decoration: InputDecoration(
                labelText: 'Write a Comments',
              ),
            ),
            trailing: OutlineButton(
              onPressed: addComments,
              borderSide: BorderSide.none,
              child: Text('Post'),
            ),
          ),
        ],
      ),
    );
  }
}

class Comment extends StatelessWidget {
  final String userId;
  final String username;
  final String comment;
  final String avatarUrl;
  final Timestamp timestamp;
  Comment({
    this.userId,
    this.username,
    this.comment,
    this.avatarUrl,
    this.timestamp,
  });
  factory Comment.fromDocument(DocumentSnapshot doc) {
    return Comment(
      userId: doc['userId'],
      username: doc['username'],
      comment: doc['comment'],
      avatarUrl: doc['avatarUrl'],
      timestamp: doc['timestamp'],
    );
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(comment),
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(avatarUrl),
          ),
          subtitle: Text(timeago.format(timestamp.toDate())),
        ),
      ],
    );
  }
}

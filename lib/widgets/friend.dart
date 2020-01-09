

import 'package:flutter/material.dart';
import '../main.dart';
class Friend extends StatefulWidget {
  final sender;
  final counter;
  Friend({this.sender, this.counter});
  @override
  _FriendState createState() => _FriendState();
}

class _FriendState extends State<Friend> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Navigator.of(context).pushNamed(ChatScreen.route , arguments: widget.sender),
      leading: CircleAvatar(
        child: Text(widget.sender[0]),
      ),
      title: Text(widget.sender),
    );
  }
}

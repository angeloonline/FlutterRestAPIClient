import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:resta_api_client/services/PostService.dart';

class PostDelete extends StatefulWidget{
  final String postId;
  PostDelete(this.postId);

  @override
  _PostDeleteState createState() => _PostDeleteState();
}

class _PostDeleteState extends State<PostDelete> {
  final service = GetIt.I<PostService>();

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
            title: Text('Attenzione'),
            content: Text('Sei sicuro di voler cancellare?'),
            actions: <Widget>[
              FlatButton(
                child: Text('Yes'),
                onPressed: () async {
                  
                  final deleteResult = await service.deletePost(widget.postId);
                  if(deleteResult)
                    Navigator.of(context).pop(true);
                  else
                    Text('Error!');
                },
              ),
              FlatButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
            ],
              
    );
  }
}
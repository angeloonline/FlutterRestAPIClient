import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:resta_api_client/models/Post.dart';
import 'package:resta_api_client/services/PostService.dart';

class PostView extends StatefulWidget{
  final String postId;
  PostView({this.postId});


  @override
  _PostViewState createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  bool get isEditing => widget.postId != null;
  final service = GetIt.I<PostService>();
  TextEditingController _postTitleController = TextEditingController();
  TextEditingController _postDescriptionController = TextEditingController();
  bool isLoading = false;


  @override
  void initState() {
    super.initState();
    if (isEditing){
      
      setState(() {
        isLoading = true;
      });
      service.getPost(widget.postId).then((response){
        
        setState(() {
          isLoading = false;
        });
        _postTitleController.text = response.title;
        _postDescriptionController.text = response.description;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(title: Text(isEditing ? 'Modify Post' : "Create Post")),
        body: isLoading ? Center(child: CircularProgressIndicator()) : Container(
          padding: EdgeInsets.all(8.0),
          child: Column(
                children: <Widget> [
                      TextField(
                      controller: _postTitleController,
                      decoration: InputDecoration(
                        hintText: 'Post title'
                      )
                      ),
                      Container(height: 8,),
                      TextField(
                      controller: _postDescriptionController,
                      decoration: InputDecoration(
                        hintText: 'Post description'
                      )
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: RaisedButton(
                          child: Text('Submit', style: TextStyle(color: Colors.white)),
                          color: Theme.of(context).primaryColor,
                          onPressed: () async {
                            print("Is editing?: $isEditing");
                            if (isEditing) {
                              setState(() {
                                isLoading = true;
                              });
                              final post = Post(
                                title: _postTitleController.text,
                                description: _postDescriptionController.text
                              );
                              final result = await service.updatePost(widget.postId, post);
                              
                              setState(() {
                                isLoading = false;
                              });
                              final title = 'Done';
                              final text = result ?  'Your post was updated' : 'error';
                              print (text);
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: Text(title),
                                  content: Text(text),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text('Ok'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                )
                              );  
                              }else{
                                  setState(() {
                                    isLoading = true;
                                  });
                                  final post = Post(
                                    title: _postTitleController.text,
                                    description: _postDescriptionController.text
                                  );
                                  final result = await service.createPost(post);
                                  
                                  setState(() {
                                    isLoading = false;
                                  });
                                  final title = 'Done';
                                  final text = result ?  'Your post was created' : 'error';
                                  print (text);
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: Text(title),
                                      content: Text(text),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text('Ok'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        )
                                      ],
                                    )
                                  );
                              }
                          }
                        )    
                      )
                    ])  
        )      
    );
  }
}
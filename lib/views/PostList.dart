import 'package:flutter/material.dart'; 
import 'package:get_it/get_it.dart';
import 'package:resta_api_client/services/PostService.dart';

import '../models/Post.dart';
import '../views/PostView.dart';
import 'PostDelete.dart';

class MyHomeLayout extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MyBodyLayout();
  }
}

class MyBodyLayout extends StatefulWidget{
  @override
  PostListState createState() {
    return PostListState();
  }
}

  class PostListState extends State<MyBodyLayout>{

    final service = GetIt.I<PostService>();
    Future<List<Post>> futurePosts;
    var refreshKey = GlobalKey<RefreshIndicatorState>();
  
    fetchPosts() async{    
      setState(() {
        futurePosts = service.getPostList();
      });
    }

    @override
    void initState() {
      fetchPosts();
      super.initState();
    }

    @override
    Widget build(BuildContext context) {
        return myScaffoldView();
    }

    Widget myScaffoldView() {
      return Scaffold(
            appBar: AppBar(
              title: Text('Client REST API'),
              actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.refresh),
                    tooltip: 'Refresh',
                    onPressed: () => refreshKey.currentState.show()
                    )
              ],),
            body: _postListView(),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => PostView(postId: null))
                ).then((_) {
                  fetchPosts();
                });
                },
              child: Icon(Icons.add),
            )
        );
    }
      
    Widget _postListView() {
      return  RefreshIndicator(
                key: refreshKey,
                onRefresh: () => fetchPosts(),
                child: FutureBuilder<List<Post>>(
                      future: futurePosts,
                      builder: (context, snapshot) {
                        print('has data: ${snapshot.hasData}');
                        if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }
                        if (snapshot.hasData) {                          
                          return ListView.separated(
                            separatorBuilder: (context, index){
                              return Divider(height: 0, color: Colors.black54);
                            },
                            scrollDirection: Axis.vertical,
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                            print('Number of Posts: ${snapshot.data.length}');
                            print('Index of data posts : ${snapshot.data[index].id}');
                            return Dismissible(
                              key: ValueKey(snapshot.data[index].id),
                              direction: DismissDirection.startToEnd,
                              onDismissed: (direction) {
                                snapshot.data.remove(snapshot.data[index]);
                              },
                              confirmDismiss: (direction) async {
                                final deleteResult = await showDialog(context: context, builder: (_) => PostDelete(snapshot.data[index].id));
                                  var message = '';
                                  if (deleteResult != null && deleteResult == true) {
                                    message = 'The Post was deleted successfully';
                                  } 
                                  else if (deleteResult == false) {
                                    message = 'The Post was not deleted';
                                  }
                                  else {
                                    message = deleteResult ?? 'An error occrued';
                                  }
                                  Scaffold.of(context).showSnackBar(SnackBar(content: Text(message),duration: new Duration(milliseconds: 1000)));
                                
                                return deleteResult;
                              },                              
                              background: _dismissBackgoundContainer(),
                              // card containing Post infos
                              child: Container(
                                padding: EdgeInsets.all(5.0),
                                child: ListTile(                                  
                                  leading: CircleAvatar(
                                    child: Icon(Icons.event_note)
                                  ),
                                  trailing: Icon(Icons.keyboard_arrow_right),
                                  title: Text(snapshot.data[index].title),
                                  subtitle: Text('${snapshot.data[index].description} \n ' + formatDate(snapshot.data[index].date)),
                                  onTap: () {
                                    print('on Tap -> Index of data posts : ${snapshot.data[index].id}');
                                    _navigateToPostView(snapshot.data[index].id);   
                                  },
                                  onLongPress: (){
                                    print('On long press -> remove item: ${snapshot.data[index].id}');
                                  }
                              ))
                            );
                          }                          
                          );
                        }
                        // By default, show a loading spinner.
                        return Center(
                          child: CircularProgressIndicator()
                        );
                      }
          )
     );
     
   }

  
  String formatDate(DateTime date){
    return '${date.day}/${date.month}/${date.year}';
  }

  void _navigateToPostView(String postId){
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => PostView(postId: postId))
    ).then((_) {
      refreshKey.currentState.show();
    });
  }

}

Widget _dismissBackgoundContainer(){
  return Container(
          color: Colors.red,
          padding: EdgeInsets.only(left: 16),
          child: Align(
            child: Icon(Icons.delete, color: Colors.white),
            alignment: Alignment.centerLeft,
          ),
        );                              
}

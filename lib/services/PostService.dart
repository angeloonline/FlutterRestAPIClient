import 'dart:convert';

import 'package:resta_api_client/models/Post.dart';
import 'package:http/http.dart' as http;

import 'exceptions.dart';

class PostService{
  static const apiURL = 'https://www.devnode.it/rest-api/';
  static const apiURLLocal = 'http://192.168.1.11:4000';
  
  static const headers = {"Content-type": "application/json"};

  dynamic _response(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        var responseJson = json.decode(response.body.toString());        
        print('JSON Data received: $responseJson');
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:

      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:

      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

  Future<List<Post>> getPostList () async{
    final response = await http.get(apiURL + '/posts/');
    var jsonData = _response(response);
    final posts = <Post>[];
    for (var post in jsonData){
      posts.add(Post.fromJson(post));
    }
    return posts;
  }

  Future<Post> getPost(String postId) async{
    final response = await http.get(apiURL + '/posts/'+ postId);
    var jsonData = _response(response);
    return Post.fromJson(jsonData);
  }

  Future<bool> updatePost(String postId, Post post) async{
    print(postId);
    print(json.encode(post.toJson()));
    final response = await http.put(apiURL + '/posts/' + postId, headers: headers, body: json.encode(post.toJson()));
    
    var jsonData = _response(response);
    return true;
    
  }

  Future<bool> createPost(Post post) async{
    print(json.encode(post.toJson()));
    final response = await http.post(apiURL + '/posts/', headers: headers, body: json.encode(post.toJson()));
    var jsonData = _response(response);
    return true;
  }

  Future<bool> deletePost(String postId) async{
    print(postId);
    final response = await http.delete(apiURL + '/posts/' + postId, headers: headers);
    var jsonData = _response(response);
    return true;    
  }
}

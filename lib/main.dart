import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:resta_api_client/services/PostService.dart';
import 'package:resta_api_client/views/PostList.dart';

void setupLocator(){
  GetIt.instance.registerLazySingleton(
    () => PostService()
  );
}

void main(){
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Main App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: MyHomeLayout()
        );
  }
}
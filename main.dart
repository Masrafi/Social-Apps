import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/pages/home.dart';

void main() {
  Firestore.instance.settings(timestampsInSnapshotsEnabled: true).then((_) {
    print('Timestamp is Enabled in Snapshot\n');
  }, onError: (_) {
    print('Erro Timestamp is Enabled in Snapshot\n');
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterShare',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.teal,
      ),
      home: Home(),
    );
  }
}

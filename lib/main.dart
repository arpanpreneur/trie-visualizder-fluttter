import 'package:flutter/material.dart';
import 'package:trievisualize/data_structures/TrieNode.dart';
import 'package:trievisualize/widgets/TrieBuilder.dart';
import 'package:trievisualize/widgets/TrieNodeBuilder.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trie Visualizer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primarySwatch: Colors.teal,
      ),
      home: MyHomePage(title: 'Trie Visualizer'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {

    return Container(
      child: TrieBuilder(),
    );

  }
}

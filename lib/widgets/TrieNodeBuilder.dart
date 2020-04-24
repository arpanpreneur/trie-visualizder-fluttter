import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:trievisualize/data_structures/Trie.dart';
import 'package:trievisualize/data_structures/TrieNode.dart';
import 'package:trievisualize/view_models/AlgoState.dart';

class TrieNodeBuilder extends StatefulWidget {
  final TrieNode node;
  final Trie trie;
  final double width;

  TrieNodeBuilder({@required this.node, @required this.width, @required this.trie});

  @override
  _TrieNodeBuilderState createState() => _TrieNodeBuilderState();
}

class _TrieNodeBuilderState extends State<TrieNodeBuilder> {

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

//    if (widget.node.isRootNode && widget.node.isLeafNode) {
//      return Container(
//        padding: EdgeInsets.all(10.0),
//        width: MediaQuery.of(context).size.width,
//        child: Center(child: Text("No Words in Trie! Try Adding a few", style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w300),)),
//      );
//    }

    return Consumer<AlgoState>(
      builder: (context, algoState, child) {
        return Padding(
          padding: EdgeInsets.only(
            top: 1.0,
          ),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 0),
            width:  (widget.node.isLeafNode) ? 20 : widget.trie.getTotalLeafNodeCount(root: widget.node)*20.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  height: 30,
                  decoration: BoxDecoration(
                    border: Border.all(style: BorderStyle.solid, color: Colors.white),
                    color: algoState.getNodeColor(widget.node),
                  ),


                  child: (widget.node.isRootNode)
                      ? null
                      : Center(
                      child: Text(
                        widget.node.ch,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      )
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.node.children.keys
                      .map((key) => TrieNodeBuilder(
                    node: widget.node.getChildNode(key),
                    width: (widget.width / widget.node.childrenCount),
                    trie: widget.trie,
                  ))
                      .toList(),
                ),
              ],
            ),
          ),
        );
      },

    );


  }


}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:trievisualize/data_structures/TrieNode.dart';

class AlgoState with ChangeNotifier {
  Set<TrieNode> _visited = Set();

  Set<String> outputWords = Set();

  bool _started = false;
  bool _finished = false;
  bool _paused = false;

  int _delay = 0;

  void setDelay(int d) {
    this._delay = d;
    notifyListeners();
  }

  get delay => this._delay;

  void setStart(bool val) {
    this.reset();
    this._started = val;
    notifyListeners();
  }

  get started => this._started;

  //void setRunning(bool val) => this._running = val;
  get running => this._started && !(this._finished || this._paused);

  void setFinish(bool val) {
    this._finished = val;
    notifyListeners();
  }

  get finished => this._finished;

  void setPause(bool val) {
    this._paused = val;
    notifyListeners();
  }

  void registerVisitedNode(TrieNode node) {
    _visited.add(node);
    notifyListeners();
  }

  bool isVisited(TrieNode node) {
    return _visited.contains(node);
  }

  void reset() {
    _started = false;
    _finished = false;
    _paused = false;
    _visited.clear();
    outputWords.clear();

    notifyListeners();
  }

  get paused => this._paused;


  Color getNodeColor(TrieNode node) {
    if (node.isRootNode && node.isLeafNode) {
      return Colors.white;
    } else if (node.isRootNode) {
      return Colors.grey;
    } else {

      if (node.isWordEnd) {
        if (this.isVisited(node)) {
          return Colors.orangeAccent[400];
        }
        return Colors.yellow[200];
      }
      if (this.isVisited(node)) {
        return Colors.green[300];
      }
    }
    // Default Node color
    return Colors.blue[100];
  }

  String toString() {
    return "started=$started, finished=$finished, running=$running, visited=$_visited, outputWords=$outputWords";
  }
}


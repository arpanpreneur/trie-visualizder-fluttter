import 'package:flutter/foundation.dart';
import 'package:trievisualize/data_structures/TrieNode.dart';
import 'package:trievisualize/utils.dart';
import 'dart:math';

import 'package:trievisualize/view_models/AlgoState.dart';

class Trie {
  TrieNode head = TrieNode();

//  InsertState insertState = new InsertState();
//  SearchState searchState = new SearchState();

  AlgoState algoState = new AlgoState();

  Trie();


  Trie.fromList(List<String> words) {
    for (String word in words) {
      this.insert(word);
    }
    algoState.reset();
  }

  void insert(String word) async {

    word = word.toLowerCase();
    algoState.setStart(true);

    TrieNode currentNode = this.head;

    for (int i = 0; i < word.length; i++) {
      algoState.registerVisitedNode(currentNode);
      await pause(this.algoState.delay);

      String ch = word[i];


      if (currentNode.containsChild(ch)) {
        currentNode = currentNode.getChildNode(ch);
      } else {
        currentNode = currentNode.addChildNode(TrieNode(ch: ch));
      }

    }

    currentNode.setWordEnd();
    algoState.setFinish(true);
  }

  bool contains(String word) {
    TrieNode currentNode = this.head;

    for (int i = 0; i < word.length; i++) {
      String ch = word[i];
      if (currentNode.containsChild(ch)) {
        currentNode = currentNode.getChildNode(ch);
      } else {
        return false;
      }
    }

    return currentNode.isWordEnd;
  }

  Future<TrieNode> _getNodeTill(String prefix) async {
    TrieNode currentNode = this.head;

    for (int i = 0; i < prefix.length; i++) {
      await pause(algoState.delay);
      algoState.registerVisitedNode(currentNode);

      String ch = prefix[i];
      if (currentNode.containsChild(ch)) {
        currentNode = currentNode.getChildNode(ch);
      } else {
        throw Exception;
      }
    }

    return currentNode;
  }

  Future<Set<String>> wordsWithPrefixHelper(String prefix,
      {Set<String> words, TrieNode root}) async {
    //print("Started searching with prefix $prefix");
    if (words == null) {
      words = Set();
    }

    if (root == null) {
      root = await _getNodeTill(prefix);
    }

    algoState.registerVisitedNode(root);

    //print(root);
    if (root.isWordEnd) words.add(prefix);

    if (!root.isLeafNode) {
      for (String ch in root.children.keys) {
        await pause(algoState.delay);
        wordsWithPrefixHelper(prefix + ch, words: words, root: root.getChildNode(ch));
      }
    }

    return words;
  }

  void wordsWithPrefix(String prefix) async {
    try {
      algoState.reset();
      algoState.setStart(true);
      algoState.outputWords = await wordsWithPrefixHelper(prefix);
      algoState.setFinish(true);
    } catch (ex) {
      algoState.setFinish(true);
    }

  }


  int getDepth({TrieNode root}) {
    if (root == null) {
      root = this.head;
    }

    if (root.isLeafNode) {
      // Base Case
      return 0;
    }
    return 1 +
        root.children.values.map((node) => getDepth(root: node)).reduce(max);
  }

  int _getImmeditateLeafNodeCount(TrieNode root) {
    int cnt = 0;

    for (var node in root.children.values) {
      if (node.isLeafNode) {
        cnt++;
      }
    }

    return cnt;
  }

  int getTotalLeafNodeCount({TrieNode root}) {
    if (root == null) {
      root = this.head;
    }

    if (root.isLeafNode) {
      return 1;
    }

    return root.children.values.map((node) => getTotalLeafNodeCount(root: node)).reduce((a, b) => a + b);
  }

  int getMaxChildrenCount({TrieNode root, int maxChildren = 0}) {
    if (root == null) {
      root = this.head;
    }

    if (root.isLeafNode) {
      return 0;
    }

    return max(root.childrenCount, root.children.values.map((node) => getMaxChildrenCount(root: node)).reduce(max));

  }


}
//void main() {
//  Trie trie =
//  Trie.fromList(["foo", "bar", "barz", "barr", "apple", "app", "animal"]);
//
//  print(trie.contains("foo"));
//  print(trie.contains("ba"));
//  print(trie.contains("barz"));
//  print(trie.contains("app"));
//
//  print(trie.wordsWithPrefix("ap"));
//  print(trie.wordsWithPrefix("a"));
//  print(trie.wordsWithPrefix("bar"));
//}

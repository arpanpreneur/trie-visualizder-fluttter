class TrieNode {
  String ch;
  Map<String, TrieNode> children = {};
  bool isWordEnd;


  void setWordEnd() {
    this.isWordEnd = true;
  }

  bool containsChild(String ch) {
    return this.children.containsKey(ch);
  }

  TrieNode getChildNode(String ch) {
    return this.children[ch];
  }

  TrieNode addChildNode(TrieNode node) {
    this.children[node.ch] = node;
    return node;
  }

  bool get isLeafNode => this.children.isEmpty;
  bool get isRootNode => this.ch == null;

  int get childrenCount => this.children.keys.length;

  String toString() {
    return '$ch -> ${children.keys} isWordEnd = $isWordEnd';
  }

  TrieNode({this.ch}) {
    isWordEnd = false;
  }
}
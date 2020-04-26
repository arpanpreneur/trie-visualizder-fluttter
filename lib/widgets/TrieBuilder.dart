import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import 'package:trievisualize/data_structures/Trie.dart';
import 'package:trievisualize/utils.dart';
import 'package:trievisualize/view_models/AlgoState.dart';
import 'package:trievisualize/widgets/TrieNodeBuilder.dart';

class TrieBuilder extends StatefulWidget {
  @override
  _TrieBuilderState createState() => _TrieBuilderState();
}

class _TrieBuilderState extends State<TrieBuilder> {
  Trie trie;
  String word = "";
  bool isLive = false;

  int lastCallId = 0;

  @override
  void initState() {
    super.initState();
    trie = new Trie();
    print(trie.algoState);

  }

  void callWordsWithPrefix(String prefix) {
    if (lastCallId != 0) {
      trie.algoState.cancelSearch(lastCallId);
    }

    int callId = DateTime.now().millisecondsSinceEpoch;
    trie.wordsWithPrefix(prefix, callId);
    lastCallId = callId;
  }

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: this.trie.algoState),
      ],
      child: Scaffold(

        appBar: AppBar(
          title: Text("Trie Visualizer"),
          actions: <Widget>[
            IconButton(onPressed: () {
              setState(() {
                trie = new Trie();
              });
            }, icon: Icon(Icons.refresh), ),

            IconButton(onPressed: () {
              trie.algoState.reset();

            }, icon: Icon(Icons.format_color_reset),),

            FlatButton(
              colorBrightness: Brightness.dark,
              child: Text("Load Sample Data"),
              onPressed: (!isLive) ? () async {
                List<String> words = await loadWords();
                trie = Trie.fromList(words);
                setState(() {
                  
                });
              } : null,
            ),

          ],
        ),
        body: ListView(
            physics: ClampingScrollPhysics(), children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Consumer<AlgoState>(
                      builder: (context, algoState, child) {
                        return Container(
                          width: 0.55*MediaQuery.of(context).size.width,
                          child: TextField(
                              decoration: InputDecoration(
                                  labelText: "Word",
                                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)))
                              ),
                              onChanged: (val) {
                                this.word = val;
                                if (isLive) {
                                  this.trie.algoState.setDelay(0);
                                  trie.algoState.reset();
                                  
                                  //trie.wordsWithPrefix(word);
                                  callWordsWithPrefix(word);
                                }
                              },
//                            onSubmitted: (val) {
//                              if (!algoState.running && !isLive){
//                                trie.insert(word);
//                              }
//                            }
                          ),
                        );
                      },
                    ),

                    Consumer<AlgoState>(
                      builder: (context, algoState, child) {
                        return Row(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                if (!algoState.running && !isLive){
                                  trie.insert(word);
                                }

                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.search),
                              onPressed: () {
                                if (!algoState.running && !isLive)
                                  //trie.wordsWithPrefix(word);
                                  callWordsWithPrefix(word);
                              },
                            ),
                            Visibility(
                              visible: !isLive,
                              child: IconButton(
                                icon: Icon(Icons.play_arrow),
                                onPressed: () {
                                  setState(() {
                                    isLive = true;
                                  });
                                },
                              ),
                            ),

                            Visibility(
                              visible: isLive,
                              child: IconButton(
                                icon: Icon(Icons.stop),
                                onPressed: () {
                                  setState(() {
                                    isLive = false;
                                    trie.algoState.cancelSearch(lastCallId);
                                    trie.algoState.reset();
                                  });
                                },
                              ),
                            ),

                          ],
                        );
                      },

                    )
                  ],
                ),
              ),
            ),
          ),

          Consumer<AlgoState>(
            builder: (context, algoState, child) {
              return Container(
                width: MediaQuery.of(context).size.width,
                child: Slider(
                  label: "Simulation Speed",
                  value: 2000 - algoState.delay.toDouble(),
                  min: 0,
                  max: 2000,
                  divisions: 10,
                  onChanged: (val) => algoState.setDelay(2000 - val.toInt()),
                ),
              );
            },
          ),

          Consumer<AlgoState>(
            builder: (context, algoState, child) {
              return AnimatedOpacity(
                opacity: (algoState.outputWords.isNotEmpty) ? 1.0 : 0,
                duration: Duration(milliseconds: 500),
                child: Card(
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    padding: EdgeInsets.all(10.0),
                    color: Colors.grey[300],
                    child: (algoState.outputWords.isNotEmpty) ? Text(algoState.outputWords.toString(), style: TextStyle(fontSize: 18),) : null,
                  ),
                ),
              );
            },
          ),


          SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: TrieNodeBuilder(
                node: trie.head,
                trie: trie,
                width: 400,
              ))
        ]),
      ),
    );
  }
}

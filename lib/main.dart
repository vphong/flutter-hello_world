import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

/**
 * Stateless widgets:
 *  - Immutable: properties can’t change. All values are final.
 */
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Startup Name Generator',
      home: new RandomWords(),
    );
  }
}

/**
 * Stateful widgets:
 *  - Maintain state that might change over lifetime of widget.
 * 
 * Implementation requires 2 classes:
 *  1. StatefulWidget that makes an instance of
 *  2. a State class.
 */

class RandomWords extends StatefulWidget {
  @override
  createState() => new RandomWordsState();
}

/**
 * Class: RandomWordsState
 *  Saves:
 *    1) generated WordPairs, created as user infinitely scrolls
 *    2) favorited WordPairs, as user adds or removes them by toggling heart icon
 * 
 */
class RandomWordsState extends State<RandomWords> {

  // prefixing identifier with underscore enforces privacy in Dart
  final _suggestions = <WordPair>[];
  final _saved = Set<WordPair>();
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  /** Basic build method that generates WordPairs.  */
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Startup Name Generator"),
      ),
      body: _buildSuggestions(),
    );
  }

  /** Builds ListView that displays suggested word pairing. */
  Widget _buildSuggestions() {
    return new ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return new Divider();

        final index = i ~/ 2; // ~- integer division

        // if reached end of available pairings
        if (index >= _suggestions.length) {
          // generate 10 more
          _suggestions.addAll(generateWordPairs().take(10));
        }

        return _buildRow(_suggestions[index]);
      },
    );
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);

    return new ListTile(
      title: new Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () { 
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }
}
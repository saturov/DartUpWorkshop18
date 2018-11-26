import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Book Shelf',
      theme: new ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: new SearchScreen(title: 'Book Shelf'),
    );
  }
}

//Виджет экрана поисковой выдачи.
class SearchScreen extends StatefulWidget {
  SearchScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SearchScreenState createState() => new _SearchScreenState();
}

//Состояние экрана поисковой выдачи.
class _SearchScreenState extends State<SearchScreen> {
  List<Book> _items = new List();
  bool _isLoading = false;

  final subject = new PublishSubject<String>();

  @override
  void initState() {
    super.initState();
    subject.stream
        .debounce(new Duration(milliseconds: 600))
        .listen(_textChanged);
  }

  @override
  void dispose() {
    subject.close();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Container(
        padding: new EdgeInsets.all(16.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new TextField(
              decoration: new InputDecoration(
                labelText: "Найти книгу",
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 0.0),
                ),
                border: OutlineInputBorder(),
                labelStyle: new TextStyle(color: Colors.black),
              ),
              onChanged: (string) => (subject.add(string)),
            ),
          ],
        ),
      ),
    );
  }

  void _textChanged(String text) {
    if (text.isEmpty) {
      setState(() {
        _isLoading = false;
      });
      _clearList();
      return;
    }
    setState(() {
      _isLoading = true;
    });
    _clearList();
    //todo network call
  }

  void _clearList() {
    setState(() {
      _items.clear();
    });
  }
}

class Book {
  String title, url;

  Book(String title, String url) {
    this.title = title;
    this.url = url;
  }
}

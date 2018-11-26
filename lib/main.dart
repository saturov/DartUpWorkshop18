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
  }

  @override
  void dispose() {}

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
            ),
          ],
        ),
      ),
    );
  }
}

class Book {
  String title, url;

  Book(String title, String url) {
    this.title = title;
    this.url = url;
  }
}

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:book_list/models/book.dart';
import 'book_page.dart';
import 'package:book_list/utils/utils.dart';

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
            Container(
              child: _isLoading
                  ? Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    )
                  : Container(),
            ),
            Flexible(
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(FadeRoute(
                        builder: (BuildContext context) =>
                            BookNotesPage(_items[index]),
                      ));
                    },
                    child: Card(
                        child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              children: <Widget>[
                                _items[index].url != null
                                    ? new Hero(
                                        child: new ClipRRect(
                                          child:
                                              Image.network(_items[index].url),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15.0)),
                                        ),
                                        tag: _items[index].id,
                                      )
                                    : Container(),
                                Flexible(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child:
                                        Text(_items[index].title, maxLines: 10),
                                  ),
                                ),
                              ],
                            ))),
                  );
                },
              ),
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
    http
        .get("https://www.googleapis.com/books/v1/volumes?q=$text")
        .then((response) => response.body)
        .then(json.decode)
        .then((map) => map["items"])
        .then((list) {
          list.forEach(_onNext);
        })
        .catchError(_onError)
        .then((e) {
          setState(() {
            _isLoading = false;
          });
        });
  }

  void _clearList() {
    setState(() {
      _items.clear();
    });
  }

  void _onNext(dynamic book) {
    setState(() {
      _items.add(new Book(book["volumeInfo"]["title"],
          book["volumeInfo"]["imageLinks"]["smallThumbnail"], book["id"]));
    });
  }

  void _onError(dynamic d) {
    setState(() {
      _isLoading = false;
    });
  }
}

import 'package:flutter/material.dart';
import 'package:book_list/models/book.dart';

//Виджет подробной информации о книге.
class BookNotesPage extends StatefulWidget {
  BookNotesPage(this.book);

  final Book book;

  @override
  State<StatefulWidget> createState() => new _BookNotesPageState();
}

//Состояние виджета информации о книге.
class _BookNotesPageState extends State<BookNotesPage> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: const Text("Книга"),),
      body: new Container(
        child: new Padding(
          padding: new EdgeInsets.all(8.0),
          child: new Column(
            children: <Widget>[
              new Hero(
                  child: new Image.network(widget.book.url),
                  tag: widget.book.id
              ),
              new Expanded(
                child: new Card(
                  child: new Padding(
                    padding: new EdgeInsets.all(8.0),
                    child: new TextField(
                      style: new TextStyle(fontSize: 18.0, color: Colors.black),
                      maxLines: null,
                      decoration: null,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
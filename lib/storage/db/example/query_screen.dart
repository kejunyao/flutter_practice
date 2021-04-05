import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice/storage/db/example/book.dart';
import 'package:flutter_practice/storage/db/example/book_form.dart';
import 'example_database_manager.dart';

/// 查询操作测试
class QueryScreen extends StatefulWidget {
  @override
  _QueryScreenState createState() => _QueryScreenState();
}

class _QueryScreenState extends State<QueryScreen> {

  String queryResult = '';
  BookForm _from;

  @override
  Widget build(BuildContext context) {
    _from = BookForm(idRequire: false, nameRequire: false);
    return Scaffold(
        appBar: AppBar(
          title: Text('Query'),
          actions: [
            GestureDetector(
                onTap: _add,
                child: Icon(Icons.add_circle, color: Colors.white,))
          ],
        ),
        body: SingleChildScrollView(
            child: Column(
              children: [
                _from,
                RaisedButton(
                    onPressed: _queryAll,
                    child: Text('queryAll', style: TextStyle(fontSize: 18, color: Colors.blue))
                ),
                RaisedButton(
                  onPressed: _has,
                  child: Text('has', style: TextStyle(fontSize: 18, color: Colors.blue))
                ),
                RaisedButton(
                  onPressed: _getInt,
                  child: Text('getInt', style: TextStyle(fontSize: 18, color: Colors.blue))
                ),
                RaisedButton(
                    onPressed: _getInts,
                    child: Text('getInts', style: TextStyle(fontSize: 18, color: Colors.blue))
                ),
                RaisedButton(
                    onPressed: _getString,
                    child: Text('getString', style: TextStyle(fontSize: 18, color: Colors.blue))
                ),
                RaisedButton(
                    onPressed: _getStrings,
                    child: Text('getStrings', style: TextStyle(fontSize: 18, color: Colors.blue))
                ),
                RaisedButton(
                    onPressed: _getRowValues,
                    child: Text('getRowValues', style: TextStyle(fontSize: 18, color: Colors.blue))
                ),
                RaisedButton(
                    onPressed: _query,
                    child: Text('query', style: TextStyle(fontSize: 18, color: Colors.blue))
                ),
                RaisedButton(
                    onPressed: _queryMany,
                    child: Text('queryMany', style: TextStyle(fontSize: 18, color: Colors.blue))
                ),
                RaisedButton(
                    onPressed: _rawQuery,
                    child: Text('rawQuery', style: TextStyle(fontSize: 18, color: Colors.blue))
                ),
                Container(
                  child: Text(
                    queryResult,
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                )
              ]
            )
        )
    );
  }

  void _add() async {

  }

  void _queryAll() async {
    List<Book> _books = await ExampleDatabaseManager.instance.queryAll<Book>(Book);
    setState(() {
      queryResult = '$_books';
    });
  }

  void _has() async {
    Book book = _from.getInput();
    if (book == null) return;
    bool has;
    if (book.id != null) has = await ExampleDatabaseManager.instance.has(Book, '${Book.key_id} = ?', whereArgs: [book.id]);
    else if (book.name?.isNotEmpty == true) has = await ExampleDatabaseManager.instance.has(Book, '${Book.key_name} = ?', whereArgs: [book.name]);
    else if (book.desc?.isNotEmpty == true) has = await ExampleDatabaseManager.instance.has(Book, '${Book.key_desc} = ?', whereArgs: [book.desc]);
    setState(() {
      queryResult = 'has: $has';
    });
  }

  void _getInt() async {
    Book book = _from.getInput();
    if (book == null) return;
    int result = await ExampleDatabaseManager.instance.getInt(Book, Book.key_id, '${Book.key_name} = ?', whereArgs: [book.name]);
    setState(() {
      queryResult = 'result: $result';
    });
  }

  void _getInts() async {
    List<int> result = await ExampleDatabaseManager.instance.getInts(Book, Book.key_id, '${Book.key_id} >= ?', whereArgs: [10]);
    setState(() {
      queryResult = 'result: $result';
    });
  }

  void _getString() async {
    String result = await ExampleDatabaseManager.instance.getString(Book, Book.key_name, '${Book.key_id} = ?', whereArgs: [100]);
    setState(() {
      queryResult = 'result: $result';
    });
  }

  void _getStrings() async {
    List<String> result = await ExampleDatabaseManager.instance.getStrings(Book, Book.key_name, '${Book.key_id} >= ?', whereArgs: [100]);
    setState(() {
      queryResult = 'result: $result';
    });
  }

  void _getRowValues() async {
    Map<String, dynamic> result = await ExampleDatabaseManager.instance.getRowValues(Book, [Book.key_name, Book.key_desc], '${Book.key_id} = ?', whereArgs: [100]);
    setState(() {
      queryResult = 'result: $result';
    });
  }

  void _query() async {
    Book result = await ExampleDatabaseManager.instance.query<Book>(Book, '${Book.key_id} = ?', whereArgs: [100]);
    setState(() {
      queryResult = 'result: $result';
    });
  }

  void _queryMany() async {
    List<Book> result = await ExampleDatabaseManager.instance.queryMany<Book>(Book, '${Book.key_id} >= ?', whereArgs: [100]);
    setState(() {
      queryResult = 'result: $result';
    });
  }

  void _rawQuery() async {
    List<Map<String, dynamic>> result = await ExampleDatabaseManager.instance.rawQuery(Book, 'SELECT COUNT(1) FROM book WHERE id >= ?', whereArgs: [100]);
    setState(() {
      queryResult = 'result: $result';
    });
  }


}

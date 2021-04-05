import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice/storage/db/example/book.dart';
import 'package:flutter_practice/storage/db/example/book_form.dart';
import 'example_database_manager.dart';

/// 删除操作测试
class DeleteScreen extends StatefulWidget {
  @override
  _DeleteScreenState createState() => _DeleteScreenState();
}

class _DeleteScreenState extends State<DeleteScreen> {

  String queryResult = '';
  BookForm _from;

  @override
  Widget build(BuildContext context) {
    _from = BookForm(idRequire: false, nameRequire: false);
    return Scaffold(
        appBar: AppBar(
          title: Text('Delete'),
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
                    onPressed: _delete,
                    child: Text('delete', style: TextStyle(fontSize: 18, color: Colors.blue))
                ),
                RaisedButton(
                    onPressed: _deleteAll,
                    child: Text('deleteAll', style: TextStyle(fontSize: 18, color: Colors.blue))
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

  void _delete() async {
    Book book = _from.getInput();
    if (book == null) return;
    String whereClause;
    List<dynamic> whereArgs;
    if (book.id != null) {
      whereClause = '${Book.key_id} = ?';
      whereArgs = [book.id];
    } else if (book.name?.isNotEmpty == true) {
      whereClause = '${Book.key_name} = ?';
      whereArgs = [book.name];
    } else if (book.desc?.isNotEmpty == true) {
      whereClause = '${Book.key_desc} = ?';
      whereArgs = [book.desc];
    }
    if (whereClause == null) {
      return;
    }
    int result = await ExampleDatabaseManager.instance.delete(Book, whereClause, whereArgs: whereArgs);
    List<Book> _books = await ExampleDatabaseManager.instance.queryAll<Book>(Book);
    setState(() {
      queryResult = 'result: $result, $_books';
    });
  }

  void _deleteAll() async {
    int result = await ExampleDatabaseManager.instance.deleteAll(Book);
    List<Book> _books = await ExampleDatabaseManager.instance.queryAll<Book>(Book);
    setState(() {
      queryResult = 'result: $result, books: $_books';
    });
  }
}

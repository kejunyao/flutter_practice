import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice/storage/db/database.dart';
import 'package:flutter_practice/storage/db/example/book.dart';
import 'package:flutter_practice/storage/db/example/book_form.dart';
import 'package:sqflite/sqflite.dart';
import 'example_database_manager.dart';

/// 事务操作测试
class TransactionScreen extends StatefulWidget {
  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {

  final List<Widget> children = [];

  String queryResult = '';

  @override
  void initState() {
    super.initState();
    _buildDefaultWidget();
  }

  void _buildDefaultWidget() {
    children.add(BookForm(idRequire: true, nameRequire: true));
    children.add(RaisedButton(
        onPressed: _transaction,
        child: Text('Transaction', style: TextStyle(fontSize: 18, color: Colors.blue))
    ));
    children.add(Container(
      child: Text(
        queryResult,
        style: TextStyle(fontSize: 16, color: Colors.red),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Transaction'),
          actions: [
            GestureDetector(
                onTap: _add,
                child: Icon(Icons.add_circle, color: Colors.white,))
          ],
        ),
        body: SingleChildScrollView(
            child: Column(
              children: children
            )
        )
    );
  }

  void _add() async {
    children.insert(1, BookForm(idRequire: true, nameRequire: true));
    setState(() {
    });
  }

  void _transaction() async {
    List<Book> books = [];
    children.where((element) => element is BookForm).forEach((element) {
      Book book = (element as BookForm).getInput();
      if (book == null) return;
      books.add(book);
    });
    bool result = await ExampleDatabaseManager.instance.exeTransaction((txn) async {
      Batch batch = txn.batch();
      books.forEach((book) {
        batch.insert('book', Book.toMap(book));
      });
      batch.commit();
      return true;
    });

    List<Book> _books = await ExampleDatabaseManager.instance.queryAll<Book>(Book);
    setState(() {
      queryResult = 'result: $result, $_books';
    });
  }
}

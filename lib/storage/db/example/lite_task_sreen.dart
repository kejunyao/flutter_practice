import 'package:flutter/material.dart';
import 'package:flutter_practice/storage/db/example/book.dart';
import 'package:flutter_practice/storage/db/example/book_form.dart';
import 'package:flutter_practice/storage/db/lite_task.dart';

import 'example_database_manager.dart';

/// LiteTask操作测试
class LiteTaskScreen extends StatefulWidget {
  @override
  _LiteTaskScreenState createState() => _LiteTaskScreenState();
}

class _LiteTaskScreenState extends State<LiteTaskScreen> {
  String queryResult = '';
  BookForm _form;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _form = BookForm(idRequire: true, nameRequire: true);
    return Scaffold(
        appBar: AppBar(
          title: Text('LiteTask'),
        ),
        body: SingleChildScrollView(child: Column(children: [
            Text('LiteTask旨在解决App启动时，在不确定数据库是否已初始化完毕的情况下，做到有效地执行数据库操作', style: TextStyle(fontSize: 10, color: Colors.red)),
          _form,
          RaisedButton(
            onPressed: _insertTask,
            child: Text('insertTask', style: TextStyle(fontSize: 20, color: Colors.blue)),
          ),
          RaisedButton(
            onPressed: _queryAll,
            child: Text('queryAll', style: TextStyle(fontSize: 20, color: Colors.blue)),
          ),
          RaisedButton(
            onPressed: _init,
            child: Text('init', style: TextStyle(fontSize: 20, color: Colors.blue)),
          ),
          Text(
            queryResult,
            style: TextStyle(fontSize: 16, color: Colors.red),
          )
        ])));
  }

  void _insertTask() async {
    Book book = _form?.getInput();
    if (book == null) return;
    InsertTask task = InsertTask(Book, (int result) async {
      List<Book> books = await ExampleDatabaseManager.instance.queryAll<Book>(Book);
      if (!this.mounted) return;
      setState(() {
        queryResult = 'result: $result, books: $books';
      });
    }, book);
    ExampleDatabaseManager.instance.executeSafely(task);
  }

  void _init() async {
    // if (ExampleDatabaseManager.instance.initialized) {
    //   List<Book> books = await ExampleDatabaseManager.instance.queryAll<Book>(Book);
    //   setState(() {
    //     queryResult = 'books: $books';
    //   });
    //   return;
    // }
    ExampleDatabaseManager.instance.init();
    // ExampleDatabaseManager.instance.setOnDatabaseInitialized(() async {
    //   List<Book> books = await ExampleDatabaseManager.instance.queryAll<Book>(Book);
    //   setState(() {
    //     queryResult = 'books: $books';
    //   });
    // });
  }

  void _queryAll() async {
    QueryAllTask task = QueryAllTask(Book, (List result) {
      if (!this.mounted) return;
      setState(() {
        queryResult = 'books: $result';
      });
    });
    ExampleDatabaseManager.instance.executeSafely(task);
  }

}

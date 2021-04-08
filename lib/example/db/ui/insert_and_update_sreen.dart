import 'package:flutter/material.dart';
import 'package:flutter_practice/example/db/book.dart';
import 'package:flutter_practice/example/db/ui/book_form.dart';
import '../example_database_manager.dart';

/// 插入和更新操作测试
class InsertAndUpdateScreen extends StatefulWidget {
  @override
  _InsertAndUpdateScreenState createState() => _InsertAndUpdateScreenState();
}

class _InsertAndUpdateScreenState extends State<InsertAndUpdateScreen> {
  final List<Widget> children = [];

  String queryResult = '';

  @override
  void initState() {
    super.initState();
    _buildDefaultWidget();
    // ExampleDatabaseManager.instance.init();
  }

  void _buildDefaultWidget() {
    children.add(BookForm(idRequire: true, nameRequire: true));
    children.add(RaisedButton(
      onPressed: _insertBook,
      child: Text('insert', style: TextStyle(fontSize: 20, color: Colors.blue)),
    ));
    children.add(RaisedButton(
      onPressed: _updateBook,
      child: Text('update', style: TextStyle(fontSize: 20, color: Colors.blue)),
    ));
    children.add(RaisedButton(
      onPressed: _insertOrUpdate,
      child: Text('insertOrUpdate', style: TextStyle(fontSize: 20, color: Colors.blue)),
    ));
    children.add(RaisedButton(
      onPressed: _updatePart,
      child: Text('updatePart', style: TextStyle(fontSize: 20, color: Colors.blue)),
    ));
    children.add(RaisedButton(
      onPressed: _batchInsert,
      child: Text('batchInsert', style: TextStyle(fontSize: 20, color: Colors.blue)),
    ));
    children.add(RaisedButton(
      onPressed: _batchUpdate,
      child: Text('batchUpdate', style: TextStyle(fontSize: 20, color: Colors.blue)),
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
          title: Text('Insert、Update'),
          actions: [
            GestureDetector(
                onTap: _addForm,
                child: Icon(Icons.add_circle, color: Colors.white,))
          ],
        ),
        body: SingleChildScrollView(child: Column(children: children)));
  }

  void _addForm() {
    children.insert(1, BookForm(idRequire: true, nameRequire: true));
    setState(() {
    });
  }

  /// 插入
  void _insertBook() async {
    Book book = (children.first as BookForm)?.getInput();
    if (book == null) return;
    int code = await ExampleDatabaseManager.instance.insert(Book, book);
    List<Book> books = await ExampleDatabaseManager.instance.queryAll<Book>(Book);
    setState(() {
      queryResult = 'result: $code, books: $books';
    });
  }

  /// 更新
  void _updateBook() async {
    Book book = (children.first as BookForm)?.getInput();
    if (book == null) return;
    int code =
        await ExampleDatabaseManager.instance.update<Book>(Book, book, "${Book.key_id} = ?", whereArgs: [book.id]);
    List<Book> books = await ExampleDatabaseManager.instance.queryAll<Book>(Book);
    setState(() {
      queryResult = 'result: $code, books: $books';
    });
  }

  /// 插入或更新
  void _insertOrUpdate() async {
    Book book = (children.first as BookForm)?.getInput();
    if (book == null) return;
    int code = await ExampleDatabaseManager.instance
        .insertOrUpdate<Book>(Book, book, "${Book.key_id} = ?", whereArgs: [book.id]);
    List<Book> books = await ExampleDatabaseManager.instance.queryAll<Book>(Book);
    setState(() {
      queryResult = 'result: $code, books: $books';
    });
  }

  /// 部分更新
  void _updatePart() async {
    Book book = (children.first as BookForm)?.getInput();
    if (book == null) return;
    Map<String, dynamic> values = {};
    values[Book.key_name] = book.name;
    if (book.desc?.isNotEmpty == true) values[Book.key_desc] = book.desc;
    int code = await ExampleDatabaseManager.instance.updatePart(Book, values, '${Book.key_id} = ?', whereArgs: [book.id]);
    List<Book> books = await ExampleDatabaseManager.instance.queryAll<Book>(Book);
    setState(() {
      queryResult = 'result: $code, books: $books';
    });
  }

  /// 批量插入
  void _batchInsert() async {
    List<Book> books = [];
    children.where((element) => element is BookForm).forEach((element) {
      Book book = (element as BookForm).getInput();
      if (book == null) return;
      books.add(book);
    });
    List<dynamic> result = await ExampleDatabaseManager.instance.batchInsert(
        Book, books,
        exclusive: false, noResult: false, continueOnError: true
    );
    List<Book> _books = await ExampleDatabaseManager.instance.queryAll<Book>(Book);
    setState(() {
      queryResult = 'result: $result, books: $_books';
    });
  }

  /// 批量更新
  void _batchUpdate() async {
    List<Book> books = [];
    children.where((element) => element is BookForm).forEach((element) {
      Book book = (element as BookForm).getInput();
      if (book == null) return;
      books.add(book);
    });
    List<dynamic> result = await ExampleDatabaseManager.instance.batchUpdate(
        Book,
        books,
        Book.key_id,
        exclusive: false, noResult: false, continueOnError: true
    );
    List<Book> _books = await ExampleDatabaseManager.instance.queryAll<Book>(Book);
    setState(() {
      queryResult = 'result: $result, books: $_books';
    });
  }
}

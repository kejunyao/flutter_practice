import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_practice/storage/db/example/book.dart';

import 'example_database_manager.dart';

class InsertBookScreen extends StatefulWidget {
  @override
  _InsertBookScreenState createState() => _InsertBookScreenState();
}

class _InsertBookScreenState extends State<InsertBookScreen> {

  TextEditingController _idController = TextEditingController(text: '');
  TextEditingController _nameController = TextEditingController(text: '');
  TextEditingController _descController = TextEditingController(text: '');

  String _idErrorText = '';
  String _nameErrorText = '';

  String queryResult = '';

  @override
  void initState() {
    super.initState();
    // ExampleDatabaseManager.instance.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('数据库InsertOrUpdate'),
        ),
        body: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _idController,
                  decoration: InputDecoration(
                      hintText: '请输入书籍ID',
                      errorText: _idErrorText
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(9)
                  ],
                  onChanged: _onIdTextChange,
                ),
                TextField(
                    onChanged: _onNameTextChange,
                    controller: _nameController,
                    decoration: InputDecoration(
                        hintText: '请输入书籍名称',
                        errorText: _nameErrorText
                    )
                ),
                TextField(
                    controller: _descController,
                    decoration: InputDecoration(
                        hintText: '请输入书籍描述'
                    )
                ),
                RaisedButton(
                  onPressed: _insertBook,
                  child: Text('insert', style: TextStyle(fontSize: 20, color: Colors.blue)),
                ),
                RaisedButton(
                  onPressed: _updateBook,
                  child: Text('update', style: TextStyle(fontSize: 20, color: Colors.blue)),
                ),
                RaisedButton(
                  onPressed: _insertOrUpdate,
                  child: Text('insertOrUpdate', style: TextStyle(fontSize: 20, color: Colors.blue)),
                ),
                Container(
                  child: Text(queryResult, style: TextStyle(fontSize: 16, color: Colors.red),),
                ),
              ],
            ))
    );
  }

  void _onIdTextChange(String text) {
    if (text.isNotEmpty && _idErrorText.isNotEmpty) {
      setState(() {
        _idErrorText = '';
      });
    }
  }

  void _onNameTextChange(String text) {
    if (text.isNotEmpty && _nameErrorText.isNotEmpty) {
      setState(() {
        _nameErrorText = '';
      });
    }
  }

  /// 检查输入
  Book checkInput() {
    Book book;
    String id = _idController.value.text.trim();
    if (id.isEmpty) {
      setState(() {
        _idErrorText = '请输入书籍ID';
      });
      return book;
    }
    String name = _nameController.value.text.trim();
    if (name.isEmpty) {
      setState(() {
        _idErrorText = '请输入书籍名称';
      });
      return book;
    }
    String desc = _descController.value.text.trim();
    book = Book(int.parse(id), name, desc);
    return book;
  }

  /// 插入
  void _insertBook() async {
    Book book = checkInput();
    if (book == null) return;
    int code = await ExampleDatabaseManager.instance.insert(Book, book);
    List<Book> books = await ExampleDatabaseManager.instance.queryAll<Book>(Book);
    setState(() {
      queryResult = 'code: $code, result: $books';
    });
  }

  /// 更新
  void _updateBook() async {
    Book book = checkInput();
    if (book == null) return;
    int code = await ExampleDatabaseManager.instance.update<Book>(
        Book, book, "${Book.key_id} = ?", whereArgs: [book.id]);
    List<Book> books = await ExampleDatabaseManager.instance.queryAll<Book>(Book);
    setState(() {
      queryResult = 'code: $code, result: $books';
    });
  }

  /// 插入或更新
  void _insertOrUpdate() async {
    Book book = checkInput();
    if (book == null) return;
    int code = await ExampleDatabaseManager.instance.insertOrUpdate<Book>(
        Book, book, "${Book.key_id} = ?", whereArgs: [book.id]);
    List<Book> books = await ExampleDatabaseManager.instance.queryAll<Book>(Book);
    setState(() {
      queryResult = 'code: $code, result: $books';
    });
  }
}

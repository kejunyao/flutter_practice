import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_practice/example/db/book.dart';

/// 书本表单
class BookForm extends StatefulWidget {
  _BookFormState state;

  bool _idRequire;
  bool _nameRequire;
  BookForm({bool idRequire, bool nameRequire, Key key}): super(key: key) {
    _idRequire = idRequire ?? true;
    _nameRequire = nameRequire ?? this;
  }

  @override
  _BookFormState createState() => (state = _BookFormState());

  Book getInput() {
    return state?.getInput();
  }
}

class _BookFormState extends State<BookForm> {
  TextEditingController _idController = TextEditingController(text: '');
  TextEditingController _nameController = TextEditingController(text: '');
  TextEditingController _descController = TextEditingController(text: '');

  String _idErrorText = '';
  String _nameErrorText = '';

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      TextField(
        controller: _idController,
        decoration: InputDecoration(hintText: '请输入书籍ID', errorText: widget._idRequire ? _idErrorText : null),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(9)],
        onChanged: _onIdTextChange,
      ),
      TextField(
          onChanged: _onNameTextChange,
          controller: _nameController,
          decoration: InputDecoration(hintText: '请输入书籍名称', errorText: widget._nameRequire ? _nameErrorText : null)),
      TextField(controller: _descController, decoration: InputDecoration(hintText: '请输入书籍描述'))
    ]);
  }

  @override
  void initState() {
    super.initState();
    widget.state = this;
  }

  @override
  void didUpdateWidget(covariant BookForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.state = this;
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

  Book getInput() {
    Book book;
    String id = _idController.value.text.trim();
    if (id.isEmpty && widget._idRequire) {
      setState(() {
        _idErrorText = '请输入书籍ID';
      });
      return book;
    }
    String name = _nameController.value.text.trim();
    if (name.isEmpty && widget._nameRequire) {
      setState(() {
        _idErrorText = '请输入书籍名称';
      });
      return book;
    }
    String desc = _descController.value.text.trim();
    int _id = id?.isEmpty == true ? null : int.parse(id);
    book = Book(_id, name, desc);
    return book;
  }
}

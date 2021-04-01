import 'dart:io';

import 'package:flutter/material.dart';
import '../compatible_editable_text.dart';
import '../compatible_text_field.dart';

class CompatibleTextEditing extends StatefulWidget {
  @override
  _CompatibleTextEditingState createState() => _CompatibleTextEditingState();
}

class _CompatibleTextEditingState extends State<CompatibleTextEditing> {

  CompatibleTextEditingController _textController = CompatibleTextEditingController(text: '');
  // TextEditingController _textController = TextEditingController();
  FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return _buildInputWidget();
  }

  Widget _buildInputWidget() {
    print('_buildInputWidget: isComposingRangeValid: ${_textController.value.isComposingRangeValid}, validText: ${_textController.validText}, text: ${_textController.value.text}');
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        RaisedButton(onPressed: () {
          print('onPressed: isComposingRangeValid: ${_textController.value.isComposingRangeValid}, validText: ${_textController.validText}, text: ${_textController.value.text}');
        }, child: Text('Click', style: TextStyle(fontSize: 18, color: Colors.blueAccent),),),
        Container(
          constraints: BoxConstraints(minHeight: 48.0, maxHeight: 100.0),
          padding: EdgeInsets.symmetric(vertical: 20),
          margin: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 30),
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          // CompatibleTextField
          child: TextField(
            decoration: InputDecoration(
              hintText: '请输入文本',
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
              isDense: true,
              contentPadding: EdgeInsetsDirectional.only(start: 16.0, end: 12.0),
            ),
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 16.0, color: Colors.black),
            focusNode: _focusNode,
            controller: _textController,
            autocorrect: false,
            autofocus: false,
            maxLines: null,
            textInputAction: Platform.isIOS ? TextInputAction.send : TextInputAction.newline,
            onSubmitted: _onInputSubmit,
            onChanged: _onTextChanged,
            keyboardAppearance: Brightness.light,
          ),
        )
      ],
    );
  }
  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocus);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
    _focusNode.removeListener(_onFocus);
  }

  _onFocus() {
    // print("_CompatibleTextEditingState#_onFocus, hasFocus: ${_focusNode.hasFocus}");
  }

  void _onInputSubmit(String keyword) {
    if (Platform.isIOS) {
      FocusScope.of(context).requestFocus(_focusNode);
    }
    // print("_CompatibleTextEditingState#_onInputSubmit, keyword: $keyword");
  }

  void _onTextChanged(String text) {
    setState(() {
      print('onTextChanged: isComposingRangeValid: ${_textController.value.isComposingRangeValid}, validText: ${_textController.validText}, text: ${_textController.value.text}');
    });
  }


}

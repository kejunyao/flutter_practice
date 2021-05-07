import 'package:flutter/material.dart';

class NestedScrollViewWidget extends StatefulWidget {
  @override
  _NestedScrollViewWidgetState createState() => _NestedScrollViewWidgetState();
}

class _NestedScrollViewWidgetState extends State<NestedScrollViewWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NestedScrollView使用'),
      ),
      body: _buildBody2(),
    );
  }

  Widget _buildBody() {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[SliverAppBar(
          expandedHeight: 230.0,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text('复仇者联盟'),
            background: Image.network(
              'http://img.haote.com/upload/20180918/2018091815372344164.jpg',
              fit: BoxFit.fitHeight,
            ),
          ),
        )];
      },
      body: ListView.builder(itemBuilder: (BuildContext context,int index){
        return Container(
          height: 80,
          color: Colors.primaries[index % Colors.primaries.length],
          alignment: Alignment.center,
          child: Text(
            '$index',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        );
      },itemCount: 20,),
    );
  }

  Widget _buildBody2() {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[SliverAppBar(
          toolbarHeight: MediaQuery.of(context).padding.top + kToolbarHeight,
          leading: Container(),
          expandedHeight: 0,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Container(
                height: 44,
                child: Text('复仇者联盟')
            ),
          ),
        )];
      },
      body: ListView.builder(
        itemBuilder: (BuildContext context,int index){
        return Container(
          height: 80,
          color: Colors.primaries[index % Colors.primaries.length],
          alignment: Alignment.center,
          child: Text(
            '$index',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        );
      },itemCount: 5,),
    );
  }
}

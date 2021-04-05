
import 'package:flutter_practice/storage/db/base_dao.dart';
import 'package:flutter_practice/storage/db/table_column.dart';

class Book {

  static const key_id   = 'id';
  static const key_name = 'name';
  static const key_desc = '_desc';

  int id;
  String name;
  String desc;
  Book(this.id, this.name, this.desc);

  Book.fromMap(Map<String, dynamic> map) {
    id = map[key_id];
    name = map[key_name];
    desc = map[key_desc];
  }

  static Map<String, dynamic> toMap(Book book) {
    return {
      key_id: book.id,
      key_name: book.name,
      key_desc: book.desc
    };
  }

  @override
  String toString() {
    return '{id: $id, name: $name, desc: $desc}';
  }
}

class BookDaoImpl extends BaseDao<Book> {

  final _table = 'book';

  final List<TableColumn> _columns = [
    TableColumn.of(Book.key_id).integerType().primaryKey(),
    TableColumn.of(Book.key_name).textType().defaultStringValue(''),
    TableColumn.of(Book.key_desc).textType().defaultStringValue('')
  ];

  @override
  Book toEntity(Map<String, dynamic> map) {
    return Book.fromMap(map);
  }

  @override
  Map<String, dynamic> toValues(Book entity) {
    return Book.toMap(entity);
  }

  @override
  List<TableColumn> get columns => _columns;

  @override
  String get table => _table;

}
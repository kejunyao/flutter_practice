
import 'package:flutter_practice/storage/db/dao.dart';

class DaoOwner {

  final Dao dao;

  DaoOwner(this.dao);

  Future<bool> createTable() async {
    return true;
  }

  Future<bool> updateTable() async {
    return true;
  }

  Future<bool> checkTableIntegrity() async {
    return true;
  }

  Future<bool> _hasTable() async {
    return true;
  }
}
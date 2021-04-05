# EasyLite详细说明
    软件开发，是一个逐步迭代、完善的过程，并非一开始就能做到大而全，本数据库（暂取名EasyLite）也是一样的。
    目前，EasyLite可支持日常大部分需求，像索引、视图、关联查询、注解，后期会逐步提供。

# 一、如何使用？

# 1、实现数据库总入口
1.1）首先继承[BaseLite]实现具体的数据库入口类XXXLite，然后分别提供[checkIntegrityAuto]、[databaseName]、[databaseVersion]：
    [BaseLite]: 可以理解为数据库的总入口，一个[BaseLite]对应着一个数据库；
    [checkIntegrityAuto]：设置为true会，自动建表、自动新增字段，表创建、升级，不需手动完成；设置为false，表创建、升级需要手动维护；
    [databaseName]：数据库文件名称；
    [databaseVersion]：当前数据库版本；
1.2）接步骤1.1），设置是否开启debug模式，若开启debug模式，最好设置debug全局tag（默认为EasyLite）；
# 以上步骤，请参考：package:flutter_practice/storage/db/example/example_database_manager.dart

# 2、实现实体增、删、改、查
2.1）继承BaseDao实现实体Dao的实现类XXXDaoImp，分别提供[table]、[columns]:
    [table]: 实体在数据库中对应的表名称；
    [columns]：数据库表所有的字段信息；
2.2）分别实现[toEntity]、[toValues]等方法：
    [toEntity]：将[Map]转为实体Entity；
    [toValues]：将实体Entity转为[Map]；
# 以上步骤，请参考：# 如：package:flutter_practice/storage/db/example/book.dart，BookDaoImp

# 3、将Dao实现类注册到Lite中
3.1）将Dao实现注册到Lite中，如：registerDao(XXX, XXXDaoImpl());
# 以上步骤，请参考：package:flutter_practice/storage/db/example/example_database_manager.dart，ExampleDatabaseManager._()

# 4、初始化数据库
4.1）调用Lite的初始化方法，进行数据库初始化，如：XXXLite.init();

### 以上1到4具体操作步骤，请分别查看：example_database_manager.dart 和 book.dart。


# 二、EasyLite提供了哪些能力？
1、请查看数据库表定义接口[Dao](在dao.dart文件中)，每个定义方法的上方，注释写的很清楚；
2、请查看数据库定义接口[Lite](在lite.dart文件中)，每个定义方法的上方，注释写的很清楚；
3、关于[Dao]有Base实现类[BaseDao]，在base_dao.dart文件中；
      [Lite]有Base实现类，在base_lite.dart文件中。
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
# 以上步骤，请参考：package:flutter_practice/example/db/example_database_manager.dart

# 2、实现实体增、删、改、查
2.1）继承BaseDao实现实体Dao的实现类XXXDaoImp，分别提供[table]、[columns]:
    [table]: 实体在数据库中对应的表名称；
    [columns]：数据库表所有的字段信息；
2.2）分别实现[toEntity]、[toValues]等方法：
    [toEntity]：将[Map]转为实体Entity；
    [toValues]：将实体Entity转为[Map]；
# 以上步骤，请参考：# 如：package:flutter_practice/example/db/book.dart，BookDaoImp

# 3、将Dao实现类注册到Lite中
3.1）将Dao实现注册到Lite中，如：registerDao(XXX, XXXDaoImpl());
# 以上步骤，请参考：package:flutter_practice/example/db/example_database_manager.dart，ExampleDatabaseManager._()

# 4、初始化数据库
4.1）调用Lite的初始化方法，进行数据库初始化，如：XXXLite.init();

### 以上1到4具体操作步骤，请分别查看：example_database_manager.dart 和 book.dart。


# 二、EasyLite提供了哪些能力？
1、请查看数据库表定义接口[Dao](在dao.dart文件中)，每个定义方法的上方，注释写的很清楚；
2、请查看数据库定义接口[Lite](在lite.dart文件中)，每个定义方法的上方，注释写的很清楚；
3、关于[Dao]有Base实现类[BaseDao]，在base_dao.dart文件中；
      [Lite]有Base实现类，在base_lite.dart文件中。
      
# 三、EasyLite代码结构说明，根目录：package:flutter_practice/storage/db/
3.1、lite.dart, [Lite]，定义了数据库行为基类；
3.2、base_lite.dart，[BaseLite]，实现了数据库基本行为；

3.3、dao.dart，[Dao]，定义了数据库表行为基类；
3.4、base_dao.dart，[Dao]，实现了数据库表基本行为；

3.5、callback.dart，[OnDatabaseCallback]，定义了数据库所有的回调，
    3.5.1、[OnDatabaseCallback]中的回调方法：
    [OnDatabaseCallback.setOnDatabaseCreate]: 设置数据库创建回调；
    [OnDatabaseCallback.setOnDatabaseOpen]: 设置数据库打开回调；
    [OnDatabaseCallback.setOnDatabaseUpgrade]: 设置数据库升级回调；
    [OnDatabaseCallback.setOnDatabaseDowngrade]: 设置数据库降级回调；
    [OnDatabaseCallback.setOnDatabaseError]: 设置数据库错误回调；
    [OnDatabaseCallback.setOnDatabaseInitialized]: 设置数据库初始化完成回调；
    3.5.2、[OnDatabaseCallback]中定义的回调函数：
    [OnDatabaseError]: 数据库错误回调；
    [OnDatabaseInitialized]: 数据库初始化完成回调；
    [OnDatabaseVersionChange]: 数据库升级/降级回调；
    [OnDatabaseCreate]: 数据库创建回调；
    [OnDatabaseConfigure]: 数据库配置回调；
    
3.6、database.dart，[RootDatabase]定义了数据库基础库行为；
3.7、sqflite_database.dart, [SqfliteDatabase]，数据库基础库封装类
    EasyLite是对三方库sqflite作的进一步封装，使得数据库操作变得更友好、方便，考虑到后期可能换成其他三方库，故对sqflite作一层包装，并将其基本能力暴露出去；

3.8、table_builder.dart，[TableBuilder]实现了数据库表创建、数据库表字段新增等操作；
3.9、table_column.dart，[TableColumn]数据库表字段数据结构；
3.10、db_log.dart，[DbLog]数据库日志工具类；
3.11、db_utils.dart，[DbUtils]数据库工具类；
3.12、time_recorder.dart，[TimeRecorder]时间录制器，提供：当前时间输出、每一个操作步骤耗时、整体操作耗时。\

# 四、lite_task.dart，定义了数据库所有行为的安全实现：
App冷启动之后，数据库需要初始化，而初始化是一个稍微耗时的操作；
此时，如果数据库还未初始化完毕，就开始对数据库记录进行增、删、改、查操作，势必操作失败；
为解决此类问题，LiteTask提供了方案：
4.1、先构建LiteTask，在lite_task.dart中已经将EasyLite所有的操作行为，都定义过相应的Task；
4.2、然后将构造的Task作为参数，传入到XXXLite的[executeSafely(RootTask task)]方法中执行。


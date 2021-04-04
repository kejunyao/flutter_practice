/// 时间间隔录制器
class TimeRecorder {

  /// 开始记录的时间
  int _begin = 0;
  /// 当前时间
  int _time = 0;
  int _tmp = 0;
  /// record与上次操作间隔时间
  int _interval = 0;
  /// 总共耗时
  int _total = 0;
  /// 当前时间
  DateTime _now;

  TimeRecorder() {
    _init();
  }

  /// 开始记录时间
  void _init() {
    _refreshTime();
    _begin = _time;
    _tmp = _time;
    _total = 0;
  }

  /// 录制某一步骤耗时
  void record() {
    _refreshTime();
    _interval = _time - _tmp;
    _tmp = _time;
    _total = _time - _begin;
  }

  /// 刷新时间
  void _refreshTime() {
    _now = DateTime.now();
    _time = _now.millisecondsSinceEpoch;
  }

  /// 本次操作的当前时间
  int get time => _time;

  /// 每两次操作之间的耗时
  int get interval => _interval;

  /// 从调用begin()到目前总共耗时
  int get total => _total;
  /// 日志
  String get info => 'now: $_now, time: $_time, interval: $_interval ms, total: $_total ms';

  TimeRecorder.of() {
    _init();
  }
}
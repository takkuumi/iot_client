class SerialPort {
  //私有构造函数
  SerialPort._internal();
  //保存单例
  static final SerialPort _singleton = SerialPort._internal();

  //工厂构造函数
  factory SerialPort() => _singleton;
}

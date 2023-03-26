class Device {
  String name;
  String address;
  bool isChecked;
  Device(this.name, this.address, this.isChecked);

  bool contains(String name) {
    return this.name == name;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Device && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}

class Port {
  int sence;
  int p0;
  int p1;
  int p2;
  int p3;
  int p4;
  int p5;
  int p6;
  int p7;
  int p8;
  int p9;

  Port({
    required this.sence,
    required this.p0,
    required this.p1,
    required this.p2,
    required this.p3,
    required this.p4,
    required this.p5,
    required this.p6,
    required this.p7,
    required this.p8,
    required this.p9,
  });

  int get getSence => sence;

  int get getP0 => p0 + 512;
  int get getP1 => p1 + 512;
  int get getP2 => p2 + 512;
  int get getP3 => p3 + 512;
  int get getP4 => p4 + 512;
  int get getP5 => p5 + 512;
  int get getP6 => p6 + 512;
  int get getP7 => p7 + 512;
  int get getP8 => p8 + 512;
  int get getP9 => p9 + 512;

  static Port fromList(int sence, List<int> list) {
    return Port(
      sence: sence,
      p0: list[0],
      p1: list[1],
      p2: list[2],
      p3: list[3],
      p4: list[4],
      p5: list[5],
      p6: list[6],
      p7: list[7],
      p8: list[8],
      p9: list[9],
    );
  }

  static Port emptyPort() {
    return Port(
      sence: -1,
      p0: -1,
      p1: -1,
      p2: -1,
      p3: -1,
      p4: -1,
      p5: -1,
      p6: -1,
      p7: -1,
      p8: -1,
      p9: -1,
    );
  }
}

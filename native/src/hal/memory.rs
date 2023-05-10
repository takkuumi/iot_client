// 本设备SN号18个字符	D20-D28	字符串	1234567
// 本设备设备位置18个字符	D29-D37	字符串	ABCDEFG
// 485端口1配置	D38	u16
// 485端口1做从站地址	D39	u16	1
// 485端口1做主 发重试次数	D40	u16	2
// 485端口1做主 从发送到响应最大时间间隔	D41	u16	100
// 485端口1做主 发起通信间隔(20-5000ms)	D42	u16	50
// 485端口2配置	D43	u16
// 485端口2做从站地址	D44	u16	1
// 485端口2做主 发重试次数	D45	u16	2
// 485端口2做主 从发送到响应最大时间间隔	D46	u16	100
// 485端口2做主发起通信间隔(20-5000ms)	D47	u16	50
// 485端口3配置	D48	u16
// 485端口3做从站地址	D49	u16	1
// 485端口3做主 发重试次数	D50	u16	2
// 485端口3做主 从发送到响应最大时间间隔	D51	u16	100
// 485端口3主发起通信间隔(20-5000ms)	D52	u16	50
// BT端口配置	D53	u16
// BT端口做从站地址	D54	u16	1
// BT端口 做主 发重试次数	D55	u16	2
// BT端口 做主 从发送到响应最大时间间隔	D56	u16	100
// BT端口 做主发起通信间隔(20-5000ms)	D57	u16	50
// NET端口配置	D58	u16
// 网络做从站地址	D59	u16	1
// 网络做主 发重试次数	D60	u16	2
// 网络做主 从发送到响应最大时间间隔	D61	u16	100
// 网络做主 发起通信间隔(20-5000ms)	D62	u16	50
// 本地客户端(主)端口号1	D63	u16	502
// 本地客户端(主)端口号2	D64	u16	503
// 本地客户端(主)端口号3	D65	u16	504
// 本地客户端(主)端口号4	D66	u16	505
// 本地服务器(从)端口号1	D67	u16	5002
// 本地服务器(从)端口号2	D68	u16	5003
// 本地服务器(从)端口号3	D69	u16	5004
// 本地服务器(从)端口号4	D70	u16	5005
// 本地IP地址1	D71	u16	192
// 本地IP地址2	D72	u16	168
// 本地IP地址3	D73	u16	1
// 本地IP地址4(本机做从站的设备地址)	D74	u16	200
// 子网掩码1	D75	u16	255
// 子网掩码2	D76	u16	255
// 子网掩码3	D77	u16	255
// 子网掩码4	D78	u16	0
// 网关IP1	D79	u16	192
// 网关IP2	D80	u16	168
// 网关IP3	D81	u16	1
// 网关IP4	D82	u16	1
// DNS1	D83	u16	114
// DNS2	D84	u16	114
// DNS3	D85	u16	114
// DNS4	D86	u16	114
// MAC地址1	D87	u16	0x00
// MAC地址2	D88	u16	0x80
// MAC地址3	D89	u16	MCUID码1
// MAC地址4	D90	u16	MCUID码2
// MAC地址5	D91	u16	MCUID码3
// MAC地址6	D92	u16	MCUID码4
// 远程端口号	D92	u16	5002
// 远程IP地址1	D93	u16	192
// 远程IP地址2	D94	u16	168
// 远程IP地址3	D95	u16	1
// 远程IP地址4(从站的设备地址)	D96	u16	150
// 蓝牙本地节点地址	D97	u16	0x0001
// 蓝牙远程节点地址	D98	u16	0x1000

#[allow(dead_code)]
pub mod hal_mmr {
  pub const X0: u16 = 0x000;
  pub const X1: u16 = 0x001;
  pub const X2: u16 = 0x002;
  pub const X3: u16 = 0x003;
  pub const X4: u16 = 0x004;
  pub const X5: u16 = 0x005;
  pub const X6: u16 = 0x006;
  pub const X7: u16 = 0x007;
  pub const X8: u16 = 0x008;
  pub const X9: u16 = 0x009;
  pub const X10: u16 = 0x00A;
  pub const X11: u16 = 0x00B;
  pub const X12: u16 = 0x00C;
  pub const X13: u16 = 0x00D;
  pub const X14: u16 = 0x00E;
  pub const X15: u16 = 0x00F;
  pub const X16: u16 = 0x010;
  pub const X17: u16 = 0x011;
  pub const X18: u16 = 0x012;
  pub const X19: u16 = 0x013;
  pub const X20: u16 = 0x014;

  pub const D20: u16 = 0x894;
  pub const D21: u16 = 0x895;
  pub const D22: u16 = 0x896;
  pub const D23: u16 = 0x897;
  pub const D24: u16 = 0x898;
  pub const D25: u16 = 0x899;
  pub const D26: u16 = 0x89A;
  pub const D27: u16 = 0x89B;
  pub const D28: u16 = 0x89C;
  pub const D29: u16 = 0x89D;
  pub const D30: u16 = 0x89E;
  pub const D31: u16 = 0x89F;
  pub const D32: u16 = 0x8A0;
  pub const D33: u16 = 0x8A1;
  pub const D34: u16 = 0x8A2;
  pub const D35: u16 = 0x8A3;
  pub const D36: u16 = 0x8A4;
  pub const D37: u16 = 0x8A5;
  pub const D38: u16 = 0x8A6;
  pub const D39: u16 = 0x8A7;
  pub const D40: u16 = 0x8A8;
  pub const D41: u16 = 0x8A9;
  pub const D42: u16 = 0x8AA;
  pub const D43: u16 = 0x8AB;
  pub const D44: u16 = 0x8AC;
  pub const D45: u16 = 0x8AD;
  pub const D46: u16 = 0x8AE;
  pub const D47: u16 = 0x8AF;
  pub const D48: u16 = 0x8B0;
  pub const D49: u16 = 0x8B1;
  pub const D50: u16 = 0x8B2;
  pub const D51: u16 = 0x8B3;
  pub const D52: u16 = 0x8B4;
  pub const D53: u16 = 0x8B5;
  pub const D54: u16 = 0x8B6;
  pub const D55: u16 = 0x8B7;
  pub const D56: u16 = 0x8B8;
  pub const D57: u16 = 0x8B9;
  pub const D58: u16 = 0x8BA;
  pub const D59: u16 = 0x8BB;
  pub const D60: u16 = 0x8BC;
  pub const D61: u16 = 0x8BD;
  pub const D62: u16 = 0x8BE;
  pub const D63: u16 = 0x8BF;
  pub const D64: u16 = 0x8C0;
  pub const D65: u16 = 0x8C1;
  pub const D66: u16 = 0x8C2;
  pub const D67: u16 = 0x8C3;
  pub const D68: u16 = 0x8C4;
  pub const D69: u16 = 0x8C5;
  pub const D70: u16 = 0x8C6;
  pub const D71: u16 = 0x8C7;
  pub const D72: u16 = 0x8C8;
  pub const D73: u16 = 0x8C9;
  pub const D74: u16 = 0x8CA;
  pub const D75: u16 = 0x8CB;
  pub const D76: u16 = 0x8CC;
  pub const D77: u16 = 0x8CD;
  pub const D78: u16 = 0x8CE;
  pub const D79: u16 = 0x8CF;
  pub const D80: u16 = 0x8D0;
  pub const D81: u16 = 0x8D1;
  pub const D82: u16 = 0x8D2;
  pub const D83: u16 = 0x8D3;
  pub const D84: u16 = 0x8D4;
  pub const D85: u16 = 0x8D5;
  pub const D86: u16 = 0x8D6;
  pub const D87: u16 = 0x8D7;
  pub const D88: u16 = 0x8D8;
  pub const D89: u16 = 0x8D9;
  pub const D90: u16 = 0x8DA;
  pub const D91: u16 = 0x8DB;
  pub const D92: u16 = 0x8DC;
  pub const D93: u16 = 0x8DD;
  pub const D94: u16 = 0x8DE;
  pub const D95: u16 = 0x8DF;
  pub const D96: u16 = 0x8E0;
  pub const D97: u16 = 0x8E1;
  pub const D98: u16 = 0x8E2;

  pub const fn at(var: u16) -> usize {
    (var - D20) as usize
  }

  pub const fn range(var1: u16, var2: u16) -> (usize, usize) {
    (at(var1), at(var2))
  }

  pub fn copy_range(src: &[u16], var1: u16, var2: u16) -> &[u16] {
    let start = at(var1);
    let end = at(var2);
    &src[start..end]
  }

  pub fn copy_slice_section<const N: usize>(src: &[u16], var1: u16, var2: u16) -> [u16; N] {
    let start = at(var1);
    let end = at(var2);
    let mut dst = [0; N];
    dst.copy_from_slice(&src[start..end]);
    dst
  }
}

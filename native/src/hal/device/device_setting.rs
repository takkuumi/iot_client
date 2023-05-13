use super::{hal_mmr, utils::Hex, Indexed, Setting, SettingDefault};
use flutter_rust_bridge::frb;
use serde::{Deserialize, Serialize};
use std::hash::Hash;

#[frb(dart_metadata = ("freezed"))]
#[derive(Serialize, Deserialize, PartialEq, Eq, Debug)]
pub struct DeviceSetting {
  // 本设备SN号18个字符	D20-D28	字符串
  pub sn: [u16; 9],
  // 本设备设备位置18个字符	D29-D37	字符串
  pub location: [u16; 9],

  pub rs485_1: Setting,

  pub rs485_2: Setting,

  pub rs485_3: Setting,

  // BT端口配置	D53	u16
  pub bt: Setting,

  // NET端口配置	D58	u16
  pub net: Setting,

  pub local_port1: u16,
  pub local_port2: u16,
  pub local_port3: u16,
  pub local_port4: u16,

  pub local_port5: u16,
  pub local_port6: u16,
  pub local_port7: u16,
  pub local_port8: u16,

  pub local_ip: [u16; 4],
  pub subnet_mask: [u16; 4],
  pub gateway: [u16; 4],
  pub dns: [u16; 4],
  pub mac: [u16; 6],

  pub remote_port: u16,
  pub remote_ip: [u16; 4],
}

impl Default for DeviceSetting {
  fn default() -> Self {
    let hex9 = Hex::<9>(None);
    DeviceSetting {
      rs485_1: Setting::rs485(),
      rs485_2: Setting::rs485(),
      rs485_3: Setting::rs485(),
      bt: Setting::bluetooth(),
      net: Setting::net(),
      local_port1: 500,
      local_port2: 501,
      local_port3: 502,
      local_port4: 503,

      local_port5: 5000,
      local_port6: 5001,
      local_port7: 5002,
      local_port8: 5003,

      local_ip: [192, 168, 1, 200], // 192.168.1.1
      subnet_mask: [255, 255, 255, 0],
      gateway: [192, 168, 1, 1], // 255.255.255.240
      dns: [114, 114, 114, 114], // 192.18.0.2

      mac: [0x00, 0x10, 0x39, 0x0F, 0x71, 0x44], // 00-10-39-0f-71-44

      remote_port: 5001,
      remote_ip: [192, 168, 1, 150],

      sn: hex9.encode("1234567890abcdefgh"),
      location: hex9.encode("1234567890abcdefgh"),
    }
  }
}

impl Hash for DeviceSetting {
  fn hash<H: std::hash::Hasher>(&self, state: &mut H) {
    self.local_port7.hash(state);
    self.local_ip.hash(state);
  }
}

impl TryFrom<Vec<Indexed<u16>>> for DeviceSetting {
  type Error = String;

  fn try_from(value: Vec<Indexed<u16>>) -> std::result::Result<Self, Self::Error> {
    let iter = value.into_iter().map(|idx| idx.value).collect::<Vec<u16>>();
    std::convert::TryFrom::<Vec<u16>>::try_from(iter)
  }
}

impl TryFrom<Vec<u16>> for DeviceSetting {
  type Error = String;

  fn try_from(value: Vec<u16>) -> std::result::Result<Self, Self::Error> {
    let sliced = value.as_slice();

    // 本设备SN号18个字符	D20-D28	字符串	1234567
    let sn: [u16; 9] = hal_mmr::copy_slice_section(sliced, hal_mmr::D20, hal_mmr::D29);

    // 本设备设备位置18个字符	D29-D37	字符串	ABCDEFG
    let location: [u16; 9] = hal_mmr::copy_slice_section(sliced, hal_mmr::D29, hal_mmr::D38);

    let rs485_1 = Setting::try_from(hal_mmr::copy_range(sliced, hal_mmr::D38, hal_mmr::D43))?;
    let rs485_2 = Setting::try_from(hal_mmr::copy_range(sliced, hal_mmr::D43, hal_mmr::D48))?;
    let rs485_3 = Setting::try_from(hal_mmr::copy_range(sliced, hal_mmr::D48, hal_mmr::D53))?;
    let bt = Setting::try_from(hal_mmr::copy_range(sliced, hal_mmr::D53, hal_mmr::D58))?;
    let net = Setting::try_from(hal_mmr::copy_range(sliced, hal_mmr::D58, hal_mmr::D63))?;

    let local_port1 = sliced[hal_mmr::at(hal_mmr::D63)];
    let local_port2 = sliced[hal_mmr::at(hal_mmr::D64)];
    let local_port3 = sliced[hal_mmr::at(hal_mmr::D65)];
    let local_port4 = sliced[hal_mmr::at(hal_mmr::D66)];

    let local_port5 = sliced[hal_mmr::at(hal_mmr::D67)];
    let local_port6 = sliced[hal_mmr::at(hal_mmr::D68)];
    let local_port7 = sliced[hal_mmr::at(hal_mmr::D69)];
    let local_port8 = sliced[hal_mmr::at(hal_mmr::D70)];

    // 以太网 0X077C;0X077D;0X077E;0X077F

    let local_ip: [u16; 4] = hal_mmr::copy_slice_section(sliced, hal_mmr::D71, hal_mmr::D75);

    let subnet_mask: [u16; 4] = hal_mmr::copy_slice_section(sliced, hal_mmr::D75, hal_mmr::D79);

    // 网关	0X0784;0X0785;0X0786;0X0787
    let gateway: [u16; 4] = hal_mmr::copy_slice_section(sliced, hal_mmr::D79, hal_mmr::D83);

    // DNS	0X0788;0X0789;0X0790;0X078B
    let dns: [u16; 4] = hal_mmr::copy_slice_section(sliced, hal_mmr::D83, hal_mmr::D87);

    // MAC地址 0X0780;0X0781;0X0782;0X0783
    let mac: [u16; 6] = hal_mmr::copy_slice_section(sliced, hal_mmr::D87, hal_mmr::D93);
    // 端口号	 0X078C;0X078D;0X078E;0X078F
    //        0X0790;0X0791;0X0792;0X0790

    let remote_port = sliced[hal_mmr::at(hal_mmr::D93)];

    // 从站地址	0X0794;0X0795;0X0796;0X0797
    let remote_ip: [u16; 4] = hal_mmr::copy_slice_section(sliced, hal_mmr::D94, hal_mmr::D98);

    Ok(Self {
      sn,
      location,
      rs485_1,
      rs485_2,
      rs485_3,
      bt,
      net,
      local_port1,
      local_port2,
      local_port3,
      local_port4,
      local_port5,
      local_port6,
      local_port7,
      local_port8,
      local_ip,
      subnet_mask,
      gateway,
      dns,
      mac,
      remote_port,
      remote_ip,
    })
  }
}

impl TryInto<Vec<u16>> for DeviceSetting {
  type Error = String;

  fn try_into(self) -> std::result::Result<Vec<u16>, Self::Error> {
    let mut bytes = Vec::with_capacity(78);
    let rs485_1 = std::convert::TryInto::<Vec<u16>>::try_into(self.rs485_1)?;
    let rs485_2 = std::convert::TryInto::<Vec<u16>>::try_into(self.rs485_2)?;
    let rs485_3 = std::convert::TryInto::<Vec<u16>>::try_into(self.rs485_3)?;
    let bt = std::convert::TryInto::<Vec<u16>>::try_into(self.bt)?;
    let net = std::convert::TryInto::<Vec<u16>>::try_into(self.net)?;

    // 需要保证此顺序
    bytes.extend_from_slice(&self.sn);
    bytes.extend_from_slice(&self.location);

    bytes.extend_from_slice(&rs485_1);
    bytes.extend_from_slice(&rs485_2);
    bytes.extend_from_slice(&rs485_3);
    bytes.extend_from_slice(&bt);
    bytes.extend_from_slice(&net);

    bytes.push(self.local_port1);
    bytes.push(self.local_port2);
    bytes.push(self.local_port3);
    bytes.push(self.local_port4);
    bytes.push(self.local_port5);
    bytes.push(self.local_port6);
    bytes.push(self.local_port7);
    bytes.push(self.local_port8);

    bytes.extend_from_slice(&self.local_ip);
    bytes.extend_from_slice(&self.subnet_mask);
    bytes.extend_from_slice(&self.gateway);
    bytes.extend_from_slice(&self.dns);
    bytes.extend_from_slice(&self.mac);
    bytes.push(self.remote_port);
    bytes.extend_from_slice(&self.remote_ip);
    Ok(bytes)
  }
}

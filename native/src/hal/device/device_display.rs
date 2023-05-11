use std::{net::AddrParseError, str::FromStr};

use serde::{Deserialize, Serialize};

use super::{
  utils::{Hex, IPv4, MacAdd},
  DeviceSetting,
  Setting,
};

#[derive(Serialize, Deserialize, PartialEq, Eq, Debug)]
pub struct DeviceDisplay {
  // 本设备SN号18个字符	D20-D28	字符串
  pub sn: String,
  // 本设备设备位置18个字符	D29-D37	字符串
  pub location: String,

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

  pub local_ip: String,
  pub subnet_mask: String,
  pub gateway: String,
  pub dns: String,
  pub mac: String,

  pub remote_port: u16,
  pub remote_ip: String,
}

impl TryFrom<DeviceSetting> for DeviceDisplay {
  type Error = String;

  fn try_from(value: DeviceSetting) -> Result<Self, Self::Error> {
    let hex9 = Hex::<9>(None);
    let sn = hex9.decode(&value.sn);
    let location = hex9.decode(&value.location);

    let local_ip = IPv4::new(value.local_ip).to_string();

    let subnet_mask = IPv4::new(value.subnet_mask).to_string();

    let mac = MacAdd::decode(&value.mac);

    let gateway = IPv4::new(value.gateway).to_string();

    let dns = IPv4::new(value.dns).to_string();

    let remote_ip = IPv4::new(value.remote_ip).to_string();

    let device_setting = DeviceDisplay {
      sn,
      location,
      rs485_1: value.rs485_1,
      rs485_2: value.rs485_2,
      rs485_3: value.rs485_3,
      bt: value.bt,
      net: value.net,
      local_port1: value.local_port1,
      local_port2: value.local_port2,
      local_port3: value.local_port3,
      local_port4: value.local_port4,
      local_port5: value.local_port5,
      local_port6: value.local_port6,
      local_port7: value.local_port7,
      local_port8: value.local_port8,
      local_ip,
      subnet_mask,
      mac,
      gateway,
      dns,
      remote_port: value.remote_port,
      remote_ip,
    };

    Ok(device_setting)
  }
}

impl TryInto<DeviceSetting> for DeviceDisplay {
  type Error = AddrParseError;

  fn try_into(self) -> Result<DeviceSetting, Self::Error> {
    let hex9 = Hex::<9>(None);
    let sn = hex9.encode(self.sn.as_str());
    let location = hex9.encode(self.location.as_str());

    let local_ip = IPv4::from_str(self.local_ip.as_str())?.inner();
    let subnet_mask = IPv4::from_str(self.subnet_mask.as_str())?.inner();
    let mac = MacAdd::encode(self.mac.as_str());
    let gateway = IPv4::from_str(self.gateway.as_str())?.inner();
    let dns = IPv4::from_str(self.dns.as_str())?.inner();
    let remote_ip = IPv4::from_str(self.remote_ip.as_str())?.inner();

    Ok(DeviceSetting {
      sn,
      location,
      rs485_1: self.rs485_1,
      rs485_2: self.rs485_2,
      rs485_3: self.rs485_3,
      bt: self.bt,
      net: self.net,
      local_port1: self.local_port1,
      local_port2: self.local_port2,
      local_port3: self.local_port3,
      local_port4: self.local_port4,
      local_port5: self.local_port5,
      local_port6: self.local_port6,
      local_port7: self.local_port7,
      local_port8: self.local_port8,
      local_ip,
      subnet_mask,
      gateway,
      dns,
      mac,
      remote_port: self.remote_port,
      remote_ip,
    })
  }
}

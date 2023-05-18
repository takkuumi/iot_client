use crate::serial::ReadStat;

use super::{send_serialport_until, DataType, SerialResponse};

#[allow(clippy::module_inception)]
mod ble_at {
  pub const AT_TPMODE: &str = "AT+TPMODE"; // 读/写连接状态下的工作模式
  pub const AT_LECHCNT: &str = "AT+LECHCNT"; // 读/写BLE的最大连接数量配置
  pub const AT_REBOOT: &str = "AT+REBOOT"; // 软件复位
  pub const AT_LESEND: &str = "AT+LESEND"; //发送数据给GATT直连设备

  pub const AT_SCAN: &str = "AT+SCAN"; // 搜索附近的设备

  pub const AT_CHINFO: &str = "AT+CHINFO"; // 读取连接对端信息
  pub const AT_LECCONN: &str = "AT+LECCONN"; // 向指定地址发起连接

  pub const AT_LEDISC: &str = "AT+LEDISC"; // 断开指定连接

  pub const AT_UARTCFG: &str = "AT+UARTCFG"; // 读/写串口配置
}

pub fn scan(typee: u8) -> SerialResponse {
  let data = format!("{}={}", ble_at::AT_SCAN, typee);
  send_serialport_until(data.as_bytes(), 1000, DataType::Scan)
}

pub fn lecconn(addr: &str, add_type: u8) -> bool {
  let data = format!("{}={}{}", ble_at::AT_LECCONN, addr, add_type);
  let resp = send_serialport_until(data.as_bytes(), 100, DataType::GATTStat);
  if let Some(buffer) = resp.data {
    let res = DataType::check_gatt_stat(&buffer);
    return res == ReadStat::Ok;
  }

  false
}

pub fn ledisc(index: u8) -> bool {
  let data = format!("{}={}", ble_at::AT_LEDISC, index);
  let resp = send_serialport_until(data.as_bytes(), 100, DataType::GATTStat);
  if let Some(buffer) = resp.data {
    let res = DataType::check_gatt_stat(&buffer);
    return res == ReadStat::Err;
  }

  false
}

pub fn lesend(index: u8, data: &str) -> SerialResponse {
  let data = format!("{}={},{},{}", ble_at::AT_LESEND, index, data.len(), data);
  send_serialport_until(data.as_bytes(), 100, DataType::Date)
}

// AT_UARTCFG
pub fn uartcfg() -> SerialResponse {
  send_serialport_until(ble_at::AT_UARTCFG.as_bytes(), 100, DataType::OkOrErr)
}

pub fn chinfo() -> SerialResponse {
  send_serialport_until(ble_at::AT_CHINFO.as_bytes(), 152, DataType::Chinfo)
}

// pub const AT_TPMODE: &str = "AT+TPMODE"; // 读/写连接状态下的工作模式
// pub const AT_LECHCNT: &str = "AT+LECHCNT"; // 读/写BLE的最大连接数量配置
// pub const AT_REBOOT: &str = "AT+REBOOT"; // 软件复位

pub fn tpmode() {
  let data = format!("{}={}", ble_at::AT_TPMODE, 0);
  let _ = send_serialport_until(data.as_bytes(), 100, DataType::OkOrErr);
  let data = format!("{}={}", ble_at::AT_LECHCNT, 10);
  let _ = send_serialport_until(data.as_bytes(), 100, DataType::OkOrErr);
  let _ = send_serialport_until(ble_at::AT_REBOOT.as_bytes(), 100, DataType::OkOrErr);
}

pub fn reboot() {
  let _ = send_serialport_until(ble_at::AT_REBOOT.as_bytes(), 100, DataType::OkOrErr);
}

#[cfg(test)]
mod test {
  use std::eprintln;

  #[test]
  fn at_works() {
    loop {
      let resp = super::scan(1);

      if let Some(data) = resp.data {
        let resp_text = String::from_utf8(data).unwrap();
        eprintln!("scan respText: {}", resp_text);
      }

      let resp = super::lecconn("DC0D30000FC3", 0);

      eprintln!("lecconn: {}", resp);

      let resp = super::chinfo();

      if let Some(data) = resp.data {
        let resp_text = String::from_utf8(data).unwrap();
        eprintln!("chinfo respText: {}", resp_text);
      }

      let resp = super::ledisc(0);

      eprintln!("ledisc: {}", resp);
    }
  }
}

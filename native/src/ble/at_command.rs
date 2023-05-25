use super::{send_serialport_once, send_serialport_until, DataType, ReadStat, SerialResponse};

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
  send_serialport_until(data.as_bytes(), DataType::Scan)
}

fn try_loop(data: &[u8], flag: DataType) -> SerialResponse {
  let mut retry = 0;
  loop {
    if retry >= 3 {
      let mut resp = SerialResponse::default();
      resp.set_err(crate::serial::ErrorKind::Timeout);
      return resp;
    }
    let resp = send_serialport_once(data, flag);
    if resp.is_ok() {
      return resp;
    }
    retry += 1;
  }
}

pub fn lecconn(addr: &str, add_type: u8) -> bool {
  let data = format!("{}={}{},FFF0,FFF2,FFF1", ble_at::AT_LECCONN, addr, add_type);
  let resp = send_serialport_until(data.as_bytes(), DataType::GATTStat);
  if let Some(buffer) = resp.data {
    let res = DataType::check_gatt_stat_with(&buffer, 3);
    return res == ReadStat::Ok;
  }

  false
}

pub fn ledisc(index: u8) -> bool {
  tracing::info!("ledisc: {}", index);
  let data = format!("{}={}", ble_at::AT_LEDISC, index);
  let resp = send_serialport_until(data.as_bytes(), DataType::GATTStat);
  if let Some(buffer) = resp.data {
    let res = DataType::check_gatt_stat_with(&buffer, 1);
    return res == ReadStat::Ok;
  }

  false
}

pub fn lesend(index: u8, data: &str) -> SerialResponse {
  let data = format!("{}={},{},{}", ble_at::AT_LESEND, index, data.len(), data);
  // send_serialport_until(data.as_bytes(), 300, DataType::Date)
  try_loop(data.as_bytes(), DataType::Date)
}

// AT_UARTCFG
pub fn uartcfg() -> SerialResponse {
  send_serialport_until(ble_at::AT_UARTCFG.as_bytes(), DataType::OkOrErr)
}

pub fn chinfo() -> SerialResponse {
  send_serialport_until(ble_at::AT_CHINFO.as_bytes(), DataType::Chinfo)
}

pub fn tpmode() {
  let data = format!("{}={}", ble_at::AT_TPMODE, 0);
  let _ = send_serialport_until(data.as_bytes(), DataType::OkOrErr);
  let data = format!("{}={}", ble_at::AT_LECHCNT, 10);
  let _ = send_serialport_until(data.as_bytes(), DataType::OkOrErr);
  let _ = send_serialport_until(ble_at::AT_REBOOT.as_bytes(), DataType::OkOrErr);
}

pub fn reboot() {
  let _ = send_serialport_once(ble_at::AT_REBOOT.as_bytes(), DataType::OkOrErr);
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

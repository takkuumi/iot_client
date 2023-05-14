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

fn try_send_serialport_until(
  data: &[u8],
  timeout: u64,
  max_try: u8,
  read_try: u8,
  flag: DataType,
) -> SerialResponse {
  let mut retry: u8 = 0;
  loop {
    if retry > max_try {
      let mut resp = SerialResponse::default();
      resp.set_err(crate::serial::ResponseState::MaxRetry);
      return resp;
    }
    let res = send_serialport_until(data, timeout, read_try, flag);
    if res.is_err() {
      std::thread::sleep(core::time::Duration::from_millis(20));
      retry += 1;
      continue;
    }
    return res;
  }
}

const READ_RETRY: u8 = 1;
pub fn scan(typee: u8) -> SerialResponse {
  let data = format!("{}={}", ble_at::AT_SCAN, typee);
  try_send_serialport_until(data.as_bytes(), 200, 1, 3, DataType::Scan)
}

pub fn lecconn(addr: &str, add_type: u8) -> bool {
  let data = format!("{}={}{}", ble_at::AT_LECCONN, addr, add_type);
  let resp = try_send_serialport_until(data.as_bytes(), 100, 3, 3, DataType::GATTStat);
  if let Some(buffer) = resp.data {
    let res = DataType::check_gatt_stat(&buffer);
    return res == ReadStat::Ok;
  }

  false
}

pub fn ledisc(index: u8) -> bool {
  let data = format!("{}={}", ble_at::AT_LEDISC, index);
  let resp = try_send_serialport_until(data.as_bytes(), 100, 3, 3, DataType::GATTStat);
  if let Some(buffer) = resp.data {
    let res = DataType::check_gatt_stat(&buffer);
    return res == ReadStat::Err;
  }

  false
}

pub fn lesend(index: u8, data: &str) -> SerialResponse {
  let data = format!("{}={},{},{}", ble_at::AT_LESEND, index, data.len(), data);
  try_send_serialport_until(data.as_bytes(), 152, 6, 3, DataType::Date)
}

// AT_UARTCFG
pub fn uartcfg() -> SerialResponse {
  try_send_serialport_until(
    ble_at::AT_UARTCFG.as_bytes(),
    100,
    3,
    READ_RETRY,
    DataType::OK,
  )
}

pub fn chinfo() -> SerialResponse {
  try_send_serialport_until(ble_at::AT_CHINFO.as_bytes(), 152, 2, 5, DataType::Chinfo)
}

// pub const AT_TPMODE: &str = "AT+TPMODE"; // 读/写连接状态下的工作模式
// pub const AT_LECHCNT: &str = "AT+LECHCNT"; // 读/写BLE的最大连接数量配置
// pub const AT_REBOOT: &str = "AT+REBOOT"; // 软件复位

pub fn tpmode() {
  let data = format!("{}={}", ble_at::AT_TPMODE, 0);
  try_send_serialport_until(data.as_bytes(), 100, 3, READ_RETRY, DataType::OK);
  let data = format!("{}={}", ble_at::AT_LECHCNT, 10);
  try_send_serialport_until(data.as_bytes(), 100, 3, READ_RETRY, DataType::OK);
  try_send_serialport_until(
    ble_at::AT_REBOOT.as_bytes(),
    100,
    3,
    READ_RETRY,
    DataType::OK,
  );
}

pub fn reboot() {
  try_send_serialport_until(
    ble_at::AT_REBOOT.as_bytes(),
    100,
    1,
    READ_RETRY,
    DataType::OK,
  );
}

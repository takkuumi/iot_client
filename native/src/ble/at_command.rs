use super::{send_serialport_until, DataType, SerialResponse};

#[allow(clippy::module_inception)]
mod ble_at {

  pub const AT_LESEND: &str = "AT+LESEND"; //发送数据给GATT直连设备

  pub const AT_SCAN: &str = "AT+SCAN"; // 搜索附近的设备

  pub const AT_CHINFO: &str = "AT+CHINFO"; // 读取连接对端信息
  pub const AT_LECCONN: &str = "AT+LECCONN"; // 向指定地址发起连接

  pub const AT_LEDISC: &str = "AT+LEDISC"; // 断开指定连接

  pub const AT_UARTCFG: &str = "AT+UARTCFG"; // 读/写串口配置
}

fn try_send_serialport_until(
  data: &[u8],
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
    let res = send_serialport_until(data, read_try, flag);
    if res.is_err() {
      std::thread::sleep(core::time::Duration::from_millis(20));
      retry += 1;
      continue;
    }
    return res;
  }
}

pub fn scan(typee: u8) -> SerialResponse {
  let data = format!("{}={}", ble_at::AT_SCAN, typee);
  try_send_serialport_until(data.as_bytes(), 1, 100, DataType::Scan)
}

pub fn lecconn(addr: &str, add_type: u8) -> SerialResponse {
  let data = format!("{}={}{}", ble_at::AT_LECCONN, addr, add_type);
  try_send_serialport_until(data.as_bytes(), 3, 3, DataType::OK)
}

pub fn lecconn_addr(addr: &str) -> SerialResponse {
  let data = format!("{}={}", ble_at::AT_LECCONN, addr);
  try_send_serialport_until(data.as_bytes(), 3, 3, DataType::OK)
}

pub fn ledisc(index: u8) -> SerialResponse {
  let data = format!("{}={}", ble_at::AT_LEDISC, index);
  try_send_serialport_until(data.as_bytes(), 5, 3, DataType::OK)
}

pub fn lesend(index: u8, data: &str) -> SerialResponse {
  let data = format!("{}={},{},{}", ble_at::AT_LESEND, index, data.len(), data);
  try_send_serialport_until(data.as_bytes(), 5, 3, DataType::Date)
}

// AT_UARTCFG
pub fn uartcfg() -> SerialResponse {
  try_send_serialport_until(ble_at::AT_UARTCFG.as_bytes(), 3, 3, DataType::OK)
}

pub fn chinfo() -> SerialResponse {
  try_send_serialport_until(ble_at::AT_CHINFO.as_bytes(), 3, 5, DataType::OK)
}

use super::{crc_16, send_serialport, SerialResponse};

#[allow(clippy::module_inception)]
mod ble_at {
  pub const AT: &str = "AT"; //串口通讯测试
  pub const AT_VER: &str = "AT+VER"; //读固件版本
  pub const AT_ADDR: &str = "AT+ADDR"; //读MAC地址
  pub const AT_TXPOWER: &str = "AT+TXPOWER"; //读/写发射功率
  pub const AT_BAUD: &str = "AT+BAUD"; //读/写串口波特率
  pub const AT_MODE: &str = "AT+MODE"; //读/写工作模式
  pub const AT_REBOOT: &str = "AT+REBOOT"; //软复位
  pub const AT_RESTORE: &str = "AT+RESTORE"; //恢复出厂设置
  pub const AT_NDSEND: &str = "AT+NDSEND"; //向发布地址发送数据
  pub const AT_NDRPT: &str = "AT+NDRPT"; //发送数据到指定地址
  pub const AT_NDRELAY: &str = "AT+NDRELAY"; //读/写Mesh消息中继配置
  pub const AT_NDRESET: &str = "AT+NDRESET"; //重置Mesh网络
  pub const AT_TMCFG: &str = "AT+TMCFG"; //读/写天猫三元组
  pub const AT_NDPUBL: &str = "AT+NDPUBL"; //读/写节点的发布地址
  pub const AT_NDSUBS: &str = "AT+NDSUBS"; //读/写节点的订阅地址
  pub const AT_NDID: &str = "AT+NDID"; //读/写节点地址
  pub const AT_NDNETKEY: &str = "AT+NDNETKEY"; //读/写Mesh网络的网络密匙
  pub const AT_NDAPPKEY: &str = "AT+NDAPPKEY"; //读/写Mesh网络的应用密匙
  pub const AT_NDDEVKEY: &str = "AT+NDDEVKEY"; //读/写Mesh网络的设备密钥
  pub const AT_NDADV: &str = "AT+NDADV"; //始能未组网的广播
  pub const AT_LESEND: &str = "AT+LESEND"; //发送数据给GATT直连设备
}

fn try_until(data: &[u8], retry: u8) -> SerialResponse {
  let mut max_retry: u8 = 0;
  loop {
    if max_retry > retry {
      return SerialResponse::new_err();
    }
    let res = send_serialport(data);
    if res.is_err() {
      let _ = send_serialport(ble_at::AT_REBOOT.as_bytes());
      eprintln!("start reboot...");
      std::thread::sleep(core::time::Duration::from_millis(100));
      eprintln!("rebooted!");
      max_retry += 1;
      continue;
    }
    return res;
  }
}

pub fn get_ndid() -> SerialResponse {
  let data = format!("{}", ble_at::AT_NDID);
  send_serialport(data.as_bytes())
}

pub fn set_ndid(id: &str) -> SerialResponse {
  let data = format!("{}={}", ble_at::AT_NDID, id);
  send_serialport(data.as_bytes())
}

pub fn set_baud() -> SerialResponse {
  let data = format!("{}=115200", ble_at::AT_BAUD);
  send_serialport(data.as_bytes())
}

pub fn ndreset() -> SerialResponse {
  let data = format!("{}", ble_at::AT_NDRESET);
  send_serialport(data.as_bytes())
}

pub fn restore() -> SerialResponse {
  let data = format!("{}", ble_at::AT_RESTORE);
  send_serialport(data.as_bytes())
}

pub fn set_mode(mode: u8) -> SerialResponse {
  let data = format!("{}={}", ble_at::AT_MODE, mode);
  send_serialport(data.as_bytes())
}

pub fn reboot() -> SerialResponse {
  let data = format!("{}", ble_at::AT_REBOOT);
  send_serialport(data.as_bytes())
}

pub fn at_ndrpt(id: &str, data: &[u8], retry: u8) -> SerialResponse {
  let size = data.len() + 5;

  let crc_data = crc_16(data);
  let mut bytes = Vec::<u8>::new();
  bytes.extend_from_slice(ble_at::AT_NDRPT.as_bytes());
  bytes.push(b'=');
  bytes.extend_from_slice(id.as_bytes());
  bytes.push(b',');
  bytes.extend_from_slice(size.to_string().as_bytes());
  bytes.push(b',');
  bytes.push(b'\xc8');

  bytes.extend_from_slice(data);
  let r = format!("{crc_data:04X}");
  bytes.extend_from_slice(r.as_bytes());

  try_until(&bytes, retry)
}

pub fn at_ndrpt_data(id: &str, data: &[u8], retry: u8) -> SerialResponse {
  let size = data.len() + 1;

  eprintln!("size: {}", size);
  let mut bytes = Vec::<u8>::new();
  bytes.extend_from_slice(ble_at::AT_NDRPT.as_bytes());
  bytes.push(b'=');
  bytes.extend_from_slice(id.as_bytes());
  bytes.push(b',');
  bytes.extend_from_slice(size.to_string().as_bytes());
  bytes.push(b',');
  bytes.push(b'\xc8');

  bytes.extend_from_slice(data);

  try_until(&bytes, retry)
}

pub fn at_ndrpt_test() -> SerialResponse {
  at_ndrpt("0001", "01050200FF00".as_bytes(), 5)
}

#[cfg(test)]
mod test {

  #[test]
  pub fn at_works() {
    let res = super::get_ndid();
    assert!(res.is_ok());
  }

  //[65, 84, 43, 78, 68, 82, 80, 84, 61, 48, 48, 48, 49, 44, 17, 44, 200, 48, 49,
  //[65, 48, 53, 48, 50, 48, 48, 70, 70, 48, 48, 56, 68, 56, 50, 13, 10] 84, 43,
  //[65, 78, 68, 82, 80, 84, 61, 48, 48, 48, 49, 44, 49, 55, 44, 200, 48, 49, 48,
  //[65, 53, 48, 50, 48, 48, 70, 70, 48, 48, 56, 68, 56, 50, 13, 10]
  #[test]
  pub fn at_ndrpt_works() {
    let mut i = 0;
    loop {
      let res = super::at_ndrpt("0001", "010F020000030105".as_bytes(), 5);
      println!("res: {res:?}");
      println!("res: {}", String::from_utf8_lossy(&res.data.unwrap()));

      i += 1;

      eprintln!("index:{i}");

      // let res = super::at_ndrpt("0001", "01050200FF00".as_bytes());
      // println!("res: {:?}", res);
      // println!("res: {}", String::from_utf8_lossy(&res.unwrap()));
      let res = super::at_ndrpt("0001", "010F020000030100".as_bytes(), 5);
      println!("res: {res:?}");
      println!("res: {}", String::from_utf8_lossy(&res.data.unwrap()));

      i += 1;

      eprintln!("index:{i}");
    }
  }

  #[test]
  pub fn at_ndrpt_test3() {
    loop {
      let res = super::at_ndrpt("0001", "010102000004".as_bytes(), 5);
      println!(
        "------1   res: {}/",
        String::from_utf8_lossy(&res.data.unwrap())
      );
      let res = super::at_ndrpt("0001", "010F020000020101".as_bytes(), 5);
      println!(
        "------2   res: {}/",
        String::from_utf8_lossy(&res.data.unwrap())
      );
      let res = super::at_ndrpt("0001", "010F020000020102".as_bytes(), 5);
      println!(
        "------3   res: {}/",
        String::from_utf8_lossy(&res.data.unwrap())
      );
      let res = super::at_ndrpt("0001", "010F020200020101".as_bytes(), 5);
      println!(
        "------4   res: {}/",
        String::from_utf8_lossy(&res.data.unwrap())
      );
      let res = super::at_ndrpt("0001", "010F020200020102".as_bytes(), 5);
      println!(
        "------5   res: {}/",
        String::from_utf8_lossy(&res.data.unwrap())
      );
    }
  }

  #[test]
  pub fn at_ndrpt_test4() {
    let res = super::at_ndrpt("0001", "010F020000030105".as_bytes(), 5);
    println!("res: {res:?}");
    println!("res: {}", String::from_utf8_lossy(&res.data.unwrap()));
  }

  #[test]
  pub fn at_ndrpt_test2() {

    // super::reboot().unwrap();

    // super::ndreset().unwrap();
    // let data = "010100000001".as_bytes();

    // let res = super::at_ndrpt("0001", data);

    // println!("res: {:?}", res);

    // let res = super::at_ndrpt("0001", data);

    // super::restore().unwrap();
    // // println!("res: {:?}", res);
    // println!("res: {}", String::from_utf8_lossy(&res));
  }
}

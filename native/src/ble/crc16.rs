pub fn crc(data: &[u8]) -> u16 {
  let bytes = data.chunks(2).fold(Vec::new(), |mut res, items| {
    let a = format!("{}{}", items[0] as char, items[1] as char);
    res.push(u8::from_str_radix(a.as_str(), 16).unwrap());
    res
  });
  let crc = crc::Crc::<u16>::new(&crc::CRC_16_MODBUS);
  let mut digest = crc.digest();
  digest.update(bytes.as_slice());
  digest.finalize()
}

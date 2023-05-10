use std::{
  net::{AddrParseError, Ipv4Addr},
  ops::Deref,
  str::FromStr,
};

pub struct Hex<const N: usize>(pub Option<char>);
impl<const N: usize> Hex<N> {
  pub fn encode(&self, src: &str) -> [u16; N] {
    let mut s = src.to_string();

    if let Some(ch) = self.0 {
      s.retain(|c| c != ch);
    }

    let chunks = s.as_bytes().chunks_exact(2);
    let rem = chunks.remainder();
    let mut res = Vec::<u16>::new();
    for chunk in chunks {
      res.push(u16::from_le_bytes([chunk[0], chunk[1]]));
    }

    if !rem.is_empty() {
      res.push(u16::from_be_bytes([rem[0], 0]));
    }

    let mut sn = [0_u16; N];
    sn.copy_from_slice(&res.as_slice()[0..N]);

    sn
  }

  pub fn decode(&self, arr: &[u16; N]) -> String {
    arr
      .iter()
      .map(|item| item.to_le_bytes())
      .fold(String::new(), |mut res, item| {
        res.push_str(&String::from_utf8_lossy(&item));
        res
      })
  }
}

pub struct MacAdd;

impl MacAdd {
  fn empty_mac(_: super::eui48::ParseError) -> super::eui48::MacAddress {
    super::eui48::MacAddress::new([0, 0, 0, 0, 0, 0])
  }

  pub fn encode(src: &str) -> [u16; 6] {
    let mac = super::eui48::MacAddress::from_str(src).unwrap_or_else(Self::empty_mac);

    let [a, b, c, d, e, f] = mac.to_array();

    [a as u16, b as u16, c as u16, d as u16, e as u16, f as u16]
  }

  pub fn decode(arr: &[u16; 6]) -> String {
    let [a, b, c, d, e, f] = arr;
    let eui = [*a as u8, *b as u8, *c as u8, *d as u8, *e as u8, *f as u8];

    let mac = super::eui48::MacAddress::new(eui);

    mac.to_canonical()
  }
}

pub struct IPv4([u16; 4]);

impl IPv4 {
  pub fn new(addr: [u16; 4]) -> Self {
    Self(addr)
  }

  pub fn octets(&self) -> [u8; 4] {
    let [a, b, c, d] = self.0;
    [a as u8, b as u8, c as u8, d as u8]
  }

  pub fn inner(self) -> [u16; 4] {
    self.0
  }
}

impl Deref for IPv4 {
  type Target = [u16; 4];

  fn deref(&self) -> &Self::Target {
    &self.0
  }
}

impl ToString for IPv4 {
  fn to_string(&self) -> String {
    format!("{}.{}.{}.{}", self.0[0], self.0[1], self.0[2], self.0[3])
  }
}

impl From<&[u8; 4]> for IPv4 {
  fn from(arr: &[u8; 4]) -> Self {
    let mut res = [0_u16; 4];
    for (index, item) in arr.iter().enumerate() {
      res[index] = u16::from(*item);
    }

    Self(res)
  }
}

impl TryFrom<&[u16]> for IPv4 {
  type Error = std::num::TryFromIntError;

  fn try_from(value: &[u16]) -> Result<Self, Self::Error> {
    let mut res = [0_u8; 4];
    for (index, item) in value.iter().enumerate() {
      res[index] = u8::try_from(*item)?;
    }

    Ok(Self::from(&res))
  }
}

impl From<&Ipv4Addr> for IPv4 {
  fn from(value: &Ipv4Addr) -> Self {
    Self::from(&value.octets())
  }
}

impl From<IPv4> for Ipv4Addr {
  fn from(val: IPv4) -> Self {
    Ipv4Addr::from(val.octets())
  }
}

impl FromStr for IPv4 {
  type Err = AddrParseError;

  fn from_str(s: &str) -> Result<Self, Self::Err> {
    let addr = Ipv4Addr::from_str(s)?;

    let res = Self::from(&addr.octets());

    Ok(res)
  }
}

pub fn to_modbus_hex_str(bytes: &[u8]) -> String {
  let mut res = String::new();

  for b in bytes {
    res.push_str(&format!("{:02X} ", b));
  }

  res
}

#[cfg(test)]
mod test {

  use super::Hex;

  #[test]
  fn hex_works() {
    let mac: [u16; 9] = [12849, 13363, 13877, 55, 0, 0, 0, 0, 0]; // EAEAEAAE3C40

    let hex = Hex::<9>(None);

    let s1 = hex.decode(&mac);
    println!("{s1}");

    let s2 = hex.encode("12345678901234567890");

    eprintln!("{s2:?}");
  }

  #[test]
  fn mac_test() {
    let mac: [u8; 6] = [0, 16, 57, 15, 113, 68]; // EAEAEAAE3C40

    let mac = super::super::eui48::MacAddress::new(mac);

    println!("{}", mac.to_canonical());
    println!("{}", mac.to_hex_string());
    println!("{}", mac.to_dot_string());
    println!("{}", mac.to_hexadecimal());
    println!("{}", mac.to_interfaceid());
    println!("{}", mac.to_link_local());
  }
}

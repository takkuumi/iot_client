use std::ops::{BitOr, Deref};

use bitflags::bitflags;

// The `bitflags!` macro generates `struct`s that manage a set of flags.
bitflags! {
  #[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash)]
  pub struct Scenes: u8 {
    const A = 0b00000000;
    const B = 0b00000001;
    const C = 0b00000010;
    const D = 0b00000011;
    const E = 0b00000100;
    const F = 0b00000101;
    const G = 0b00000110;
    const H = 0b00000111;
    const I = 0b00001000;
    const J = 0b00001001;
    const K = 0b00001010;
    const L = 0b00001011;
    const M = 0b00001100;
    const N = 0b00001101;
    const O = 0b00001110;
    const P = 0b00001111;
    const Q = 0b00010000;
  }
}

#[derive(Debug)]
pub struct Index {
  pub index: u16,
  pub value: bool,
}

impl Index {
  pub fn offset(&mut self, offset: u16) -> &Self {
    self.index += offset;
    self
  }
}

#[derive(Default)]
pub struct Com(u32);

impl Deref for Com {
  type Target = u32;

  fn deref(&self) -> &Self::Target {
    &self.0
  }
}

impl BitOr for Com {
  type Output = Self;

  fn bitor(self, rhs: Self) -> Self::Output {
    Self(self.0 | rhs.0)
  }
}

impl Com {
  pub fn set_index(&mut self, index: u8) {
    self.0 |= 1 << (32 - index);
  }

  pub fn clear_index(&mut self, index: u8) {
    self.0 &= !(1 << (32 - index));
  }

  pub fn get_index(&self, index: u8) -> bool {
    self.0 & (1 << (32 - index)) != 0
  }

  pub fn to_index(&self) -> Vec<Index> {
    let mut result = Vec::with_capacity(32);
    for i in 1..33 {
      let value = self.get_index(i);
      result.push(Index {
        index: i as u16,
        value,
      });
    }
    result
  }

  pub fn bits(&self) -> [u8; 4] {
    self.0.to_be_bytes()
  }
}

// |场景(u8高4位)|索引(u8低4位)|IO输入(u32)|IO输出(u32)|模式(u8)
pub struct LogicControl {
  pub index: u8,
  pub scene: Scenes,
  pub com_in: Com,
  pub com_out: Com,
}

impl LogicControl {
  pub fn bytes(&self) -> [u8; 10] {
    let mut result = [0u8; 10];
    result[0] = self.scene.bits();
    result[1] = self.index;
    result[2..6].copy_from_slice(&self.com_in.bits());
    result[6..10].copy_from_slice(&self.com_out.bits());
    result
  }
}

#[cfg(test)]
mod test {
  use std::ops::{BitOr, Deref};

  #[test]
  fn it_works() {
    for i in 0..17 {
      eprintln!("    const {} = 0b{:08b};", (65 + i as u8) as char, i)
    }
  }

  #[test]
  fn index_works() {
    let mut com1 = super::Com::default();
    com1.set_index(2);
    let mut com2 = super::Com::default();
    com2.set_index(3);

    let mut a = com1.bitor(com2);

    eprintln!("{:032b}", a.deref());

    a.clear_index(3);

    eprintln!("{:032b}", a.deref());

    let vec_a = a.to_index();
    eprintln!("{:?}", vec_a);
  }
}

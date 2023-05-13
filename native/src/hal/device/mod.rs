pub mod device_display;
pub mod device_setting;

use super::{
  indexed::Indexed,
  memory::hal_mmr,
  serial::{Setting, SettingDefault},
  utils,
};
pub use device_display::DeviceDisplay;
pub use device_setting::DeviceSetting;

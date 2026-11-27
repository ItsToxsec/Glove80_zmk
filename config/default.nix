
{ pkgs ? import <nixpkgs> {}
, firmware ? import ../src {}
}:

let
  config = ./.;

  # XIAO nRF52840 dongle - BLE central
  # Requires glove80_dongle shield to be installed in MoErgo ZMK.
  dongle = firmware.zmk.override {
    board = "seeeduino_xiao_ble";
    shield = "glove80_dongle";
    keymap = "${config}/glove80_dongle.keymap";
  };

  # Glove80 left half - BLE peripheral
  glove80_lh = firmware.zmk.override {
    board = "glove80_lh";
    keymap = "${config}/peripheral.keymap";
    kconfig = "${config}/glove80.conf";
  };

  # Glove80 right half - BLE peripheral
  glove80_rh = firmware.zmk.override {
    board = "glove80_rh";
    keymap = "${config}/peripheral.keymap";
    kconfig = "${config}/glove80.conf";
  };

  # Bluetooth bond reset images
  reset_dongle = firmware.zmk.override {
    board = "seeeduino_xiao_ble";
    shield = "settings_reset";
  };

  reset_lh = firmware.zmk.override {
    board = "glove80_lh";
    shield = "settings_reset";
  };

  reset_rh = firmware.zmk.override {
    board = "glove80_rh";
    shield = "settings_reset";
  };

in
pkgs.runCommandNoCC "glove80-xiao-dongle-firmware" {} ''
  mkdir -p $out

  cp ${dongle}/zmk.uf2 $out/glove80_xiao_dongle.uf2
  cp ${glove80_lh}/zmk.uf2 $out/glove80_lh_peripheral.uf2
  cp ${glove80_rh}/zmk.uf2 $out/glove80_rh_peripheral.uf2

  cp ${reset_dongle}/zmk.uf2 $out/reset_dongle.uf2
  cp ${reset_lh}/zmk.uf2 $out/reset_glove80_lh.uf2
  cp ${reset_rh}/zmk.uf2 $out/reset_glove80_rh.uf2
''

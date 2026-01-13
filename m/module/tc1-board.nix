{ lib, pkgs, ... }:

{
  # Allow user access to FTDI USB device
  services.udev.packages = lib.singleton (pkgs.writeTextFile {
    # Needs to be < 73
    name = "60-ftdi-tc1.rules";
    text = ''
      # Bus 003 Device 003: ID 0403:6011 Future Technology Devices International, Ltd FT4232H Quad HS USB-UART/FIFO IC
      # Use := to make sure it doesn't get changed later
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6011", MODE:="0666"
    '';
    destination = "/etc/udev/rules.d/60-ftdi-tc1.rules";
  });
}

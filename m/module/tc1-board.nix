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

  # Allow access to USB for docker in GitLab runner
  services.gitlab-runner = {
    services.gitlab-bsc-docker = {
      registrationFlags = [
        # We need raw access to the USB port to reboot the board
        "--docker-devices /dev/bus/usb/003/003"
        # And TTY access for the serial port
        "--docker-devices /dev/ttyUSB2"
      ];
    };
  };
}

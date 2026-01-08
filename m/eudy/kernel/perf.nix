{ pkgs, lib, ... }:

{
  # allow non-root users to read tracing data from the kernel
  boot.kernel.sysctl."kernel.perf_event_paranoid" = -2;
  boot.kernel.sysctl."kernel.kptr_restrict" = 0;

  # specify additionl options to the tracefs directory to allow members of the
  # tracing group to access tracefs.
  fileSystems."/sys/kernel/tracing" = {
    options = [
      "mode=755"
      "gid=tracing"
    ];
  };
}


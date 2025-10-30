{ config, pkgs, ... }:

{
  services.slurm = {
    controlMachine = "apex";
    clusterName = "jungle";
    nodeName = [
      "owl[1,2]  Sockets=2 CoresPerSocket=14 ThreadsPerCore=2 Feature=owl"
      "fox       Sockets=8 CoresPerSocket=24 ThreadsPerCore=1"
    ];

    partitionName = [
      "owl Nodes=owl[1-2]     Default=YES DefaultTime=01:00:00 MaxTime=INFINITE State=UP"
      "fox Nodes=fox          Default=NO  DefaultTime=01:00:00 MaxTime=INFINITE State=UP"
    ];

    # See slurm.conf(5) for more details about these options.
    extraConfig = ''
      # Use PMIx for MPI by default. It works okay with MPICH and OpenMPI, but
      # not with Intel MPI. For that use the compatibility shim libpmi.so
      # setting I_MPI_PMI_LIBRARY=$pmix/lib/libpmi.so while maintaining the PMIx
      # library in SLURM (--mpi=pmix). See more details here:
      # https://pm.bsc.es/gitlab/rarias/jungle/-/issues/16
      MpiDefault=pmix

      # When a node reboots return that node to the slurm queue as soon as it
      # becomes operative again.
      ReturnToService=2

      # Track all processes by using a cgroup
      ProctrackType=proctrack/cgroup

      # Enable task/affinity to allow the jobs to run in a specified subset of
      # the resources. Use the task/cgroup plugin to enable process containment.
      TaskPlugin=task/affinity,task/cgroup

      # Reduce port range so we can allow only this range in the firewall
      SrunPortRange=60000-61000

      # Use cores as consumable resources. In SLURM terms, a core may have
      # multiple hardware threads (or CPUs).
      SelectType=select/cons_tres

      # Ignore memory constraints and only use unused cores to share a node with
      # other jobs.
      SelectTypeParameters=CR_Core

      # Required for pam_slurm_adopt, see https://slurm.schedmd.com/pam_slurm_adopt.html
      # This sets up the "extern" step into which ssh-launched processes will be
      # adopted. Alloc runs the prolog at job allocation (salloc) rather than
      # when a task runs (srun) so we can ssh early.
      PrologFlags=Alloc,Contain,X11

      LaunchParameters=use_interactive_step
      SlurmdDebug=debug5
      #DebugFlags=Protocol,Cgroup
    '';

    extraCgroupConfig = ''
      CgroupPlugin=cgroup/v2
      #ConstrainCores=yes
    '';
  };

  # Place the slurm config in /etc as this will be required by PAM
  environment.etc.slurm.source = config.services.slurm.etcSlurm;

  age.secrets.mungeKey = {
    file = ../../secrets/munge-key.age;
    owner = "munge";
    group = "munge";
  };

  services.munge = {
    enable = true;
    password = config.age.secrets.mungeKey.path;
  };
}

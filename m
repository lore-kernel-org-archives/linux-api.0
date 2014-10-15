From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v3 0/6] TPM 2.0 support
Date: Wed, 15 Oct 2014 13:35:10 +0200
Message-ID: <1413372916-12091-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, Ashley Lai <ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, josh.triplett-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, will.c.arthur-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, monty.wiseman-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This patch set enables TPM2 protocol and provides drivers for FIFO and
CRB interfaces. In addition life-cycle model is somewhat improved (but
not yet fully fixed) for TPM device drivers. There's still work to do
in ref counting and locking but this patch set takes (I believe) the
correct interm steps towards right direction.

TPM2 sysfs attributes are placed to misc dev instead of binding them
to the platform device as misc dev represents the device to the user
space. TPM1 uses invalid place for the sysfs attributes.

Major changes since v1:

- Improved struct tpm_chip life-cycle by taking advantage of devres
  API.
- Refined sysfs attributes as simple key-values thereby not repeating
  mistakes in TPM1 sysfs attributes.
- Documented functions in tpm-chip.c and tpm2-cmd.c.
- Documented sysfs attributes.

Major changes since v2:

- Lots of fixes in calling order in device drivers (thanks to Jason
  Gunthorpe for pointing these out!).
- Attach sysfs attributes to the misc device because it represents
  TPM device to the user space.

Known opens:

- I'm still pending to test the FIFO (tpm_tis) driver. Now I should
  have system to actually get this done but I'm right now at the
  LinuxCon.
- struct tpm_chip would need proper ref counting and locking applied
  everywhere but this has been existing problem before this patch set.
  It is a large change that I'm willing to work on after getting this
  merged first.
- It might be that in some cases PPI interface might be attached to
  a wrong PPI interface if ACPI tree shows up having two PPI interface. 
  I think the way PPI interface is grabbed is invalid. Instead it should
  be passed an ACPI handle to the device and it should take PPI interface
  under that ACPi handle. I can add a fix to do this in v4 if everyone
  else agrees.

Jarkko Sakkinen (5):
  tpm: merge duplicate transmit_cmd() functions
  tpm: two-phase chip management functions
  tpm: TPM 2.0 commands
  tpm: TPM 2.0 sysfs attributes
  tpm: TPM 2.0 CRB Interface

Will Arthur (1):
  tpm: TPM 2.0 FIFO Interface

 Documentation/ABI/stable/sysfs-class-tpm2 |  72 ++++
 drivers/char/tpm/Kconfig                  |   9 +
 drivers/char/tpm/Makefile                 |   3 +-
 drivers/char/tpm/tpm-chip.c               | 209 ++++++++++++
 drivers/char/tpm/tpm-dev.c                |   7 +-
 drivers/char/tpm/tpm-interface.c          | 225 +++----------
 drivers/char/tpm/tpm-sysfs.c              |  23 +-
 drivers/char/tpm/tpm.h                    | 106 +++++-
 drivers/char/tpm/tpm2-cmd.c               | 543 ++++++++++++++++++++++++++++++
 drivers/char/tpm/tpm2-sysfs.c             | 314 +++++++++++++++++
 drivers/char/tpm/tpm_atmel.c              |  11 +-
 drivers/char/tpm/tpm_crb.c                | 329 ++++++++++++++++++
 drivers/char/tpm/tpm_i2c_atmel.c          |  33 +-
 drivers/char/tpm/tpm_i2c_infineon.c       |  37 +-
 drivers/char/tpm/tpm_i2c_nuvoton.c        |  44 +--
 drivers/char/tpm/tpm_i2c_stm_st33.c       |  22 +-
 drivers/char/tpm/tpm_ibmvtpm.c            |  17 +-
 drivers/char/tpm/tpm_infineon.c           |  13 +-
 drivers/char/tpm/tpm_nsc.c                |  11 +-
 drivers/char/tpm/tpm_tis.c                | 160 +++++----
 drivers/char/tpm/xen-tpmfront.c           |  14 +-
 21 files changed, 1813 insertions(+), 389 deletions(-)
 create mode 100644 Documentation/ABI/stable/sysfs-class-tpm2
 create mode 100644 drivers/char/tpm/tpm-chip.c
 create mode 100644 drivers/char/tpm/tpm2-cmd.c
 create mode 100644 drivers/char/tpm/tpm2-sysfs.c
 create mode 100644 drivers/char/tpm/tpm_crb.c

-- 
2.1.0

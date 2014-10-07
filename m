From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v2 0/7] TPM 2.0 support
Date: Tue,  7 Oct 2014 20:01:10 +0300
Message-ID: <1412701277-27794-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, Ashley Lai <ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This patch set enables TPM2 protocol and provides drivers for FIFO and
CRB interfaces.

Major changes since v1:

- Improved struct tpm_chip life-cycle by taking advantage of devres
  API.
- Refined sysfs attributes as simple key-values thereby not repeating
  mistakes in TPM1 sysfs attributes.
- Documented functions in tpm-chip.c and tpm2-cmd.c.
- Documented sysfs attributes.

Jarkko Sakkinen (6):
  tpm: merge duplicate transmit_cmd() functions
  tpm: two-phase chip management functions
  tpm: clean up tpm_tis driver life-cycle
  tpm: TPM 2.0 commands
  tpm: TPM 2.0 sysfs attributes
  tpm: TPM 2.0 CRB Interface

Will Arthur (1):
  tpm: TPM 2.0 FIFO Interface

 Documentation/ABI/stable/sysfs-class-tpm2 |  69 ++++
 drivers/char/tpm/Kconfig                  |   9 +
 drivers/char/tpm/Makefile                 |   3 +-
 drivers/char/tpm/tpm-chip.c               | 184 ++++++++++
 drivers/char/tpm/tpm-dev.c                |   4 +-
 drivers/char/tpm/tpm-interface.c          | 201 ++++-------
 drivers/char/tpm/tpm-sysfs.c              |  23 +-
 drivers/char/tpm/tpm.h                    | 103 +++++-
 drivers/char/tpm/tpm2-cmd.c               | 543 ++++++++++++++++++++++++++++++
 drivers/char/tpm/tpm2-sysfs.c             | 314 +++++++++++++++++
 drivers/char/tpm/tpm_crb.c                | 329 ++++++++++++++++++
 drivers/char/tpm/tpm_i2c_atmel.c          |   5 -
 drivers/char/tpm/tpm_i2c_infineon.c       |  10 -
 drivers/char/tpm/tpm_i2c_nuvoton.c        |   5 -
 drivers/char/tpm/tpm_infineon.c           |   1 -
 drivers/char/tpm/tpm_tis.c                | 142 +++++---
 16 files changed, 1696 insertions(+), 249 deletions(-)
 create mode 100644 Documentation/ABI/stable/sysfs-class-tpm2
 create mode 100644 drivers/char/tpm/tpm-chip.c
 create mode 100644 drivers/char/tpm/tpm2-cmd.c
 create mode 100644 drivers/char/tpm/tpm2-sysfs.c
 create mode 100644 drivers/char/tpm/tpm_crb.c

-- 
2.1.0

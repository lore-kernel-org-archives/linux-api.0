From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH 00/10] TPM2 updates for 4.4
Date: Fri, 16 Oct 2015 21:40:19 +0300
Message-ID: <1445020843-9382-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: peterhuewe-Mmb7MZpHnFY@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, artem.bityutskiy-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, Jiri Slaby <jslaby-IBi9RG/b67k@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, "open list:KEYS-TRUSTED" <keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:KEYS-TRUSTED" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vivien Didelot <vivien.didelot-4ysUXcep3aM1wj+D4I0NRVaTQe2KTcn/@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This patch set enables distributions to start production of for TPM 2.0:

* Two critical bug fixes
* PPI support
* Basic trusted keys with authentication value and SHA256 for keyed hash

Next steps after this is to add policy based sealing for trusted keys and
algorithmic agility.

Jarkko Sakkinen (10):
  tpm, tpm_crb: fix unaligned read of the command buffer address
  tpm, tpm_tis: fix tpm_tis ACPI detection issue with TPM 2.0
  sysfs: added __compat_only_sysfs_link_entry_to_kobj()
  tpm: move the PPI attributes to character device directory.
  tpm: update PPI documentation to address the location change.
  tpm: introduce tpm_buf
  keys, trusted: move struct trusted_key_options to trusted-type.h
  tpm: seal/unseal for TPM 2.0
  keys, trusted: seal/unseal with TPM 2.0 chips
  MAINTAINERS: add new maintainer for TPM DEVICE DRIVER

 Documentation/ABI/testing/sysfs-driver-ppi |  19 ++-
 MAINTAINERS                                |   1 +
 drivers/char/tpm/tpm-chip.c                |  24 ++-
 drivers/char/tpm/tpm-interface.c           |  76 +++++++++
 drivers/char/tpm/tpm.h                     | 134 ++++++++++++++--
 drivers/char/tpm/tpm2-cmd.c                | 250 ++++++++++++++++++++++++++++-
 drivers/char/tpm/tpm_crb.c                 |  39 ++---
 drivers/char/tpm/tpm_ppi.c                 |  34 ++--
 drivers/char/tpm/tpm_tis.c                 | 192 ++++++++++++++++++----
 fs/sysfs/group.c                           |  44 +++++
 include/keys/trusted-type.h                |  14 +-
 include/linux/sysfs.h                      |  11 ++
 include/linux/tpm.h                        |  26 +++
 security/keys/trusted.c                    |  36 ++++-
 security/keys/trusted.h                    |  11 --
 15 files changed, 793 insertions(+), 118 deletions(-)

-- 
2.5.0

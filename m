From: xiaoyan.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH v5 0/2] Add PPI support in tpm driver
Date: Wed, 22 Aug 2012 18:47:20 +0800
Message-ID: <1345632442-1458-1-git-send-email-xiaoyan.zhang@intel.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: xiaoyan.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, joseph.cihula-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, gang.wei-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, debora-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, srajiv-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, m.selhorst-iBygD9l97zzQT0dZR+AlfA@public.gmane.org, shpedoikal-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yoder1-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, key-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
List-Id: linux-api@vger.kernel.org

From: Xiaoyan Zhang <xiaoyan.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The Physical Presence Interface enables the OS and the BIOS to cooperate to
provide a simple and straightforward platform user experience for
administering the TPM without sacrificing security.

Xiaoyan Zhang (2):
  Documentation: sysfs for Physical Presence Interface
  driver: add PPI support in tpm driver

 Documentation/ABI/testing/sysfs-driver-ppi |   70 +++++
 drivers/char/tpm/Makefile                  |    2 +-
 drivers/char/tpm/tpm.c                     |    5 +
 drivers/char/tpm/tpm.h                     |    9 +
 drivers/char/tpm/tpm_ppi.c                 |  460 ++++++++++++++++++++++++++++
 5 files changed, 545 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-ppi
 create mode 100644 drivers/char/tpm/tpm_ppi.c

-- 
1.7.7.6

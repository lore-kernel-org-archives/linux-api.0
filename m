From: Krzysztof Opasiak <k.opasiak@samsung.com>
Subject: [PATCH v3 0/4] Ensure that lun ids are contiguous
Date: Thu, 09 Apr 2015 18:18:06 +0200
Message-ID: <1428596290-23637-1-git-send-email-k.opasiak@samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: balbi@ti.com, gregkh@linuxfoundation.org, jlbec@evilplan.org
Cc: andrzej.p@samsung.com, m.szyprowski@samsung.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, Krzysztof Opasiak <k.opasiak@samsung.com>
List-Id: linux-api@vger.kernel.org

Dear list,

This series fix configfs interface for mass storage function.
According to mass storage specification[1]:

"Logical Unit Numbers on the device shall be numbered contiguously
 starting from LUN 0 to a maximum LUN of 15 (Fh)."

Currently configfs interface allows to create LUNs with
arbitrary ids what causes problems with some host side
mass storage drivers.

This patch extends configfs interface with unlocked version
of configfs_depend_item() which should be used only in configfs
callbacks. This allows to protect from
removing lun directory from the middle of id space.

Example:

as is:
$ mkdir mass_storage.name
$ mkdir lun.3
$ mkdir lun.5
$ rmdir lun.3

After this series:
$ mkdir mass_storage.name
$ mkdir lun.3
mkdir: cannot create directory 'lun.3': Invalid argument
$ mkdir lun.1
$ mkdir lun.2
$ rmdir lun.1
rmdir: failed to remove 'lun.1': Device or resource busy
$ rmdir lun.2
$ rmdir lun.1

Footnotes:
1 - http://www.usb.org/developers/docs/devclass_docs/usbmassbulk_10.pdf

--
Best regards,
Krzysztof Opasiak
Samsung R&D Institute Poland
Samsung Electronics

---
Changes since v1:
- drop incorrect typo fix
   ("iff" is not a typo but shorten version of "if and only if")

Changes since v2:
- replace BUG_ON() with WARN_ON()
- s/arabic numeral/deciaml value
- add more verbose commit messages
- fix some typos
- move out label in more suitable place

Krzysztof Opasiak (4):
  fs: configfs: Add unlocked version of configfs_depend_item()
  usb: gadget: mass_storage: Store lun_opts in fsg_opts
  usb: gadget: mass_storage: Ensure that lun ids are contiguous
  Documentation: ABI: Fix documentation for mass_storage function

 .../ABI/testing/configfs-usb-gadget-mass-storage   |    7 +++-
 drivers/usb/gadget/function/f_mass_storage.c       |   34 +++++++++++++++++---
 drivers/usb/gadget/function/f_mass_storage.h       |    1 +
 fs/configfs/dir.c                                  |   29 +++++++++++++++++
 include/linux/configfs.h                           |    9 ++++++
 5 files changed, 75 insertions(+), 5 deletions(-)

-- 
1.7.9.5

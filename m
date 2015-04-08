From: Krzysztof Opasiak <k.opasiak-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 0/5] Ensure that lun ids are contiguous
Date: Wed, 08 Apr 2015 13:28:43 +0200
Message-ID: <1428492528-11993-1-git-send-email-k.opasiak@samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: balbi-l0cyMroinI0@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, jlbec-aKy9MeLSZ9dg9hUCZPvPmw@public.gmane.org
Cc: andrzej.p-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Krzysztof Opasiak <k.opasiak-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
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

--
Best regards,
Krzysztof Opasiak
Samsung R&D Institute Poland
Samsung Electronics

Krzysztof Opasiak (5):
  fs: configfs: Fix typo in comment
  fs: configfs: Add unlocked version of configfs_depend_item()
  usb: gadget: mass_storage: Store lun_opts in fsg_opts
  usb: gadget: mass_storage: Ensure that lun ids are contiguous
  Documentation: ABI: Fix documentation for mass_storage function

 .../ABI/testing/configfs-usb-gadget-mass-storage   |    7 +++-
 drivers/usb/gadget/function/f_mass_storage.c       |   40 ++++++++++++++++++--
 drivers/usb/gadget/function/f_mass_storage.h       |    1 +
 fs/configfs/dir.c                                  |   31 ++++++++++++++-
 include/linux/configfs.h                           |    9 +++++
 5 files changed, 82 insertions(+), 6 deletions(-)

-- 
1.7.9.5

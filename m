From: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v2 0/8] uuid: convert users to generic UUID API
Date: Mon,  4 Apr 2016 16:30:02 +0300
Message-ID: <1459776610-68469-1-git-send-email-andriy.shevchenko@linux.intel.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

There are few functions here and there along with type definitions that provide
UUID API. This series consolidates everything under one hood and converts
current users.

This has been tested for a while internally, however it doesn't mean we covered
all possible cases (especially accuracy of UUID constants after conversion).
So, please test this as much as you can and provide your tag. We appreciate the
effort.

Since v1:
- address Matt's comment (fix return value of efivarfs_valid_name())
- drop patches 5 and 6 (ACPI) for now, will return to them after sorting out generic things
- rebase on top of latest linux-next

Andy Shevchenko (8):
  lib/vsprintf: simplify UUID printing
  lib/uuid: move generate_random_uuid() to uuid.c
  lib/uuid: introduce few more generic helpers for UUID
  lib/uuid: remove FSF address
  sysctl: drop away useless label
  sysctl: use generic UUID library
  efi: redefine type, constant, macro from generic code
  efivars: use generic UUID library

 drivers/char/random.c     | 21 +----------
 fs/btrfs/volumes.c        |  2 +-
 fs/efivarfs/inode.c       | 40 ++------------------
 fs/ext4/ioctl.c           |  2 +-
 fs/f2fs/file.c            |  2 +-
 fs/reiserfs/objectid.c    |  2 +-
 fs/ubifs/sb.c             |  2 +-
 include/linux/efi.h       | 14 ++-----
 include/linux/random.h    |  1 -
 include/linux/uuid.h      | 21 ++++++++---
 include/uapi/linux/uuid.h |  4 --
 kernel/sysctl_binary.c    | 30 +++++----------
 lib/uuid.c                | 96 ++++++++++++++++++++++++++++++++++++++++++++---
 lib/vsprintf.c            | 21 ++++-------
 14 files changed, 137 insertions(+), 121 deletions(-)

-- 
2.8.0.rc3

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v3 00/10] uuid: convert users to generic UUID API
Date: Tue,  5 Apr 2016 16:56:09 +0300
Message-ID: <1459864579-55988-1-git-send-email-andriy.shevchenko@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-efi@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, Arnd Bergmann <arnd@arndb.de>, Theodore Ts'o <tytso@mit.edu>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
List-Id: linux-api@vger.kernel.org

There are few functions here and there along with type definitions that provide
UUID API. This series consolidates everything under one hood and converts
current users.

This has been tested for a while internally, however it doesn't mean we covered
all possible cases (especially accuracy of UUID constants after conversion).
So, please test this as much as you can and provide your tag. We appreciate the
effort.

The ACPI conversion is postponed for now to sort more generic things out first.

Since v2:
- uuid_is_valid() now returns boolean (Joe, Stephen)
- remove redundant strnlen() call (Andrew)
- add patches 2 and 10 (one more user converted)

Since v1:
- address Matt's comment (fix return value of efivarfs_valid_name())
- drop patches 5 and 6 (ACPI) for now, will return to them after sorting out generic things
- rebase on top of latest linux-next

Andy Shevchenko (10):
  lib/vsprintf: simplify UUID printing
  ima: use %pU to output UUID in printable format
  lib/uuid: move generate_random_uuid() to uuid.c
  lib/uuid: introduce few more generic helpers for UUID
  lib/uuid: remove FSF address
  sysctl: drop away useless label
  sysctl: use generic UUID library
  efi: redefine type, constant, macro from generic code
  efivars: use generic UUID library
  genhd: move to use generic UUID library

 drivers/char/random.c               | 21 +--------
 fs/btrfs/volumes.c                  |  2 +-
 fs/efivarfs/inode.c                 | 40 ++--------------
 fs/ext4/ioctl.c                     |  2 +-
 fs/f2fs/file.c                      |  2 +-
 fs/reiserfs/objectid.c              |  2 +-
 fs/ubifs/sb.c                       |  2 +-
 include/linux/efi.h                 | 14 ++----
 include/linux/genhd.h               | 23 ++--------
 include/linux/random.h              |  1 -
 include/linux/uuid.h                | 21 +++++++--
 include/uapi/linux/uuid.h           |  4 --
 kernel/sysctl_binary.c              | 30 ++++--------
 lib/uuid.c                          | 91 +++++++++++++++++++++++++++++++++++--
 lib/vsprintf.c                      | 21 ++++-----
 security/integrity/ima/ima_policy.c | 14 +-----
 16 files changed, 137 insertions(+), 153 deletions(-)

-- 
2.8.0.rc3

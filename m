From: Marcin Niesluchowski <m.niesluchow@samsung.com>
Subject: [RFC 0/8] Additional kmsg devices
Date: Fri, 03 Jul 2015 12:49:47 +0200
Message-ID: <1435920595-30879-1-git-send-email-m.niesluchow@samsung.com>
Return-path: <linux-doc-owner@vger.kernel.org>
Sender: linux-doc-owner@vger.kernel.org
To: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.cz>, Tejun Heo <tj@kernel.org>, Kay Sievers <kay@vrfy.org>, Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>, Karol Lewandowski <k.lewandowsk@samsung.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, Marcin Niesluchowski <m.niesluchow@samsung.com>
List-Id: linux-api@vger.kernel.org

Dear All,

This series of patches extends kmsg interface with ability to dynamicaly
create (and destroy) kmsg-like devices which can be used by user space
for logging. Logging to kernel has number of benefits, including but not
limited to - always available, requiring no userspace, automatically
rotating and low overhead.

User-space logging to kernel cyclic buffers was already successfully used
in android logger concept but it had certain flaws that this commits try
to address:
* drops hardcoded number of devices and static paths in favor for dynamic
  configuration by ioctl interface in userspace
* extends existing driver instead of creating completely new one

Those patches apply on branch 'master',
(commit 9bdc771f2c29a11920f477fba05a58e23ee42554):
  git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git

Marcin Niesluchowski (8):
  printk: move code regarding log message storing format
  printk: add one function for storing log in proper format
  kmsg: introduce additional kmsg devices support
  kmsg: add function for adding and deleting additional buffers
  kmsg: device support in mem class
  kmsg: add predefined _PID, _TID, _COMM keywords to kmsg* log dict
  kmsg: add ioctl for adding and deleting kmsg* devices
  kmsg: add ioctl for kmsg* devices operating on buffers

 Documentation/ioctl/ioctl-number.txt |    1 +
 drivers/char/mem.c                   |  154 +++-
 fs/proc/kmsg.c                       |    4 +-
 include/linux/printk.h               |    6 +
 include/uapi/linux/Kbuild            |    1 +
 include/uapi/linux/kmsg_ioctl.h      |   45 ++
 kernel/printk/printk.c               | 1361 ++++++++++++++++++++++------------
 7 files changed, 1087 insertions(+), 485 deletions(-)
 create mode 100644 include/uapi/linux/kmsg_ioctl.h

-- 

Best Regards,
Marcin Niesluchowski

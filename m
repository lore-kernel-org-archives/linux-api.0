From: Paul Osmialowski <p.osmialowsk@samsung.com>
Subject: [RFC v4 0/9] Additional kmsg devices
Date: Mon, 19 Oct 2015 18:49:55 +0200
Message-ID: <1445273404-24562-1-git-send-email-p.osmialowsk@samsung.com>
Return-path: <linux-doc-owner@vger.kernel.org>
Sender: linux-doc-owner@vger.kernel.org
To: Jonathan Corbet <corbet@lwn.net>, Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, Petr Mladek <pmladek@suse.cz>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Daniel Mack <daniel@zonque.org>, Kay Sievers <kay.sievers@vrfy.org>, Joe Perches <joe@perches.com>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org
Cc: Richard Weinberger <richard.weinberger@gmail.com>, Marcin Niesluchowski <m.niesluchow@samsung.com>, Karol Lewandowski <k.lewandowsk@samsung.com>, Paul Osmialowski <p.osmialowsk@samsung.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, Shuah Khan <shuahkh@osg.samsung.com>
List-Id: linux-api@vger.kernel.org

Dear All,

This is the fourth iteration of Marcin Niesluchowski's serie of patches
extending kmsg interface with ability to dynamically create (and destroy)
kmsg-like devices which can be used by userspace for logging.

In this iteration, problems spotted by kbuild test robot are addressed.

Also problem with inproper use of copy_from_user() spotted by
Arnd Bergmanns is fixed (Thanks Arnd!).

I would like to apologize to Richard for omitting him in the CC. This was
unintended.

I do realise that there is a strong movement against putting into kernel
things that could be done in userpsace, however a large number of diverse
environments in which Linux can operate entails greater flexibility in our
perception of what should be in userspace and what should be (carefully)
embraced by the kernel.

Best regards,
Paul

Marcin Niesluchowski (7):
  printk: add one function for storing log in proper format
  kmsg: introduce additional kmsg devices support
  kmsg: add additional buffers support to memory class
  kmsg: add function for adding and deleting additional buffers
  kmsg: add ioctl for adding and deleting kmsg* devices
  kmsg: add ioctl for kmsg* devices operating on buffers
  kmsg: add predefined _PID, _TID, _COMM keywords to kmsg* log dict

Paul Osmialowski (2):
  printk: extract kmsg-related routines from printk.c to kmsg.c
  kmsg: selftests

 Documentation/ioctl/ioctl-number.txt               |    1 +
 drivers/char/mem.c                                 |   27 +-
 fs/proc/kmsg.c                                     |    4 +-
 include/linux/printk.h                             |   48 +
 include/uapi/linux/Kbuild                          |    1 +
 include/uapi/linux/kmsg_ioctl.h                    |   45 +
 kernel/printk/Makefile                             |    1 +
 kernel/printk/kmsg.c                               | 1054 +++++++++++++++++
 kernel/printk/printk.c                             | 1251 +++++---------------
 kernel/printk/printk.h                             |  256 ++++
 samples/kmsg/kmsg-api.h                            |   44 +
 tools/testing/selftests/Makefile                   |    1 +
 tools/testing/selftests/kmsg/.gitignore            |    1 +
 tools/testing/selftests/kmsg/Makefile              |   30 +
 tools/testing/selftests/kmsg/kmsg-test.c           |  329 +++++
 tools/testing/selftests/kmsg/kmsg-test.h           |   34 +
 tools/testing/selftests/kmsg/test-buffer-add-del.c |   76 ++
 .../kmsg/test-buffer-add-write-read-del.c          |  161 +++
 .../kmsg/test-buffer-buf-multithreaded-torture.c   |  199 ++++
 .../selftests/kmsg/test-buffer-buf-torture.c       |  139 +++
 20 files changed, 2737 insertions(+), 965 deletions(-)
 create mode 100644 include/uapi/linux/kmsg_ioctl.h
 create mode 100644 kernel/printk/kmsg.c
 create mode 100644 kernel/printk/printk.h
 create mode 100644 samples/kmsg/kmsg-api.h
 create mode 100644 tools/testing/selftests/kmsg/.gitignore
 create mode 100644 tools/testing/selftests/kmsg/Makefile
 create mode 100644 tools/testing/selftests/kmsg/kmsg-test.c
 create mode 100644 tools/testing/selftests/kmsg/kmsg-test.h
 create mode 100644 tools/testing/selftests/kmsg/test-buffer-add-del.c
 create mode 100644 tools/testing/selftests/kmsg/test-buffer-add-write-read-del.c
 create mode 100644 tools/testing/selftests/kmsg/test-buffer-buf-multithreaded-torture.c
 create mode 100644 tools/testing/selftests/kmsg/test-buffer-buf-torture.c

-- 
1.9.1


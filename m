From: Paul Osmialowski <p.osmialowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: [RFC v2 0/9] Additional kmsg devices
Date: Mon, 12 Oct 2015 11:29:08 +0200
Message-ID: <1444642157-32618-1-git-send-email-p.osmialowsk@samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Petr Mladek <pmladek-AlSwsSmVLrQ@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Marcin Niesluchowski <m.niesluchow-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Karol Lewandowski <k.lewandowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Paul Osmialowski <p.osmialowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Bartlomiej Zolnierkiewicz <b.zolnierkie-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Dear All,

This is the second iteration of Marcin Niesluchowski's serie of patches
extending kmsg interface with ability to dynamically create (and destroy)
kmsg-like devices which can be used by userspace for logging.

Some changes were introduced in this iteration:

- all occurences of '#ifdef CONFIG_PRINTK' removed from drivers/char/mem.c

- printk related code moved to kernel/printk/printk.c

- use of VMCOREINFO_STRUCT_SIZE as suggested by Petr Mladek

- selftests for kmsg added (shape of testing infrastructure based on
  kdbus selftests)

Best regards,
Paul

Marcin Niesluchowski (8):
  printk: move code regarding log message storing format
  printk: add one function for storing log in proper format
  kmsg: introduce additional kmsg devices support
  kmsg: add additional buffers support to memory class
  kmsg: add function for adding and deleting additional buffers
  kmsg: add predefined _PID, _TID, _COMM keywords to kmsg* log dict
  kmsg: add ioctl for adding and deleting kmsg* devices
  kmsg: add ioctl for kmsg* devices operating on buffers

Paul Osmialowski (1):
  kmsg: selftests

 Documentation/ioctl/ioctl-number.txt               |    1 +
 drivers/char/mem.c                                 |   27 +-
 fs/proc/kmsg.c                                     |    4 +-
 include/linux/printk.h                             |   48 +
 include/uapi/linux/Kbuild                          |    1 +
 include/uapi/linux/kmsg_ioctl.h                    |   45 +
 kernel/printk/printk.c                             | 1500 +++++++++++++-------
 samples/kmsg/kmsg-api.h                            |   44 +
 tools/testing/selftests/Makefile                   |    1 +
 tools/testing/selftests/kmsg/.gitignore            |    1 +
 tools/testing/selftests/kmsg/Makefile              |   30 +
 tools/testing/selftests/kmsg/kmsg-test.c           |  329 +++++
 tools/testing/selftests/kmsg/kmsg-test.h           |   34 +
 tools/testing/selftests/kmsg/test-buffer-add-del.c |   76 +
 .../kmsg/test-buffer-add-write-read-del.c          |  161 +++
 .../kmsg/test-buffer-buf-multithreaded-torture.c   |  199 +++
 .../selftests/kmsg/test-buffer-buf-torture.c       |  139 ++
 17 files changed, 2154 insertions(+), 486 deletions(-)
 create mode 100644 include/uapi/linux/kmsg_ioctl.h
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

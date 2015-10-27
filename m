From: Paul Osmialowski <p.osmialowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: [RFC v5 0/8] Additional kmsg devices
Date: Tue, 27 Oct 2015 11:28:35 +0100
Message-ID: <1445941723-20388-1-git-send-email-p.osmialowsk@samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Petr Mladek <pmladek-AlSwsSmVLrQ@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Richard Weinberger <richard.weinberger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Marcin Niesluchowski <m.niesluchow-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Karol Lewandowski <k.lewandowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Paul Osmialowski <p.osmialowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Bartlomiej Zolnierkiewicz <b.zolnierkie-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Dear All,

This is the fifth iteration of Marcin Niesluchowski's serie of patches
extending kmsg interface with ability to dynamically create (and destroy)
kmsg-like devices which can be used by userspace for logging.

This iteration introduces two changes:

1. selftests are rearranged to use kselftest.h API

2. A disputed  patch "add predefined _PID, _TID, _COMM keywords to kmsg*
   log dict" is removed - no chance it will be ever accepted. It is not
   critical for this patchset as a whole.

Best regards,
Paul

Marcin Niesluchowski (6):
  printk: add one function for storing log in proper format
  kmsg: introduce additional kmsg devices support
  kmsg: add additional buffers support to memory class
  kmsg: add function for adding and deleting additional buffers
  kmsg: add ioctl for adding and deleting kmsg* devices
  kmsg: add ioctl for kmsg* devices operating on buffers

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
 kernel/printk/kmsg.c                               | 1022 ++++++++++++++++
 kernel/printk/printk.c                             | 1251 +++++---------------
 kernel/printk/printk.h                             |  256 ++++
 samples/kmsg/kmsg-api.h                            |   44 +
 tools/testing/selftests/Makefile                   |    1 +
 tools/testing/selftests/kmsg/.gitignore            |    1 +
 tools/testing/selftests/kmsg/Makefile              |   30 +
 tools/testing/selftests/kmsg/kmsg-test.c           |  344 ++++++
 tools/testing/selftests/kmsg/kmsg-test.h           |   28 +
 tools/testing/selftests/kmsg/test-buffer-add-del.c |   78 ++
 .../kmsg/test-buffer-add-write-read-del.c          |  163 +++
 .../kmsg/test-buffer-buf-multithreaded-torture.c   |  201 ++++
 .../selftests/kmsg/test-buffer-buf-torture.c       |  141 +++
 20 files changed, 2722 insertions(+), 965 deletions(-)
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

From: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 0/2] openat2: minor uapi cleanups
Date: Sat, 18 Jan 2020 23:07:58 +1100
Message-ID: <20200118120800.16358-1-cyphar@cyphar.com>
References: <20200115144831.GJ8904@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200115144831.GJ8904-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Laight <david.laight-JxhZ9S5GRejQT0dZR+AlfA@public.gmane.org>, Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, quae-l4MFkWPWeOkX2WXlbB3fKg@public.gmane.org, dev-IGmTWi+3HBZvNhPySn5qfx2eb7JE58TQ@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Patch changelog:
  v3:
   * Merge changes into the original patches to make Al's life easier.
     [Al Viro]
  v2:
   * Add include <linux/types.h> to openat2.h. [Florian Weimer]
   * Move OPEN_HOW_SIZE_* constants out of UAPI. [Florian Weimer]
   * Switch from __aligned_u64 to __u64 since it isn't necessary.
     [David Laight]
  v1: <https://lore.kernel.org/lkml/20191219105533.12508-1-cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org/>

While openat2(2) is still not yet in Linus's tree, we can take this
opportunity to iron out some small warts that weren't noticed earlier:

  * A fix was suggested by Florian Weimer, to separate the openat2
    definitions so glibc can use the header directly. I've put the
    maintainership under VFS but let me know if you'd prefer it belong
    ot the fcntl folks.

  * Having heterogenous field sizes in an extensible struct results in
    "padding hole" problems when adding new fields (in addition the
    correct error to use for non-zero padding isn't entirely clear ).
    The simplest solution is to just copy clone(3)'s model -- always use
    u64s. It will waste a little more space in the struct, but it
    removes a possible future headache.

This patch is intended to replace the corresponding patches in Al's
#work.openat2 tree (and *will not* apply on Linus' tree).

@Al: I will send some additional patches later, but they will require
     proper design review since they're ABI-related features (namely,
	 adding a way to check what features a syscall supports as I
	 outlined in my talk here[1]).

[1]: https://youtu.be/ggD-eb3yPVs

Aleksa Sarai (2):
  open: introduce openat2(2) syscall
  selftests: add openat2(2) selftests

 CREDITS                                       |   4 +-
 MAINTAINERS                                   |   1 +
 arch/alpha/kernel/syscalls/syscall.tbl        |   1 +
 arch/arm/tools/syscall.tbl                    |   1 +
 arch/arm64/include/asm/unistd.h               |   2 +-
 arch/arm64/include/asm/unistd32.h             |   2 +
 arch/ia64/kernel/syscalls/syscall.tbl         |   1 +
 arch/m68k/kernel/syscalls/syscall.tbl         |   1 +
 arch/microblaze/kernel/syscalls/syscall.tbl   |   1 +
 arch/mips/kernel/syscalls/syscall_n32.tbl     |   1 +
 arch/mips/kernel/syscalls/syscall_n64.tbl     |   1 +
 arch/mips/kernel/syscalls/syscall_o32.tbl     |   1 +
 arch/parisc/kernel/syscalls/syscall.tbl       |   1 +
 arch/powerpc/kernel/syscalls/syscall.tbl      |   1 +
 arch/s390/kernel/syscalls/syscall.tbl         |   1 +
 arch/sh/kernel/syscalls/syscall.tbl           |   1 +
 arch/sparc/kernel/syscalls/syscall.tbl        |   1 +
 arch/x86/entry/syscalls/syscall_32.tbl        |   1 +
 arch/x86/entry/syscalls/syscall_64.tbl        |   1 +
 arch/xtensa/kernel/syscalls/syscall.tbl       |   1 +
 fs/open.c                                     | 147 +++--
 include/linux/fcntl.h                         |  16 +-
 include/linux/syscalls.h                      |   3 +
 include/uapi/asm-generic/unistd.h             |   5 +-
 include/uapi/linux/fcntl.h                    |   2 +-
 include/uapi/linux/openat2.h                  |  39 ++
 tools/testing/selftests/Makefile              |   1 +
 tools/testing/selftests/openat2/.gitignore    |   1 +
 tools/testing/selftests/openat2/Makefile      |   8 +
 tools/testing/selftests/openat2/helpers.c     | 109 ++++
 tools/testing/selftests/openat2/helpers.h     | 106 ++++
 .../testing/selftests/openat2/openat2_test.c  | 312 +++++++++++
 .../selftests/openat2/rename_attack_test.c    | 160 ++++++
 .../testing/selftests/openat2/resolve_test.c  | 523 ++++++++++++++++++
 34 files changed, 1418 insertions(+), 39 deletions(-)
 create mode 100644 include/uapi/linux/openat2.h
 create mode 100644 tools/testing/selftests/openat2/.gitignore
 create mode 100644 tools/testing/selftests/openat2/Makefile
 create mode 100644 tools/testing/selftests/openat2/helpers.c
 create mode 100644 tools/testing/selftests/openat2/helpers.h
 create mode 100644 tools/testing/selftests/openat2/openat2_test.c
 create mode 100644 tools/testing/selftests/openat2/rename_attack_test.c
 create mode 100644 tools/testing/selftests/openat2/resolve_test.c

-- 
2.24.1

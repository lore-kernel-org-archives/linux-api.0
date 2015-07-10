From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH 0/3] sys_membarrier (x86, generic)
Date: Fri, 10 Jul 2015 16:58:29 -0400
Message-ID: <1436561912-24365-1-git-send-email-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
List-Id: linux-api@vger.kernel.org

Hi Andrew,

Here is a repost of sys_membarrier, rebased on top of Linus commit
c4b5fd3fb2058b650447372472ad24e2a989f9f6 without any change since the
last v19 post other that proceeding to further testing. When merging
with other system calls, system call number conflicts should be quite
straightforward to handle, there is nothing special there.

Please consider pulling it into your tree in preparation for the
following merge window.

Thanks!

Mathieu

Mathieu Desnoyers (2):
  sys_membarrier(): system-wide memory barrier (generic, x86)
  selftests: enhance membarrier syscall test

Pranith Kumar (1):
  selftests: add membarrier syscall test

 MAINTAINERS                                        |   8 ++
 arch/x86/entry/syscalls/syscall_32.tbl             |   1 +
 arch/x86/entry/syscalls/syscall_64.tbl             |   1 +
 include/linux/syscalls.h                           |   2 +
 include/uapi/asm-generic/unistd.h                  |   4 +-
 include/uapi/linux/Kbuild                          |   1 +
 include/uapi/linux/membarrier.h                    |  53 +++++++++
 init/Kconfig                                       |  12 ++
 kernel/Makefile                                    |   1 +
 kernel/membarrier.c                                |  66 +++++++++++
 kernel/sys_ni.c                                    |   3 +
 tools/testing/selftests/Makefile                   |   1 +
 tools/testing/selftests/membarrier/.gitignore      |   1 +
 tools/testing/selftests/membarrier/Makefile        |  11 ++
 .../testing/selftests/membarrier/membarrier_test.c | 121 +++++++++++++++++++++
 15 files changed, 285 insertions(+), 1 deletion(-)
 create mode 100644 include/uapi/linux/membarrier.h
 create mode 100644 kernel/membarrier.c
 create mode 100644 tools/testing/selftests/membarrier/.gitignore
 create mode 100644 tools/testing/selftests/membarrier/Makefile
 create mode 100644 tools/testing/selftests/membarrier/membarrier_test.c

-- 
2.1.4

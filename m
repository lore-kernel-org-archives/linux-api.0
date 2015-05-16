From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for v4.2 0/3] membarrier system call
Date: Sat, 16 May 2015 19:48:17 -0400
Message-ID: <1431820100-17040-1-git-send-email-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Paul E . McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi,

At this point, all we're awaiting for is formal Acked-by by affected
maintainers.

Andrew, should you eventually pick it up into your tree ? Or perhaps it should
go through Paul McKenney's tree, given that it uses synchronize_sched() ?

The only change since last post is a layout change in the patch changelog, so
I'm not even bumping the patch version (kept at v18).

Thanks,

Mathieu

Mathieu Desnoyers (2):
  sys_membarrier(): system-wide memory barrier (generic, x86) (v18)
  selftests: enhance membarrier syscall test

Pranith Kumar (1):
  selftests: add membarrier syscall test

 MAINTAINERS                                        |    8 ++
 arch/x86/syscalls/syscall_32.tbl                   |    1 +
 arch/x86/syscalls/syscall_64.tbl                   |    1 +
 include/linux/syscalls.h                           |    2 +
 include/uapi/asm-generic/unistd.h                  |    4 +-
 include/uapi/linux/Kbuild                          |    1 +
 include/uapi/linux/membarrier.h                    |   53 +++++++++
 init/Kconfig                                       |   12 ++
 kernel/Makefile                                    |    1 +
 kernel/membarrier.c                                |   66 +++++++++++
 kernel/sys_ni.c                                    |    3 +
 tools/testing/selftests/Makefile                   |    1 +
 tools/testing/selftests/membarrier/.gitignore      |    1 +
 tools/testing/selftests/membarrier/Makefile        |   11 ++
 .../testing/selftests/membarrier/membarrier_test.c |  121 ++++++++++++++++++++
 15 files changed, 285 insertions(+), 1 deletions(-)
 create mode 100644 include/uapi/linux/membarrier.h
 create mode 100644 kernel/membarrier.c
 create mode 100644 tools/testing/selftests/membarrier/.gitignore
 create mode 100644 tools/testing/selftests/membarrier/Makefile
 create mode 100644 tools/testing/selftests/membarrier/membarrier_test.c

-- 
1.7.7.3

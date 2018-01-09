From: Mike Rapoport <rppt@linux.vnet.ibm.com>
Subject: [PATCH v5 0/4] vm: add a syscall to map a process memory into a pipe
Date: Tue,  9 Jan 2018 08:30:49 +0200
Message-ID: <1515479453-14672-1-git-send-email-rppt@linux.vnet.ibm.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, criu@openvz.org, gdb@sourceware.org, devel@lists.open-mpi.org, rr-dev@mozilla.org, Arnd Bergmann <arnd@arndb.de>, Pavel Emelyanov <xemul@virtuozzo.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Josh Triplett <josh@joshtriplett.org>, Jann Horn <jannh@google.com>, Greg KH <gregkh@linuxfoundation.org>, Andrei Vagin <avagin@openvz.org>, Mike Rapoport <rppt@linux.vnet.ibm.com>
List-Id: linux-api@vger.kernel.org

Hi,

This patches introduces new process_vmsplice system call that combines
functionality of process_vm_read and vmsplice.

It allows to map the memory of another process into a pipe, similarly to
what vmsplice does for its own address space.

The patch 2/4 ("vm: add a syscall to map a process memory into a pipe")
actually adds the new system call and provides its elaborate description.

The patchset is against -mm tree.

v5: update changelog with more elaborate usecase description
v4: skip test when process_vmsplice syscall is not available
v3: minor refactoring to reduce code duplication
v2: move this syscall under CONFIG_CROSS_MEMORY_ATTACH
    give correct flags to get_user_pages_remote()


Andrei Vagin (3):
  vm: add a syscall to map a process memory into a pipe
  x86: wire up the process_vmsplice syscall
  test: add a test for the process_vmsplice syscall

Mike Rapoport (1):
  fs/splice: introduce pages_to_pipe helper

 arch/x86/entry/syscalls/syscall_32.tbl             |   1 +
 arch/x86/entry/syscalls/syscall_64.tbl             |   2 +
 fs/splice.c                                        | 262 +++++++++++++++++++--
 include/linux/compat.h                             |   3 +
 include/linux/syscalls.h                           |   4 +
 include/uapi/asm-generic/unistd.h                  |   5 +-
 kernel/sys_ni.c                                    |   2 +
 tools/testing/selftests/process_vmsplice/Makefile  |   5 +
 .../process_vmsplice/process_vmsplice_test.c       | 196 +++++++++++++++
 9 files changed, 458 insertions(+), 22 deletions(-)
 create mode 100644 tools/testing/selftests/process_vmsplice/Makefile
 create mode 100644 tools/testing/selftests/process_vmsplice/process_vmsplice_test.c

-- 
2.7.4

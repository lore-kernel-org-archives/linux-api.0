From: Sargun Dhillon <sargun@sargun.me>
Subject: [PATCH v7 0/3] Add pidfd_getfd syscall
Date: Thu, 26 Dec 2019 18:02:30 +0000
Message-ID: <20191226180227.GA29389@ircssh-2.c.rugged-nimbus-611.internal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: tycho@tycho.ws, jannh@google.com, cyphar@cyphar.com, christian.brauner@ubuntu.com, oleg@redhat.com, luto@amacapital.net, viro@zeniv.linux.org.uk, gpascutto@mozilla.com, ealvarez@mozilla.com, fweimer@redhat.com, jld@mozilla.com, arnd@arndb.de
List-Id: linux-api@vger.kernel.org

This patchset introduces a mechanism (pidfd_getfd syscall) to get file
descriptors from other processes via pidfd. Although this can be achieved
using SCM_RIGHTS, and parasitic code injection, this offers a more
straightforward mechanism, with less overhead and complexity. The process
under manipulation's fd still remains valid, and unmodified by the
copy operation.

It introduces a flags field. The flags field is reserved a the moment,
but the intent is to extend it with the following capabilities:
 * Close the remote FD when copying it
 * Drop the cgroup data if it's a fd pointing a socket when copying it

The syscall numbers were chosen to be one greater than openat2.

Summary of history:
This initially started as a ptrace command. It did not require the process
to be stopped, and felt like kind of an awkward fit for ptrace. After that,
it moved to an ioctl on the pidfd. Given functionality, it made sense to
make it a syscall which did not require the process to be stopped.

Previous versions:
 V6: https://lore.kernel.org/lkml/20191223210823.GA25083@ircssh-2.c.rugged-nimbus-611.internal/
 V5: https://lore.kernel.org/lkml/20191220232746.GA20215@ircssh-2.c.rugged-nimbus-611.internal/
 V4: https://lore.kernel.org/lkml/20191218235310.GA17259@ircssh-2.c.rugged-nimbus-611.internal/
 V3: https://lore.kernel.org/lkml/20191217005842.GA14379@ircssh-2.c.rugged-nimbus-611.internal/
 V2: https://lore.kernel.org/lkml/20191209070446.GA32336@ircssh-2.c.rugged-nimbus-611.internal/
 RFC V1: https://lore.kernel.org/lkml/20191205234450.GA26369@ircssh-2.c.rugged-nimbus-611.internal/

Changes since v6:
 * Proper attribution of get_task_file helper
 * Move all types for syscall to int to represent fd

Changes since v5:
 * Drop pidfd_getfd_options struct and replace with a flags field

Changes since v4:
 * Turn into a syscall
 * Move to PTRACE_MODE_ATTACH_REALCREDS from PTRACE_MODE_READ_REALCREDS
 * Remove the sample code. This will come in another patchset, as the
   new self-tests cover all the functionality.

Changes since v3:
 * Add self-test
 * Move to ioctl passing fd directly, versus args struct
 * Shuffle around include files

Changes since v2:
 * Move to ioctl on pidfd instead of ptrace function
 * Add security check before moving file descriptor

Changes since the RFC v1:
 * Introduce a new helper to fs/file.c to fetch a file descriptor from
   any process. It largely uses the code suggested by Oleg, with a few
   changes to fix locking
 * It uses an extensible options struct to supply the FD, and option.
 * I added a sample, using the code from the user-ptrace sample

Sargun Dhillon (3):
  vfs, fdtable: Add get_task_file helper
  pid: Introduce pidfd_getfd syscall
  test: Add test for pidfd getfd

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
 fs/file.c                                     |  21 +-
 include/linux/file.h                          |   2 +
 include/linux/syscalls.h                      |   1 +
 include/uapi/asm-generic/unistd.h             |   4 +-
 kernel/pid.c                                  | 103 +++++++
 tools/testing/selftests/pidfd/.gitignore      |   1 +
 tools/testing/selftests/pidfd/Makefile        |   2 +-
 .../selftests/pidfd/pidfd_getfd_test.c        | 254 ++++++++++++++++++
 26 files changed, 403 insertions(+), 5 deletions(-)
 create mode 100644 tools/testing/selftests/pidfd/pidfd_getfd_test.c

-- 
2.20.1

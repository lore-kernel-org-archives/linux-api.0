From: David Drysdale <drysdale@google.com>
Subject: [PATCHv5 0/3] syscalls,x86: Add execveat() system call
Date: Wed, 22 Oct 2014 12:44:26 +0100
Message-ID: <1413978269-17274-1-git-send-email-drysdale@google.com>
Return-path: <linux-arch-owner@vger.kernel.org>
Sender: linux-arch-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>, Andy Lutomirski <luto@amacapital.net>, Alexander Viro <viro@zeniv.linux.org.uk>, Meredydd Luff <meredydd@senatehouse.org>, linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, x86@kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, David Drysdale <drysdale@google.com>
List-Id: linux-api@vger.kernel.org

This patch set adds execveat(2) for x86, and is derived from Meredydd
Luff's patch from Sept 2012 (https://lkml.org/lkml/2012/9/11/528).

The primary aim of adding an execveat syscall is to allow an
implementation of fexecve(3) that does not rely on the /proc
filesystem.  The current glibc version of fexecve(3) is implemented
via /proc, which causes problems in sandboxed or otherwise restricted
environments.

Given the desire for a /proc-free fexecve() implementation, HPA
suggested (https://lkml.org/lkml/2006/7/11/556) that an execveat(2)
syscall would be an appropriate generalization.

Also, having a new syscall means that it can take a flags argument
without back-compatibility concerns.  The current implementation just
defines the AT_EMPTY_PATH and AT_SYMLINK_NOFOLLOW flags, but other
flags could be added in future -- for example, flags for new namespaces
(as suggested at https://lkml.org/lkml/2006/7/11/474).

Related history:
 - https://lkml.org/lkml/2006/12/27/123 is an example of someone
   realizing that fexecve() is likely to fail in a chroot environment.
 - http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=514043 covered
   documenting the /proc requirement of fexecve(3) in its manpage, to
   "prevent other people from wasting their time".
 - https://bugzilla.kernel.org/show_bug.cgi?id=74481 documented that
   it's not possible to fexecve() a file descriptor for a script with
   close-on-exec set (which is possible with the implementation here).
 - https://bugzilla.redhat.com/show_bug.cgi?id=241609 described a
   problem where a process that did setuid() could not fexecve()
   because it no longer had access to /proc/self/fd; this has since
   been fixed.


Changes since v4, suggested by Eric W. Biederman:
 - Use empty filename with AT_EMPTY_PATH flag rather than NULL
   pathname to request fexecve-like behaviour.
 - Build pathname as "/dev/fd/<fd>/<filename>" (or "/dev/fd/<fd>")
   rather than using d_path().
 - Patch against v3.17 (bfe01a5ba249)

Changes since Meredydd's v3 patch:
 - Added a selftest.
 - Added a man page.
 - Left open_exec() signature untouched to reduce patch impact
   elsewhere (as suggested by Al Viro).
 - Filled in bprm->filename with d_path() into a buffer, to avoid use
   of potentially-ephemeral dentry->d_name.
 - Patch against v3.14 (455c6fdbd21916).


David Drysdale (2):
  syscalls,x86: implement execveat() system call
  syscalls,x86: add selftest for execveat(2)

 arch/x86/ia32/audit.c                   |   1 +
 arch/x86/ia32/ia32entry.S               |   1 +
 arch/x86/kernel/audit_64.c              |   1 +
 arch/x86/kernel/entry_64.S              |  28 +++
 arch/x86/syscalls/syscall_32.tbl        |   1 +
 arch/x86/syscalls/syscall_64.tbl        |   2 +
 arch/x86/um/sys_call_table_64.c         |   1 +
 fs/exec.c                               | 130 ++++++++++++--
 fs/namei.c                              |   2 +-
 include/linux/compat.h                  |   3 +
 include/linux/fs.h                      |   1 +
 include/linux/sched.h                   |   4 +
 include/linux/syscalls.h                |   4 +
 include/uapi/asm-generic/unistd.h       |   4 +-
 kernel/sys_ni.c                         |   3 +
 lib/audit.c                             |   3 +
 tools/testing/selftests/Makefile        |   1 +
 tools/testing/selftests/exec/.gitignore |   6 +
 tools/testing/selftests/exec/Makefile   |  22 +++
 tools/testing/selftests/exec/execveat.c | 295 ++++++++++++++++++++++++++++++++
 20 files changed, 497 insertions(+), 16 deletions(-)
 create mode 100644 tools/testing/selftests/exec/.gitignore
 create mode 100644 tools/testing/selftests/exec/Makefile
 create mode 100644 tools/testing/selftests/exec/execveat.c

-- 
2.1.0.rc2.206.gedb03e5

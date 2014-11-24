From: David Drysdale <drysdale@google.com>
Subject: [PATCHv10 0/5] syscalls,x86,sparc: Add execveat() system call
Date: Mon, 24 Nov 2014 11:53:54 +0000
Message-ID: <1416830039-21952-1-git-send-email-drysdale@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>, Andy Lutomirski <luto@amacapital.net>, Alexander Viro <viro@zeniv.linux.org.uk>, Meredydd Luff <meredydd@senatehouse.org>, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, David Miller <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Oleg Nesterov <oleg@redhat.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, Rich Felker <dalias@aerifal.cx>, Christoph Hellwig <hch@infradead.org>, x86@kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, sparclinux@vger.kernel.org, David Drysdale <drysdale@google.com>
List-Id: linux-api@vger.kernel.org

This patch set adds execveat(2) for x86 and sparc, and is derived from
Meredydd Luff's patch from Sept 2012 (https://lkml.org/lkml/2012/9/11/528).

The primary aim of adding an execveat syscall is to allow an
implementation of fexecve(3) that does not rely on the /proc
filesystem, at least for executables (rather than scripts).  The
current glibc version of fexecve(3) is implemented via /proc, which
causes problems in sandboxed or otherwise restricted environments.

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
 - https://bugzilla.redhat.com/show_bug.cgi?id=241609 described a
   problem where a process that did setuid() could not fexecve()
   because it no longer had access to /proc/self/fd; this has since
   been fixed.


Changes since v9:
 - Add sparc syscall wrappers and use correct sparc 32b compatibility
   function [Stephen Rothwell, David S. Miller]

Changes since v8:
 - Split core/fs changes from x86 changes [Thomas Gleixner]

Changes since v7:
 - Speculatively wire up sparc version of syscall (untested)
 - Fix leak of pathbuf in mainline arm [Oleg Nesterov]
 - Add rcu_dereference_raw() on fdt access [sparse kbuild robot]
 - Realigned comment [Andrew Morton]
 - Merged up to v3.18-rc4

Changes since v6:
 - Remove special case for O_PATH file descriptors [Andy Lutomirski]
 - Use kasprintf rather than error-prone arithmetic [Kees Cook]
 - Add test for long name [Kees Cook]
 - Add test for non-executable O_PATH fd [Andy Lutomirski]

Changes since v5:
 - Set new flag in bprm->interp_flags for O_CLOEXEC fds, so that binfmts
   that invoke an interpreter fail the exec (as they will not be able
   to access the invoked file). [Andy Lutomirski]
 - Don't truncate long paths. [Andy Lutomirski]
 - Commonize code to open the executed file. [Eric W. Biederman]
 - Mark O_PATH file descriptors so they cannot be fexecve()ed.
 - Make self-test more helpful, and add additional cases:
     - file offset non-zero
     - binary file without execute bit
     - O_CLOEXEC fds

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


David Drysdale (4):
  syscalls: implement execveat() system call
  x86: Hook up execveat system call.
  syscalls: add selftest for execveat(2)
  sparc: Hook up execveat system call.

 arch/sparc/include/uapi/asm/unistd.h    |   3 +-
 arch/sparc/kernel/systbls_32.S          |   1 +
 arch/sparc/kernel/systbls_64.S          |   2 +
 arch/x86/ia32/audit.c                   |   1 +
 arch/x86/ia32/ia32entry.S               |   1 +
 arch/x86/kernel/audit_64.c              |   1 +
 arch/x86/kernel/entry_64.S              |  28 +++
 arch/x86/syscalls/syscall_32.tbl        |   1 +
 arch/x86/syscalls/syscall_64.tbl        |   2 +
 arch/x86/um/sys_call_table_64.c         |   1 +
 fs/binfmt_em86.c                        |   4 +
 fs/binfmt_misc.c                        |   4 +
 fs/binfmt_script.c                      |  10 +
 fs/exec.c                               | 113 +++++++--
 fs/namei.c                              |   2 +-
 include/linux/binfmts.h                 |   4 +
 include/linux/compat.h                  |   3 +
 include/linux/fs.h                      |   1 +
 include/linux/sched.h                   |   4 +
 include/linux/syscalls.h                |   5 +
 include/uapi/asm-generic/unistd.h       |   4 +-
 kernel/sys_ni.c                         |   3 +
 lib/audit.c                             |   3 +
 tools/testing/selftests/Makefile        |   1 +
 tools/testing/selftests/exec/.gitignore |   9 +
 tools/testing/selftests/exec/Makefile   |  25 ++
 tools/testing/selftests/exec/execveat.c | 397 ++++++++++++++++++++++++++++++++
 27 files changed, 617 insertions(+), 16 deletions(-)
 create mode 100644 tools/testing/selftests/exec/.gitignore
 create mode 100644 tools/testing/selftests/exec/Makefile
 create mode 100644 tools/testing/selftests/exec/execveat.c

-- 
2.1.0.rc2.206.gedb03e5

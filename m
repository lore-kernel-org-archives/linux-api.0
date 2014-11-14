From: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCHv8 0/4] syscalls,x86,sparc: Add execveat() system call
Date: Fri, 14 Nov 2014 16:22:59 +0000
Message-ID: <1415982183-20525-1-git-send-email-drysdale@google.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Meredydd Luff <meredydd-zPN50pYk8eUaUu29zAJCuw@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Rich Felker <dalias-/miJ2pyFWUyWIDz0JBNUog@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sparclinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Sparc folks: the kbuild robots complained about sparc missing this
syscall, so I've speculatively included an extra patch in this
version for that.

However, I've not run it (only cross-compiled it), so it may be best
to skip the [3/4] patch and let the experts deal with other
architectures later -- I'm not sure what's the best practice for adding
a new syscall.

.........

This patch set adds execveat(2) for x86, and is derived from Meredydd
Luff's patch from Sept 2012 (https://lkml.org/lkml/2012/9/11/528).

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


David Drysdale (3):
  syscalls,x86: implement execveat() system call
  syscalls,x86: add selftest for execveat(2)
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

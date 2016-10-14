From: Marcin Nowakowski <marcin.nowakowski-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v4 00/12] syscall/tracing: compat syscall support
Date: Fri, 14 Oct 2016 10:35:02 +0200
Message-ID: <1476434115-25428-1-git-send-email-marcin.nowakowski@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, Marcin Nowakowski <marcin.nowakowski-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This patchset adds support syscall event tracing for compat syscalls.

Patch 1 removes the unnecessary syscall_nr field from syscall metadata,
which was one of the obstacles for adding proper support for compat syscalls.

Patch 2 adds a method to distinguish handling of syscalls for compat tasks
if an arch requires that. In disussions about an earlier version of these
patches (http://marc.info/?l=linux-mips&m=147259973128606&w=2) it was suggested
to use audit arch for detecting syscall type. After analysing the code
for various arches it seemed to me that this would add an unnecessary
complexity (as would require extra APIs to enumerate and map all audit
arch types) and I've just simply used compat task status to determine call
type. I cannot see any added value from using the audit arch type in this
context.

Patch 3 removes arch_syscall_match_sym_name function which was only redefined
by ppc and replaces it with a a more simple solution that makes it easy to
modify the method later without changing arch-specific method

Patch 4 (3 in pre rev 4)  add compat syscall metadata - this is mostly a copy
of a set of macros for generating metadata for standard syscalls.

Further patches add arch-specific methods required for differentiating between
standard and compat syscalls as well as for finding syscall addresses from
inside syscall tables.

I have tried to keep the tracing system working for bisections - and most
things work as previously until arch-specific patch is applied. The only
exception here is x86 which had extra methods to prevent incorrect syscall
reporting for compat tasks - this may happen after patch 2 is applied and 
without x86/tracing patch.

version 4:
- fix an invalid exit handler registration
- drop arch_syscall_match_sym_name as only used by ppc and replace it with
  a single #define for string offset (suggested by Michael Ellerman)
- x86: reword and bring back a comment on ia32/x86_64 syscall number differences
  (suggested by tglx)
- arm64: drop __NR_compat_syscalls (suggested by Will Deacon)

version 3:
- rebase on top of linux-next-20161011
- tile: change in_compat_syscall to is_compat_task (suggested and signed-off by
        Chris Metcalf)


Marcin Nowakowski (12):
  tracing/syscalls: remove syscall_nr from syscall metadata
  tracing/syscalls: add handling for compat tasks
  tracing/syscalls: drop arch_syscall_match_sym_name
  tracing/syscalls: add compat syscall metadata
  syscall/tracing: allow arch to override syscall_get_nr for ftrace
  x86/tracing: fix compat syscall handling
  s390/tracing: fix compat syscall handling
  arm64/tracing: fix compat syscall handling
  powerpc/tracing: fix compat syscall handling
  tile/tracing: fix compat syscall handling
  sparc/tracing: fix compat syscall handling
  parisc/tracing: fix compat syscall handling

 Documentation/trace/ftrace-design.txt |   4 -
 arch/arm64/include/asm/ftrace.h       |  12 +-
 arch/arm64/include/asm/unistd.h       |   2 +-
 arch/arm64/include/asm/unistd32.h     |   2 +-
 arch/arm64/kernel/Makefile            |   1 +
 arch/arm64/kernel/entry.S             |   2 +-
 arch/arm64/kernel/ftrace.c            |  16 ++
 arch/arm64/kernel/sys32.c             |   4 +-
 arch/mips/kernel/ftrace.c             |   4 +-
 arch/parisc/include/asm/ftrace.h      |  10 ++
 arch/parisc/kernel/Makefile           |   1 +
 arch/parisc/kernel/ftrace.c           |  15 ++
 arch/powerpc/include/asm/ftrace.h     |  24 +--
 arch/powerpc/kernel/ftrace.c          |   6 +-
 arch/s390/include/asm/ftrace.h        |  11 ++
 arch/s390/include/asm/syscall.h       |   1 +
 arch/s390/kernel/Makefile             |   1 +
 arch/s390/kernel/ftrace.c             |  12 ++
 arch/sparc/include/asm/ftrace.h       |  10 ++
 arch/sparc/kernel/Makefile            |   1 +
 arch/sparc/kernel/ftrace.c            |  14 ++
 arch/tile/include/asm/ftrace.h        |  10 ++
 arch/tile/kernel/Makefile             |   1 +
 arch/tile/kernel/ftrace.c             |  13 ++
 arch/x86/include/asm/ftrace.h         |  14 +-
 arch/x86/include/asm/syscall.h        |   9 ++
 arch/x86/kernel/ftrace.c              |  23 +++
 include/linux/compat.h                |  74 ++++++++++
 include/linux/ftrace.h                |   2 +-
 include/linux/syscalls.h              |   1 -
 include/trace/syscall.h               |   2 -
 kernel/trace/trace.h                  |  17 ++-
 kernel/trace/trace_syscalls.c         | 271 +++++++++++++++++++++-------------
 33 files changed, 432 insertions(+), 158 deletions(-)

-- 
2.7.4

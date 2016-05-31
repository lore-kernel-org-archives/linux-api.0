From: Dave Hansen <dave-gkUM19QKKo4@public.gmane.org>
Subject: [PATCH 0/8] System Calls for Memory Protection Keys
Date: Tue, 31 May 2016 08:28:14 -0700
Message-ID: <20160531152814.36E0B9EE@viggo.jf.intel.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Dave Hansen <dave-gkUM19QKKo4@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Are there any concerns with merging these into the x86 tree so
that they go upstream for 4.8?

--

Memory Protection Keys for User pages (pkeys) is a CPU feature
which will first appear on Skylake Servers, but will also be
supported on future non-server parts.  It provides a mechanism
for enforcing page-based protections, but without requiring
modification of the page tables when an application changes
wishes to change permissions.

Patches to implement execute-only mapping support using pkeys
were merged in to 4.6.  But, to do anything else useful with
pkeys, an application needs to be able to set the pkey field in
the PTE (obviously has to be done in-kernel) and make changes to
the "rights" register (using unprivileged instructions).

An application also needs to have an an allocator for the keys
themselves.  If two different parts of an application both want
to protect their data with pkeys, they first need to know which
key to use for their individual purposes.

This set introduces 5 system calls, in 3 logical groups:

1. PTE pkey setting (sys_pkey_mprotect(), patches #1-3)
2. Key allocation (sys_pkey_alloc() / sys_pkey_free(), patch #4)
3. Rights register manipulation (sys_pkey_set/get(), patch #5)

These patches build on top of "core" pkeys support already in
4.6, and are based on 4.6 itself with the compat siginfo fix
patches applied (includes MPX selftests).

I have manpages written for some of these syscalls, and have
had multiple rounds of reviews on the manpages list.

This set is also available here (including a fix for the compat
signal handler code):

	git://git.kernel.org/pub/scm/linux/kernel/git/daveh/x86-pkeys.git pkeys-v034

I've written a set of unit tests for these interfaces, which is
available as the last patch in the series and integrated in to
kselftests.

Note: this is based on a plain 4.6 kernel and will have a minor
merge conflict in the x86 selftests makefile with the new
MPX selftest if those get merged first.

=== diffstat ===

Dave Hansen (8):
      x86, pkeys: add fault handling for PF_PK page fault bit
      mm: implement new pkey_mprotect() system call
      x86, pkeys: make mprotect_key() mask off additional vm_flags
      x86: wire up mprotect_key() system call
      x86, pkeys: allocation/free syscalls
      x86, pkeys: add pkey set/get syscalls
      pkeys: add details of system call use to Documentation/
      x86, pkeys: add self-tests

 Documentation/x86/protection-keys.txt         |   63 +
 arch/alpha/include/uapi/asm/mman.h            |    5 +
 arch/mips/include/uapi/asm/mman.h             |    5 +
 arch/parisc/include/uapi/asm/mman.h           |    5 +
 arch/x86/entry/syscalls/syscall_32.tbl        |    5 +
 arch/x86/entry/syscalls/syscall_64.tbl        |    5 +
 arch/x86/include/asm/mmu.h                    |    8 +
 arch/x86/include/asm/mmu_context.h            |   25 +-
 arch/x86/include/asm/pkeys.h                  |   80 +-
 arch/x86/kernel/fpu/xstate.c                  |   73 +-
 arch/x86/mm/fault.c                           |    9 +
 arch/x86/mm/pkeys.c                           |   38 +-
 arch/xtensa/include/uapi/asm/mman.h           |    5 +
 include/linux/pkeys.h                         |   39 +-
 include/uapi/asm-generic/mman-common.h        |    5 +
 mm/mprotect.c                                 |  134 +-
 tools/testing/selftests/x86/Makefile          |    2 +-
 tools/testing/selftests/x86/pkey-helpers.h    |  187 +++
 tools/testing/selftests/x86/protection_keys.c | 1249 +++++++++++++++++
 19 files changed, 1912 insertions(+), 30 deletions(-)

Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org

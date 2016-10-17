From: Dave Hansen <dave@sr71.net>
Subject: [PATCH] x86, pkeys: remove cruft from never-merged syscalls
Date: Mon, 17 Oct 2016 13:57:09 -0700
Message-ID: <20161017205709.FC7C0C1D@viggo.jf.intel.com>
Return-path: <linux-arch-owner@vger.kernel.org>
Sender: linux-arch-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Dave Hansen <dave@sr71.net>, dave.hansen@linux.intel.com, tglx@linutronix.de, linux-arch@vger.kernel.org, mgorman@techsingularity.net, arnd@arndb.de, linux-api@vger.kernel.org, linux-mm@kvack.org, luto@kernel.org, akpm@linux-foundation.org, torvalds@linux-foundation.org
List-Id: linux-api@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

pkey_set() and pkey_get() were syscalls present in older versions
of the protection keys patches.  The syscall number definitions
were inadvertently left in place.  This patch removes them.

I did a git grep and verified that these are the last places in
the tree that these appear, save for the protection_keys.c tests
and Documentation.  Those spots talk about functions called
pkey_get/set() which are wrappers for the direct PKRU
instructions, not the syscalls.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arch@vger.kernel.org
Cc: mgorman@techsingularity.net
Cc: arnd@arndb.de
Cc: linux-api@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: luto@kernel.org
Cc: akpm@linux-foundation.org
Cc: torvalds@linux-foundation.org
Fixes: f9afc6197e9bb ("x86: Wire up protection keys system calls")
---

 b/arch/x86/entry/syscalls/syscall_32.tbl |    2 --
 b/arch/x86/entry/syscalls/syscall_64.tbl |    2 --
 2 files changed, 4 deletions(-)

diff -puN arch/x86/entry/syscalls/syscall_32.tbl~kill-x86-pkey-syscall-nr-cruft arch/x86/entry/syscalls/syscall_32.tbl
--- a/arch/x86/entry/syscalls/syscall_32.tbl~kill-x86-pkey-syscall-nr-cruft	2016-10-17 13:00:11.607811388 -0700
+++ b/arch/x86/entry/syscalls/syscall_32.tbl	2016-10-17 13:00:14.216930557 -0700
@@ -389,5 +389,3 @@
 380	i386	pkey_mprotect		sys_pkey_mprotect
 381	i386	pkey_alloc		sys_pkey_alloc
 382	i386	pkey_free		sys_pkey_free
-#383	i386	pkey_get		sys_pkey_get
-#384	i386	pkey_set		sys_pkey_set
diff -puN arch/x86/entry/syscalls/syscall_64.tbl~kill-x86-pkey-syscall-nr-cruft arch/x86/entry/syscalls/syscall_64.tbl
--- a/arch/x86/entry/syscalls/syscall_64.tbl~kill-x86-pkey-syscall-nr-cruft	2016-10-17 13:00:11.609811480 -0700
+++ b/arch/x86/entry/syscalls/syscall_64.tbl	2016-10-17 13:00:21.896281301 -0700
@@ -338,8 +338,6 @@
 329	common	pkey_mprotect		sys_pkey_mprotect
 330	common	pkey_alloc		sys_pkey_alloc
 331	common	pkey_free		sys_pkey_free
-#332	common	pkey_get		sys_pkey_get
-#333	common	pkey_set		sys_pkey_set
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
_

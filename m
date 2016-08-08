From: Dave Hansen <dave@sr71.net>
Subject: [PATCH 05/10] x86: wire up protection keys system calls
Date: Mon, 08 Aug 2016 16:18:27 -0700
Message-ID: <20160808231827.3530A2CB@viggo.jf.intel.com>
References: <20160808231820.F7A9C4D8@viggo.jf.intel.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20160808231820.F7A9C4D8@viggo.jf.intel.com>
Sender: owner-linux-mm@kvack.org
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, linux-mm@kvack.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, luto@kernel.org, mgorman@techsingularity.net, Dave Hansen <dave@sr71.net>, dave.hansen@linux.intel.com, arnd@arndb.de
List-Id: linux-api@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

This is all that we need to get the new system calls themselves
working on x86.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-api@vger.kernel.org
Cc: linux-arch@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: x86@kernel.org
Cc: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: mgorman@techsingularity.net
---

 b/arch/x86/entry/syscalls/syscall_32.tbl |    5 +++++
 b/arch/x86/entry/syscalls/syscall_64.tbl |    5 +++++
 2 files changed, 10 insertions(+)

diff -puN arch/x86/entry/syscalls/syscall_32.tbl~pkeys-114-x86-mprotect_key arch/x86/entry/syscalls/syscall_32.tbl
--- a/arch/x86/entry/syscalls/syscall_32.tbl~pkeys-114-x86-mprotect_key	2016-08-08 16:15:11.759084960 -0700
+++ b/arch/x86/entry/syscalls/syscall_32.tbl	2016-08-08 16:15:11.765085233 -0700
@@ -386,3 +386,8 @@
 377	i386	copy_file_range		sys_copy_file_range
 378	i386	preadv2			sys_preadv2			compat_sys_preadv2
 379	i386	pwritev2		sys_pwritev2			compat_sys_pwritev2
+380	i386	pkey_mprotect		sys_pkey_mprotect
+381	i386	pkey_alloc		sys_pkey_alloc
+382	i386	pkey_free		sys_pkey_free
+#383	i386	pkey_get		sys_pkey_get
+#384	i386	pkey_set		sys_pkey_set
diff -puN arch/x86/entry/syscalls/syscall_64.tbl~pkeys-114-x86-mprotect_key arch/x86/entry/syscalls/syscall_64.tbl
--- a/arch/x86/entry/syscalls/syscall_64.tbl~pkeys-114-x86-mprotect_key	2016-08-08 16:15:11.761085051 -0700
+++ b/arch/x86/entry/syscalls/syscall_64.tbl	2016-08-08 16:15:11.765085233 -0700
@@ -335,6 +335,11 @@
 326	common	copy_file_range		sys_copy_file_range
 327	64	preadv2			sys_preadv2
 328	64	pwritev2		sys_pwritev2
+329	common	pkey_mprotect		sys_pkey_mprotect
+330	common	pkey_alloc		sys_pkey_alloc
+331	common	pkey_free		sys_pkey_free
+#332	common	pkey_get		sys_pkey_get
+#333	common	pkey_set		sys_pkey_set
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
_

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

From: Dave Hansen <dave-gkUM19QKKo4@public.gmane.org>
Subject: [PATCH 22/25] x86: wire up mprotect_key() system call
Date: Mon, 28 Sep 2015 12:18:26 -0700
Message-ID: <20150928191826.0F8DA9A7@viggo.jf.intel.com>
References: <20150928191817.035A64E2@viggo.jf.intel.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150928191817.035A64E2-LXbPSdftPKxrdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dave-gkUM19QKKo4@public.gmane.org
Cc: borntraeger-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


From: Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

This is all that we need to get the new system call itself
working on x86.

Signed-off-by: Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---

 b/arch/x86/entry/syscalls/syscall_32.tbl |    1 +
 b/arch/x86/entry/syscalls/syscall_64.tbl |    1 +
 b/arch/x86/include/uapi/asm/mman.h       |    7 +++++++
 b/mm/Kconfig                             |    1 +
 4 files changed, 10 insertions(+)

diff -puN arch/x86/entry/syscalls/syscall_32.tbl~pkeys-16-x86-mprotect_key arch/x86/entry/syscalls/syscall_32.tbl
--- a/arch/x86/entry/syscalls/syscall_32.tbl~pkeys-16-x86-mprotect_key	2015-09-28 11:39:50.964411042 -0700
+++ b/arch/x86/entry/syscalls/syscall_32.tbl	2015-09-28 11:39:50.972411406 -0700
@@ -382,3 +382,4 @@
 373	i386	shutdown		sys_shutdown
 374	i386	userfaultfd		sys_userfaultfd
 375	i386	membarrier		sys_membarrier
+376	i386	mprotect_key		sys_mprotect_key
diff -puN arch/x86/entry/syscalls/syscall_64.tbl~pkeys-16-x86-mprotect_key arch/x86/entry/syscalls/syscall_64.tbl
--- a/arch/x86/entry/syscalls/syscall_64.tbl~pkeys-16-x86-mprotect_key	2015-09-28 11:39:50.965411087 -0700
+++ b/arch/x86/entry/syscalls/syscall_64.tbl	2015-09-28 11:39:50.972411406 -0700
@@ -331,6 +331,7 @@
 322	64	execveat		stub_execveat
 323	common	userfaultfd		sys_userfaultfd
 324	common	membarrier		sys_membarrier
+325	common	mprotect_key		sys_mprotect_key
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
diff -puN arch/x86/include/uapi/asm/mman.h~pkeys-16-x86-mprotect_key arch/x86/include/uapi/asm/mman.h
--- a/arch/x86/include/uapi/asm/mman.h~pkeys-16-x86-mprotect_key	2015-09-28 11:39:50.967411179 -0700
+++ b/arch/x86/include/uapi/asm/mman.h	2015-09-28 11:39:50.973411451 -0700
@@ -20,6 +20,13 @@
 		((vm_flags) & VM_PKEY_BIT1 ? _PAGE_PKEY_BIT1 : 0) |	\
 		((vm_flags) & VM_PKEY_BIT2 ? _PAGE_PKEY_BIT2 : 0) |	\
 		((vm_flags) & VM_PKEY_BIT3 ? _PAGE_PKEY_BIT3 : 0))
+
+#define arch_calc_vm_prot_bits(prot, key) ( 		\
+		((key) & 0x1 ? VM_PKEY_BIT0 : 0) |      \
+		((key) & 0x2 ? VM_PKEY_BIT1 : 0) |      \
+		((key) & 0x4 ? VM_PKEY_BIT2 : 0) |      \
+		((key) & 0x8 ? VM_PKEY_BIT3 : 0))
+
 #endif
 
 #include <asm-generic/mman.h>
diff -puN mm/Kconfig~pkeys-16-x86-mprotect_key mm/Kconfig
--- a/mm/Kconfig~pkeys-16-x86-mprotect_key	2015-09-28 11:39:50.969411269 -0700
+++ b/mm/Kconfig	2015-09-28 11:39:50.973411451 -0700
@@ -689,4 +689,5 @@ config NR_PROTECTION_KEYS
 	# Everything supports a _single_ key, so allow folks to
 	# at least call APIs that take keys, but require that the
 	# key be 0.
+	default 16 if X86_INTEL_MEMORY_PROTECTION_KEYS
 	default 1
_

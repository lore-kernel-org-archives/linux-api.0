From: Dave Hansen <dave@sr71.net>
Subject: [PATCH 31/37] x86: wire up mprotect_key() system call
Date: Mon, 16 Nov 2015 19:35:54 -0800
Message-ID: <20151117033554.96BBDDEC@viggo.jf.intel.com>
References: <20151117033511.BFFA1440@viggo.jf.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151117033511.BFFA1440@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Dave Hansen <dave@sr71.net>, dave.hansen@linux.intel.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

This is all that we need to get the new system call itself
working on x86.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-api@vger.kernel.org
---

 b/arch/x86/entry/syscalls/syscall_32.tbl |    1 +
 b/arch/x86/entry/syscalls/syscall_64.tbl |    1 +
 b/arch/x86/include/uapi/asm/mman.h       |    6 ++++++
 b/mm/Kconfig                             |    1 +
 4 files changed, 9 insertions(+)

diff -puN arch/x86/entry/syscalls/syscall_32.tbl~pkeys-16-x86-mprotect_key arch/x86/entry/syscalls/syscall_32.tbl
--- a/arch/x86/entry/syscalls/syscall_32.tbl~pkeys-16-x86-mprotect_key	2015-11-16 12:36:30.650682386 -0800
+++ b/arch/x86/entry/syscalls/syscall_32.tbl	2015-11-16 19:21:56.328145123 -0800
@@ -383,3 +383,4 @@
 374	i386	userfaultfd		sys_userfaultfd
 375	i386	membarrier		sys_membarrier
 376	i386	mlock2			sys_mlock2
+377	i386	pkey_mprotect		sys_pkey_mprotect
diff -puN arch/x86/entry/syscalls/syscall_64.tbl~pkeys-16-x86-mprotect_key arch/x86/entry/syscalls/syscall_64.tbl
--- a/arch/x86/entry/syscalls/syscall_64.tbl~pkeys-16-x86-mprotect_key	2015-11-16 12:36:30.652682477 -0800
+++ b/arch/x86/entry/syscalls/syscall_64.tbl	2015-11-16 19:21:56.328145123 -0800
@@ -332,6 +332,7 @@
 323	common	userfaultfd		sys_userfaultfd
 324	common	membarrier		sys_membarrier
 325	common	mlock2			sys_mlock2
+326	common	pkey_mprotect		sys_pkey_mprotect
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
diff -puN arch/x86/include/uapi/asm/mman.h~pkeys-16-x86-mprotect_key arch/x86/include/uapi/asm/mman.h
--- a/arch/x86/include/uapi/asm/mman.h~pkeys-16-x86-mprotect_key	2015-11-16 12:36:30.653682522 -0800
+++ b/arch/x86/include/uapi/asm/mman.h	2015-11-16 12:36:30.659682794 -0800
@@ -20,6 +20,12 @@
 		((vm_flags) & VM_PKEY_BIT1 ? _PAGE_PKEY_BIT1 : 0) |	\
 		((vm_flags) & VM_PKEY_BIT2 ? _PAGE_PKEY_BIT2 : 0) |	\
 		((vm_flags) & VM_PKEY_BIT3 ? _PAGE_PKEY_BIT3 : 0))
+
+#define arch_calc_vm_prot_bits(prot, key) (		\
+		((key) & 0x1 ? VM_PKEY_BIT0 : 0) |      \
+		((key) & 0x2 ? VM_PKEY_BIT1 : 0) |      \
+		((key) & 0x4 ? VM_PKEY_BIT2 : 0) |      \
+		((key) & 0x8 ? VM_PKEY_BIT3 : 0))
 #endif
 
 #include <asm-generic/mman.h>
diff -puN mm/Kconfig~pkeys-16-x86-mprotect_key mm/Kconfig
--- a/mm/Kconfig~pkeys-16-x86-mprotect_key	2015-11-16 12:36:30.655682613 -0800
+++ b/mm/Kconfig	2015-11-16 12:36:30.659682794 -0800
@@ -679,4 +679,5 @@ config NR_PROTECTION_KEYS
 	# Everything supports a _single_ key, so allow folks to
 	# at least call APIs that take keys, but require that the
 	# key be 0.
+	default 16 if X86_INTEL_MEMORY_PROTECTION_KEYS
 	default 1
_

From: akpm@linux-foundation.org
Subject: + preadv-pwritev-mips-add-preadv2-and-pwritev2-syscalls.patch added to -mm tree
Date: Mon, 02 Feb 2009 13:35:39 -0800
Message-ID: <200902022135.n12LZdx6010816@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ralf@linux-mips.org, arnd@arndb.de, kraxel@redhat.com, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, viro@zeniv.linux.org.uk
List-Id: linux-api@vger.kernel.org


The patch titled
     preadv/pwritev: MIPS: Add preadv(2) and pwritev(2) syscalls.
has been added to the -mm tree.  Its filename is
     preadv-pwritev-mips-add-preadv2-and-pwritev2-syscalls.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: preadv/pwritev: MIPS: Add preadv(2) and pwritev(2) syscalls.
From: Ralf Baechle <ralf@linux-mips.org>

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: <linux-api@vger.kernel.org>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/unistd.h |   18 ++++++++++++------
 arch/mips/kernel/scall32-o32.S |    2 ++
 arch/mips/kernel/scall64-64.S  |    2 ++
 arch/mips/kernel/scall64-n32.S |    2 ++
 arch/mips/kernel/scall64-o32.S |    2 ++
 5 files changed, 20 insertions(+), 6 deletions(-)

diff -puN arch/mips/include/asm/unistd.h~preadv-pwritev-mips-add-preadv2-and-pwritev2-syscalls arch/mips/include/asm/unistd.h
--- a/arch/mips/include/asm/unistd.h~preadv-pwritev-mips-add-preadv2-and-pwritev2-syscalls
+++ a/arch/mips/include/asm/unistd.h
@@ -350,16 +350,18 @@
 #define __NR_dup3			(__NR_Linux + 327)
 #define __NR_pipe2			(__NR_Linux + 328)
 #define __NR_inotify_init1		(__NR_Linux + 329)
+#define __NR_preadv			(__NR_Linux + 330)
+#define __NR_pwritev			(__NR_Linux + 331)
 
 /*
  * Offset of the last Linux o32 flavoured syscall
  */
-#define __NR_Linux_syscalls		329
+#define __NR_Linux_syscalls		331
 
 #endif /* _MIPS_SIM == _MIPS_SIM_ABI32 */
 
 #define __NR_O32_Linux			4000
-#define __NR_O32_Linux_syscalls		329
+#define __NR_O32_Linux_syscalls		331
 
 #if _MIPS_SIM == _MIPS_SIM_ABI64
 
@@ -656,16 +658,18 @@
 #define __NR_dup3			(__NR_Linux + 286)
 #define __NR_pipe2			(__NR_Linux + 287)
 #define __NR_inotify_init1		(__NR_Linux + 288)
+#define __NR_preadv			(__NR_Linux + 289)
+#define __NR_pwritev			(__NR_Linux + 290)
 
 /*
  * Offset of the last Linux 64-bit flavoured syscall
  */
-#define __NR_Linux_syscalls		288
+#define __NR_Linux_syscalls		290
 
 #endif /* _MIPS_SIM == _MIPS_SIM_ABI64 */
 
 #define __NR_64_Linux			5000
-#define __NR_64_Linux_syscalls		288
+#define __NR_64_Linux_syscalls		290
 
 #if _MIPS_SIM == _MIPS_SIM_NABI32
 
@@ -966,16 +970,18 @@
 #define __NR_dup3			(__NR_Linux + 290)
 #define __NR_pipe2			(__NR_Linux + 291)
 #define __NR_inotify_init1		(__NR_Linux + 292)
+#define __NR_preadv			(__NR_Linux + 293)
+#define __NR_pwritev			(__NR_Linux + 294)
 
 /*
  * Offset of the last N32 flavoured syscall
  */
-#define __NR_Linux_syscalls		292
+#define __NR_Linux_syscalls		294
 
 #endif /* _MIPS_SIM == _MIPS_SIM_NABI32 */
 
 #define __NR_N32_Linux			6000
-#define __NR_N32_Linux_syscalls		292
+#define __NR_N32_Linux_syscalls		294
 
 #ifdef __KERNEL__
 
diff -puN arch/mips/kernel/scall32-o32.S~preadv-pwritev-mips-add-preadv2-and-pwritev2-syscalls arch/mips/kernel/scall32-o32.S
--- a/arch/mips/kernel/scall32-o32.S~preadv-pwritev-mips-add-preadv2-and-pwritev2-syscalls
+++ a/arch/mips/kernel/scall32-o32.S
@@ -650,6 +650,8 @@ einval:	li	v0, -ENOSYS
 	sys	sys_dup3		3
 	sys	sys_pipe2		2
 	sys	sys_inotify_init1	1
+	sys	sys_preadv		6	/* 4330 */
+	sys	sys_pwritev		6
 	.endm
 
 	/* We pre-compute the number of _instruction_ bytes needed to
diff -puN arch/mips/kernel/scall64-64.S~preadv-pwritev-mips-add-preadv2-and-pwritev2-syscalls arch/mips/kernel/scall64-64.S
--- a/arch/mips/kernel/scall64-64.S~preadv-pwritev-mips-add-preadv2-and-pwritev2-syscalls
+++ a/arch/mips/kernel/scall64-64.S
@@ -487,4 +487,6 @@ sys_call_table:
 	PTR	sys_dup3
 	PTR	sys_pipe2
 	PTR	sys_inotify_init1
+	PTR	sys_preadv
+	PTR	sys_pwritev			/* 5390 */
 	.size	sys_call_table,.-sys_call_table
diff -puN arch/mips/kernel/scall64-n32.S~preadv-pwritev-mips-add-preadv2-and-pwritev2-syscalls arch/mips/kernel/scall64-n32.S
--- a/arch/mips/kernel/scall64-n32.S~preadv-pwritev-mips-add-preadv2-and-pwritev2-syscalls
+++ a/arch/mips/kernel/scall64-n32.S
@@ -413,4 +413,6 @@ EXPORT(sysn32_call_table)
 	PTR	sys_dup3			/* 5290 */
 	PTR	sys_pipe2
 	PTR	sys_inotify_init1
+	PTR	sys_preadv
+	PTR	sys_pwritev
 	.size	sysn32_call_table,.-sysn32_call_table
diff -puN arch/mips/kernel/scall64-o32.S~preadv-pwritev-mips-add-preadv2-and-pwritev2-syscalls arch/mips/kernel/scall64-o32.S
--- a/arch/mips/kernel/scall64-o32.S~preadv-pwritev-mips-add-preadv2-and-pwritev2-syscalls
+++ a/arch/mips/kernel/scall64-o32.S
@@ -533,4 +533,6 @@ sys_call_table:
 	PTR	sys_dup3
 	PTR	sys_pipe2
 	PTR	sys_inotify_init1
+	PTR	compat_sys_preadv		/* 4330 */
+	PTR	compat_sys_pwritev
 	.size	sys_call_table,.-sys_call_table
_

Patches currently in -mm which might be from ralf@linux-mips.org are

origin.patch
linux-next.patch
mtd-txx9-add-ndfmc-support.patch
mtd-rbtx4939-add-mtd-support.patch
mtd-rbtx4939-add-mtd-support-fix.patch
mtd-txx9-soc-nand-flash-memory-controller-driver.patch
mtd-rbtx4939-map-driver.patch
mm-unify-some-pmd_-functions-fix.patch
preadv-pwritev-create-compat_readv.patch
preadv-pwritev-create-compat_writev.patch
preadv-pwritev-add-preadv-and-pwritev-system-calls.patch
preadv-pwritev-mips-add-preadv2-and-pwritev2-syscalls.patch
preadv-pwritev-switch-compat-readv-preadv-writev-pwritev-from-fget-to-fget_light.patch


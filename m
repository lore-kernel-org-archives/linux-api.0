From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 16/29] alpha: add generic get{eg,eu,g,p,u,pp}id() syscalls
Date: Fri, 18 Jan 2019 17:18:22 +0100
Message-ID: <20190118161835.2259170-17-arnd@arndb.de>
References: <20190118161835.2259170-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190118161835.2259170-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: y2038@lists.linaro.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, mattst88@gmail.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, tony.luck@intel.com, fenghua.yu@intel.com, geert@linux-m68k.org, monstr@monstr.eu, paul.burton@mips.com, deller@gmx.de, benh@kernel.crashing.org, mpe@ellerman.id.au, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, dalias@libc.org, davem@davemloft.net, luto@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org, jcmvbkbc@gmail.com, akpm@linux-foundation.org, deepa.kernel@gmail.com, ebiederm@xmission.com, firoz.khan@linaro.org, linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-ia64@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.or
List-Id: linux-api@vger.kernel.org

Alpha has traditionally followed the OSF1 calling conventions
here, with its getxpid, getxuid, getxgid system calls returning
two different values in separate registers.

Following what glibc has done here, we can define getpid,
getuid and getgid to be aliases for getxpid, getxuid and getxgid
respectively, and add new system call numbers for getppid, geteuid
and getegid.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/alpha/include/asm/unistd.h        | 11 -----------
 arch/alpha/include/uapi/asm/unistd.h   |  5 +++++
 arch/alpha/kernel/syscalls/syscall.tbl |  3 +++
 3 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/arch/alpha/include/asm/unistd.h b/arch/alpha/include/asm/unistd.h
index 31ad350b58a0..986f5da9b7d8 100644
--- a/arch/alpha/include/asm/unistd.h
+++ b/arch/alpha/include/asm/unistd.h
@@ -19,15 +19,4 @@
 #define __ARCH_WANT_SYS_VFORK
 #define __ARCH_WANT_SYS_CLONE
 
-/*
- * Ignore legacy syscalls that we don't use.
- */
-#define __IGNORE_getegid
-#define __IGNORE_geteuid
-#define __IGNORE_getgid
-#define __IGNORE_getpid
-#define __IGNORE_getppid
-#define __IGNORE_getuid
-
-
 #endif /* _ALPHA_UNISTD_H */
diff --git a/arch/alpha/include/uapi/asm/unistd.h b/arch/alpha/include/uapi/asm/unistd.h
index 4507071f995f..71fd5db06866 100644
--- a/arch/alpha/include/uapi/asm/unistd.h
+++ b/arch/alpha/include/uapi/asm/unistd.h
@@ -7,6 +7,11 @@
 #define __NR_umount	__NR_umount2
 #define __NR_osf_shmat	__NR_shmat
 
+/* These return an extra value but can be used as aliases */
+#define __NR_getpid	__NR_getxpid
+#define __NR_getuid	__NR_getxuid
+#define __NR_getgid	__NR_getxgid
+
 #include <asm/unistd_32.h>
 
 #endif /* _UAPI_ALPHA_UNISTD_H */
diff --git a/arch/alpha/kernel/syscalls/syscall.tbl b/arch/alpha/kernel/syscalls/syscall.tbl
index 0ebd59fdcb8b..337b8108771a 100644
--- a/arch/alpha/kernel/syscalls/syscall.tbl
+++ b/arch/alpha/kernel/syscalls/syscall.tbl
@@ -458,3 +458,6 @@
 527	common	rseq				sys_rseq
 528	common	statfs64			sys_statfs64
 529	common	fstatfs64			sys_fstatfs64
+530	common	getegid				sys_getegid
+531	common	geteuid				sys_geteuid
+532	common	getppid				sys_getppid
-- 
2.20.0

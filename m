From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 05/29] alpha: update syscall macro definitions
Date: Fri, 18 Jan 2019 17:18:11 +0100
Message-ID: <20190118161835.2259170-6-arnd@arndb.de>
References: <20190118161835.2259170-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190118161835.2259170-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: y2038@lists.linaro.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, mattst88@gmail.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, tony.luck@intel.com, fenghua.yu@intel.com, geert@linux-m68k.org, monstr@monstr.eu, paul.burton@mips.com, deller@gmx.de, benh@kernel.crashing.org, mpe@ellerman.id.au, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, dalias@libc.org, davem@davemloft.net, luto@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org, jcmvbkbc@gmail.com, akpm@linux-foundation.org, deepa.kernel@gmail.com, ebiederm@xmission.com, firoz.khan@linaro.org, linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-ia64@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.or
List-Id: linux-api@vger.kernel.org

Other architectures commonly use __NR_umount2 for sys_umount,
only ia64 and alpha use __NR_umount here. In order to synchronize
the generated tables, use umount2 like everyone else, and add back
the old name from asm/unistd.h for compatibility.

For shmat, alpha uses the osf_shmat name, we can do the same thing
here, which means we don't have to add an entry in the __IGNORE
list now that shmat is mandatory everywhere

alarm, creat, pause, time, and utime are optional everywhere
these days, no need to list them here any more.

I considered also adding the regular versions of the get*id system
calls that have different names and calling conventions on alpha,
which would further help unify the syscall ABI, but for now
I decided against that.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/alpha/include/asm/unistd.h        | 6 ------
 arch/alpha/include/uapi/asm/unistd.h   | 5 +++++
 arch/alpha/kernel/syscalls/syscall.tbl | 4 ++--
 3 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/alpha/include/asm/unistd.h b/arch/alpha/include/asm/unistd.h
index 21b706a5b772..564ba87bdc38 100644
--- a/arch/alpha/include/asm/unistd.h
+++ b/arch/alpha/include/asm/unistd.h
@@ -22,18 +22,12 @@
 /*
  * Ignore legacy syscalls that we don't use.
  */
-#define __IGNORE_alarm
-#define __IGNORE_creat
 #define __IGNORE_getegid
 #define __IGNORE_geteuid
 #define __IGNORE_getgid
 #define __IGNORE_getpid
 #define __IGNORE_getppid
 #define __IGNORE_getuid
-#define __IGNORE_pause
-#define __IGNORE_time
-#define __IGNORE_utime
-#define __IGNORE_umount2
 
 /* Alpha doesn't have protection keys. */
 #define __IGNORE_pkey_mprotect
diff --git a/arch/alpha/include/uapi/asm/unistd.h b/arch/alpha/include/uapi/asm/unistd.h
index 9ba724f116f1..4507071f995f 100644
--- a/arch/alpha/include/uapi/asm/unistd.h
+++ b/arch/alpha/include/uapi/asm/unistd.h
@@ -2,6 +2,11 @@
 #ifndef _UAPI_ALPHA_UNISTD_H
 #define _UAPI_ALPHA_UNISTD_H
 
+/* These are traditionally the names linux-alpha uses for
+ * the two otherwise generic system calls */
+#define __NR_umount	__NR_umount2
+#define __NR_osf_shmat	__NR_shmat
+
 #include <asm/unistd_32.h>
 
 #endif /* _UAPI_ALPHA_UNISTD_H */
diff --git a/arch/alpha/kernel/syscalls/syscall.tbl b/arch/alpha/kernel/syscalls/syscall.tbl
index e09558edae73..f920b65e8c49 100644
--- a/arch/alpha/kernel/syscalls/syscall.tbl
+++ b/arch/alpha/kernel/syscalls/syscall.tbl
@@ -29,7 +29,7 @@
 19	common	lseek				sys_lseek
 20	common	getxpid				sys_getxpid
 21	common	osf_mount			sys_osf_mount
-22	common	umount				sys_umount
+22	common	umount2				sys_umount
 23	common	setuid				sys_setuid
 24	common	getxuid				sys_getxuid
 25	common	exec_with_loader		sys_ni_syscall
@@ -183,7 +183,7 @@
 206	common	semop				sys_semop
 207	common	osf_utsname			sys_osf_utsname
 208	common	lchown				sys_lchown
-209	common	osf_shmat			sys_shmat
+209	common	shmat				sys_shmat
 210	common	shmctl				sys_shmctl
 211	common	shmdt				sys_shmdt
 212	common	shmget				sys_shmget
-- 
2.20.0

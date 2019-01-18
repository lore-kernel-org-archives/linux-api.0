From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 28/29] y2038: rename old time and utime syscalls
Date: Fri, 18 Jan 2019 17:18:34 +0100
Message-ID: <20190118161835.2259170-29-arnd@arndb.de>
References: <20190118161835.2259170-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190118161835.2259170-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: y2038@lists.linaro.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, mattst88@gmail.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, tony.luck@intel.com, fenghua.yu@intel.com, geert@linux-m68k.org, monstr@monstr.eu, paul.burton@mips.com, deller@gmx.de, benh@kernel.crashing.org, mpe@ellerman.id.au, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, dalias@libc.org, davem@davemloft.net, luto@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org, jcmvbkbc@gmail.com, akpm@linux-foundation.org, deepa.kernel@gmail.com, ebiederm@xmission.com, firoz.khan@linaro.org, linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-ia64@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.or
List-Id: linux-api@vger.kernel.org

The time, stime, utime, utimes, and futimesat system calls are only
used on older architectures, and we do not provide y2038 safe variants
of them, as they are replaced by clock_gettime64, clock_settime64,
and utimensat_time64.

However, for consistency it seems better to have the 32-bit architectures
that still use them call the "time32" entry points (leaving the
traditional handlers for the 64-bit architectures), like we do for system
calls that now require two versions.

Note: We used to always define __ARCH_WANT_SYS_TIME and
__ARCH_WANT_SYS_UTIME and only set __ARCH_WANT_COMPAT_SYS_TIME and
__ARCH_WANT_SYS_UTIME32 for compat mode on 64-bit kernels. Now this is
reversed: only 64-bit architectures set __ARCH_WANT_SYS_TIME/UTIME, while
we need __ARCH_WANT_SYS_TIME32/UTIME32 for 32-bit architectures and compat
mode. The resulting asm/unistd.h changes look a bit counterintuitive.

This is only a cleanup patch and it should not change any behavior.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/include/asm/unistd.h               |  4 ++--
 arch/arm/tools/syscall.tbl                  | 10 +++++-----
 arch/m68k/include/asm/unistd.h              |  4 ++--
 arch/m68k/kernel/syscalls/syscall.tbl       | 10 +++++-----
 arch/microblaze/include/asm/unistd.h        |  4 ++--
 arch/microblaze/kernel/syscalls/syscall.tbl | 10 +++++-----
 arch/mips/include/asm/unistd.h              |  4 ++--
 arch/mips/kernel/syscalls/syscall_o32.tbl   | 10 +++++-----
 arch/parisc/include/asm/unistd.h            |  9 ++++++---
 arch/parisc/kernel/syscalls/syscall.tbl     | 15 ++++++++++-----
 arch/powerpc/include/asm/unistd.h           |  8 ++++----
 arch/powerpc/kernel/syscalls/syscall.tbl    | 19 ++++++++++++++-----
 arch/s390/include/asm/unistd.h              |  2 +-
 arch/sh/include/asm/unistd.h                |  4 ++--
 arch/sh/kernel/syscalls/syscall.tbl         | 10 +++++-----
 arch/sparc/include/asm/unistd.h             |  8 ++++----
 arch/sparc/kernel/syscalls/syscall.tbl      | 14 +++++++++-----
 arch/x86/entry/syscalls/syscall_32.tbl      | 10 +++++-----
 arch/x86/include/asm/unistd.h               |  8 ++++----
 arch/xtensa/include/asm/unistd.h            |  2 +-
 arch/xtensa/kernel/syscalls/syscall.tbl     |  6 +++---
 kernel/time/time.c                          |  4 ++--
 22 files changed, 98 insertions(+), 77 deletions(-)

diff --git a/arch/arm/include/asm/unistd.h b/arch/arm/include/asm/unistd.h
index d713587dfcf4..7a39e77984ef 100644
--- a/arch/arm/include/asm/unistd.h
+++ b/arch/arm/include/asm/unistd.h
@@ -26,10 +26,10 @@
 #define __ARCH_WANT_SYS_SIGPROCMASK
 #define __ARCH_WANT_SYS_OLD_MMAP
 #define __ARCH_WANT_SYS_OLD_SELECT
-#define __ARCH_WANT_SYS_UTIME
+#define __ARCH_WANT_SYS_UTIME32
 
 #if !defined(CONFIG_AEABI) || defined(CONFIG_OABI_COMPAT)
-#define __ARCH_WANT_SYS_TIME
+#define __ARCH_WANT_SYS_TIME32
 #define __ARCH_WANT_SYS_IPC
 #define __ARCH_WANT_SYS_OLDUMOUNT
 #define __ARCH_WANT_SYS_ALARM
diff --git a/arch/arm/tools/syscall.tbl b/arch/arm/tools/syscall.tbl
index 200f4b878a46..a96d9b5ee04e 100644
--- a/arch/arm/tools/syscall.tbl
+++ b/arch/arm/tools/syscall.tbl
@@ -24,7 +24,7 @@
 10	common	unlink			sys_unlink
 11	common	execve			sys_execve
 12	common	chdir			sys_chdir
-13	oabi	time			sys_time
+13	oabi	time			sys_time32
 14	common	mknod			sys_mknod
 15	common	chmod			sys_chmod
 16	common	lchown			sys_lchown16
@@ -36,12 +36,12 @@
 22	oabi	umount			sys_oldumount
 23	common	setuid			sys_setuid16
 24	common	getuid			sys_getuid16
-25	oabi	stime			sys_stime
+25	oabi	stime			sys_stime32
 26	common	ptrace			sys_ptrace
 27	oabi	alarm			sys_alarm
 # 28 was sys_fstat
 29	common	pause			sys_pause
-30	oabi	utime			sys_utime
+30	oabi	utime			sys_utime32
 # 31 was sys_stty
 # 32 was sys_gtty
 33	common	access			sys_access
@@ -283,7 +283,7 @@
 266	common	statfs64		sys_statfs64_wrapper
 267	common	fstatfs64		sys_fstatfs64_wrapper
 268	common	tgkill			sys_tgkill
-269	common	utimes			sys_utimes
+269	common	utimes			sys_utimes_time32
 270	common	arm_fadvise64_64	sys_arm_fadvise64_64
 271	common	pciconfig_iobase	sys_pciconfig_iobase
 272	common	pciconfig_read		sys_pciconfig_read
@@ -340,7 +340,7 @@
 323	common	mkdirat			sys_mkdirat
 324	common	mknodat			sys_mknodat
 325	common	fchownat		sys_fchownat
-326	common	futimesat		sys_futimesat
+326	common	futimesat		sys_futimesat_time32
 327	common	fstatat64		sys_fstatat64		sys_oabi_fstatat64
 328	common	unlinkat		sys_unlinkat
 329	common	renameat		sys_renameat
diff --git a/arch/m68k/include/asm/unistd.h b/arch/m68k/include/asm/unistd.h
index 49d5de18646b..2e0047cf86f8 100644
--- a/arch/m68k/include/asm/unistd.h
+++ b/arch/m68k/include/asm/unistd.h
@@ -15,8 +15,8 @@
 #define __ARCH_WANT_SYS_IPC
 #define __ARCH_WANT_SYS_PAUSE
 #define __ARCH_WANT_SYS_SIGNAL
-#define __ARCH_WANT_SYS_TIME
-#define __ARCH_WANT_SYS_UTIME
+#define __ARCH_WANT_SYS_TIME32
+#define __ARCH_WANT_SYS_UTIME32
 #define __ARCH_WANT_SYS_WAITPID
 #define __ARCH_WANT_SYS_SOCKETCALL
 #define __ARCH_WANT_SYS_FADVISE64
diff --git a/arch/m68k/kernel/syscalls/syscall.tbl b/arch/m68k/kernel/syscalls/syscall.tbl
index fe7583987efc..dec78dc5b056 100644
--- a/arch/m68k/kernel/syscalls/syscall.tbl
+++ b/arch/m68k/kernel/syscalls/syscall.tbl
@@ -20,7 +20,7 @@
 10	common	unlink				sys_unlink
 11	common	execve				sys_execve
 12	common	chdir				sys_chdir
-13	common	time				sys_time
+13	common	time				sys_time32
 14	common	mknod				sys_mknod
 15	common	chmod				sys_chmod
 16	common	chown				sys_chown16
@@ -32,12 +32,12 @@
 22	common	umount				sys_oldumount
 23	common	setuid				sys_setuid16
 24	common	getuid				sys_getuid16
-25	common	stime				sys_stime
+25	common	stime				sys_stime32
 26	common	ptrace				sys_ptrace
 27	common	alarm				sys_alarm
 28	common	oldfstat			sys_fstat
 29	common	pause				sys_pause
-30	common	utime				sys_utime
+30	common	utime				sys_utime32
 # 31 was stty
 # 32 was gtty
 33	common	access				sys_access
@@ -273,7 +273,7 @@
 263	common	statfs64			sys_statfs64
 264	common	fstatfs64			sys_fstatfs64
 265	common	tgkill				sys_tgkill
-266	common	utimes				sys_utimes
+266	common	utimes				sys_utimes_time32
 267	common	fadvise64_64			sys_fadvise64_64
 268	common	mbind				sys_mbind
 269	common	get_mempolicy			sys_get_mempolicy
@@ -299,7 +299,7 @@
 289	common	mkdirat				sys_mkdirat
 290	common	mknodat				sys_mknodat
 291	common	fchownat			sys_fchownat
-292	common	futimesat			sys_futimesat
+292	common	futimesat			sys_futimesat_time32
 293	common	fstatat64			sys_fstatat64
 294	common	unlinkat			sys_unlinkat
 295	common	renameat			sys_renameat
diff --git a/arch/microblaze/include/asm/unistd.h b/arch/microblaze/include/asm/unistd.h
index 9b7c2c4eaf12..d79d35ac6253 100644
--- a/arch/microblaze/include/asm/unistd.h
+++ b/arch/microblaze/include/asm/unistd.h
@@ -21,8 +21,8 @@
 #define __ARCH_WANT_SYS_GETHOSTNAME
 #define __ARCH_WANT_SYS_PAUSE
 #define __ARCH_WANT_SYS_SIGNAL
-#define __ARCH_WANT_SYS_TIME
-#define __ARCH_WANT_SYS_UTIME
+#define __ARCH_WANT_SYS_TIME32
+#define __ARCH_WANT_SYS_UTIME32
 #define __ARCH_WANT_SYS_WAITPID
 #define __ARCH_WANT_SYS_SOCKETCALL
 #define __ARCH_WANT_SYS_FADVISE64
diff --git a/arch/microblaze/kernel/syscalls/syscall.tbl b/arch/microblaze/kernel/syscalls/syscall.tbl
index 492ff5c35b68..44a87649d681 100644
--- a/arch/microblaze/kernel/syscalls/syscall.tbl
+++ b/arch/microblaze/kernel/syscalls/syscall.tbl
@@ -20,7 +20,7 @@
 10	common	unlink				sys_unlink
 11	common	execve				sys_execve
 12	common	chdir				sys_chdir
-13	common	time				sys_time
+13	common	time				sys_time32
 14	common	mknod				sys_mknod
 15	common	chmod				sys_chmod
 16	common	lchown				sys_lchown
@@ -32,12 +32,12 @@
 22	common	umount				sys_oldumount
 23	common	setuid				sys_setuid
 24	common	getuid				sys_getuid
-25	common	stime				sys_stime
+25	common	stime				sys_stime32
 26	common	ptrace				sys_ptrace
 27	common	alarm				sys_alarm
 28	common	oldfstat			sys_ni_syscall
 29	common	pause				sys_pause
-30	common	utime				sys_utime
+30	common	utime				sys_utime32
 31	common	stty				sys_ni_syscall
 32	common	gtty				sys_ni_syscall
 33	common	access				sys_access
@@ -278,7 +278,7 @@
 268	common	statfs64			sys_statfs64
 269	common	fstatfs64			sys_fstatfs64
 270	common	tgkill				sys_tgkill
-271	common	utimes				sys_utimes
+271	common	utimes				sys_utimes_time32
 272	common	fadvise64_64			sys_fadvise64_64
 273	common	vserver				sys_ni_syscall
 274	common	mbind				sys_mbind
@@ -306,7 +306,7 @@
 296	common	mkdirat				sys_mkdirat
 297	common	mknodat				sys_mknodat
 298	common	fchownat			sys_fchownat
-299	common	futimesat			sys_futimesat
+299	common	futimesat			sys_futimesat_time32
 300	common	fstatat64			sys_fstatat64
 301	common	unlinkat			sys_unlinkat
 302	common	renameat			sys_renameat
diff --git a/arch/mips/include/asm/unistd.h b/arch/mips/include/asm/unistd.h
index 5e9eeb83d8d4..26f313bc03c9 100644
--- a/arch/mips/include/asm/unistd.h
+++ b/arch/mips/include/asm/unistd.h
@@ -45,10 +45,10 @@
 #define __ARCH_WANT_SYS_SIGPROCMASK
 # ifdef CONFIG_32BIT
 #  define __ARCH_WANT_STAT64
-#  define __ARCH_WANT_SYS_TIME
+#  define __ARCH_WANT_SYS_TIME32
 # endif
 # ifdef CONFIG_MIPS32_O32
-#  define __ARCH_WANT_COMPAT_SYS_TIME
+#  define __ARCH_WANT_SYS_TIME32
 # endif
 #define __ARCH_WANT_SYS_FORK
 #define __ARCH_WANT_SYS_CLONE
diff --git a/arch/mips/kernel/syscalls/syscall_o32.tbl b/arch/mips/kernel/syscalls/syscall_o32.tbl
index 5642d93b64c0..54312c5b5343 100644
--- a/arch/mips/kernel/syscalls/syscall_o32.tbl
+++ b/arch/mips/kernel/syscalls/syscall_o32.tbl
@@ -20,7 +20,7 @@
 10	o32	unlink				sys_unlink
 11	o32	execve				sys_execve			compat_sys_execve
 12	o32	chdir				sys_chdir
-13	o32	time				sys_time			sys_time32
+13	o32	time				sys_time32
 14	o32	mknod				sys_mknod
 15	o32	chmod				sys_chmod
 16	o32	lchown				sys_lchown
@@ -33,13 +33,13 @@
 22	o32	umount				sys_oldumount
 23	o32	setuid				sys_setuid
 24	o32	getuid				sys_getuid
-25	o32	stime				sys_stime			sys_stime32
+25	o32	stime				sys_stime32
 26	o32	ptrace				sys_ptrace			compat_sys_ptrace
 27	o32	alarm				sys_alarm
 # 28 was sys_fstat
 28	o32	unused28			sys_ni_syscall
 29	o32	pause				sys_pause
-30	o32	utime				sys_utime			sys_utime32
+30	o32	utime				sys_utime32
 31	o32	stty				sys_ni_syscall
 32	o32	gtty				sys_ni_syscall
 33	o32	access				sys_access
@@ -278,7 +278,7 @@
 264	o32	clock_getres			sys_clock_getres_time32
 265	o32	clock_nanosleep			sys_clock_nanosleep_time32
 266	o32	tgkill				sys_tgkill
-267	o32	utimes				sys_utimes			sys_utimes_time32
+267	o32	utimes				sys_utimes_time32
 268	o32	mbind				sys_mbind			compat_sys_mbind
 269	o32	get_mempolicy			sys_get_mempolicy		compat_sys_get_mempolicy
 270	o32	set_mempolicy			sys_set_mempolicy		compat_sys_set_mempolicy
@@ -303,7 +303,7 @@
 289	o32	mkdirat				sys_mkdirat
 290	o32	mknodat				sys_mknodat
 291	o32	fchownat			sys_fchownat
-292	o32	futimesat			sys_futimesat			sys_futimesat_time32
+292	o32	futimesat			sys_futimesat_time32
 293	o32	fstatat64			sys_fstatat64			sys_newfstatat
 294	o32	unlinkat			sys_unlinkat
 295	o32	renameat			sys_renameat
diff --git a/arch/parisc/include/asm/unistd.h b/arch/parisc/include/asm/unistd.h
index 385eae49ed02..61f24ed7e934 100644
--- a/arch/parisc/include/asm/unistd.h
+++ b/arch/parisc/include/asm/unistd.h
@@ -150,10 +150,8 @@ type name(type1 arg1, type2 arg2, type3 arg3, type4 arg4, type5 arg5)	\
 #define __ARCH_WANT_SYS_GETHOSTNAME
 #define __ARCH_WANT_SYS_PAUSE
 #define __ARCH_WANT_SYS_SIGNAL
-#define __ARCH_WANT_SYS_TIME
-#define __ARCH_WANT_COMPAT_SYS_TIME
+#define __ARCH_WANT_SYS_TIME32
 #define __ARCH_WANT_COMPAT_SYS_SCHED_RR_GET_INTERVAL
-#define __ARCH_WANT_SYS_UTIME
 #define __ARCH_WANT_SYS_UTIME32
 #define __ARCH_WANT_SYS_WAITPID
 #define __ARCH_WANT_SYS_SOCKETCALL
@@ -168,6 +166,11 @@ type name(type1 arg1, type2 arg2, type3 arg3, type4 arg4, type5 arg5)	\
 #define __ARCH_WANT_SYS_CLONE
 #define __ARCH_WANT_COMPAT_SYS_SENDFILE
 
+#ifdef CONFIG_64BIT
+#define __ARCH_WANT_SYS_TIME
+#define __ARCH_WANT_SYS_UTIME
+#endif
+
 #endif /* __ASSEMBLY__ */
 
 #undef STR
diff --git a/arch/parisc/kernel/syscalls/syscall.tbl b/arch/parisc/kernel/syscalls/syscall.tbl
index 1b3bb683c014..2521cd561769 100644
--- a/arch/parisc/kernel/syscalls/syscall.tbl
+++ b/arch/parisc/kernel/syscalls/syscall.tbl
@@ -20,7 +20,8 @@
 10	common	unlink			sys_unlink
 11	common	execve			sys_execve			compat_sys_execve
 12	common	chdir			sys_chdir
-13	common	time			sys_time			sys_time32
+13	32	time			sys_time32
+13	64	time			sys_time
 14	common	mknod			sys_mknod
 15	common	chmod			sys_chmod
 16	common	lchown			sys_lchown
@@ -32,12 +33,14 @@
 22	common	bind			sys_bind
 23	common	setuid			sys_setuid
 24	common	getuid			sys_getuid
-25	common	stime			sys_stime			sys_stime32
+25	32	stime			sys_stime32
+25	64	stime			sys_stime
 26	common	ptrace			sys_ptrace			compat_sys_ptrace
 27	common	alarm			sys_alarm
 28	common	fstat			sys_newfstat			compat_sys_newfstat
 29	common	pause			sys_pause
-30	common	utime			sys_utime			sys_utime32
+30	32	utime			sys_utime32
+30	64	utime			sys_utime
 31	common	connect			sys_connect
 32	common	listen			sys_listen
 33	common	access			sys_access
@@ -310,7 +313,8 @@
 276	common	mkdirat			sys_mkdirat
 277	common	mknodat			sys_mknodat
 278	common	fchownat		sys_fchownat
-279	common	futimesat		sys_futimesat			sys_futimesat_time32
+279	32	futimesat		sys_futimesat_time32
+279	64	futimesat		sys_futimesat
 280	common	fstatat64		sys_fstatat64
 281	common	unlinkat		sys_unlinkat
 282	common	renameat		sys_renameat
@@ -374,7 +378,8 @@
 333	common	finit_module		sys_finit_module
 334	common	sched_setattr		sys_sched_setattr
 335	common	sched_getattr		sys_sched_getattr
-336	common	utimes			sys_utimes			sys_utimes_time32
+336	32	utimes			sys_utimes_time32
+336	64	utimes			sys_utimes
 337	common	renameat2		sys_renameat2
 338	common	seccomp			sys_seccomp
 339	common	getrandom		sys_getrandom
diff --git a/arch/powerpc/include/asm/unistd.h b/arch/powerpc/include/asm/unistd.h
index a3c35e6d6ffb..f44dbc65e38e 100644
--- a/arch/powerpc/include/asm/unistd.h
+++ b/arch/powerpc/include/asm/unistd.h
@@ -29,8 +29,8 @@
 #define __ARCH_WANT_SYS_IPC
 #define __ARCH_WANT_SYS_PAUSE
 #define __ARCH_WANT_SYS_SIGNAL
-#define __ARCH_WANT_SYS_TIME
-#define __ARCH_WANT_SYS_UTIME
+#define __ARCH_WANT_SYS_TIME32
+#define __ARCH_WANT_SYS_UTIME32
 #define __ARCH_WANT_SYS_WAITPID
 #define __ARCH_WANT_SYS_SOCKETCALL
 #define __ARCH_WANT_SYS_FADVISE64
@@ -45,8 +45,8 @@
 #define __ARCH_WANT_OLD_STAT
 #endif
 #ifdef CONFIG_PPC64
-#define __ARCH_WANT_COMPAT_SYS_TIME
-#define __ARCH_WANT_SYS_UTIME32
+#define __ARCH_WANT_SYS_TIME
+#define __ARCH_WANT_SYS_UTIME
 #define __ARCH_WANT_SYS_NEWFSTATAT
 #define __ARCH_WANT_COMPAT_SYS_SENDFILE
 #endif
diff --git a/arch/powerpc/kernel/syscalls/syscall.tbl b/arch/powerpc/kernel/syscalls/syscall.tbl
index 2a8b060f73b3..500edbf9e8a6 100644
--- a/arch/powerpc/kernel/syscalls/syscall.tbl
+++ b/arch/powerpc/kernel/syscalls/syscall.tbl
@@ -20,7 +20,9 @@
 10	common	unlink				sys_unlink
 11	nospu	execve				sys_execve			compat_sys_execve
 12	common	chdir				sys_chdir
-13	common	time				sys_time			sys_time32
+13	32	time				sys_time32
+13	64	time				sys_time
+13	spu	time				sys_time
 14	common	mknod				sys_mknod
 15	common	chmod				sys_chmod
 16	common	lchown				sys_lchown
@@ -36,14 +38,17 @@
 22	spu	umount				sys_ni_syscall
 23	common	setuid				sys_setuid
 24	common	getuid				sys_getuid
-25	common	stime				sys_stime			sys_stime32
+25	32	stime				sys_stime32
+25	64	stime				sys_stime
+25	spu	stime				sys_stime
 26	nospu	ptrace				sys_ptrace			compat_sys_ptrace
 27	common	alarm				sys_alarm
 28	32	oldfstat			sys_fstat			sys_ni_syscall
 28	64	oldfstat			sys_ni_syscall
 28	spu	oldfstat			sys_ni_syscall
 29	nospu	pause				sys_pause
-30	nospu	utime				sys_utime			sys_utime32
+30	32	utime				sys_utime32
+30	64	utime				sys_utime
 31	common	stty				sys_ni_syscall
 32	common	gtty				sys_ni_syscall
 33	common	access				sys_access
@@ -315,7 +320,9 @@
 249	64	swapcontext			ppc64_swapcontext
 249	spu	swapcontext			sys_ni_syscall
 250	common	tgkill				sys_tgkill
-251	common	utimes				sys_utimes			sys_utimes_time32
+251	32	utimes				sys_utimes_time32
+251	64	utimes				sys_utimes
+251	spu	utimes				sys_utimes
 252	common	statfs64			sys_statfs64			compat_sys_statfs64
 253	common	fstatfs64			sys_fstatfs64			compat_sys_fstatfs64
 254	32	fadvise64_64			ppc_fadvise64_64
@@ -361,7 +368,9 @@
 287	common	mkdirat				sys_mkdirat
 288	common	mknodat				sys_mknodat
 289	common	fchownat			sys_fchownat
-290	common	futimesat			sys_futimesat			sys_futimesat_time32
+290	32	futimesat			sys_futimesat_time32
+290	64	futimesat			sys_futimesat
+290	spu	utimesat			sys_futimesat
 291	32	fstatat64			sys_fstatat64
 291	64	newfstatat			sys_newfstatat
 291	spu	newfstatat			sys_newfstatat
diff --git a/arch/s390/include/asm/unistd.h b/arch/s390/include/asm/unistd.h
index 59202ceea1f6..b6755685c7b8 100644
--- a/arch/s390/include/asm/unistd.h
+++ b/arch/s390/include/asm/unistd.h
@@ -28,7 +28,7 @@
 #define __ARCH_WANT_SYS_SIGPENDING
 #define __ARCH_WANT_SYS_SIGPROCMASK
 # ifdef CONFIG_COMPAT
-#   define __ARCH_WANT_COMPAT_SYS_TIME
+#   define __ARCH_WANT_SYS_TIME32
 #   define __ARCH_WANT_SYS_UTIME32
 # endif
 #define __ARCH_WANT_SYS_FORK
diff --git a/arch/sh/include/asm/unistd.h b/arch/sh/include/asm/unistd.h
index a97f93ca3bd7..9c7d9d9999c6 100644
--- a/arch/sh/include/asm/unistd.h
+++ b/arch/sh/include/asm/unistd.h
@@ -16,8 +16,8 @@
 # define __ARCH_WANT_SYS_IPC
 # define __ARCH_WANT_SYS_PAUSE
 # define __ARCH_WANT_SYS_SIGNAL
-# define __ARCH_WANT_SYS_TIME
-# define __ARCH_WANT_SYS_UTIME
+# define __ARCH_WANT_SYS_TIME32
+# define __ARCH_WANT_SYS_UTIME32
 # define __ARCH_WANT_SYS_WAITPID
 # define __ARCH_WANT_SYS_SOCKETCALL
 # define __ARCH_WANT_SYS_FADVISE64
diff --git a/arch/sh/kernel/syscalls/syscall.tbl b/arch/sh/kernel/syscalls/syscall.tbl
index e6a18d3db6ac..d3993b305cab 100644
--- a/arch/sh/kernel/syscalls/syscall.tbl
+++ b/arch/sh/kernel/syscalls/syscall.tbl
@@ -20,7 +20,7 @@
 10	common	unlink				sys_unlink
 11	common	execve				sys_execve
 12	common	chdir				sys_chdir
-13	common	time				sys_time
+13	common	time				sys_time32
 14	common	mknod				sys_mknod
 15	common	chmod				sys_chmod
 16	common	lchown				sys_lchown16
@@ -32,12 +32,12 @@
 22	common	umount				sys_oldumount
 23	common	setuid				sys_setuid16
 24	common	getuid				sys_getuid16
-25	common	stime				sys_stime
+25	common	stime				sys_stime32
 26	common	ptrace				sys_ptrace
 27	common	alarm				sys_alarm
 28	common	oldfstat			sys_fstat
 29	common	pause				sys_pause
-30	common	utime				sys_utime
+30	common	utime				sys_utime32
 # 31 was stty
 # 32 was gtty
 33	common	access				sys_access
@@ -278,7 +278,7 @@
 268	common	statfs64			sys_statfs64
 269	common	fstatfs64			sys_fstatfs64
 270	common	tgkill				sys_tgkill
-271	common	utimes				sys_utimes
+271	common	utimes				sys_utimes_time32
 272	common	fadvise64_64			sys_fadvise64_64_wrapper
 # 273 is reserved for vserver
 274	common	mbind				sys_mbind
@@ -306,7 +306,7 @@
 296	common	mkdirat				sys_mkdirat
 297	common	mknodat				sys_mknodat
 298	common	fchownat			sys_fchownat
-299	common	futimesat			sys_futimesat
+299	common	futimesat			sys_futimesat_time32
 300	common	fstatat64			sys_fstatat64
 301	common	unlinkat			sys_unlinkat
 302	common	renameat			sys_renameat
diff --git a/arch/sparc/include/asm/unistd.h b/arch/sparc/include/asm/unistd.h
index 08696ea5dca8..1e66278ba4a5 100644
--- a/arch/sparc/include/asm/unistd.h
+++ b/arch/sparc/include/asm/unistd.h
@@ -30,8 +30,8 @@
 #define __ARCH_WANT_SYS_GETHOSTNAME
 #define __ARCH_WANT_SYS_PAUSE
 #define __ARCH_WANT_SYS_SIGNAL
-#define __ARCH_WANT_SYS_TIME
-#define __ARCH_WANT_SYS_UTIME
+#define __ARCH_WANT_SYS_TIME32
+#define __ARCH_WANT_SYS_UTIME32
 #define __ARCH_WANT_SYS_WAITPID
 #define __ARCH_WANT_SYS_SOCKETCALL
 #define __ARCH_WANT_SYS_FADVISE64
@@ -43,8 +43,8 @@
 #ifdef __32bit_syscall_numbers__
 #define __ARCH_WANT_SYS_IPC
 #else
-#define __ARCH_WANT_COMPAT_SYS_TIME
-#define __ARCH_WANT_SYS_UTIME32
+#define __ARCH_WANT_SYS_TIME
+#define __ARCH_WANT_SYS_UTIME
 #define __ARCH_WANT_COMPAT_SYS_SENDFILE
 #endif
 
diff --git a/arch/sparc/kernel/syscalls/syscall.tbl b/arch/sparc/kernel/syscalls/syscall.tbl
index 29b77f3bf2b7..fde7491f76e8 100644
--- a/arch/sparc/kernel/syscalls/syscall.tbl
+++ b/arch/sparc/kernel/syscalls/syscall.tbl
@@ -44,7 +44,8 @@
 28	common	sigaltstack		sys_sigaltstack			compat_sys_sigaltstack
 29	32    	pause			sys_pause
 29	64    	pause			sys_nis_syscall
-30	common	utime			sys_utime			sys_utime32
+30	32	utime			sys_utime32
+30	64	utime			sys_utime
 31	32    	lchown32		sys_lchown
 32	32    	fchown32		sys_fchown
 33	common	access			sys_access
@@ -169,7 +170,8 @@
 135	common	socketpair		sys_socketpair
 136	common	mkdir			sys_mkdir
 137	common	rmdir			sys_rmdir
-138	common	utimes			sys_utimes			sys_utimes_time32
+138	32	utimes			sys_utimes_time32
+138	64	utimes			sys_utimes
 139	common	stat64			sys_stat64			compat_sys_stat64
 140	common	sendfile64		sys_sendfile64
 141	common	getpeername		sys_getpeername
@@ -274,9 +276,10 @@
 228	common	setfsuid		sys_setfsuid16
 229	common	setfsgid		sys_setfsgid16
 230	common	_newselect		sys_select			compat_sys_select
-231	32	time			sys_time			sys_time32
+231	32	time			sys_time32
 232	common	splice			sys_splice
-233	common	stime			sys_stime			sys_stime32
+233	32	stime			sys_stime32
+233	64	stime			sys_stime
 234	common	statfs64		sys_statfs64			compat_sys_statfs64
 235	common	fstatfs64		sys_fstatfs64			compat_sys_fstatfs64
 236	common	_llseek			sys_llseek
@@ -345,7 +348,8 @@
 285	common	mkdirat			sys_mkdirat
 286	common	mknodat			sys_mknodat
 287	common	fchownat		sys_fchownat
-288	common	futimesat		sys_futimesat			sys_futimesat_time32
+288	32	futimesat		sys_futimesat_time32
+288	64	futimesat		sys_futimesat
 289	common	fstatat64		sys_fstatat64			compat_sys_fstatat64
 290	common	unlinkat		sys_unlinkat
 291	common	renameat		sys_renameat
diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
index 35c7a1ebdf3d..1ad4b1c5417d 100644
--- a/arch/x86/entry/syscalls/syscall_32.tbl
+++ b/arch/x86/entry/syscalls/syscall_32.tbl
@@ -24,7 +24,7 @@
 10	i386	unlink			sys_unlink			__ia32_sys_unlink
 11	i386	execve			sys_execve			__ia32_compat_sys_execve
 12	i386	chdir			sys_chdir			__ia32_sys_chdir
-13	i386	time			sys_time			__ia32_sys_time32
+13	i386	time			sys_time32			__ia32_sys_time32
 14	i386	mknod			sys_mknod			__ia32_sys_mknod
 15	i386	chmod			sys_chmod			__ia32_sys_chmod
 16	i386	lchown			sys_lchown16			__ia32_sys_lchown16
@@ -36,12 +36,12 @@
 22	i386	umount			sys_oldumount			__ia32_sys_oldumount
 23	i386	setuid			sys_setuid16			__ia32_sys_setuid16
 24	i386	getuid			sys_getuid16			__ia32_sys_getuid16
-25	i386	stime			sys_stime			__ia32_sys_stime32
+25	i386	stime			sys_stime32			__ia32_sys_stime32
 26	i386	ptrace			sys_ptrace			__ia32_compat_sys_ptrace
 27	i386	alarm			sys_alarm			__ia32_sys_alarm
 28	i386	oldfstat		sys_fstat			__ia32_sys_fstat
 29	i386	pause			sys_pause			__ia32_sys_pause
-30	i386	utime			sys_utime			__ia32_sys_utime32
+30	i386	utime			sys_utime32			__ia32_sys_utime32
 31	i386	stty
 32	i386	gtty
 33	i386	access			sys_access			__ia32_sys_access
@@ -282,7 +282,7 @@
 268	i386	statfs64		sys_statfs64			__ia32_compat_sys_statfs64
 269	i386	fstatfs64		sys_fstatfs64			__ia32_compat_sys_fstatfs64
 270	i386	tgkill			sys_tgkill			__ia32_sys_tgkill
-271	i386	utimes			sys_utimes			__ia32_sys_utimes_time32
+271	i386	utimes			sys_utimes_time32		__ia32_sys_utimes_time32
 272	i386	fadvise64_64		sys_fadvise64_64		__ia32_compat_sys_x86_fadvise64_64
 273	i386	vserver
 274	i386	mbind			sys_mbind			__ia32_sys_mbind
@@ -310,7 +310,7 @@
 296	i386	mkdirat			sys_mkdirat			__ia32_sys_mkdirat
 297	i386	mknodat			sys_mknodat			__ia32_sys_mknodat
 298	i386	fchownat		sys_fchownat			__ia32_sys_fchownat
-299	i386	futimesat		sys_futimesat			__ia32_sys_futimesat_time32
+299	i386	futimesat		sys_futimesat_time32		__ia32_sys_futimesat_time32
 300	i386	fstatat64		sys_fstatat64			__ia32_compat_sys_x86_fstatat
 301	i386	unlinkat		sys_unlinkat			__ia32_sys_unlinkat
 302	i386	renameat		sys_renameat			__ia32_sys_renameat
diff --git a/arch/x86/include/asm/unistd.h b/arch/x86/include/asm/unistd.h
index dc4ed8bc2382..146859efd83c 100644
--- a/arch/x86/include/asm/unistd.h
+++ b/arch/x86/include/asm/unistd.h
@@ -23,8 +23,8 @@
 
 #  include <asm/unistd_64.h>
 #  include <asm/unistd_64_x32.h>
-#  define __ARCH_WANT_COMPAT_SYS_TIME
-#  define __ARCH_WANT_SYS_UTIME32
+#  define __ARCH_WANT_SYS_TIME
+#  define __ARCH_WANT_SYS_UTIME
 #  define __ARCH_WANT_COMPAT_SYS_PREADV64
 #  define __ARCH_WANT_COMPAT_SYS_PWRITEV64
 #  define __ARCH_WANT_COMPAT_SYS_PREADV64V2
@@ -48,8 +48,8 @@
 # define __ARCH_WANT_SYS_SIGPENDING
 # define __ARCH_WANT_SYS_SIGPROCMASK
 # define __ARCH_WANT_SYS_SOCKETCALL
-# define __ARCH_WANT_SYS_TIME
-# define __ARCH_WANT_SYS_UTIME
+# define __ARCH_WANT_SYS_TIME32
+# define __ARCH_WANT_SYS_UTIME32
 # define __ARCH_WANT_SYS_WAITPID
 # define __ARCH_WANT_SYS_FORK
 # define __ARCH_WANT_SYS_VFORK
diff --git a/arch/xtensa/include/asm/unistd.h b/arch/xtensa/include/asm/unistd.h
index 81cc52ea1bd5..30af4dc3ce7b 100644
--- a/arch/xtensa/include/asm/unistd.h
+++ b/arch/xtensa/include/asm/unistd.h
@@ -7,7 +7,7 @@
 
 #define __ARCH_WANT_NEW_STAT
 #define __ARCH_WANT_STAT64
-#define __ARCH_WANT_SYS_UTIME
+#define __ARCH_WANT_SYS_UTIME32
 #define __ARCH_WANT_SYS_GETPGRP
 
 #define NR_syscalls				__NR_syscalls
diff --git a/arch/xtensa/kernel/syscalls/syscall.tbl b/arch/xtensa/kernel/syscalls/syscall.tbl
index 6f05bc8f015a..482673389e21 100644
--- a/arch/xtensa/kernel/syscalls/syscall.tbl
+++ b/arch/xtensa/kernel/syscalls/syscall.tbl
@@ -72,8 +72,8 @@
 61	common	fcntl64				sys_fcntl64
 62	common	fallocate			sys_fallocate
 63	common	fadvise64_64			xtensa_fadvise64_64
-64	common	utime				sys_utime
-65	common	utimes				sys_utimes
+64	common	utime				sys_utime32
+65	common	utimes				sys_utimes_time32
 66	common	ioctl				sys_ioctl
 67	common	fcntl				sys_fcntl
 68	common	setxattr			sys_setxattr
@@ -318,7 +318,7 @@
 295	common	readlinkat			sys_readlinkat
 296	common	utimensat			sys_utimensat_time32
 297	common	fchownat			sys_fchownat
-298	common	futimesat			sys_futimesat
+298	common	futimesat			sys_futimesat_time32
 299	common	fstatat64			sys_fstatat64
 300	common	fchmodat			sys_fchmodat
 301	common	faccessat			sys_faccessat
diff --git a/kernel/time/time.c b/kernel/time/time.c
index 6261f969dcb7..c3f756f8534b 100644
--- a/kernel/time/time.c
+++ b/kernel/time/time.c
@@ -99,7 +99,7 @@ SYSCALL_DEFINE1(stime, time_t __user *, tptr)
 #endif /* __ARCH_WANT_SYS_TIME */
 
 #ifdef CONFIG_COMPAT_32BIT_TIME
-#ifdef __ARCH_WANT_COMPAT_SYS_TIME
+#ifdef __ARCH_WANT_SYS_TIME32
 
 /* old_time32_t is a 32 bit "long" and needs to get converted. */
 SYSCALL_DEFINE1(time32, old_time32_t __user *, tloc)
@@ -134,7 +134,7 @@ SYSCALL_DEFINE1(stime32, old_time32_t __user *, tptr)
 	return 0;
 }
 
-#endif /* __ARCH_WANT_COMPAT_SYS_TIME */
+#endif /* __ARCH_WANT_SYS_TIME32 */
 #endif
 
 SYSCALL_DEFINE2(gettimeofday, struct timeval __user *, tv,
-- 
2.20.0

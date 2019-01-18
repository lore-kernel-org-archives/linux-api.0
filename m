From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 13/29] arch: add split IPC system calls where needed
Date: Fri, 18 Jan 2019 17:18:19 +0100
Message-ID: <20190118161835.2259170-14-arnd@arndb.de>
References: <20190118161835.2259170-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20190118161835.2259170-1-arnd@arndb.de>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: y2038@lists.linaro.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: dalias@libc.org, linux-ia64@vger.kernel.org, linux-sh@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, jcmvbkbc@gmail.com, deepa.kernel@gmail.com, hpa@zytor.com, sparclinux@vger.kernel.org, linux-s390@vger.kernel.org, mpe@ellerman.id.au, deller@gmx.de, x86@kernel.org, linux@armlinux.org.uk, mingo@redhat.com, geert@linux-m68k.org, benh@kernel.crashing.org, firoz.khan@linaro.org, mattst88@gmail.com, fenghua.yu@intel.com, Arnd Bergmann <arnd@arndb.de>, heiko.carstens@de.ibm.com, linux-fsdevel@vger.kernel.org, linux-m68k@lists.linux-m68k.org, luto@kernel.org, tglx@linutronix.de, linux-arm-kernel@lists.infradead.org, monstr@monstr.eu, tony.luck@intel.com, linux-parisc@vger.kernel.org, netdev@vger.kernel.org, linux-mips@vger.kernel.org, paul.burton@mips.com, ebiederm@xmission.com, linux-alpha@vger.kernel.org, schwidefsky@de.ibm.com, akpm@linux-foundation.orglinu
List-Id: linux-api@vger.kernel.org

The IPC system call handling is highly inconsistent across architectures,
some use sys_ipc, some use separate calls, and some use both.  We also
have some architectures that require passing IPC_64 in the flags, and
others that set it implicitly.

For the additon of a y2083 safe semtimedop() system call, I chose to only
support the separate entry points, but that requires first supporting
the regular ones with their own syscall numbers.

The IPC_64 is now implied by the new semctl/shmctl/msgctl system
calls even on the architectures that require passing it with the ipc()
multiplexer.

I'm not adding the new semtimedop() or semop() on 32-bit architectures,
those will get implemented using the new semtimedop_time64() version
that gets added along with the other time64 calls.
Three 64-bit architectures (powerpc, s390 and sparc) get semtimedop().

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
One aspect here that might be a bit controversial is the use of
the same system call numbers across all architectures, synchronizing
all of them with the x86-32 numbers. With the new syscall.tbl
files, I hope we can just keep doing that in the future, and no
longer require the architecture maintainers to assign a number.

This is mainly useful for implementers of the C libraries: if
we can add future system calls everywhere at the same time, using
a particular version of the kernel headers also guarantees that
the system call number macro is visible.
---
 arch/m68k/kernel/syscalls/syscall.tbl     | 11 +++++++++++
 arch/mips/kernel/syscalls/syscall_o32.tbl | 11 +++++++++++
 arch/powerpc/kernel/syscalls/syscall.tbl  | 13 +++++++++++++
 arch/s390/kernel/syscalls/syscall.tbl     | 12 ++++++++++++
 arch/sh/kernel/syscalls/syscall.tbl       | 11 +++++++++++
 arch/sparc/kernel/syscalls/syscall.tbl    | 12 ++++++++++++
 arch/x86/entry/syscalls/syscall_32.tbl    | 11 +++++++++++
 7 files changed, 81 insertions(+)

diff --git a/arch/m68k/kernel/syscalls/syscall.tbl b/arch/m68k/kernel/syscalls/syscall.tbl
index 85779d6ef935..5354ba02eed2 100644
--- a/arch/m68k/kernel/syscalls/syscall.tbl
+++ b/arch/m68k/kernel/syscalls/syscall.tbl
@@ -388,3 +388,14 @@
 378	common	pwritev2			sys_pwritev2
 379	common	statx				sys_statx
 380	common	seccomp				sys_seccomp
+# room for arch specific calls
+393	common	semget				sys_semget
+394	common	semctl				sys_semctl
+395	common	shmget				sys_shmget
+396	common	shmctl				sys_shmctl
+397	common	shmat				sys_shmat
+398	common	shmdt				sys_shmdt
+399	common	msgget				sys_msgget
+400	common	msgsnd				sys_msgsnd
+401	common	msgrcv				sys_msgrcv
+402	common	msgctl				sys_msgctl
diff --git a/arch/mips/kernel/syscalls/syscall_o32.tbl b/arch/mips/kernel/syscalls/syscall_o32.tbl
index 3d5a47b80d2b..fa47ea8cc6ef 100644
--- a/arch/mips/kernel/syscalls/syscall_o32.tbl
+++ b/arch/mips/kernel/syscalls/syscall_o32.tbl
@@ -380,3 +380,14 @@
 366	o32	statx				sys_statx
 367	o32	rseq				sys_rseq
 368	o32	io_pgetevents			sys_io_pgetevents		compat_sys_io_pgetevents
+# room for arch specific calls
+393	o32	semget				sys_semget
+394	o32	semctl				sys_semctl			compat_sys_semctl
+395	o32	shmget				sys_shmget
+396	o32	shmctl				sys_shmctl			compat_sys_shmctl
+397	o32	shmat				sys_shmat			compat_sys_shmat
+398	o32	shmdt				sys_shmdt
+399	o32	msgget				sys_msgget
+400	o32	msgsnd				sys_msgsnd			compat_sys_msgsnd
+401	o32	msgrcv				sys_msgrcv			compat_sys_msgrcv
+402	o32	msgctl				sys_msgctl			compat_sys_msgctl
diff --git a/arch/powerpc/kernel/syscalls/syscall.tbl b/arch/powerpc/kernel/syscalls/syscall.tbl
index db3bbb8744af..7555874ce39c 100644
--- a/arch/powerpc/kernel/syscalls/syscall.tbl
+++ b/arch/powerpc/kernel/syscalls/syscall.tbl
@@ -414,6 +414,7 @@
 363	spu	switch_endian			sys_ni_syscall
 364	common	userfaultfd			sys_userfaultfd
 365	common	membarrier			sys_membarrier
+# 366-377 originally left for IPC, now unused
 378	nospu	mlock2				sys_mlock2
 379	nospu	copy_file_range			sys_copy_file_range
 380	common	preadv2				sys_preadv2			compat_sys_preadv2
@@ -425,3 +426,15 @@
 386	nospu	pkey_mprotect			sys_pkey_mprotect
 387	nospu	rseq				sys_rseq
 388	nospu	io_pgetevents			sys_io_pgetevents		compat_sys_io_pgetevents
+# room for arch specific syscalls
+392	64	semtimedop			sys_semtimedop
+393	common	semget				sys_semget
+394	common	semctl				sys_semctl			compat_sys_semctl
+395	common	shmget				sys_shmget
+396	common	shmctl				sys_shmctl			compat_sys_shmctl
+397	common	shmat				sys_shmat			compat_sys_shmat
+398	common	shmdt				sys_shmdt
+399	common	msgget				sys_msgget
+400	common	msgsnd				sys_msgsnd			compat_sys_msgsnd
+401	common	msgrcv				sys_msgrcv			compat_sys_msgrcv
+402	common	msgctl				sys_msgctl			compat_sys_msgctl
diff --git a/arch/s390/kernel/syscalls/syscall.tbl b/arch/s390/kernel/syscalls/syscall.tbl
index 7413fd318e2a..0bccb01c6202 100644
--- a/arch/s390/kernel/syscalls/syscall.tbl
+++ b/arch/s390/kernel/syscalls/syscall.tbl
@@ -391,3 +391,15 @@
 381  common	kexec_file_load		sys_kexec_file_load		sys_kexec_file_load
 382  common	io_pgetevents		sys_io_pgetevents		compat_sys_io_pgetevents
 383  common	rseq			sys_rseq			sys_rseq
+# room for arch specific syscalls
+392	64	semtimedop		sys_semtimedop			-
+393  common	semget			sys_semget			sys_semget
+394  common	semctl			sys_semctl			compat_sys_semctl
+395  common	shmget			sys_shmget			sys_shmget
+396  common	shmctl			sys_shmctl			compat_sys_shmctl
+397  common	shmat			sys_shmat			compat_sys_shmat
+398  common	shmdt			sys_shmdt 			sys_shmdt
+399  common	msgget			sys_msgget			sys_msgget
+400  common	msgsnd			sys_msgsnd			compat_sys_msgsnd
+401  common	msgrcv			sys_msgrcv			compat_sys_msgrcv
+402  common	msgctl			sys_msgctl			compat_sys_msgctl
diff --git a/arch/sh/kernel/syscalls/syscall.tbl b/arch/sh/kernel/syscalls/syscall.tbl
index a70db013dbc7..6d0b84e3ef2d 100644
--- a/arch/sh/kernel/syscalls/syscall.tbl
+++ b/arch/sh/kernel/syscalls/syscall.tbl
@@ -391,3 +391,14 @@
 381	common	preadv2				sys_preadv2
 382	common	pwritev2			sys_pwritev2
 383	common	statx				sys_statx
+# room for arch specific syscalls
+393	common	semget				sys_semget
+394	common	semctl				sys_semctl
+395	common	shmget				sys_shmget
+396	common	shmctl				sys_shmctl
+397	common	shmat				sys_shmat
+398	common	shmdt				sys_shmdt
+399	common	msgget				sys_msgget
+400	common	msgsnd				sys_msgsnd
+401	common	msgrcv				sys_msgrcv
+402	common	msgctl				sys_msgctl
diff --git a/arch/sparc/kernel/syscalls/syscall.tbl b/arch/sparc/kernel/syscalls/syscall.tbl
index c8c77c05ea97..8c9580302422 100644
--- a/arch/sparc/kernel/syscalls/syscall.tbl
+++ b/arch/sparc/kernel/syscalls/syscall.tbl
@@ -407,3 +407,15 @@
 359	common	pwritev2		sys_pwritev2			compat_sys_pwritev2
 360	common	statx			sys_statx
 361	common	io_pgetevents		sys_io_pgetevents		compat_sys_io_pgetevents
+# room for arch specific syscalls
+392	64	semtimedop			sys_semtimedop
+393	common	semget			sys_semget
+394	common	semctl			sys_semctl			compat_sys_semctl
+395	common	shmget			sys_shmget
+396	common	shmctl			sys_shmctl			compat_sys_shmctl
+397	common	shmat			sys_shmat			compat_sys_shmat
+398	common	shmdt			sys_shmdt
+399	common	msgget			sys_msgget
+400	common	msgsnd			sys_msgsnd			compat_sys_msgsnd
+401	common	msgrcv			sys_msgrcv			compat_sys_msgrcv
+402	common	msgctl			sys_msgctl			compat_sys_msgctl
diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
index 3cf7b533b3d1..fef80b92eb7e 100644
--- a/arch/x86/entry/syscalls/syscall_32.tbl
+++ b/arch/x86/entry/syscalls/syscall_32.tbl
@@ -398,3 +398,14 @@
 384	i386	arch_prctl		sys_arch_prctl			__ia32_compat_sys_arch_prctl
 385	i386	io_pgetevents		sys_io_pgetevents		__ia32_compat_sys_io_pgetevents
 386	i386	rseq			sys_rseq			__ia32_sys_rseq
+# room for arch specific syscalls
+393	i386	semget			sys_semget    			__ia32_sys_semget
+394	i386	semctl			sys_semctl    			__ia32_compat_sys_semctl
+395	i386	shmget			sys_shmget    			__ia32_sys_shmget
+396	i386	shmctl			sys_shmctl    			__ia32_compat_sys_shmctl
+397	i386	shmat			sys_shmat     			__ia32_compat_sys_shmat
+398	i386	shmdt			sys_shmdt     			__ia32_sys_shmdt
+399	i386	msgget			sys_msgget    			__ia32_sys_msgget
+400	i386	msgsnd			sys_msgsnd    			__ia32_compat_sys_msgsnd
+401	i386	msgrcv			sys_msgrcv    			__ia32_compat_sys_msgrcv
+402	i386	msgctl			sys_msgctl    			__ia32_compat_sys_msgctl
-- 
2.20.0

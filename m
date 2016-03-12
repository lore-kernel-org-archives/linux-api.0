From: Piotr Henryk Dabrowski <ultr-FYXd98AMhaE@public.gmane.org>
Subject: [PATCH v3] cpu-= command line parmeter, SYS_cpuid sys call,
 kernel-adjusted CPUID
Date: Sat, 12 Mar 2016 02:12:18 +0100
Message-ID: <20160312021218.6005d5dc@ultra.tux-net>
References: <20160310212716.3711abfc@ultra.tux-net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160310212716.3711abfc-iCS8D82cxDOkYAyEuCb6Mw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Piotr Henryk Dabrowski <ultr-FYXd98AMhaE@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Currently there is no way of disabling CPU features reported by the CPUID
instruction. Which sometimes turn out to be broken [1] or undesired [2].
We can assume we will run into similar situations again sooner or later.
The only way to fix this is to do a microcode update (if it is available),
as the BIOS does not provide a way to disable CPUID bits either. When there is
no new microcode, then there is no way to tell your system not to use certain
CPU features. This sometimes leads to an unbootable and/or unusable system.
Plus the ability to quickly disable certain CPU extensions would be handy for
debugging.

This patch aims at providing system-wide support for the kernel-adjusted CPUID:
* The kernel takes a command line parameter (cpu-=...) allowing for an easy way
  to disable any of the known CPUID capability bits [3]. Plus the kernel may
  disable certain features by itself as well.
* Then the kernel provides a system call for obtaining the adjusted data [4]
  (SYS_cpuid, to be used instead of the __cpuid* macros from GCC's cpuid.h).

Since the cpuid instruction is available from the user-space, use of SYS_cpuid
cannot be enforced on programmers. But it can be encouraged. And having a
possibility to have it supported in glibc is a good start [5].
The expected impact is, after the new versions of kernel and glibc are widely
adopted, to discourage use of low-level __cpuid* macros for checking supported
CPU features on Linux as a coding issue that workarounds and breaks system
features.
And we may expect users to report bugs for programs that do not respect CPU
flags being disabled. Especially that they will be trivial to fix.
It will take time, but if this is introduced now, it may become a widely used
solution in a few years that will finally allow us to easily disable unwanted
CPU features on demand.

Old 'no*' command line parameters are obsoleted by this patch, as the cpu-=
syntax provides the same functionality in a more flexible and generic way.

*Replacing the syscall with vsyscall/vdso could be considered for this patch.*

This thread is a follow-up of a previous short discussion on this topic [6]:
>[...] ask the kernel instead and that is a problem because older kernels won't
>have the newer features enabled in, say /proc/cpuinfo [...]
Hence the syscall, which will nicely fallback for older kernels with a non-zero
return value.
Ideally, there should be a header file that does this. But having this syscall
provides at least a posibility for the userland to painlessly replace the native
__cpuid calls within their code. It even has the same syntax and parameters'
types as the __cpuid_count macro (see test program below).
Reading the /proc/cpuinfo would be a nightmare. While syscall is probably the
fastest, most low-level and fallback-enabled solution possible. If it is
acceptable for glibc, then I guess it is good enough for all the programs above.

On GitLab you can find trees with both this patch [7][8] and the modified latest
version of glibc [9]. And I attach a test program for the SYS_cpuid below [10].

This is my very first patch for the kernel, so please let me know of any code
quality issues or improvement suggestions.

[1]  https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=800574
[2]  https://devtalk.nvidia.com/default/topic/893325/newest-and-beta-linux-driver-causing-segmentation-fault-core-dumped-on-all-skylake-platforms/
[3]  e.g. 'linux ... nosplash quiet cpu-=mmx,sse,sse2'
[4]  long sys_cpuid(const u32 level, const u32 count,
                    u32 __user *eax, u32 __user *ebx,
                    u32 __user *ecx, u32 __user *edx);
[5]  https://sourceware.org/ml/libc-alpha/2016-03/msg00260.html
[6]  https://lkml.org/lkml/2016/1/4/720
[7]  https://gitlab.com/ultr/linux/tags/ultr-sys_cpuid-master
[8]  https://gitlab.com/ultr/linux/tags/ultr-sys_cpuid-next-v3
[9]  https://gitlab.com/ultr/glibc/tags/ultr-sys_cpuid-v2
[10] SYS_cpuid test program:
- - - - cut here - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#include <stdio.h>
#include <stdint.h>

#include <unistd.h>
#include <sys/syscall.h>

#include <cpuid.h>

#ifndef __linux__
    #warning Not a Linux!
#endif

#ifndef SYS_cpuid
    #warning Defining undefined SYS_cpuid!
    #ifdef __x86_64__
        #define SYS_cpuid 327
    #else
        #define SYS_cpuid 378
    #endif
#endif

void get_native(const uint32_t level, const uint32_t count) {
    register uint32_t eax = 0, ebx = 0, ecx = 0, edx = 0;
    __cpuid_count(level, count, eax, ebx, ecx, edx);
    printf("native cpuid:\t[0x%08X,%u] => [0x%08X,0x%08X,0x%08X,0x%08X]\n", level, count, eax, ebx, ecx, edx);
}

void get_kernel(const uint32_t level, const uint32_t count) {
    uint32_t eax = 0, ebx = 0, ecx = 0, edx = 0;
    int ret = syscall(SYS_cpuid, level, count, &eax, &ebx, &ecx, &edx);
    printf("sys_cpuid==%d:\t[0x%08X,%u] => [0x%08X,0x%08X,0x%08X,0x%08X]\n", ret, level, count, eax, ebx, ecx, edx);
}

void get(const uint32_t level, const uint32_t count) {
    get_native(level, count);
    get_kernel(level, count);
}

int main(int argc, char **argv) {
    printf("SYS_cpuid = %d\n", SYS_cpuid);
    get(0x00000001, 0);
    get(0x00000006, 0);
    get(0x00000007, 0);
    get(0x0000000D, 1);
    get(0x0000000F, 0);
    get(0x0000000F, 1);
    get(0x80000001, 0);
    get(0x80000008, 0);
    get(0x8000000A, 0);
    get(0x80860001, 0);
    get(0xC0000001, 0);

    get(0x00000002, 0);
    get(0x00000004, 0);
    get(0x00000004, 1);
    get(0x00000004, 2);
    get(0x00000004, 3);
    return 0;
}
- - - - cut here - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

Regards,
Piotr Henryk Dabrowski


--

kernel-adjusted cpuid

* cpu-= command line parmeter
* SYS_cpuid(level,count,eax,ebx,ecx,edx) syscall
* kernel-adjusted cpuid functions
---
 Documentation/kernel-parameters.txt    |  29 +++--
 arch/x86/entry/syscalls/syscall_32.tbl |   1 +
 arch/x86/entry/syscalls/syscall_64.tbl |   1 +
 arch/x86/include/asm/cpufeature.h      |  21 ----
 arch/x86/include/asm/cpuid_leafs.h     |  26 +++++
 arch/x86/include/asm/elf.h             |   3 +-
 arch/x86/include/asm/processor.h       | 110 +++++++++++++++++--
 arch/x86/include/asm/syscalls.h        |   6 ++
 arch/x86/kernel/cpu/centaur.c          |   4 +-
 arch/x86/kernel/cpu/common.c           | 186 ++++++++++++++++++++++++++++-----
 arch/x86/kernel/cpu/transmeta.c        |  10 +-
 arch/x86/kernel/mpparse.c              |   4 +-
 arch/x86/lguest/boot.c                 |   3 +-
 arch/x86/um/sys_call_table_64.c        |   1 +
 arch/x86/xen/enlighten.c               |   3 +-
 kernel/sys_ni.c                        |   1 +
 16 files changed, 342 insertions(+), 67 deletions(-)
 create mode 100644 arch/x86/include/asm/cpuid_leafs.h

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 1e58ae9..a681206 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -675,7 +675,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			[SPARC64] tick
 			[X86-64] hpet,tsc
 
-	clearcpuid=BITNUM [X86]
+	clearcpuid=BITNUM [X86] Deprecated. Use cpu-= instead.
 			Disable CPUID feature X for the kernel. See
 			arch/x86/include/asm/cpufeatures.h for the valid bit
 			numbers. Note the Linux specific bits are not necessarily
@@ -776,6 +776,20 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			/proc/<pid>/coredump_filter.
 			See also Documentation/filesystems/proc.txt.
 
+	cpu-= 		[X86]
+			Comma-separated list of CPU features (flags) to
+			forcefully ignore.
+			See /proc/cpuinfo for the list of supported flags in
+			your CPU. Their names are case insensitive. Numeric
+			values for flags' bits can also be used, see
+			arch/x86/include/asm/cpufeature.h for the list.
+			You can query the kernel-adjusted CPUID with SYS_cpuid
+			sys-call and it is recommended to do so in your code.
+			Calling CPUID directly provides original hardware CPU
+			features.
+			Note the kernel might malfunction if you disable some
+			critical features.
+
 	cpuidle.off=1	[CPU_IDLE]
 			disable the cpuidle sub-system
 
@@ -983,7 +997,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			Enable debug messages at boot time.  See
 			Documentation/dynamic-debug-howto.txt for details.
 
-	nompx		[X86] Disables Intel Memory Protection Extensions.
+	nompx		[X86] Deprecated. Use cpu-=mpx instead.
+			Disables Intel Memory Protection Extensions.
 			See Documentation/x86/intel_mpx.txt for more
 			information about the feature.
 
@@ -2498,7 +2513,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 
 	nocache		[ARM]
 
-	noclflush	[BUGS=X86] Don't use the CLFLUSH instruction
+	noclflush	[BUGS=X86] Deprecated. Use cpu-=clflush instead.
+			Don't use the CLFLUSH instruction
 
 	nodelayacct	[KNL] Disable per-task delay accounting
 
@@ -2515,11 +2531,11 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			noexec=on: enable non-executable mappings (default)
 			noexec=off: disable non-executable mappings
 
-	nosmap		[X86]
+	nosmap		[X86] Deprecated. Use cpu-=smap instead.
 			Disable SMAP (Supervisor Mode Access Prevention)
 			even if it is supported by processor.
 
-	nosmep		[X86]
+	nosmep		[X86] Deprecated. Use cpu-=smep instead.
 			Disable SMEP (Supervisor Mode Execution Prevention)
 			even if it is supported by processor.
 
@@ -2663,7 +2679,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 
 	nosbagart	[IA-64]
 
-	nosep		[BUGS=X86-32] Disables x86 SYSENTER/SYSEXIT support.
+	nosep		[BUGS=X86-32] Deprecated. Use cpu-=sep instead.
+			Disables x86 SYSENTER/SYSEXIT support.
 
 	nosmp		[SMP] Tells an SMP kernel to act as a UP kernel,
 			and disable the IO APIC.  legacy for "maxcpus=0".
diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
index cb713df..60f2524 100644
--- a/arch/x86/entry/syscalls/syscall_32.tbl
+++ b/arch/x86/entry/syscalls/syscall_32.tbl
@@ -384,3 +384,4 @@
 375	i386	membarrier		sys_membarrier
 376	i386	mlock2			sys_mlock2
 377	i386	copy_file_range		sys_copy_file_range
+378	i386	cpuid			sys_cpuid
diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
index 2e5b565..0f7ecda 100644
--- a/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/arch/x86/entry/syscalls/syscall_64.tbl
@@ -333,6 +333,7 @@
 324	common	membarrier		sys_membarrier
 325	common	mlock2			sys_mlock2
 326	common	copy_file_range		sys_copy_file_range
+327	common	cpuid			sys_cpuid
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 50e292a..67575cb 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -8,27 +8,6 @@
 #include <asm/asm.h>
 #include <linux/bitops.h>
 
-enum cpuid_leafs
-{
-	CPUID_1_EDX		= 0,
-	CPUID_8000_0001_EDX,
-	CPUID_8086_0001_EDX,
-	CPUID_LNX_1,
-	CPUID_1_ECX,
-	CPUID_C000_0001_EDX,
-	CPUID_8000_0001_ECX,
-	CPUID_LNX_2,
-	CPUID_LNX_3,
-	CPUID_7_0_EBX,
-	CPUID_D_1_EAX,
-	CPUID_F_0_EDX,
-	CPUID_F_1_EDX,
-	CPUID_8000_0008_EBX,
-	CPUID_6_EAX,
-	CPUID_8000_000A_EDX,
-	CPUID_7_ECX,
-};
-
 #ifdef CONFIG_X86_FEATURE_NAMES
 extern const char * const x86_cap_flags[NCAPINTS*32];
 extern const char * const x86_power_flags[32];
diff --git a/arch/x86/include/asm/cpuid_leafs.h b/arch/x86/include/asm/cpuid_leafs.h
new file mode 100644
index 0000000..7e1ae39
--- /dev/null
+++ b/arch/x86/include/asm/cpuid_leafs.h
@@ -0,0 +1,26 @@
+#ifndef _ASM_X86_CPUID_LEAFS_H
+#define _ASM_X86_CPUID_LEAFS_H
+
+enum cpuid_leafs
+{
+	CPUID_00000001_0_EDX	= 0,
+	CPUID_80000001_0_EDX,
+	CPUID_80860001_0_EDX,
+	CPUID_LNX_1,
+	CPUID_00000001_0_ECX,
+	CPUID_C0000001_0_EDX,
+	CPUID_80000001_0_ECX,
+	CPUID_LNX_2,
+	CPUID_LNX_3,
+	CPUID_00000007_0_EBX,
+	CPUID_0000000D_1_EAX,
+	CPUID_0000000F_0_EDX,
+	CPUID_0000000F_1_EDX,
+	CPUID_80000008_0_EBX,
+	CPUID_00000006_0_EAX,
+	CPUID_8000000A_0_EDX,
+	CPUID_00000007_0_ECX,
+};
+#define CPUID_LEAFS_COUNT 17
+
+#endif /* _ASM_X86_CPUID_LEAFS_H */
diff --git a/arch/x86/include/asm/elf.h b/arch/x86/include/asm/elf.h
index 15340e3..f39b3c7 100644
--- a/arch/x86/include/asm/elf.h
+++ b/arch/x86/include/asm/elf.h
@@ -9,6 +9,7 @@
 #include <asm/ptrace.h>
 #include <asm/user.h>
 #include <asm/auxvec.h>
+#include <asm/cpuid_leafs.h>
 
 typedef unsigned long elf_greg_t;
 
@@ -256,7 +257,7 @@ extern int force_personality32;
    instruction set this CPU supports.  This could be done in user space,
    but it's not easy, and we've already done it here.  */
 
-#define ELF_HWCAP		(boot_cpu_data.x86_capability[CPUID_1_EDX])
+#define ELF_HWCAP	(boot_cpu_data.x86_capability[CPUID_00000001_0_EDX])
 
 /* This yields a string that ld.so will use to load implementation
    specific libraries for optimization.  This is more specific in
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 983738a..a600ad4 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -22,6 +22,7 @@ struct vm86;
 #include <asm/nops.h>
 #include <asm/special_insns.h>
 #include <asm/fpu/types.h>
+#include <asm/cpuid_leafs.h>
 
 #include <linux/personality.h>
 #include <linux/cache.h>
@@ -159,6 +160,7 @@ extern struct cpuinfo_x86	new_cpu_data;
 extern struct tss_struct	doublefault_tss;
 extern __u32			cpu_caps_cleared[NCAPINTS];
 extern __u32			cpu_caps_set[NCAPINTS];
+extern __u32			*cpuid_overrides[CPUID_LEAFS_COUNT];
 
 #ifdef CONFIG_SMP
 DECLARE_PER_CPU_READ_MOSTLY(struct cpuinfo_x86, cpu_info);
@@ -487,6 +489,53 @@ static inline void load_sp0(struct tss_struct *tss,
 #define set_iopl_mask native_set_iopl_mask
 #endif /* CONFIG_PARAVIRT */
 
+static inline void __kernel_cpuid(unsigned int *eax, unsigned int *ebx,
+				  unsigned int *ecx, unsigned int *edx)
+{
+	unsigned int op = *eax;
+	unsigned int count = *ecx;
+	unsigned int *oeax, *oebx, *oecx, *oedx;
+
+	__cpuid(eax, ebx, ecx, edx);
+
+	oeax = oebx = oecx = oedx = 0;
+	if (op == 0x00000001) {
+		oecx = cpuid_overrides[CPUID_00000001_0_ECX];
+		oedx = cpuid_overrides[CPUID_00000001_0_EDX];
+	} else if (op == 0x00000006) {
+		oeax = cpuid_overrides[CPUID_00000006_0_EAX];
+	} else if (op == 0x00000007) {
+		oebx = cpuid_overrides[CPUID_00000007_0_EBX];
+		oecx = cpuid_overrides[CPUID_00000007_0_ECX];
+	} else if (op == 0x0000000D && count == 1) {
+		oeax = cpuid_overrides[CPUID_0000000D_1_EAX];
+	} else if (op == 0x0000000F && count == 0) {
+		oedx = cpuid_overrides[CPUID_0000000F_0_EDX];
+	} else if (op == 0x0000000F && count == 1) {
+		oedx = cpuid_overrides[CPUID_0000000F_1_EDX];
+	} else if (op == 0x80000001) {
+		oecx = cpuid_overrides[CPUID_80000001_0_ECX];
+		oedx = cpuid_overrides[CPUID_80000001_0_EDX];
+	} else if (op == 0x80000008) {
+		oebx = cpuid_overrides[CPUID_80000008_0_EBX];
+	} else if (op == 0x8000000A) {
+		oedx = cpuid_overrides[CPUID_8000000A_0_EDX];
+	} else if (op == 0x80860001) {
+		oedx = cpuid_overrides[CPUID_80860001_0_EDX];
+	} else if (op == 0xC0000001) {
+		oedx = cpuid_overrides[CPUID_C0000001_0_EDX];
+	}
+
+	if (oeax)
+		*eax = *oeax;
+	if (oebx)
+		*ebx = *oebx;
+	if (oecx)
+		*ecx = *oecx;
+	if (oedx)
+		*edx = *oedx;
+}
+
 typedef struct {
 	unsigned long		seg;
 } mm_segment_t;
@@ -527,36 +576,83 @@ static inline void cpuid_count(unsigned int op, int count,
 static inline unsigned int cpuid_eax(unsigned int op)
 {
 	unsigned int eax, ebx, ecx, edx;
-
 	cpuid(op, &eax, &ebx, &ecx, &edx);
-
 	return eax;
 }
 
 static inline unsigned int cpuid_ebx(unsigned int op)
 {
 	unsigned int eax, ebx, ecx, edx;
-
 	cpuid(op, &eax, &ebx, &ecx, &edx);
-
 	return ebx;
 }
 
 static inline unsigned int cpuid_ecx(unsigned int op)
 {
 	unsigned int eax, ebx, ecx, edx;
-
 	cpuid(op, &eax, &ebx, &ecx, &edx);
-
 	return ecx;
 }
 
 static inline unsigned int cpuid_edx(unsigned int op)
 {
 	unsigned int eax, ebx, ecx, edx;
-
 	cpuid(op, &eax, &ebx, &ecx, &edx);
+	return edx;
+}
+
+/*
+ * Kernel-adjusted CPUID function
+ * clear %ecx since some cpus (Cyrix MII) do not set or clear %ecx
+ * resulting in stale register contents being returned.
+ */
+static inline void kernel_cpuid(unsigned int op,
+				unsigned int *eax, unsigned int *ebx,
+				unsigned int *ecx, unsigned int *edx)
+{
+	*eax = op;
+	*ecx = 0;
+	__kernel_cpuid(eax, ebx, ecx, edx);
+}
 
+/* Some CPUID calls want 'count' to be placed in ecx */
+static inline void kernel_cpuid_count(unsigned int op, int count,
+				      unsigned int *eax, unsigned int *ebx,
+				      unsigned int *ecx, unsigned int *edx)
+{
+	*eax = op;
+	*ecx = count;
+	__kernel_cpuid(eax, ebx, ecx, edx);
+}
+
+/*
+ * CPUID functions returning a single datum
+ */
+static inline unsigned int kernel_cpuid_eax(unsigned int op)
+{
+	unsigned int eax, ebx, ecx, edx;
+	kernel_cpuid(op, &eax, &ebx, &ecx, &edx);
+	return eax;
+}
+
+static inline unsigned int kernel_cpuid_ebx(unsigned int op)
+{
+	unsigned int eax, ebx, ecx, edx;
+	kernel_cpuid(op, &eax, &ebx, &ecx, &edx);
+	return ebx;
+}
+
+static inline unsigned int kernel_cpuid_ecx(unsigned int op)
+{
+	unsigned int eax, ebx, ecx, edx;
+	kernel_cpuid(op, &eax, &ebx, &ecx, &edx);
+	return ecx;
+}
+
+static inline unsigned int kernel_cpuid_edx(unsigned int op)
+{
+	unsigned int eax, ebx, ecx, edx;
+	kernel_cpuid(op, &eax, &ebx, &ecx, &edx);
 	return edx;
 }
 
diff --git a/arch/x86/include/asm/syscalls.h b/arch/x86/include/asm/syscalls.h
index 91dfcaf..bb4aa14 100644
--- a/arch/x86/include/asm/syscalls.h
+++ b/arch/x86/include/asm/syscalls.h
@@ -2,6 +2,7 @@
  * syscalls.h - Linux syscall interfaces (arch-specific)
  *
  * Copyright (c) 2008 Jaswinder Singh Rajput
+ * Copyright (c) 2016 Piotr Henryk Dabrowski <ultr-FYXd98AMhaE@public.gmane.org>
  *
  * This file is released under the GPLv2.
  * See the file COPYING for more details.
@@ -30,6 +31,11 @@ asmlinkage long sys_rt_sigreturn(void);
 asmlinkage long sys_set_thread_area(struct user_desc __user *);
 asmlinkage long sys_get_thread_area(struct user_desc __user *);
 
+/* kernel/common.c */
+asmlinkage long sys_cpuid(const u32 level, const u32 count,
+			  u32 __user *eax, u32 __user *ebx,
+			  u32 __user *ecx, u32 __user *edx);
+
 /* X86_32 only */
 #ifdef CONFIG_X86_32
 
diff --git a/arch/x86/kernel/cpu/centaur.c b/arch/x86/kernel/cpu/centaur.c
index 1661d8e..977c218 100644
--- a/arch/x86/kernel/cpu/centaur.c
+++ b/arch/x86/kernel/cpu/centaur.c
@@ -5,6 +5,7 @@
 #include <asm/e820.h>
 #include <asm/mtrr.h>
 #include <asm/msr.h>
+#include <asm/cpuid_leafs.h>
 
 #include "cpu.h"
 
@@ -43,7 +44,8 @@ static void init_c3(struct cpuinfo_x86 *c)
 		/* store Centaur Extended Feature Flags as
 		 * word 5 of the CPU capability bit array
 		 */
-		c->x86_capability[CPUID_C000_0001_EDX] = cpuid_edx(0xC0000001);
+		c->x86_capability[CPUID_C0000001_0_EDX] = cpuid_edx(0xC0000001);
+		cpuid_overrides[CPUID_C0000001_0_EDX] = &(c->x86_capability[CPUID_C0000001_0_EDX]);
 	}
 #ifdef CONFIG_X86_32
 	/* Cyrix III family needs CX8 & PGE explicitly enabled. */
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 9988caf..18cd087 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -14,6 +14,8 @@
 #include <linux/smp.h>
 #include <linux/io.h>
 #include <linux/syscore_ops.h>
+#include <linux/string.h>
+#include <linux/syscalls.h>
 
 #include <asm/stackprotector.h>
 #include <asm/perf_event.h>
@@ -43,6 +45,8 @@
 #include <asm/pat.h>
 #include <asm/microcode.h>
 #include <asm/microcode_intel.h>
+#include <asm/cpufeature.h>
+#include <asm/cpuid_leafs.h>
 
 #ifdef CONFIG_X86_LOCAL_APIC
 #include <asm/uv/uv.h>
@@ -146,8 +150,105 @@ DEFINE_PER_CPU_PAGE_ALIGNED(struct gdt_page, gdt_page) = { .gdt = {
 } };
 EXPORT_PER_CPU_SYMBOL_GPL(gdt_page);
 
+int forcefully_ignore_caps_requested = 0;
+__u32 forcefully_ignored_caps[NCAPINTS] = {};
+
+/*
+ * Print actually forcefully ignored CPU capabilities.
+ * Stay silent if no such ignore was requested from command line.
+ */
+static void print_forcefully_ignored_caps(void)
+{
+	unsigned long bit;
+	int n = 0;
+	static char buf[COMMAND_LINE_SIZE];
+
+	if (forcefully_ignore_caps_requested == 0)
+		return;
+
+	buf[0] = '\0';
+	for (bit = 0; bit < 32 * NCAPINTS; bit++)
+	{
+		if (test_bit(bit, (unsigned long *)forcefully_ignored_caps)) {
+			int len = strlen(buf);
+#ifdef CONFIG_X86_FEATURE_NAMES
+			if (x86_cap_flags[bit] != NULL)
+				snprintf(buf + len, sizeof(buf) - len,
+					 " %s", x86_cap_flags[bit]);
+			else
+#endif
+				snprintf(buf + len, sizeof(buf) - len,
+					 " %lu", bit);
+			n++;
+		}
+	}
+	if (n == 0)
+		sprintf(buf, " -");
+	printk(KERN_INFO "CPU: CPU features forcefully ignored:%s\n", buf);
+}
+
+/*
+ * Forcefully ignore CPU capability.
+ */
+static void forcefully_ignore_cap(unsigned long bit)
+{
+	forcefully_ignore_caps_requested = 1;
+
+	if (boot_cpu_has(bit)) {
+		setup_clear_cpu_cap(bit);
+		set_bit(bit, (unsigned long *)forcefully_ignored_caps);
+	}
+
+	/* for X86_FEATURE_CLFLUSH clear also X86_FEATURE_CLFLUSHOPT */
+	if (bit == X86_FEATURE_CLFLUSH) {
+		forcefully_ignore_cap(X86_FEATURE_CLFLUSHOPT);
+	}
+}
+
+/*
+ * Forcefully ignore CPU capabilities specified with the cpu-= cmdline argument.
+ */
+static int __init setup_forcefully_ignore_caps(char *arg)
+{
+	static char c_arg[COMMAND_LINE_SIZE];
+	int i;
+	unsigned long bit;
+
+	forcefully_ignore_caps_requested = 1;
+
+	snprintf(c_arg, sizeof(c_arg), ",%s,", arg);
+	for (i = 0; i < sizeof(c_arg); i++) {
+		if (c_arg[i] == '\0')
+			break;
+		c_arg[i] = tolower(c_arg[i]);
+	}
+
+	for (bit = 0; bit < 32 * NCAPINTS; bit++)
+	{
+		char c_feature[128];
+		sprintf(c_feature, ",%lu,", bit);
+		if (strstr(c_arg, c_feature) != 0) {
+			forcefully_ignore_cap(bit);
+			continue;
+		}
+#ifdef CONFIG_X86_FEATURE_NAMES
+		if (x86_cap_flags[bit] != NULL) {
+			sprintf(c_feature, ",%s,", x86_cap_flags[bit]);
+			if (strstr(c_arg, c_feature) != 0) {
+				forcefully_ignore_cap(bit);
+			}
+		}
+#endif
+	}
+
+	return 1;
+}
+__setup("cpu-=", setup_forcefully_ignore_caps);
+
 static int __init x86_mpx_setup(char *s)
 {
+	printk(KERN_INFO "nompx: deprecated, use cpu-=mpx\n");
+
 	/* require an exact match without trailing characters */
 	if (strlen(s))
 		return 0;
@@ -156,11 +257,11 @@ static int __init x86_mpx_setup(char *s)
 	if (!boot_cpu_has(X86_FEATURE_MPX))
 		return 1;
 
-	setup_clear_cpu_cap(X86_FEATURE_MPX);
+	forcefully_ignore_cap(X86_FEATURE_MPX);
 	pr_info("nompx: Intel Memory Protection Extensions (MPX) disabled\n");
 	return 1;
 }
-__setup("nompx", x86_mpx_setup);
+__setup("nompx", x86_mpx_setup); /* deprecated by cpu-=mpx */
 
 static int __init x86_noinvpcid_setup(char *s)
 {
@@ -191,10 +292,11 @@ __setup("cachesize=", cachesize_setup);
 
 static int __init x86_sep_setup(char *s)
 {
-	setup_clear_cpu_cap(X86_FEATURE_SEP);
+	printk(KERN_INFO "nosep: deprecated, use cpu-=sep\n");
+	forcefully_ignore_cap(X86_FEATURE_SEP);
 	return 1;
 }
-__setup("nosep", x86_sep_setup);
+__setup("nosep", x86_sep_setup); /* deprecated by cpu-=sep */
 
 /* Standard macro to see if a specific flag is changeable */
 static inline int flag_is_changeable_p(u32 flag)
@@ -269,10 +371,11 @@ static inline void squash_the_stupid_serial_number(struct cpuinfo_x86 *c)
 
 static __init int setup_disable_smep(char *arg)
 {
-	setup_clear_cpu_cap(X86_FEATURE_SMEP);
+	printk(KERN_INFO "nosmep: deprecated, use cpu-=smep\n");
+	forcefully_ignore_cap(X86_FEATURE_SMEP);
 	return 1;
 }
-__setup("nosmep", setup_disable_smep);
+__setup("nosmep", setup_disable_smep); /* deprecated by cpu-=smep */
 
 static __always_inline void setup_smep(struct cpuinfo_x86 *c)
 {
@@ -282,10 +385,11 @@ static __always_inline void setup_smep(struct cpuinfo_x86 *c)
 
 static __init int setup_disable_smap(char *arg)
 {
-	setup_clear_cpu_cap(X86_FEATURE_SMAP);
+	printk(KERN_INFO "nosmap: deprecated, use cpu-=smap\n");
+	forcefully_ignore_cap(X86_FEATURE_SMAP);
 	return 1;
 }
-__setup("nosmap", setup_disable_smap);
+__setup("nosmap", setup_disable_smap); /* deprecated by cpu-=smap */
 
 static __always_inline void setup_smap(struct cpuinfo_x86 *c)
 {
@@ -424,6 +528,7 @@ static const char *table_lookup_model(struct cpuinfo_x86 *c)
 
 __u32 cpu_caps_cleared[NCAPINTS];
 __u32 cpu_caps_set[NCAPINTS];
+__u32 *cpuid_overrides[CPUID_LEAFS_COUNT];
 
 void load_percpu_segment(int cpu)
 {
@@ -656,25 +761,33 @@ void get_cpu_cap(struct cpuinfo_x86 *c)
 	if (c->cpuid_level >= 0x00000001) {
 		cpuid(0x00000001, &eax, &ebx, &ecx, &edx);
 
-		c->x86_capability[CPUID_1_ECX] = ecx;
-		c->x86_capability[CPUID_1_EDX] = edx;
+		c->x86_capability[CPUID_00000001_0_ECX] = ecx;
+		cpuid_overrides[CPUID_00000001_0_ECX] = &(c->x86_capability[CPUID_00000001_0_ECX]);
+
+		c->x86_capability[CPUID_00000001_0_EDX] = edx;
+		cpuid_overrides[CPUID_00000001_0_EDX] = &(c->x86_capability[CPUID_00000001_0_EDX]);
 	}
 
 	/* Additional Intel-defined flags: level 0x00000007 */
 	if (c->cpuid_level >= 0x00000007) {
 		cpuid_count(0x00000007, 0, &eax, &ebx, &ecx, &edx);
 
-		c->x86_capability[CPUID_7_0_EBX] = ebx;
+		c->x86_capability[CPUID_00000007_0_EBX] = ebx;
+		cpuid_overrides[CPUID_00000007_0_EBX] = &(c->x86_capability[CPUID_00000007_0_EBX]);
 
-		c->x86_capability[CPUID_6_EAX] = cpuid_eax(0x00000006);
-		c->x86_capability[CPUID_7_ECX] = ecx;
+		c->x86_capability[CPUID_00000007_0_ECX] = ecx;
+		cpuid_overrides[CPUID_00000007_0_ECX] = &(c->x86_capability[CPUID_00000007_0_ECX]);
+
+		c->x86_capability[CPUID_00000006_0_EAX] = cpuid_eax(0x00000006);
+		cpuid_overrides[CPUID_00000006_0_EAX] = &(c->x86_capability[CPUID_00000006_0_EAX]);
 	}
 
 	/* Extended state features: level 0x0000000d */
 	if (c->cpuid_level >= 0x0000000d) {
 		cpuid_count(0x0000000d, 1, &eax, &ebx, &ecx, &edx);
 
-		c->x86_capability[CPUID_D_1_EAX] = eax;
+		c->x86_capability[CPUID_0000000D_1_EAX] = eax;
+		cpuid_overrides[CPUID_0000000D_1_EAX] = &(c->x86_capability[CPUID_0000000D_1_EAX]);
 	}
 
 	/* Additional Intel-defined flags: level 0x0000000F */
@@ -682,7 +795,8 @@ void get_cpu_cap(struct cpuinfo_x86 *c)
 
 		/* QoS sub-leaf, EAX=0Fh, ECX=0 */
 		cpuid_count(0x0000000F, 0, &eax, &ebx, &ecx, &edx);
-		c->x86_capability[CPUID_F_0_EDX] = edx;
+		c->x86_capability[CPUID_0000000F_0_EDX] = edx;
+		cpuid_overrides[CPUID_0000000F_0_EDX] = &(c->x86_capability[CPUID_0000000F_0_EDX]);
 
 		if (cpu_has(c, X86_FEATURE_CQM_LLC)) {
 			/* will be overridden if occupancy monitoring exists */
@@ -690,7 +804,8 @@ void get_cpu_cap(struct cpuinfo_x86 *c)
 
 			/* QoS sub-leaf, EAX=0Fh, ECX=1 */
 			cpuid_count(0x0000000F, 1, &eax, &ebx, &ecx, &edx);
-			c->x86_capability[CPUID_F_1_EDX] = edx;
+			c->x86_capability[CPUID_0000000F_1_EDX] = edx;
+			cpuid_overrides[CPUID_0000000F_1_EDX] = &(c->x86_capability[CPUID_0000000F_1_EDX]);
 
 			if (cpu_has(c, X86_FEATURE_CQM_OCCUP_LLC)) {
 				c->x86_cache_max_rmid = ecx;
@@ -710,8 +825,11 @@ void get_cpu_cap(struct cpuinfo_x86 *c)
 		if (eax >= 0x80000001) {
 			cpuid(0x80000001, &eax, &ebx, &ecx, &edx);
 
-			c->x86_capability[CPUID_8000_0001_ECX] = ecx;
-			c->x86_capability[CPUID_8000_0001_EDX] = edx;
+			c->x86_capability[CPUID_80000001_0_ECX] = ecx;
+			cpuid_overrides[CPUID_80000001_0_ECX] = &(c->x86_capability[CPUID_80000001_0_ECX]);
+
+			c->x86_capability[CPUID_80000001_0_EDX] = edx;
+			cpuid_overrides[CPUID_80000001_0_EDX] = &(c->x86_capability[CPUID_80000001_0_EDX]);
 		}
 	}
 
@@ -720,7 +838,8 @@ void get_cpu_cap(struct cpuinfo_x86 *c)
 
 		c->x86_virt_bits = (eax >> 8) & 0xff;
 		c->x86_phys_bits = eax & 0xff;
-		c->x86_capability[CPUID_8000_0008_EBX] = ebx;
+		c->x86_capability[CPUID_80000008_0_EBX] = ebx;
+		cpuid_overrides[CPUID_80000008_0_EBX] = &(c->x86_capability[CPUID_80000008_0_EBX]);
 	}
 #ifdef CONFIG_X86_32
 	else if (cpu_has(c, X86_FEATURE_PAE) || cpu_has(c, X86_FEATURE_PSE36))
@@ -731,7 +850,10 @@ void get_cpu_cap(struct cpuinfo_x86 *c)
 		c->x86_power = cpuid_edx(0x80000007);
 
 	if (c->extended_cpuid_level >= 0x8000000a)
-		c->x86_capability[CPUID_8000_000A_EDX] = cpuid_edx(0x8000000a);
+	{
+		c->x86_capability[CPUID_8000000A_0_EDX] = cpuid_edx(0x8000000a);
+		cpuid_overrides[CPUID_8000000A_0_EDX] = &(c->x86_capability[CPUID_8000000A_0_EDX]);
+	}
 
 	init_scattered_cpuid_features(c);
 }
@@ -1167,11 +1289,11 @@ __setup("show_msr=", setup_show_msr);
 
 static __init int setup_noclflush(char *arg)
 {
-	setup_clear_cpu_cap(X86_FEATURE_CLFLUSH);
-	setup_clear_cpu_cap(X86_FEATURE_CLFLUSHOPT);
+	printk(KERN_INFO "noclflush: deprecated, use cpu-=clflush\n");
+	forcefully_ignore_cap(X86_FEATURE_CLFLUSH);
 	return 1;
 }
-__setup("noclflush", setup_noclflush);
+__setup("noclflush", setup_noclflush); /* deprecated by cpu-=clflush */
 
 void print_cpu_info(struct cpuinfo_x86 *c)
 {
@@ -1212,14 +1334,16 @@ static __init int setup_disablecpuid(char *arg)
 {
 	int bit;
 
+	printk(KERN_INFO "clearcpuid: deprecated, use cpu-=\n");
+
 	if (get_option(&arg, &bit) && bit < NCAPINTS*32)
-		setup_clear_cpu_cap(bit);
+		forcefully_ignore_cap(bit);
 	else
 		return 0;
 
 	return 1;
 }
-__setup("clearcpuid=", setup_disablecpuid);
+__setup("clearcpuid=", setup_disablecpuid); /* deprecated by cpu-= */
 
 #ifdef CONFIG_X86_64
 struct desc_ptr idt_descr = { NR_VECTORS * 16 - 1, (unsigned long) idt_table };
@@ -1502,6 +1626,8 @@ void cpu_init(void)
 
 	if (is_uv_system())
 		uv_cpu_init();
+
+	print_forcefully_ignored_caps();
 }
 
 #else
@@ -1557,6 +1683,8 @@ void cpu_init(void)
 	dbg_restore_debug_regs();
 
 	fpu__init_cpu();
+
+	print_forcefully_ignored_caps();
 }
 #endif
 
@@ -1576,3 +1704,11 @@ static int __init init_cpu_syscore(void)
 	return 0;
 }
 core_initcall(init_cpu_syscore);
+
+SYSCALL_DEFINE6(cpuid, const u32, level, const u32, count,
+		u32 __user *, eax, u32 __user *, ebx,
+		u32 __user *, ecx, u32 __user *, edx)
+{
+	kernel_cpuid_count(level, count, eax, ebx, ecx, edx);
+	return 0;
+}
diff --git a/arch/x86/kernel/cpu/transmeta.c b/arch/x86/kernel/cpu/transmeta.c
index 3417856..3def5fa 100644
--- a/arch/x86/kernel/cpu/transmeta.c
+++ b/arch/x86/kernel/cpu/transmeta.c
@@ -2,6 +2,7 @@
 #include <linux/mm.h>
 #include <asm/cpufeature.h>
 #include <asm/msr.h>
+#include <asm/cpuid_leafs.h>
 #include "cpu.h"
 
 static void early_init_transmeta(struct cpuinfo_x86 *c)
@@ -11,8 +12,10 @@ static void early_init_transmeta(struct cpuinfo_x86 *c)
 	/* Transmeta-defined flags: level 0x80860001 */
 	xlvl = cpuid_eax(0x80860000);
 	if ((xlvl & 0xffff0000) == 0x80860000) {
-		if (xlvl >= 0x80860001)
-			c->x86_capability[CPUID_8086_0001_EDX] = cpuid_edx(0x80860001);
+		if (xlvl >= 0x80860001) {
+			c->x86_capability[CPUID_80860001_0_EDX] = cpuid_edx(0x80860001);
+			cpuid_overrides[CPUID_80860001_0_EDX] = &(c->x86_capability[CPUID_80860001_0_EDX]);
+		}
 	}
 }
 
@@ -82,7 +85,8 @@ static void init_transmeta(struct cpuinfo_x86 *c)
 	/* Unhide possibly hidden capability flags */
 	rdmsr(0x80860004, cap_mask, uk);
 	wrmsr(0x80860004, ~0, uk);
-	c->x86_capability[CPUID_1_EDX] = cpuid_edx(0x00000001);
+	c->x86_capability[CPUID_00000001_0_EDX] = cpuid_edx(0x00000001);
+	cpuid_overrides[CPUID_00000001_0_EDX] = &(c->x86_capability[CPUID_00000001_0_EDX]);
 	wrmsr(0x80860004, cap_mask, uk);
 
 	/* All Transmeta CPUs have a constant TSC */
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 97340f2..33e879a 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -30,6 +30,7 @@
 #include <asm/e820.h>
 #include <asm/setup.h>
 #include <asm/smp.h>
+#include <asm/cpuid_leafs.h>
 
 #include <asm/apic.h>
 /*
@@ -408,7 +409,8 @@ static inline void __init construct_default_ISA_mptable(int mpc_default_type)
 	processor.cpuflag = CPU_ENABLED;
 	processor.cpufeature = (boot_cpu_data.x86 << 8) |
 	    (boot_cpu_data.x86_model << 4) | boot_cpu_data.x86_mask;
-	processor.featureflag = boot_cpu_data.x86_capability[CPUID_1_EDX];
+	processor.featureflag =
+	    boot_cpu_data.x86_capability[CPUID_00000001_0_EDX];
 	processor.reserved[0] = 0;
 	processor.reserved[1] = 0;
 	for (i = 0; i < 2; i++) {
diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
index fd57d3a..b21dd30 100644
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -76,6 +76,7 @@
 #include <asm/kvm_para.h>
 #include <asm/pci_x86.h>
 #include <asm/pci-direct.h>
+#include <asm/cpuid_leafs.h>
 
 /*G:010
  * Welcome to the Guest!
@@ -1529,7 +1530,7 @@ __init void lguest_init(void)
 	 */
 	cpu_detect(&new_cpu_data);
 	/* head.S usually sets up the first capability word, so do it here. */
-	new_cpu_data.x86_capability[CPUID_1_EDX] = cpuid_edx(1);
+	new_cpu_data.x86_capability[CPUID_00000001_0_EDX] = cpuid_edx(1);
 
 	/* Math is always hard! */
 	set_cpu_cap(&new_cpu_data, X86_FEATURE_FPU);
diff --git a/arch/x86/um/sys_call_table_64.c b/arch/x86/um/sys_call_table_64.c
index f306413..be43219 100644
--- a/arch/x86/um/sys_call_table_64.c
+++ b/arch/x86/um/sys_call_table_64.c
@@ -34,6 +34,7 @@
 #define stub_execve sys_execve
 #define stub_execveat sys_execveat
 #define stub_rt_sigreturn sys_rt_sigreturn
+#define stub_cpuid sys_cpuid
 
 #define __SYSCALL_64(nr, sym, qual) extern asmlinkage long sym(unsigned long, unsigned long, unsigned long, unsigned long, unsigned long, unsigned long) ;
 #include <asm/syscalls_64.h>
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 2379a5a..9398164 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -77,6 +77,7 @@
 #include <asm/pci_x86.h>
 #include <asm/pat.h>
 #include <asm/cpu.h>
+#include <asm/cpuid_leafs.h>
 
 #ifdef CONFIG_ACPI
 #include <linux/acpi.h>
@@ -1655,7 +1656,7 @@ asmlinkage __visible void __init xen_start_kernel(void)
 	cpu_detect(&new_cpu_data);
 	set_cpu_cap(&new_cpu_data, X86_FEATURE_FPU);
 	new_cpu_data.wp_works_ok = 1;
-	new_cpu_data.x86_capability[CPUID_1_EDX] = cpuid_edx(1);
+	new_cpu_data.x86_capability[CPUID_00000001_0_EDX] = cpuid_edx(1);
 #endif
 
 	if (xen_start_info->mod_start) {
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index 2c5e3a8..ef22bea 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -187,6 +187,7 @@ cond_syscall(sys_spu_create);
 cond_syscall(sys_subpage_prot);
 cond_syscall(sys_s390_pci_mmio_read);
 cond_syscall(sys_s390_pci_mmio_write);
+cond_syscall(sys_cpuid);
 
 /* mmu depending weak syscall entries */
 cond_syscall(sys_mprotect);
-- 
2.1.4

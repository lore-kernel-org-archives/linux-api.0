From: Yury Norov <ynorov@caviumnetworks.com>
Subject: [PATCH 08/24] arm64: rename COMPAT to AARCH32_EL0 in Kconfig
Date: Wed, 16 May 2018 11:18:53 +0300
Message-ID: <20180516081910.10067-9-ynorov@caviumnetworks.com>
References: <20180516081910.10067-1-ynorov@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180516081910.10067-1-ynorov@caviumnetworks.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Catalin Marinas <catalin.marinas@arm.com>, Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
Cc: Yury Norov <ynorov@caviumnetworks.com>, Adam Borowski <kilobyte@angband.pl>, Alexander Graf <agraf@suse.de>, Alexey Klimov <klimov.linux@gmail.com>, Andreas Schwab <schwab@suse.de>, Andrew Pinski <pinskia@gmail.com>, Bamvor Zhangjian <bamv2005@gmail.com>, Chris Metcalf <cmetcalf@mellanox.com>, Christoph Muellner <christoph.muellner@theobroma-systems.com>, Dave Martin <Dave.Martin@arm.com>, "David S . Miller" <davem@davemloft.net>, Florian Weimer <fweimer@redhat.com>, Geert Uytterhoeven <geert@linux-m68k.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, James Hogan <james.hogan@imgtec.com>, James Morse <james.morse@arm.com>, Joseph Myers <joseph@codesourcery.com>, Lin Yongting <linyongting@huawei.com>, Manuel Montezelo <manuel.montezelo@gmail.>
List-Id: linux-api@vger.kernel.org

From: Andrew Pinski <apinski@cavium.com>

In this patchset ILP32 ABI support is added. Additionally to AARCH32,
which is binary-compatible with ARM, ILP32 is (mostly) ABI-compatible.

>From now, AARCH32_EL0 (former COMPAT) config option means the support of
AARCH32 userspace, and ARM64_ILP32 - support of ILP32 ABI (see following
patches), and COMPAT indicates that one of them or both is enabled.

Where needed, CONFIG_COMPAT is changed over to use CONFIG_AARCH32_EL0
instead.

Reviewed-by: David Daney <ddaney@caviumnetworks.com>
Signed-off-by: Andrew Pinski <Andrew.Pinski@caviumnetworks.com>
Signed-off-by: Yury Norov <ynorov@caviumnetworks.com>
Signed-off-by: Philipp Tomsich <philipp.tomsich@theobroma-systems.com>
Signed-off-by: Christoph Muellner <christoph.muellner@theobroma-systems.com>
Signed-off-by: Bamvor Jian Zhang <bamv2005@gmail.com>
---
 arch/arm64/Kconfig                   | 9 +++++++--
 arch/arm64/include/asm/fpsimd.h      | 2 +-
 arch/arm64/include/asm/hwcap.h       | 4 ++--
 arch/arm64/include/asm/processor.h   | 6 +++---
 arch/arm64/include/asm/ptrace.h      | 2 +-
 arch/arm64/include/asm/seccomp.h     | 2 +-
 arch/arm64/include/asm/signal32.h    | 6 ++++--
 arch/arm64/include/asm/unistd.h      | 2 +-
 arch/arm64/kernel/Makefile           | 2 +-
 arch/arm64/kernel/asm-offsets.c      | 2 +-
 arch/arm64/kernel/cpufeature.c       | 8 ++++----
 arch/arm64/kernel/cpuinfo.c          | 8 ++++----
 arch/arm64/kernel/entry.S            | 6 +++---
 arch/arm64/kernel/head.S             | 2 +-
 arch/arm64/kernel/perf_callchain.c   | 6 +++---
 arch/arm64/kernel/ptrace.c           | 8 ++++----
 arch/arm64/kernel/traps.c            | 2 +-
 arch/arm64/kernel/vdso.c             | 4 ++--
 drivers/clocksource/arm_arch_timer.c | 2 +-
 19 files changed, 45 insertions(+), 38 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 7381eeb7ef8e..a16916be20f5 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -433,7 +433,7 @@ config ARM64_ERRATUM_834220
 
 config ARM64_ERRATUM_845719
 	bool "Cortex-A53: 845719: a load might read incorrect data"
-	depends on COMPAT
+	depends on AARCH32_EL0
 	default y
 	help
 	  This option adds an alternative code sequence to work around ARM
@@ -906,7 +906,7 @@ config HARDEN_BRANCH_PREDICTOR
 
 menuconfig ARMV8_DEPRECATED
 	bool "Emulate deprecated/obsolete ARMv8 instructions"
-	depends on COMPAT
+	depends on AARCH32_EL0
 	depends on SYSCTL
 	help
 	  Legacy software support may require certain instructions
@@ -1225,7 +1225,12 @@ menu "Userspace binary formats"
 source "fs/Kconfig.binfmt"
 
 config COMPAT
+	def_bool y
+	depends on AARCH32_EL0
+
+config AARCH32_EL0
 	bool "Kernel support for 32-bit EL0"
+	def_bool y
 	depends on ARM64_4K_PAGES || EXPERT
 	select COMPAT_BINFMT_ELF if BINFMT_ELF
 	select HAVE_UID16
diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index 8857a0f0d0f7..0971bf730d44 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -49,7 +49,7 @@ struct fpsimd_state {
 	unsigned int cpu;
 };
 
-#if defined(__KERNEL__) && defined(CONFIG_COMPAT)
+#if defined(__KERNEL__) && defined(CONFIG_AARCH32_EL0)
 /* Masks for extracting the FPSR and FPCR from the FPSCR */
 #define VFP_FPSCR_STAT_MASK	0xf800009f
 #define VFP_FPSCR_CTRL_MASK	0x07f79f00
diff --git a/arch/arm64/include/asm/hwcap.h b/arch/arm64/include/asm/hwcap.h
index 400b80b49595..2c7fc5d89813 100644
--- a/arch/arm64/include/asm/hwcap.h
+++ b/arch/arm64/include/asm/hwcap.h
@@ -46,7 +46,7 @@
  */
 #define ELF_HWCAP		(elf_hwcap)
 
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_AARCH32_EL0
 #define COMPAT_ELF_HWCAP	(compat_elf_hwcap)
 #define COMPAT_ELF_HWCAP2	(compat_elf_hwcap2)
 extern unsigned int compat_elf_hwcap, compat_elf_hwcap2;
@@ -54,7 +54,7 @@ extern unsigned int compat_elf_hwcap, compat_elf_hwcap2;
 
 enum {
 	CAP_HWCAP = 1,
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_AARCH32_EL0
 	CAP_COMPAT_HWCAP,
 	CAP_COMPAT_HWCAP2,
 #endif
diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index fce604e3e599..79cbc385f52a 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -104,7 +104,7 @@ struct cpu_context {
 struct thread_struct {
 	struct cpu_context	cpu_context;	/* cpu context */
 	unsigned long		tp_value;	/* TLS register */
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_AARCH32_EL0
 	unsigned long		tp2_value;
 #endif
 	struct fpsimd_state	fpsimd_state;
@@ -126,7 +126,7 @@ static inline void arch_thread_struct_whitelist(unsigned long *offset,
 	*offset = *size = 0;
 }
 
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_AARCH32_EL0
 #define task_user_tls(t)						\
 ({									\
 	unsigned long *__tls;						\
@@ -160,7 +160,7 @@ static inline void start_thread(struct pt_regs *regs, unsigned long pc,
 	regs->sp = sp;
 }
 
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_AARCH32_EL0
 static inline void compat_start_thread(struct pt_regs *regs, unsigned long pc,
 				       unsigned long sp)
 {
diff --git a/arch/arm64/include/asm/ptrace.h b/arch/arm64/include/asm/ptrace.h
index 6069d66e0bc2..0c85b469ad68 100644
--- a/arch/arm64/include/asm/ptrace.h
+++ b/arch/arm64/include/asm/ptrace.h
@@ -154,7 +154,7 @@ static inline void forget_syscall(struct pt_regs *regs)
 
 #define arch_has_single_step()	(1)
 
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_AARCH32_EL0
 #define compat_thumb_mode(regs) \
 	(((regs)->pstate & COMPAT_PSR_T_BIT))
 #else
diff --git a/arch/arm64/include/asm/seccomp.h b/arch/arm64/include/asm/seccomp.h
index c76fac979629..00ef0bf63230 100644
--- a/arch/arm64/include/asm/seccomp.h
+++ b/arch/arm64/include/asm/seccomp.h
@@ -13,7 +13,7 @@
 
 #include <asm/unistd.h>
 
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_AARCH32_EL0
 #define __NR_seccomp_read_32		__NR_compat_read
 #define __NR_seccomp_write_32		__NR_compat_write
 #define __NR_seccomp_exit_32		__NR_compat_exit
diff --git a/arch/arm64/include/asm/signal32.h b/arch/arm64/include/asm/signal32.h
index 81abea0b7650..2ebde460f5a0 100644
--- a/arch/arm64/include/asm/signal32.h
+++ b/arch/arm64/include/asm/signal32.h
@@ -17,7 +17,9 @@
 #define __ASM_SIGNAL32_H
 
 #ifdef __KERNEL__
-#ifdef CONFIG_COMPAT
+
+#ifdef CONFIG_AARCH32_EL0
+
 #include <linux/compat.h>
 
 #define AARCH32_KERN_SIGRET_CODE_OFFSET	0x500
@@ -45,6 +47,6 @@ static inline int compat_setup_rt_frame(int usig, struct ksignal *ksig, sigset_t
 static inline void compat_setup_restart_syscall(struct pt_regs *regs)
 {
 }
-#endif /* CONFIG_COMPAT */
+#endif /* CONFIG_AARCH32_EL0 */
 #endif /* __KERNEL__ */
 #endif /* __ASM_SIGNAL32_H */
diff --git a/arch/arm64/include/asm/unistd.h b/arch/arm64/include/asm/unistd.h
index a0baa9af5487..99d29290c98b 100644
--- a/arch/arm64/include/asm/unistd.h
+++ b/arch/arm64/include/asm/unistd.h
@@ -13,7 +13,7 @@
  * You should have received a copy of the GNU General Public License
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_AARCH32_EL0
 #define __ARCH_WANT_COMPAT_STAT64
 #define __ARCH_WANT_SYS_GETHOSTNAME
 #define __ARCH_WANT_SYS_PAUSE
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index b87541360f43..cff1a78bdf4c 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -26,7 +26,7 @@ OBJCOPYFLAGS := --prefix-symbols=__efistub_
 $(obj)/%.stub.o: $(obj)/%.o FORCE
 	$(call if_changed,objcopy)
 
-arm64-obj-$(CONFIG_COMPAT)		+= sys32.o kuser32.o signal32.o 	\
+arm64-obj-$(CONFIG_AARCH32_EL0)		+= sys32.o kuser32.o signal32.o 	\
 					   sys_compat.o entry32.o
 arm64-obj-$(CONFIG_FUNCTION_TRACER)	+= ftrace.o entry-ftrace.o
 arm64-obj-$(CONFIG_MODULES)		+= arm64ksyms.o module.o
diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index 1303e04110cd..a416c2333e2f 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -69,7 +69,7 @@ int main(void)
   DEFINE(S_X28,			offsetof(struct pt_regs, regs[28]));
   DEFINE(S_LR,			offsetof(struct pt_regs, regs[30]));
   DEFINE(S_SP,			offsetof(struct pt_regs, sp));
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_AARCH32_EL0
   DEFINE(S_COMPAT_SP,		offsetof(struct pt_regs, compat_sp));
 #endif
   DEFINE(S_PSTATE,		offsetof(struct pt_regs, pstate));
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 2985a067fc13..1ea242547466 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -37,7 +37,7 @@
 unsigned long elf_hwcap __read_mostly;
 EXPORT_SYMBOL_GPL(elf_hwcap);
 
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_AARCH32_EL0
 #define COMPAT_ELF_HWCAP_DEFAULT	\
 				(COMPAT_HWCAP_HALF|COMPAT_HWCAP_THUMB|\
 				 COMPAT_HWCAP_FAST_MULT|COMPAT_HWCAP_EDSP|\
@@ -1133,7 +1133,7 @@ static const struct arm64_cpu_capabilities arm64_elf_hwcaps[] = {
 };
 
 static const struct arm64_cpu_capabilities compat_elf_hwcaps[] = {
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_AARCH32_EL0
 	HWCAP_CAP(SYS_ID_ISAR5_EL1, ID_ISAR5_AES_SHIFT, FTR_UNSIGNED, 2, CAP_COMPAT_HWCAP2, COMPAT_HWCAP2_PMULL),
 	HWCAP_CAP(SYS_ID_ISAR5_EL1, ID_ISAR5_AES_SHIFT, FTR_UNSIGNED, 1, CAP_COMPAT_HWCAP2, COMPAT_HWCAP2_AES),
 	HWCAP_CAP(SYS_ID_ISAR5_EL1, ID_ISAR5_SHA1_SHIFT, FTR_UNSIGNED, 1, CAP_COMPAT_HWCAP2, COMPAT_HWCAP2_SHA1),
@@ -1149,7 +1149,7 @@ static void __init cap_set_elf_hwcap(const struct arm64_cpu_capabilities *cap)
 	case CAP_HWCAP:
 		elf_hwcap |= cap->hwcap;
 		break;
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_AARCH32_EL0
 	case CAP_COMPAT_HWCAP:
 		compat_elf_hwcap |= (u32)cap->hwcap;
 		break;
@@ -1172,7 +1172,7 @@ static bool cpus_have_elf_hwcap(const struct arm64_cpu_capabilities *cap)
 	case CAP_HWCAP:
 		rc = (elf_hwcap & cap->hwcap) != 0;
 		break;
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_AARCH32_EL0
 	case CAP_COMPAT_HWCAP:
 		rc = (compat_elf_hwcap & (u32)cap->hwcap) != 0;
 		break;
diff --git a/arch/arm64/kernel/cpuinfo.c b/arch/arm64/kernel/cpuinfo.c
index 7f94623df8a5..23fdf30dc0a3 100644
--- a/arch/arm64/kernel/cpuinfo.c
+++ b/arch/arm64/kernel/cpuinfo.c
@@ -80,7 +80,7 @@ static const char *const hwcap_str[] = {
 	NULL
 };
 
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_AARCH32_EL0
 static const char *const compat_hwcap_str[] = {
 	"swp",
 	"half",
@@ -115,7 +115,7 @@ static const char *const compat_hwcap2_str[] = {
 	"crc32",
 	NULL
 };
-#endif /* CONFIG_COMPAT */
+#endif /* CONFIG_AARCH32_EL0 */
 
 static int c_show(struct seq_file *m, void *v)
 {
@@ -148,7 +148,7 @@ static int c_show(struct seq_file *m, void *v)
 		 */
 		seq_puts(m, "Features\t:");
 		if (compat) {
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_AARCH32_EL0
 			for (j = 0; compat_hwcap_str[j]; j++)
 				if (compat_elf_hwcap & (1 << j))
 					seq_printf(m, " %s", compat_hwcap_str[j]);
@@ -156,7 +156,7 @@ static int c_show(struct seq_file *m, void *v)
 			for (j = 0; compat_hwcap2_str[j]; j++)
 				if (compat_elf_hwcap2 & (1 << j))
 					seq_printf(m, " %s", compat_hwcap2_str[j]);
-#endif /* CONFIG_COMPAT */
+#endif /* CONFIG_AARCH32_EL0 */
 		} else {
 			for (j = 0; hwcap_str[j]; j++)
 				if (elf_hwcap & (1 << j))
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index ec2ee720e33e..698907724eed 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -423,7 +423,7 @@ ENTRY(vectors)
 	kernel_ventry	0, fiq_invalid			// FIQ 64-bit EL0
 	kernel_ventry	0, error			// Error 64-bit EL0
 
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_AARCH32_EL0
 	kernel_ventry	0, sync_compat, 32		// Synchronous 32-bit EL0
 	kernel_ventry	0, irq_compat, 32		// IRQ 32-bit EL0
 	kernel_ventry	0, fiq_invalid_compat, 32	// FIQ 32-bit EL0
@@ -492,7 +492,7 @@ el0_error_invalid:
 	inv_entry 0, BAD_ERROR
 ENDPROC(el0_error_invalid)
 
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_AARCH32_EL0
 el0_fiq_invalid_compat:
 	inv_entry 0, BAD_FIQ, 32
 ENDPROC(el0_fiq_invalid_compat)
@@ -656,7 +656,7 @@ el0_sync:
 	b.ge	el0_dbg
 	b	el0_inv
 
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_AARCH32_EL0
 	.align	6
 el0_sync_compat:
 	kernel_entry 0, 32
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index 2b6b8b24e5ab..fdd706a839e4 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -544,7 +544,7 @@ set_hcr:
 	msr	vpidr_el2, x0
 	msr	vmpidr_el2, x1
 
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_AARCH32_EL0
 	msr	hstr_el2, xzr			// Disable CP15 traps to EL2
 #endif
 
diff --git a/arch/arm64/kernel/perf_callchain.c b/arch/arm64/kernel/perf_callchain.c
index bcafd7dcfe8b..32e07818835d 100644
--- a/arch/arm64/kernel/perf_callchain.c
+++ b/arch/arm64/kernel/perf_callchain.c
@@ -59,7 +59,7 @@ user_backtrace(struct frame_tail __user *tail,
 	return buftail.fp;
 }
 
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_AARCH32_EL0
 /*
  * The registers we're interested in are at the end of the variable
  * length saved register structure. The fp points at the end of this
@@ -104,7 +104,7 @@ compat_user_backtrace(struct compat_frame_tail __user *tail,
 
 	return (struct compat_frame_tail __user *)compat_ptr(buftail.fp) - 1;
 }
-#endif /* CONFIG_COMPAT */
+#endif /* CONFIG_AARCH32_EL0 */
 
 void perf_callchain_user(struct perf_callchain_entry_ctx *entry,
 			 struct pt_regs *regs)
@@ -126,7 +126,7 @@ void perf_callchain_user(struct perf_callchain_entry_ctx *entry,
 		       tail && !((unsigned long)tail & 0xf))
 			tail = user_backtrace(tail, entry);
 	} else {
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_AARCH32_EL0
 		/* AARCH32 compat mode */
 		struct compat_frame_tail __user *tail;
 
diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index 9ae31f7e2243..04e9b7973b28 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -188,7 +188,7 @@ static void ptrace_hbptriggered(struct perf_event *bp,
 	info.si_code	= TRAP_HWBKPT;
 	info.si_addr	= (void __user *)(bkpt->trigger);
 
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_AARCH32_EL0
 	if (is_compat_task()) {
 		int si_errno = 0;
 		int i;
@@ -1039,7 +1039,7 @@ static const struct user_regset_view user_aarch64_view = {
 	.regsets = aarch64_regsets, .n = ARRAY_SIZE(aarch64_regsets)
 };
 
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_AARCH32_EL0
 #include <linux/compat.h>
 
 enum compat_regset {
@@ -1581,11 +1581,11 @@ long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
 
 	return ret;
 }
-#endif /* CONFIG_COMPAT */
+#endif /* CONFIG_AARCH32_EL0 */
 
 const struct user_regset_view *task_user_regset_view(struct task_struct *task)
 {
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_AARCH32_EL0
 	/*
 	 * Core dumping of 32-bit tasks or compat ptrace requests must use the
 	 * user_aarch32_view compatible with arm32. Native ptrace requests on
diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index eb2d15147e8d..691b3bbc7606 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -517,7 +517,7 @@ long compat_arm_syscall(struct pt_regs *regs);
 
 asmlinkage long do_ni_syscall(struct pt_regs *regs)
 {
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_AARCH32_EL0
 	long ret;
 	if (is_compat_task()) {
 		ret = compat_arm_syscall(regs);
diff --git a/arch/arm64/kernel/vdso.c b/arch/arm64/kernel/vdso.c
index 2d419006ad43..440fe2652d4a 100644
--- a/arch/arm64/kernel/vdso.c
+++ b/arch/arm64/kernel/vdso.c
@@ -49,7 +49,7 @@ static union {
 } vdso_data_store __page_aligned_data;
 struct vdso_data *vdso_data = &vdso_data_store.data;
 
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_AARCH32_EL0
 /*
  * Create and map the vectors page for AArch32 tasks.
  */
@@ -108,7 +108,7 @@ int aarch32_setup_vectors_page(struct linux_binprm *bprm, int uses_interp)
 
 	return PTR_ERR_OR_ZERO(ret);
 }
-#endif /* CONFIG_COMPAT */
+#endif /* CONFIG_AARCH32_EL0 */
 
 static int vdso_mremap(const struct vm_special_mapping *sm,
 		struct vm_area_struct *new_vma)
diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 57cb2f00fc07..c3c6a8d48adc 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -764,7 +764,7 @@ static void arch_timer_evtstrm_enable(int divider)
 			| ARCH_TIMER_VIRT_EVT_EN;
 	arch_timer_set_cntkctl(cntkctl);
 	elf_hwcap |= HWCAP_EVTSTRM;
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_AARCH32_EL0
 	compat_elf_hwcap |= COMPAT_HWCAP_EVTSTRM;
 #endif
 	cpumask_set_cpu(smp_processor_id(), &evtstrm_available);
-- 
2.17.0

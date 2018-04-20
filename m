From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [REVIEW][PATCH 06/17] signal: Ensure every siginfo we send has all bits initialized
Date: Thu, 19 Apr 2018 20:03:57 -0500
Message-ID: <20180420010408.24438-6-ebiederm@xmission.com>
References: <878t9ilmhv.fsf@xmission.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <878t9ilmhv.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
List-Id: linux-api@vger.kernel.org

Call clear_siginfo to ensure every stack allocated siginfo is properly
initialized before being passed to the signal sending functions.

Note: It is not safe to depend on C initializers to initialize struct
siginfo on the stack because C is allowed to skip holes when
initializing a structure.

The initialization of struct siginfo in tracehook_report_syscall_exit
was moved from the helper user_single_step_siginfo into
tracehook_report_syscall_exit itself, to make it clear that the local
variable siginfo gets fully initialized.

In a few cases the scope of struct siginfo has been reduced to make it
clear that siginfo siginfo is not used on other paths in the function
in which it is declared.

Instances of using memset to initialize siginfo have been replaced
with calls clear_siginfo for clarity.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 arch/alpha/kernel/osf_sys.c               |  1 +
 arch/alpha/kernel/signal.c                |  2 ++
 arch/alpha/kernel/traps.c                 |  5 +++++
 arch/alpha/mm/fault.c                     |  2 ++
 arch/arc/mm/fault.c                       |  2 ++
 arch/arm/kernel/ptrace.c                  |  1 +
 arch/arm/kernel/swp_emulate.c             |  1 +
 arch/arm/kernel/traps.c                   |  5 +++++
 arch/arm/mm/alignment.c                   |  1 +
 arch/arm/mm/fault.c                       |  4 ++++
 arch/arm/vfp/vfpmodule.c                  |  3 +--
 arch/arm64/kernel/fpsimd.c                |  2 +-
 arch/arm64/kernel/sys_compat.c            |  1 +
 arch/arm64/kernel/traps.c                 |  1 +
 arch/arm64/mm/fault.c                     | 18 ++++++++++++------
 arch/c6x/kernel/traps.c                   |  1 +
 arch/hexagon/kernel/traps.c               |  1 +
 arch/hexagon/mm/vm_fault.c                |  1 +
 arch/ia64/kernel/brl_emu.c                |  1 +
 arch/ia64/kernel/signal.c                 |  2 ++
 arch/ia64/kernel/traps.c                  | 27 ++++++++++++++++++++++++---
 arch/ia64/kernel/unaligned.c              |  1 +
 arch/ia64/mm/fault.c                      |  4 +++-
 arch/m68k/kernel/traps.c                  |  2 ++
 arch/microblaze/kernel/exceptions.c       |  1 +
 arch/microblaze/mm/fault.c                |  4 +++-
 arch/mips/mm/fault.c                      |  1 +
 arch/nds32/kernel/traps.c                 |  3 ++-
 arch/nds32/mm/fault.c                     |  1 +
 arch/nios2/kernel/traps.c                 |  1 +
 arch/openrisc/kernel/traps.c              |  5 ++++-
 arch/openrisc/mm/fault.c                  |  1 +
 arch/parisc/kernel/ptrace.c               |  1 +
 arch/parisc/kernel/traps.c                |  2 ++
 arch/parisc/kernel/unaligned.c            |  1 +
 arch/parisc/math-emu/driver.c             |  1 +
 arch/parisc/mm/fault.c                    |  1 +
 arch/powerpc/kernel/process.c             |  1 +
 arch/powerpc/kernel/traps.c               |  3 +--
 arch/powerpc/mm/fault.c                   |  1 +
 arch/powerpc/platforms/cell/spufs/fault.c |  2 +-
 arch/riscv/kernel/traps.c                 |  1 +
 arch/s390/kernel/traps.c                  |  5 ++++-
 arch/s390/mm/fault.c                      |  2 ++
 arch/sh/kernel/traps_32.c                 |  2 ++
 arch/sh/math-emu/math.c                   |  1 +
 arch/sh/mm/fault.c                        |  1 +
 arch/sparc/kernel/process_64.c            |  1 +
 arch/sparc/kernel/sys_sparc_32.c          |  1 +
 arch/sparc/kernel/traps_32.c              | 10 ++++++++++
 arch/sparc/kernel/traps_64.c              | 14 ++++++++++++++
 arch/sparc/kernel/unaligned_32.c          |  1 +
 arch/sparc/mm/fault_32.c                  |  1 +
 arch/sparc/mm/fault_64.c                  |  1 +
 arch/um/kernel/trap.c                     |  2 ++
 arch/unicore32/kernel/fpu-ucf64.c         |  2 +-
 arch/unicore32/mm/fault.c                 |  3 +++
 arch/x86/entry/vsyscall/vsyscall_64.c     |  2 +-
 arch/x86/kernel/ptrace.c                  |  2 +-
 arch/x86/kernel/traps.c                   |  3 +++
 arch/x86/kernel/umip.c                    |  1 +
 arch/x86/kvm/mmu.c                        |  1 +
 arch/x86/mm/fault.c                       |  1 +
 arch/xtensa/kernel/traps.c                |  1 +
 arch/xtensa/mm/fault.c                    |  1 +
 include/linux/ptrace.h                    |  1 -
 include/linux/tracehook.h                 |  1 +
 virt/kvm/arm/mmu.c                        |  1 +
 68 files changed, 158 insertions(+), 24 deletions(-)

diff --git a/arch/alpha/kernel/osf_sys.c b/arch/alpha/kernel/osf_sys.c
index 2e02aef5a334..f5f154942aab 100644
--- a/arch/alpha/kernel/osf_sys.c
+++ b/arch/alpha/kernel/osf_sys.c
@@ -881,6 +881,7 @@ SYSCALL_DEFINE5(osf_setsysinfo, unsigned long, op, void __user *, buffer,
 			if (fex & IEEE_TRAP_ENABLE_DZE) si_code = FPE_FLTDIV;
 			if (fex & IEEE_TRAP_ENABLE_INV) si_code = FPE_FLTINV;
 
+			clear_siginfo(&info);
 			info.si_signo = SIGFPE;
 			info.si_errno = 0;
 			info.si_code = si_code;
diff --git a/arch/alpha/kernel/signal.c b/arch/alpha/kernel/signal.c
index 9ebb3bcbc626..cd306e602313 100644
--- a/arch/alpha/kernel/signal.c
+++ b/arch/alpha/kernel/signal.c
@@ -221,6 +221,7 @@ do_sigreturn(struct sigcontext __user *sc)
 	if (ptrace_cancel_bpt (current)) {
 		siginfo_t info;
 
+		clear_siginfo(&info);
 		info.si_signo = SIGTRAP;
 		info.si_errno = 0;
 		info.si_code = TRAP_BRKPT;
@@ -255,6 +256,7 @@ do_rt_sigreturn(struct rt_sigframe __user *frame)
 	if (ptrace_cancel_bpt (current)) {
 		siginfo_t info;
 
+		clear_siginfo(&info);
 		info.si_signo = SIGTRAP;
 		info.si_errno = 0;
 		info.si_code = TRAP_BRKPT;
diff --git a/arch/alpha/kernel/traps.c b/arch/alpha/kernel/traps.c
index f43bd05dede2..91636765dd6d 100644
--- a/arch/alpha/kernel/traps.c
+++ b/arch/alpha/kernel/traps.c
@@ -228,6 +228,7 @@ do_entArith(unsigned long summary, unsigned long write_mask,
 	}
 	die_if_kernel("Arithmetic fault", regs, 0, NULL);
 
+	clear_siginfo(&info);
 	info.si_signo = SIGFPE;
 	info.si_errno = 0;
 	info.si_code = si_code;
@@ -241,6 +242,7 @@ do_entIF(unsigned long type, struct pt_regs *regs)
 	siginfo_t info;
 	int signo, code;
 
+	clear_siginfo(&info);
 	if ((regs->ps & ~IPL_MAX) == 0) {
 		if (type == 1) {
 			const unsigned int *data
@@ -430,6 +432,7 @@ do_entDbg(struct pt_regs *regs)
 
 	die_if_kernel("Instruction fault", regs, 0, NULL);
 
+	clear_siginfo(&info);
 	info.si_signo = SIGILL;
 	info.si_errno = 0;
 	info.si_code = ILL_ILLOPC;
@@ -761,6 +764,8 @@ do_entUnaUser(void __user * va, unsigned long opcode,
 	siginfo_t info;
 	long error;
 
+	clear_siginfo(&info);
+
 	/* Check the UAC bits to decide what the user wants us to do
 	   with the unaliged access.  */
 
diff --git a/arch/alpha/mm/fault.c b/arch/alpha/mm/fault.c
index cd3c572ee912..7f2202a9f50a 100644
--- a/arch/alpha/mm/fault.c
+++ b/arch/alpha/mm/fault.c
@@ -91,6 +91,8 @@ do_page_fault(unsigned long address, unsigned long mmcsr,
 	siginfo_t info;
 	unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
 
+	clear_siginfo(&info);
+
 	/* As of EV6, a load into $31/$f31 is a prefetch, and never faults
 	   (or is suppressed by the PALcode).  Support that for older CPUs
 	   by ignoring such an instruction.  */
diff --git a/arch/arc/mm/fault.c b/arch/arc/mm/fault.c
index a0b7bd6d030d..b884bbd6f354 100644
--- a/arch/arc/mm/fault.c
+++ b/arch/arc/mm/fault.c
@@ -70,6 +70,8 @@ void do_page_fault(unsigned long address, struct pt_regs *regs)
 	int write = regs->ecr_cause & ECR_C_PROTV_STORE;  /* ST/EX */
 	unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
 
+	clear_siginfo(&info);
+
 	/*
 	 * We fault-in kernel-space virtual memory on-demand. The
 	 * 'reference' page table is init_mm.pgd.
diff --git a/arch/arm/kernel/ptrace.c b/arch/arm/kernel/ptrace.c
index 7724b0f661b3..36718a424358 100644
--- a/arch/arm/kernel/ptrace.c
+++ b/arch/arm/kernel/ptrace.c
@@ -205,6 +205,7 @@ void ptrace_break(struct task_struct *tsk, struct pt_regs *regs)
 {
 	siginfo_t info;
 
+	clear_siginfo(&info);
 	info.si_signo = SIGTRAP;
 	info.si_errno = 0;
 	info.si_code  = TRAP_BRKPT;
diff --git a/arch/arm/kernel/swp_emulate.c b/arch/arm/kernel/swp_emulate.c
index 3bda08bee674..dfcb456afadd 100644
--- a/arch/arm/kernel/swp_emulate.c
+++ b/arch/arm/kernel/swp_emulate.c
@@ -112,6 +112,7 @@ static void set_segfault(struct pt_regs *regs, unsigned long addr)
 {
 	siginfo_t info;
 
+	clear_siginfo(&info);
 	down_read(&current->mm->mmap_sem);
 	if (find_vma(current->mm, addr) == NULL)
 		info.si_code = SEGV_MAPERR;
diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index 5e3633c24e63..2584f9066da3 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -439,6 +439,7 @@ asmlinkage void do_undefinstr(struct pt_regs *regs)
 	siginfo_t info;
 	void __user *pc;
 
+	clear_siginfo(&info);
 	pc = (void __user *)instruction_pointer(regs);
 
 	if (processor_mode(regs) == SVC_MODE) {
@@ -537,6 +538,7 @@ static int bad_syscall(int n, struct pt_regs *regs)
 {
 	siginfo_t info;
 
+	clear_siginfo(&info);
 	if ((current->personality & PER_MASK) != PER_LINUX) {
 		send_sig(SIGSEGV, current, 1);
 		return regs->ARM_r0;
@@ -604,6 +606,7 @@ asmlinkage int arm_syscall(int no, struct pt_regs *regs)
 {
 	siginfo_t info;
 
+	clear_siginfo(&info);
 	if ((no >> 16) != (__ARM_NR_BASE>> 16))
 		return bad_syscall(no, regs);
 
@@ -740,6 +743,8 @@ baddataabort(int code, unsigned long instr, struct pt_regs *regs)
 	unsigned long addr = instruction_pointer(regs);
 	siginfo_t info;
 
+	clear_siginfo(&info);
+
 #ifdef CONFIG_DEBUG_USER
 	if (user_debug & UDBG_BADABORT) {
 		pr_err("[%d] %s: bad data abort: code %d instr 0x%08lx\n",
diff --git a/arch/arm/mm/alignment.c b/arch/arm/mm/alignment.c
index 2c96190e018b..bd2c739d8083 100644
--- a/arch/arm/mm/alignment.c
+++ b/arch/arm/mm/alignment.c
@@ -950,6 +950,7 @@ do_alignment(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 	if (ai_usermode & UM_SIGNAL) {
 		siginfo_t si;
 
+		clear_siginfo(&si);
 		si.si_signo = SIGBUS;
 		si.si_errno = 0;
 		si.si_code = BUS_ADRALN;
diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
index b75eada23d0a..32034543f49c 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -163,6 +163,8 @@ __do_user_fault(struct task_struct *tsk, unsigned long addr,
 {
 	struct siginfo si;
 
+	clear_siginfo(&si);
+
 #ifdef CONFIG_DEBUG_USER
 	if (((user_debug & UDBG_SEGV) && (sig == SIGSEGV)) ||
 	    ((user_debug & UDBG_BUS)  && (sig == SIGBUS))) {
@@ -557,6 +559,7 @@ do_DataAbort(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 		inf->name, fsr, addr);
 	show_pte(current->mm, addr);
 
+	clear_siginfo(&info);
 	info.si_signo = inf->sig;
 	info.si_errno = 0;
 	info.si_code  = inf->code;
@@ -589,6 +592,7 @@ do_PrefetchAbort(unsigned long addr, unsigned int ifsr, struct pt_regs *regs)
 	pr_alert("Unhandled prefetch abort: %s (0x%03x) at 0x%08lx\n",
 		inf->name, ifsr, addr);
 
+	clear_siginfo(&info);
 	info.si_signo = inf->sig;
 	info.si_errno = 0;
 	info.si_code  = inf->code;
diff --git a/arch/arm/vfp/vfpmodule.c b/arch/arm/vfp/vfpmodule.c
index 4c375e11ae95..adda3fc2dde8 100644
--- a/arch/arm/vfp/vfpmodule.c
+++ b/arch/arm/vfp/vfpmodule.c
@@ -218,8 +218,7 @@ static void vfp_raise_sigfpe(unsigned int sicode, struct pt_regs *regs)
 {
 	siginfo_t info;
 
-	memset(&info, 0, sizeof(info));
-
+	clear_siginfo(&info);
 	info.si_signo = SIGFPE;
 	info.si_code = sicode;
 	info.si_addr = (void __user *)(instruction_pointer(regs) - 4);
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 87a35364e750..4bcdd0318729 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -882,7 +882,7 @@ asmlinkage void do_fpsimd_exc(unsigned int esr, struct pt_regs *regs)
 			si_code = FPE_FLTRES;
 	}
 
-	memset(&info, 0, sizeof(info));
+	clear_siginfo(&info);
 	info.si_signo = SIGFPE;
 	info.si_code = si_code;
 	info.si_addr = (void __user *)instruction_pointer(regs);
diff --git a/arch/arm64/kernel/sys_compat.c b/arch/arm64/kernel/sys_compat.c
index 93ab57dcfc14..a6109825eeb9 100644
--- a/arch/arm64/kernel/sys_compat.c
+++ b/arch/arm64/kernel/sys_compat.c
@@ -112,6 +112,7 @@ long compat_arm_syscall(struct pt_regs *regs)
 		break;
 	}
 
+	clear_siginfo(&info);
 	info.si_signo = SIGILL;
 	info.si_errno = 0;
 	info.si_code  = ILL_ILLTRP;
diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index ba964da31a25..7f476586cacc 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -634,6 +634,7 @@ asmlinkage void bad_el0_sync(struct pt_regs *regs, int reason, unsigned int esr)
 	siginfo_t info;
 	void __user *pc = (void __user *)instruction_pointer(regs);
 
+	clear_siginfo(&info);
 	info.si_signo = SIGILL;
 	info.si_errno = 0;
 	info.si_code  = ILL_ILLOPC;
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 4165485e8b6e..91c53a7d2575 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -305,11 +305,12 @@ static void do_bad_area(unsigned long addr, unsigned int esr, struct pt_regs *re
 	 */
 	if (user_mode(regs)) {
 		const struct fault_info *inf = esr_to_fault_info(esr);
-		struct siginfo si = {
-			.si_signo	= inf->sig,
-			.si_code	= inf->code,
-			.si_addr	= (void __user *)addr,
-		};
+		struct siginfo si;
+
+		clear_siginfo(&si);
+		si.si_signo	= inf->sig;
+		si.si_code	= inf->code;
+		si.si_addr	= (void __user *)addr;
 
 		__do_user_fault(&si, esr);
 	} else {
@@ -583,6 +584,7 @@ static int do_sea(unsigned long addr, unsigned int esr, struct pt_regs *regs)
 			nmi_exit();
 	}
 
+	clear_siginfo(&info);
 	info.si_signo = inf->sig;
 	info.si_errno = 0;
 	info.si_code  = inf->code;
@@ -687,6 +689,7 @@ asmlinkage void __exception do_mem_abort(unsigned long addr, unsigned int esr,
 		show_pte(addr);
 	}
 
+	clear_siginfo(&info);
 	info.si_signo = inf->sig;
 	info.si_errno = 0;
 	info.si_code  = inf->code;
@@ -729,6 +732,7 @@ asmlinkage void __exception do_sp_pc_abort(unsigned long addr,
 		local_irq_enable();
 	}
 
+	clear_siginfo(&info);
 	info.si_signo = SIGBUS;
 	info.si_errno = 0;
 	info.si_code  = BUS_ADRALN;
@@ -772,7 +776,6 @@ asmlinkage int __exception do_debug_exception(unsigned long addr,
 					      struct pt_regs *regs)
 {
 	const struct fault_info *inf = debug_fault_info + DBG_ESR_EVT(esr);
-	struct siginfo info;
 	int rv;
 
 	/*
@@ -788,6 +791,9 @@ asmlinkage int __exception do_debug_exception(unsigned long addr,
 	if (!inf->fn(addr, esr, regs)) {
 		rv = 1;
 	} else {
+		struct siginfo info;
+
+		clear_siginfo(&info);
 		info.si_signo = inf->sig;
 		info.si_errno = 0;
 		info.si_code  = inf->code;
diff --git a/arch/c6x/kernel/traps.c b/arch/c6x/kernel/traps.c
index 4c1d4b84dd2b..c5feee4542b0 100644
--- a/arch/c6x/kernel/traps.c
+++ b/arch/c6x/kernel/traps.c
@@ -246,6 +246,7 @@ static void do_trap(struct exception_info *except_info, struct pt_regs *regs)
 	unsigned long addr = instruction_pointer(regs);
 	siginfo_t info;
 
+	clear_siginfo(&info);
 	if (except_info->code != TRAP_BRKPT)
 		pr_err("TRAP: %s PC[0x%lx] signo[%d] code[%d]\n",
 		       except_info->kernel_str, regs->pc,
diff --git a/arch/hexagon/kernel/traps.c b/arch/hexagon/kernel/traps.c
index 2942a9204a9a..1ff6a6a7b97c 100644
--- a/arch/hexagon/kernel/traps.c
+++ b/arch/hexagon/kernel/traps.c
@@ -414,6 +414,7 @@ void do_trap0(struct pt_regs *regs)
 		if (user_mode(regs)) {
 			struct siginfo info;
 
+			clear_siginfo(&info);
 			info.si_signo = SIGTRAP;
 			info.si_errno = 0;
 			/*
diff --git a/arch/hexagon/mm/vm_fault.c b/arch/hexagon/mm/vm_fault.c
index 3eec33c5cfd7..2ad92edc877c 100644
--- a/arch/hexagon/mm/vm_fault.c
+++ b/arch/hexagon/mm/vm_fault.c
@@ -56,6 +56,7 @@ void do_page_fault(unsigned long address, long cause, struct pt_regs *regs)
 	const struct exception_table_entry *fixup;
 	unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
 
+	clear_siginfo(&info);
 	/*
 	 * If we're in an interrupt or have no user context,
 	 * then must not take the fault.
diff --git a/arch/ia64/kernel/brl_emu.c b/arch/ia64/kernel/brl_emu.c
index 9bcc908bc85e..a61f6c6a36f8 100644
--- a/arch/ia64/kernel/brl_emu.c
+++ b/arch/ia64/kernel/brl_emu.c
@@ -62,6 +62,7 @@ ia64_emulate_brl (struct pt_regs *regs, unsigned long ar_ec)
 	struct illegal_op_return rv;
 	long tmp_taken, unimplemented_address;
 
+	clear_siginfo(&siginfo);
 	rv.fkt = (unsigned long) -1;
 
 	/*
diff --git a/arch/ia64/kernel/signal.c b/arch/ia64/kernel/signal.c
index 54547c7cf8a2..d1234a5ba4c5 100644
--- a/arch/ia64/kernel/signal.c
+++ b/arch/ia64/kernel/signal.c
@@ -153,6 +153,7 @@ ia64_rt_sigreturn (struct sigscratch *scr)
 	return retval;
 
   give_sigsegv:
+	clear_siginfo(&si);
 	si.si_signo = SIGSEGV;
 	si.si_errno = 0;
 	si.si_code = SI_KERNEL;
@@ -236,6 +237,7 @@ force_sigsegv_info (int sig, void __user *addr)
 	unsigned long flags;
 	struct siginfo si;
 
+	clear_siginfo(&si);
 	if (sig == SIGSEGV) {
 		/*
 		 * Acquiring siglock around the sa_handler-update is almost
diff --git a/arch/ia64/kernel/traps.c b/arch/ia64/kernel/traps.c
index 6d4e76a4267f..972873ed1ae5 100644
--- a/arch/ia64/kernel/traps.c
+++ b/arch/ia64/kernel/traps.c
@@ -104,6 +104,7 @@ __kprobes ia64_bad_break (unsigned long break_num, struct pt_regs *regs)
 	int sig, code;
 
 	/* SIGILL, SIGFPE, SIGSEGV, and SIGBUS want these field initialized: */
+	clear_siginfo(&siginfo);
 	siginfo.si_addr = (void __user *) (regs->cr_iip + ia64_psr(regs)->ri);
 	siginfo.si_imm = break_num;
 	siginfo.si_flags = 0;		/* clear __ISR_VALID */
@@ -293,7 +294,6 @@ handle_fpu_swa (int fp_fault, struct pt_regs *regs, unsigned long isr)
 {
 	long exception, bundle[2];
 	unsigned long fault_ip;
-	struct siginfo siginfo;
 
 	fault_ip = regs->cr_iip;
 	if (!fp_fault && (ia64_psr(regs)->ri == 0))
@@ -344,10 +344,13 @@ handle_fpu_swa (int fp_fault, struct pt_regs *regs, unsigned long isr)
 			printk(KERN_ERR "handle_fpu_swa: fp_emulate() returned -1\n");
 			return -1;
 		} else {
+			struct siginfo siginfo;
+
 			/* is next instruction a trap? */
 			if (exception & 2) {
 				ia64_increment_ip(regs);
 			}
+			clear_siginfo(&siginfo);
 			siginfo.si_signo = SIGFPE;
 			siginfo.si_errno = 0;
 			siginfo.si_code = FPE_FIXME;	/* default code */
@@ -372,6 +375,9 @@ handle_fpu_swa (int fp_fault, struct pt_regs *regs, unsigned long isr)
 			return -1;
 		} else if (exception != 0) {
 			/* raise exception */
+			struct siginfo siginfo;
+
+			clear_siginfo(&siginfo);
 			siginfo.si_signo = SIGFPE;
 			siginfo.si_errno = 0;
 			siginfo.si_code = FPE_FIXME;	/* default code */
@@ -420,7 +426,7 @@ ia64_illegal_op_fault (unsigned long ec, long arg1, long arg2, long arg3,
 	if (die_if_kernel(buf, &regs, 0))
 		return rv;
 
-	memset(&si, 0, sizeof(si));
+	clear_siginfo(&si);
 	si.si_signo = SIGILL;
 	si.si_code = ILL_ILLOPC;
 	si.si_addr = (void __user *) (regs.cr_iip + ia64_psr(&regs)->ri);
@@ -434,7 +440,6 @@ ia64_fault (unsigned long vector, unsigned long isr, unsigned long ifa,
 	    long arg7, struct pt_regs regs)
 {
 	unsigned long code, error = isr, iip;
-	struct siginfo siginfo;
 	char buf[128];
 	int result, sig;
 	static const char *reason[] = {
@@ -485,6 +490,7 @@ ia64_fault (unsigned long vector, unsigned long isr, unsigned long ifa,
 
 	      case 26: /* NaT Consumption */
 		if (user_mode(&regs)) {
+			struct siginfo siginfo;
 			void __user *addr;
 
 			if (((isr >> 4) & 0xf) == 2) {
@@ -499,6 +505,7 @@ ia64_fault (unsigned long vector, unsigned long isr, unsigned long ifa,
 				addr = (void __user *) (regs.cr_iip
 							+ ia64_psr(&regs)->ri);
 			}
+			clear_siginfo(&siginfo);
 			siginfo.si_signo = sig;
 			siginfo.si_code = code;
 			siginfo.si_errno = 0;
@@ -515,6 +522,9 @@ ia64_fault (unsigned long vector, unsigned long isr, unsigned long ifa,
 
 	      case 31: /* Unsupported Data Reference */
 		if (user_mode(&regs)) {
+			struct siginfo siginfo;
+
+			clear_siginfo(&siginfo);
 			siginfo.si_signo = SIGILL;
 			siginfo.si_code = ILL_ILLOPN;
 			siginfo.si_errno = 0;
@@ -531,6 +541,10 @@ ia64_fault (unsigned long vector, unsigned long isr, unsigned long ifa,
 	      case 29: /* Debug */
 	      case 35: /* Taken Branch Trap */
 	      case 36: /* Single Step Trap */
+	      {
+		struct siginfo siginfo;
+
+		clear_siginfo(&siginfo);
 		if (fsys_mode(current, &regs)) {
 			extern char __kernel_syscall_via_break[];
 			/*
@@ -578,11 +592,15 @@ ia64_fault (unsigned long vector, unsigned long isr, unsigned long ifa,
 		siginfo.si_isr   = isr;
 		force_sig_info(SIGTRAP, &siginfo, current);
 		return;
+	      }
 
 	      case 32: /* fp fault */
 	      case 33: /* fp trap */
 		result = handle_fpu_swa((vector == 32) ? 1 : 0, &regs, isr);
 		if ((result < 0) || (current->thread.flags & IA64_THREAD_FPEMU_SIGFPE)) {
+			struct siginfo siginfo;
+
+			clear_siginfo(&siginfo);
 			siginfo.si_signo = SIGFPE;
 			siginfo.si_errno = 0;
 			siginfo.si_code = FPE_FLTINV;
@@ -616,6 +634,9 @@ ia64_fault (unsigned long vector, unsigned long isr, unsigned long ifa,
 		} else {
 			/* Unimplemented Instr. Address Trap */
 			if (user_mode(&regs)) {
+				struct siginfo siginfo;
+
+				clear_siginfo(&siginfo);
 				siginfo.si_signo = SIGILL;
 				siginfo.si_code = ILL_BADIADDR;
 				siginfo.si_errno = 0;
diff --git a/arch/ia64/kernel/unaligned.c b/arch/ia64/kernel/unaligned.c
index 72e9b4242564..e309f9859acc 100644
--- a/arch/ia64/kernel/unaligned.c
+++ b/arch/ia64/kernel/unaligned.c
@@ -1537,6 +1537,7 @@ ia64_handle_unaligned (unsigned long ifa, struct pt_regs *regs)
 		/* NOT_REACHED */
 	}
   force_sigbus:
+	clear_siginfo(&si);
 	si.si_signo = SIGBUS;
 	si.si_errno = 0;
 	si.si_code = BUS_ADRALN;
diff --git a/arch/ia64/mm/fault.c b/arch/ia64/mm/fault.c
index dfdc152d6737..817fa120645f 100644
--- a/arch/ia64/mm/fault.c
+++ b/arch/ia64/mm/fault.c
@@ -85,7 +85,6 @@ ia64_do_page_fault (unsigned long address, unsigned long isr, struct pt_regs *re
 	int signal = SIGSEGV, code = SEGV_MAPERR;
 	struct vm_area_struct *vma, *prev_vma;
 	struct mm_struct *mm = current->mm;
-	struct siginfo si;
 	unsigned long mask;
 	int fault;
 	unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
@@ -249,6 +248,9 @@ ia64_do_page_fault (unsigned long address, unsigned long isr, struct pt_regs *re
 		return;
 	}
 	if (user_mode(regs)) {
+		struct siginfo si;
+
+		clear_siginfo(&si);
 		si.si_signo = signal;
 		si.si_errno = 0;
 		si.si_code = code;
diff --git a/arch/m68k/kernel/traps.c b/arch/m68k/kernel/traps.c
index c1cc4e99aa94..0a00b476236d 100644
--- a/arch/m68k/kernel/traps.c
+++ b/arch/m68k/kernel/traps.c
@@ -1011,6 +1011,7 @@ asmlinkage void trap_c(struct frame *fp)
 	int vector = (fp->ptregs.vector >> 2) & 0xff;
 	siginfo_t info;
 
+	clear_siginfo(&info);
 	if (fp->ptregs.sr & PS_S) {
 		if (vector == VEC_TRACE) {
 			/* traced a trapping instruction on a 68020/30,
@@ -1163,6 +1164,7 @@ asmlinkage void fpemu_signal(int signal, int code, void *addr)
 {
 	siginfo_t info;
 
+	clear_siginfo(&info);
 	info.si_signo = signal;
 	info.si_errno = 0;
 	info.si_code = code;
diff --git a/arch/microblaze/kernel/exceptions.c b/arch/microblaze/kernel/exceptions.c
index e6f338d0496b..443ec1feacb4 100644
--- a/arch/microblaze/kernel/exceptions.c
+++ b/arch/microblaze/kernel/exceptions.c
@@ -65,6 +65,7 @@ void _exception(int signr, struct pt_regs *regs, int code, unsigned long addr)
 	if (kernel_mode(regs))
 		die("Exception in kernel mode", regs, signr);
 
+	clear_siginfo(&info);
 	info.si_signo = signr;
 	info.si_errno = 0;
 	info.si_code = code;
diff --git a/arch/microblaze/mm/fault.c b/arch/microblaze/mm/fault.c
index f91b30f8aaa8..43d92167012a 100644
--- a/arch/microblaze/mm/fault.c
+++ b/arch/microblaze/mm/fault.c
@@ -88,7 +88,6 @@ void do_page_fault(struct pt_regs *regs, unsigned long address,
 {
 	struct vm_area_struct *vma;
 	struct mm_struct *mm = current->mm;
-	siginfo_t info;
 	int code = SEGV_MAPERR;
 	int is_write = error_code & ESR_S;
 	int fault;
@@ -295,6 +294,9 @@ void do_page_fault(struct pt_regs *regs, unsigned long address,
 do_sigbus:
 	up_read(&mm->mmap_sem);
 	if (user_mode(regs)) {
+		siginfo_t info;
+
+		clear_siginfo(&info);
 		info.si_signo = SIGBUS;
 		info.si_errno = 0;
 		info.si_code = BUS_ADRERR;
diff --git a/arch/mips/mm/fault.c b/arch/mips/mm/fault.c
index 4f8f5bf46977..75392becd933 100644
--- a/arch/mips/mm/fault.c
+++ b/arch/mips/mm/fault.c
@@ -63,6 +63,7 @@ static void __kprobes __do_page_fault(struct pt_regs *regs, unsigned long write,
 		return;
 #endif
 
+	clear_siginfo(&info);
 	info.si_code = SEGV_MAPERR;
 
 	/*
diff --git a/arch/nds32/kernel/traps.c b/arch/nds32/kernel/traps.c
index 8e9a5b1f6234..46911768f4b5 100644
--- a/arch/nds32/kernel/traps.c
+++ b/arch/nds32/kernel/traps.c
@@ -229,6 +229,7 @@ int bad_syscall(int n, struct pt_regs *regs)
 		return regs->uregs[0];
 	}
 
+	clear_siginfo(&info);
 	info.si_signo = SIGILL;
 	info.si_errno = 0;
 	info.si_code = ILL_ILLTRP;
@@ -292,7 +293,7 @@ void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs,
 	tsk->thread.trap_no = ENTRY_DEBUG_RELATED;
 	tsk->thread.error_code = error_code;
 
-	memset(&info, 0, sizeof(info));
+	clear_siginfo(&info);
 	info.si_signo = SIGTRAP;
 	info.si_code = si_code;
 	info.si_addr = (void __user *)instruction_pointer(regs);
diff --git a/arch/nds32/mm/fault.c b/arch/nds32/mm/fault.c
index 3a246fb8098c..876ee01ff80a 100644
--- a/arch/nds32/mm/fault.c
+++ b/arch/nds32/mm/fault.c
@@ -77,6 +77,7 @@ void do_page_fault(unsigned long entry, unsigned long addr,
 	unsigned int mask = VM_READ | VM_WRITE | VM_EXEC;
 	unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
 
+	clear_siginfo(&info);
 	error_code = error_code & (ITYPE_mskINST | ITYPE_mskETYPE);
 	tsk = current;
 	mm = tsk->mm;
diff --git a/arch/nios2/kernel/traps.c b/arch/nios2/kernel/traps.c
index 8184e7d6b385..a69861d3e1a3 100644
--- a/arch/nios2/kernel/traps.c
+++ b/arch/nios2/kernel/traps.c
@@ -28,6 +28,7 @@ static void _send_sig(int signo, int code, unsigned long addr)
 {
 	siginfo_t info;
 
+	clear_siginfo(&info);
 	info.si_signo = signo;
 	info.si_errno = 0;
 	info.si_code = code;
diff --git a/arch/openrisc/kernel/traps.c b/arch/openrisc/kernel/traps.c
index 113c175fe469..1610b1d65a11 100644
--- a/arch/openrisc/kernel/traps.c
+++ b/arch/openrisc/kernel/traps.c
@@ -251,7 +251,7 @@ void __init trap_init(void)
 asmlinkage void do_trap(struct pt_regs *regs, unsigned long address)
 {
 	siginfo_t info;
-	memset(&info, 0, sizeof(info));
+	clear_siginfo(&info);
 	info.si_signo = SIGTRAP;
 	info.si_code = TRAP_TRACE;
 	info.si_addr = (void *)address;
@@ -266,6 +266,7 @@ asmlinkage void do_unaligned_access(struct pt_regs *regs, unsigned long address)
 
 	if (user_mode(regs)) {
 		/* Send a SIGBUS */
+		clear_siginfo(&info);
 		info.si_signo = SIGBUS;
 		info.si_errno = 0;
 		info.si_code = BUS_ADRALN;
@@ -285,6 +286,7 @@ asmlinkage void do_bus_fault(struct pt_regs *regs, unsigned long address)
 
 	if (user_mode(regs)) {
 		/* Send a SIGBUS */
+		clear_siginfo(&info);
 		info.si_signo = SIGBUS;
 		info.si_errno = 0;
 		info.si_code = BUS_ADRERR;
@@ -485,6 +487,7 @@ asmlinkage void do_illegal_instruction(struct pt_regs *regs,
 
 	if (user_mode(regs)) {
 		/* Send a SIGILL */
+		clear_siginfo(&info);
 		info.si_signo = SIGILL;
 		info.si_errno = 0;
 		info.si_code = ILL_ILLOPC;
diff --git a/arch/openrisc/mm/fault.c b/arch/openrisc/mm/fault.c
index d0021dfae20a..68be33e4ae17 100644
--- a/arch/openrisc/mm/fault.c
+++ b/arch/openrisc/mm/fault.c
@@ -56,6 +56,7 @@ asmlinkage void do_page_fault(struct pt_regs *regs, unsigned long address,
 	int fault;
 	unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
 
+	clear_siginfo(&info);
 	tsk = current;
 
 	/*
diff --git a/arch/parisc/kernel/ptrace.c b/arch/parisc/kernel/ptrace.c
index 1a2be6e639b5..b1c12ceb1c88 100644
--- a/arch/parisc/kernel/ptrace.c
+++ b/arch/parisc/kernel/ptrace.c
@@ -90,6 +90,7 @@ void user_enable_single_step(struct task_struct *task)
 		ptrace_disable(task);
 		/* Don't wake up the task, but let the
 		   parent know something happened. */
+		clear_siginfo(&si);
 		si.si_code = TRAP_TRACE;
 		si.si_addr = (void __user *) (task_regs(task)->iaoq[0] & ~3);
 		si.si_signo = SIGTRAP;
diff --git a/arch/parisc/kernel/traps.c b/arch/parisc/kernel/traps.c
index 68e671a11987..98f9f2f85940 100644
--- a/arch/parisc/kernel/traps.c
+++ b/arch/parisc/kernel/traps.c
@@ -299,6 +299,7 @@ static void handle_gdb_break(struct pt_regs *regs, int wot)
 {
 	struct siginfo si;
 
+	clear_siginfo(&si);
 	si.si_signo = SIGTRAP;
 	si.si_errno = 0;
 	si.si_code = wot;
@@ -489,6 +490,7 @@ void notrace handle_interruption(int code, struct pt_regs *regs)
 	unsigned long fault_space = 0;
 	struct siginfo si;
 
+	clear_siginfo(&si);
 	if (code == 1)
 	    pdc_console_restart();  /* switch back to pdc if HPMC */
 	else
diff --git a/arch/parisc/kernel/unaligned.c b/arch/parisc/kernel/unaligned.c
index e36f7b75ab07..30b7c7f6c471 100644
--- a/arch/parisc/kernel/unaligned.c
+++ b/arch/parisc/kernel/unaligned.c
@@ -455,6 +455,7 @@ void handle_unaligned(struct pt_regs *regs)
 	struct siginfo si;
 	register int flop=0;	/* true if this is a flop */
 
+	clear_siginfo(&si);
 	__inc_irq_stat(irq_unaligned_count);
 
 	/* log a message with pacing */
diff --git a/arch/parisc/math-emu/driver.c b/arch/parisc/math-emu/driver.c
index 2fb59d2e2b29..0d10efb53361 100644
--- a/arch/parisc/math-emu/driver.c
+++ b/arch/parisc/math-emu/driver.c
@@ -93,6 +93,7 @@ handle_fpe(struct pt_regs *regs)
 	 */
 	__u64 frcopy[36];
 
+	clear_siginfo(&si);
 	memcpy(frcopy, regs->fr, sizeof regs->fr);
 	frcopy[32] = 0;
 
diff --git a/arch/parisc/mm/fault.c b/arch/parisc/mm/fault.c
index e247edbca68e..657b35096bd8 100644
--- a/arch/parisc/mm/fault.c
+++ b/arch/parisc/mm/fault.c
@@ -356,6 +356,7 @@ void do_page_fault(struct pt_regs *regs, unsigned long code,
 		struct siginfo si;
 		unsigned int lsb = 0;
 
+		clear_siginfo(&si);
 		switch (code) {
 		case 15:	/* Data TLB miss fault/Data page fault */
 			/* send SIGSEGV when outside of vma */
diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index 1237f13fed51..26ea9793d290 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -632,6 +632,7 @@ void do_break (struct pt_regs *regs, unsigned long address,
 	hw_breakpoint_disable();
 
 	/* Deliver the signal to userspace */
+	clear_siginfo(&info);
 	info.si_signo = SIGTRAP;
 	info.si_errno = 0;
 	info.si_code = TRAP_HWBKPT;
diff --git a/arch/powerpc/kernel/traps.c b/arch/powerpc/kernel/traps.c
index 0904492e7032..087855caf6a9 100644
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -296,7 +296,6 @@ NOKPROBE_SYMBOL(die);
 void user_single_step_siginfo(struct task_struct *tsk,
 				struct pt_regs *regs, siginfo_t *info)
 {
-	memset(info, 0, sizeof(*info));
 	info->si_signo = SIGTRAP;
 	info->si_code = TRAP_TRACE;
 	info->si_addr = (void __user *)regs->nip;
@@ -334,7 +333,7 @@ void _exception_pkey(int signr, struct pt_regs *regs, int code,
 	 */
 	thread_pkey_regs_save(&current->thread);
 
-	memset(&info, 0, sizeof(info));
+	clear_siginfo(&info);
 	info.si_signo = signr;
 	info.si_code = code;
 	info.si_addr = (void __user *) addr;
diff --git a/arch/powerpc/mm/fault.c b/arch/powerpc/mm/fault.c
index c01d627e687a..ef268d5d9db7 100644
--- a/arch/powerpc/mm/fault.c
+++ b/arch/powerpc/mm/fault.c
@@ -168,6 +168,7 @@ static int do_sigbus(struct pt_regs *regs, unsigned long address,
 		return SIGBUS;
 
 	current->thread.trap_nr = BUS_ADRERR;
+	clear_siginfo(&info);
 	info.si_signo = SIGBUS;
 	info.si_errno = 0;
 	info.si_code = BUS_ADRERR;
diff --git a/arch/powerpc/platforms/cell/spufs/fault.c b/arch/powerpc/platforms/cell/spufs/fault.c
index 870c0a82d560..1e002e94d0f6 100644
--- a/arch/powerpc/platforms/cell/spufs/fault.c
+++ b/arch/powerpc/platforms/cell/spufs/fault.c
@@ -44,7 +44,7 @@ static void spufs_handle_event(struct spu_context *ctx,
 		return;
 	}
 
-	memset(&info, 0, sizeof(info));
+	clear_siginfo(&info);
 
 	switch (type) {
 	case SPE_EVENT_INVALID_DMA:
diff --git a/arch/riscv/kernel/traps.c b/arch/riscv/kernel/traps.c
index 93132cb59184..48aa6471cede 100644
--- a/arch/riscv/kernel/traps.c
+++ b/arch/riscv/kernel/traps.c
@@ -68,6 +68,7 @@ static inline void do_trap_siginfo(int signo, int code,
 {
 	siginfo_t info;
 
+	clear_siginfo(&info);
 	info.si_signo = signo;
 	info.si_errno = 0;
 	info.si_code = code;
diff --git a/arch/s390/kernel/traps.c b/arch/s390/kernel/traps.c
index a5297a22bc1e..3ba649d8aa5a 100644
--- a/arch/s390/kernel/traps.c
+++ b/arch/s390/kernel/traps.c
@@ -47,6 +47,7 @@ void do_report_trap(struct pt_regs *regs, int si_signo, int si_code, char *str)
 	siginfo_t info;
 
 	if (user_mode(regs)) {
+		clear_siginfo(&info);
 		info.si_signo = si_signo;
 		info.si_errno = 0;
 		info.si_code = si_code;
@@ -86,6 +87,7 @@ void do_per_trap(struct pt_regs *regs)
 		return;
 	if (!current->ptrace)
 		return;
+	clear_siginfo(&info);
 	info.si_signo = SIGTRAP;
 	info.si_errno = 0;
 	info.si_code = TRAP_HWBKPT;
@@ -165,7 +167,6 @@ void translation_exception(struct pt_regs *regs)
 
 void illegal_op(struct pt_regs *regs)
 {
-	siginfo_t info;
         __u8 opcode[6];
 	__u16 __user *location;
 	int is_uprobe_insn = 0;
@@ -178,6 +179,8 @@ void illegal_op(struct pt_regs *regs)
 			return;
 		if (*((__u16 *) opcode) == S390_BREAKPOINT_U16) {
 			if (current->ptrace) {
+				siginfo_t info;
+				clear_siginfo(&info);
 				info.si_signo = SIGTRAP;
 				info.si_errno = 0;
 				info.si_code = TRAP_BRKPT;
diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index 93faeca52284..b3ff0e8e5860 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -268,6 +268,7 @@ static noinline void do_sigsegv(struct pt_regs *regs, int si_code)
 	struct siginfo si;
 
 	report_user_fault(regs, SIGSEGV, 1);
+	clear_siginfo(&si);
 	si.si_signo = SIGSEGV;
 	si.si_errno = 0;
 	si.si_code = si_code;
@@ -323,6 +324,7 @@ static noinline void do_sigbus(struct pt_regs *regs)
 	 * Send a sigbus, regardless of whether we were in kernel
 	 * or user mode.
 	 */
+	clear_siginfo(&si);
 	si.si_signo = SIGBUS;
 	si.si_errno = 0;
 	si.si_code = BUS_ADRERR;
diff --git a/arch/sh/kernel/traps_32.c b/arch/sh/kernel/traps_32.c
index b3770bb26211..e85e59c3d6df 100644
--- a/arch/sh/kernel/traps_32.c
+++ b/arch/sh/kernel/traps_32.c
@@ -537,6 +537,7 @@ asmlinkage void do_address_error(struct pt_regs *regs,
 		       "access (PC %lx PR %lx)\n", current->comm, regs->pc,
 		       regs->pr);
 
+		clear_siginfo(&info);
 		info.si_signo = SIGBUS;
 		info.si_errno = 0;
 		info.si_code = si_code;
@@ -600,6 +601,7 @@ asmlinkage void do_divide_error(unsigned long r4)
 {
 	siginfo_t info;
 
+	clear_siginfo(&info);
 	switch (r4) {
 	case TRAP_DIVZERO_ERROR:
 		info.si_code = FPE_INTDIV;
diff --git a/arch/sh/math-emu/math.c b/arch/sh/math-emu/math.c
index c86f4360c6ce..d6d2213df078 100644
--- a/arch/sh/math-emu/math.c
+++ b/arch/sh/math-emu/math.c
@@ -560,6 +560,7 @@ static int ieee_fpe_handler(struct pt_regs *regs)
 				~(FPSCR_CAUSE_MASK | FPSCR_FLAG_MASK);
 			task_thread_info(tsk)->status |= TS_USEDFPU;
 		} else {
+			clear_siginfo(&info);
 			info.si_signo = SIGFPE;
 			info.si_errno = 0;
 			info.si_code = FPE_FLTINV;
diff --git a/arch/sh/mm/fault.c b/arch/sh/mm/fault.c
index 6fd1bf7481c7..4c98b6f20e02 100644
--- a/arch/sh/mm/fault.c
+++ b/arch/sh/mm/fault.c
@@ -44,6 +44,7 @@ force_sig_info_fault(int si_signo, int si_code, unsigned long address,
 {
 	siginfo_t info;
 
+	clear_siginfo(&info);
 	info.si_signo	= si_signo;
 	info.si_errno	= 0;
 	info.si_code	= si_code;
diff --git a/arch/sparc/kernel/process_64.c b/arch/sparc/kernel/process_64.c
index 454a8af28f13..2219e55206b4 100644
--- a/arch/sparc/kernel/process_64.c
+++ b/arch/sparc/kernel/process_64.c
@@ -520,6 +520,7 @@ static void stack_unaligned(unsigned long sp)
 {
 	siginfo_t info;
 
+	clear_siginfo(&info);
 	info.si_signo = SIGBUS;
 	info.si_errno = 0;
 	info.si_code = BUS_ADRALN;
diff --git a/arch/sparc/kernel/sys_sparc_32.c b/arch/sparc/kernel/sys_sparc_32.c
index e8c3cb6b6d08..00f6353fe435 100644
--- a/arch/sparc/kernel/sys_sparc_32.c
+++ b/arch/sparc/kernel/sys_sparc_32.c
@@ -152,6 +152,7 @@ sparc_breakpoint (struct pt_regs *regs)
 #ifdef DEBUG_SPARC_BREAKPOINT
         printk ("TRAP: Entering kernel PC=%x, nPC=%x\n", regs->pc, regs->npc);
 #endif
+	clear_siginfo(&info);
 	info.si_signo = SIGTRAP;
 	info.si_errno = 0;
 	info.si_code = TRAP_BRKPT;
diff --git a/arch/sparc/kernel/traps_32.c b/arch/sparc/kernel/traps_32.c
index 33cd35bf3dc8..03e522274b8b 100644
--- a/arch/sparc/kernel/traps_32.c
+++ b/arch/sparc/kernel/traps_32.c
@@ -104,6 +104,7 @@ void do_hw_interrupt(struct pt_regs *regs, unsigned long type)
 	if(regs->psr & PSR_PS)
 		die_if_kernel("Kernel bad trap", regs);
 
+	clear_siginfo(&info);
 	info.si_signo = SIGILL;
 	info.si_errno = 0;
 	info.si_code = ILL_ILLTRP;
@@ -124,6 +125,7 @@ void do_illegal_instruction(struct pt_regs *regs, unsigned long pc, unsigned lon
 	       regs->pc, *(unsigned long *)regs->pc);
 #endif
 
+	clear_siginfo(&info);
 	info.si_signo = SIGILL;
 	info.si_errno = 0;
 	info.si_code = ILL_ILLOPC;
@@ -139,6 +141,7 @@ void do_priv_instruction(struct pt_regs *regs, unsigned long pc, unsigned long n
 
 	if(psr & PSR_PS)
 		die_if_kernel("Penguin instruction from Penguin mode??!?!", regs);
+	clear_siginfo(&info);
 	info.si_signo = SIGILL;
 	info.si_errno = 0;
 	info.si_code = ILL_PRVOPC;
@@ -165,6 +168,7 @@ void do_memaccess_unaligned(struct pt_regs *regs, unsigned long pc, unsigned lon
 	instruction_dump ((unsigned long *) regs->pc);
 	printk ("do_MNA!\n");
 #endif
+	clear_siginfo(&info);
 	info.si_signo = SIGBUS;
 	info.si_errno = 0;
 	info.si_code = BUS_ADRALN;
@@ -303,6 +307,7 @@ void do_fpe_trap(struct pt_regs *regs, unsigned long pc, unsigned long npc,
 	}
 
 	fsr = fpt->thread.fsr;
+	clear_siginfo(&info);
 	info.si_signo = SIGFPE;
 	info.si_errno = 0;
 	info.si_addr = (void __user *)pc;
@@ -336,6 +341,7 @@ void handle_tag_overflow(struct pt_regs *regs, unsigned long pc, unsigned long n
 
 	if(psr & PSR_PS)
 		die_if_kernel("Penguin overflow trap from kernel mode", regs);
+	clear_siginfo(&info);
 	info.si_signo = SIGEMT;
 	info.si_errno = 0;
 	info.si_code = EMT_TAGOVF;
@@ -365,6 +371,7 @@ void handle_reg_access(struct pt_regs *regs, unsigned long pc, unsigned long npc
 	printk("Register Access Exception at PC %08lx NPC %08lx PSR %08lx\n",
 	       pc, npc, psr);
 #endif
+	clear_siginfo(&info);
 	info.si_signo = SIGBUS;
 	info.si_errno = 0;
 	info.si_code = BUS_OBJERR;
@@ -378,6 +385,7 @@ void handle_cp_disabled(struct pt_regs *regs, unsigned long pc, unsigned long np
 {
 	siginfo_t info;
 
+	clear_siginfo(&info);
 	info.si_signo = SIGILL;
 	info.si_errno = 0;
 	info.si_code = ILL_COPROC;
@@ -395,6 +403,7 @@ void handle_cp_exception(struct pt_regs *regs, unsigned long pc, unsigned long n
 	printk("Co-Processor Exception at PC %08lx NPC %08lx PSR %08lx\n",
 	       pc, npc, psr);
 #endif
+	clear_siginfo(&info);
 	info.si_signo = SIGILL;
 	info.si_errno = 0;
 	info.si_code = ILL_COPROC;
@@ -408,6 +417,7 @@ void handle_hw_divzero(struct pt_regs *regs, unsigned long pc, unsigned long npc
 {
 	siginfo_t info;
 
+	clear_siginfo(&info);
 	info.si_signo = SIGFPE;
 	info.si_errno = 0;
 	info.si_code = FPE_INTDIV;
diff --git a/arch/sparc/kernel/traps_64.c b/arch/sparc/kernel/traps_64.c
index e81072ac52c3..b485b49b87a8 100644
--- a/arch/sparc/kernel/traps_64.c
+++ b/arch/sparc/kernel/traps_64.c
@@ -107,6 +107,7 @@ void bad_trap(struct pt_regs *regs, long lvl)
 		regs->tpc &= 0xffffffff;
 		regs->tnpc &= 0xffffffff;
 	}
+	clear_siginfo(&info);
 	info.si_signo = SIGILL;
 	info.si_errno = 0;
 	info.si_code = ILL_ILLTRP;
@@ -206,6 +207,7 @@ void spitfire_insn_access_exception(struct pt_regs *regs, unsigned long sfsr, un
 		regs->tpc &= 0xffffffff;
 		regs->tnpc &= 0xffffffff;
 	}
+	clear_siginfo(&info);
 	info.si_signo = SIGSEGV;
 	info.si_errno = 0;
 	info.si_code = SEGV_MAPERR;
@@ -247,6 +249,7 @@ void sun4v_insn_access_exception(struct pt_regs *regs, unsigned long addr, unsig
 		regs->tpc &= 0xffffffff;
 		regs->tnpc &= 0xffffffff;
 	}
+	clear_siginfo(&info);
 	info.si_signo = SIGSEGV;
 	info.si_errno = 0;
 	info.si_code = SEGV_MAPERR;
@@ -338,6 +341,7 @@ void spitfire_data_access_exception(struct pt_regs *regs, unsigned long sfsr, un
 	if (is_no_fault_exception(regs))
 		return;
 
+	clear_siginfo(&info);
 	info.si_signo = SIGSEGV;
 	info.si_errno = 0;
 	info.si_code = SEGV_MAPERR;
@@ -595,6 +599,7 @@ static void spitfire_ue_log(unsigned long afsr, unsigned long afar, unsigned lon
 		regs->tpc &= 0xffffffff;
 		regs->tnpc &= 0xffffffff;
 	}
+	clear_siginfo(&info);
 	info.si_signo = SIGBUS;
 	info.si_errno = 0;
 	info.si_code = BUS_OBJERR;
@@ -2211,6 +2216,7 @@ bool sun4v_nonresum_error_user_handled(struct pt_regs *regs,
 				addr += PAGE_SIZE;
 			}
 		}
+		clear_siginfo(&info);
 		info.si_signo = SIGKILL;
 		info.si_errno = 0;
 		info.si_trapno = 0;
@@ -2221,6 +2227,7 @@ bool sun4v_nonresum_error_user_handled(struct pt_regs *regs,
 	if (attrs & SUN4V_ERR_ATTRS_PIO) {
 		siginfo_t info;
 
+		clear_siginfo(&info);
 		info.si_signo = SIGBUS;
 		info.si_code = BUS_ADRERR;
 		info.si_addr = (void __user *)sun4v_get_vaddr(regs);
@@ -2368,6 +2375,7 @@ static void do_fpe_common(struct pt_regs *regs)
 			regs->tpc &= 0xffffffff;
 			regs->tnpc &= 0xffffffff;
 		}
+		clear_siginfo(&info);
 		info.si_signo = SIGFPE;
 		info.si_errno = 0;
 		info.si_addr = (void __user *)regs->tpc;
@@ -2440,6 +2448,7 @@ void do_tof(struct pt_regs *regs)
 		regs->tpc &= 0xffffffff;
 		regs->tnpc &= 0xffffffff;
 	}
+	clear_siginfo(&info);
 	info.si_signo = SIGEMT;
 	info.si_errno = 0;
 	info.si_code = EMT_TAGOVF;
@@ -2465,6 +2474,7 @@ void do_div0(struct pt_regs *regs)
 		regs->tpc &= 0xffffffff;
 		regs->tnpc &= 0xffffffff;
 	}
+	clear_siginfo(&info);
 	info.si_signo = SIGFPE;
 	info.si_errno = 0;
 	info.si_code = FPE_INTDIV;
@@ -2666,6 +2676,7 @@ void do_illegal_instruction(struct pt_regs *regs)
 			}
 		}
 	}
+	clear_siginfo(&info);
 	info.si_signo = SIGILL;
 	info.si_errno = 0;
 	info.si_code = ILL_ILLOPC;
@@ -2692,6 +2703,7 @@ void mem_address_unaligned(struct pt_regs *regs, unsigned long sfar, unsigned lo
 	if (is_no_fault_exception(regs))
 		return;
 
+	clear_siginfo(&info);
 	info.si_signo = SIGBUS;
 	info.si_errno = 0;
 	info.si_code = BUS_ADRALN;
@@ -2717,6 +2729,7 @@ void sun4v_do_mna(struct pt_regs *regs, unsigned long addr, unsigned long type_c
 	if (is_no_fault_exception(regs))
 		return;
 
+	clear_siginfo(&info);
 	info.si_signo = SIGBUS;
 	info.si_errno = 0;
 	info.si_code = BUS_ADRALN;
@@ -2785,6 +2798,7 @@ void do_privop(struct pt_regs *regs)
 		regs->tpc &= 0xffffffff;
 		regs->tnpc &= 0xffffffff;
 	}
+	clear_siginfo(&info);
 	info.si_signo = SIGILL;
 	info.si_errno = 0;
 	info.si_code = ILL_PRVOPC;
diff --git a/arch/sparc/kernel/unaligned_32.c b/arch/sparc/kernel/unaligned_32.c
index 7642d7e4f0d9..0e4cf7217413 100644
--- a/arch/sparc/kernel/unaligned_32.c
+++ b/arch/sparc/kernel/unaligned_32.c
@@ -313,6 +313,7 @@ static void user_mna_trap_fault(struct pt_regs *regs, unsigned int insn)
 {
 	siginfo_t info;
 
+	clear_siginfo(&info);
 	info.si_signo = SIGBUS;
 	info.si_errno = 0;
 	info.si_code = BUS_ADRALN;
diff --git a/arch/sparc/mm/fault_32.c b/arch/sparc/mm/fault_32.c
index a8103a84b4ac..2deb586665b9 100644
--- a/arch/sparc/mm/fault_32.c
+++ b/arch/sparc/mm/fault_32.c
@@ -129,6 +129,7 @@ static void __do_fault_siginfo(int code, int sig, struct pt_regs *regs,
 {
 	siginfo_t info;
 
+	clear_siginfo(&info);
 	info.si_signo = sig;
 	info.si_code = code;
 	info.si_errno = 0;
diff --git a/arch/sparc/mm/fault_64.c b/arch/sparc/mm/fault_64.c
index 41363f46797b..46ccff95d10e 100644
--- a/arch/sparc/mm/fault_64.c
+++ b/arch/sparc/mm/fault_64.c
@@ -172,6 +172,7 @@ static void do_fault_siginfo(int code, int sig, struct pt_regs *regs,
 	unsigned long addr;
 	siginfo_t info;
 
+	clear_siginfo(&info);
 	info.si_code = code;
 	info.si_signo = sig;
 	info.si_errno = 0;
diff --git a/arch/um/kernel/trap.c b/arch/um/kernel/trap.c
index b2b02df9896e..d4d38520c4c6 100644
--- a/arch/um/kernel/trap.c
+++ b/arch/um/kernel/trap.c
@@ -164,6 +164,7 @@ static void bad_segv(struct faultinfo fi, unsigned long ip)
 {
 	struct siginfo si;
 
+	clear_siginfo(&si);
 	si.si_signo = SIGSEGV;
 	si.si_code = SEGV_ACCERR;
 	si.si_addr = (void __user *) FAULT_ADDRESS(fi);
@@ -220,6 +221,7 @@ unsigned long segv(struct faultinfo fi, unsigned long ip, int is_user,
 	int is_write = FAULT_WRITE(fi);
 	unsigned long address = FAULT_ADDRESS(fi);
 
+	clear_siginfo(&si);
 	if (!is_user && regs)
 		current->thread.segv_regs = container_of(regs, struct pt_regs, regs);
 
diff --git a/arch/unicore32/kernel/fpu-ucf64.c b/arch/unicore32/kernel/fpu-ucf64.c
index 12c8c9527b8e..d785955e1c29 100644
--- a/arch/unicore32/kernel/fpu-ucf64.c
+++ b/arch/unicore32/kernel/fpu-ucf64.c
@@ -56,7 +56,7 @@ void ucf64_raise_sigfpe(unsigned int sicode, struct pt_regs *regs)
 {
 	siginfo_t info;
 
-	memset(&info, 0, sizeof(info));
+	clear_siginfo(&info);
 
 	info.si_signo = SIGFPE;
 	info.si_code = sicode;
diff --git a/arch/unicore32/mm/fault.c b/arch/unicore32/mm/fault.c
index bbefcc46a45e..381473412937 100644
--- a/arch/unicore32/mm/fault.c
+++ b/arch/unicore32/mm/fault.c
@@ -125,6 +125,7 @@ static void __do_user_fault(struct task_struct *tsk, unsigned long addr,
 	tsk->thread.address = addr;
 	tsk->thread.error_code = fsr;
 	tsk->thread.trap_no = 14;
+	clear_siginfo(&si);
 	si.si_signo = sig;
 	si.si_errno = 0;
 	si.si_code = code;
@@ -472,6 +473,7 @@ asmlinkage void do_DataAbort(unsigned long addr, unsigned int fsr,
 	printk(KERN_ALERT "Unhandled fault: %s (0x%03x) at 0x%08lx\n",
 	       inf->name, fsr, addr);
 
+	clear_siginfo(&info);
 	info.si_signo = inf->sig;
 	info.si_errno = 0;
 	info.si_code = inf->code;
@@ -491,6 +493,7 @@ asmlinkage void do_PrefetchAbort(unsigned long addr,
 	printk(KERN_ALERT "Unhandled prefetch abort: %s (0x%03x) at 0x%08lx\n",
 	       inf->name, ifsr, addr);
 
+	clear_siginfo(&info);
 	info.si_signo = inf->sig;
 	info.si_errno = 0;
 	info.si_code = inf->code;
diff --git a/arch/x86/entry/vsyscall/vsyscall_64.c b/arch/x86/entry/vsyscall/vsyscall_64.c
index 70b7845434cb..7782cdbcd67d 100644
--- a/arch/x86/entry/vsyscall/vsyscall_64.c
+++ b/arch/x86/entry/vsyscall/vsyscall_64.c
@@ -107,7 +107,7 @@ static bool write_ok_or_segv(unsigned long ptr, size_t size)
 		thread->cr2		= ptr;
 		thread->trap_nr		= X86_TRAP_PF;
 
-		memset(&info, 0, sizeof(info));
+		clear_siginfo(&info);
 		info.si_signo		= SIGSEGV;
 		info.si_errno		= 0;
 		info.si_code		= SEGV_MAPERR;
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index ed5c4cdf0a34..e2ee403865eb 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -1377,7 +1377,6 @@ static void fill_sigtrap_info(struct task_struct *tsk,
 	tsk->thread.trap_nr = X86_TRAP_DB;
 	tsk->thread.error_code = error_code;
 
-	memset(info, 0, sizeof(*info));
 	info->si_signo = SIGTRAP;
 	info->si_code = si_code;
 	info->si_addr = user_mode(regs) ? (void __user *)regs->ip : NULL;
@@ -1395,6 +1394,7 @@ void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs,
 {
 	struct siginfo info;
 
+	clear_siginfo(&info);
 	fill_sigtrap_info(tsk, regs, error_code, si_code, &info);
 	/* Send us the fake SIGTRAP */
 	force_sig_info(SIGTRAP, &info, tsk);
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 03f3d7695dac..a535dd64de63 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -299,6 +299,7 @@ static void do_error_trap(struct pt_regs *regs, long error_code, char *str,
 	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, signr) !=
 			NOTIFY_STOP) {
 		cond_local_irq_enable(regs);
+		clear_siginfo(&info);
 		do_trap(trapnr, signr, str, regs, error_code,
 			fill_trap_info(regs, signr, trapnr, &info));
 	}
@@ -854,6 +855,7 @@ static void math_error(struct pt_regs *regs, int error_code, int trapnr)
 
 	task->thread.trap_nr	= trapnr;
 	task->thread.error_code = error_code;
+	clear_siginfo(&info);
 	info.si_signo		= SIGFPE;
 	info.si_errno		= 0;
 	info.si_addr		= (void __user *)uprobe_get_trap_addr(regs);
@@ -929,6 +931,7 @@ dotraplinkage void do_iret_error(struct pt_regs *regs, long error_code)
 	RCU_LOCKDEP_WARN(!rcu_is_watching(), "entry code didn't wake RCU");
 	local_irq_enable();
 
+	clear_siginfo(&info);
 	info.si_signo = SIGILL;
 	info.si_errno = 0;
 	info.si_code = ILL_BADSTK;
diff --git a/arch/x86/kernel/umip.c b/arch/x86/kernel/umip.c
index f44ce0fb3583..ff20b35e98dd 100644
--- a/arch/x86/kernel/umip.c
+++ b/arch/x86/kernel/umip.c
@@ -278,6 +278,7 @@ static void force_sig_info_umip_fault(void __user *addr, struct pt_regs *regs)
 	tsk->thread.error_code	= X86_PF_USER | X86_PF_WRITE;
 	tsk->thread.trap_nr	= X86_TRAP_PF;
 
+	clear_siginfo(&info);
 	info.si_signo	= SIGSEGV;
 	info.si_errno	= 0;
 	info.si_code	= SEGV_MAPERR;
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 8494dbae41b9..d634f0332c0f 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3007,6 +3007,7 @@ static void kvm_send_hwpoison_signal(unsigned long address, struct task_struct *
 {
 	siginfo_t info;
 
+	clear_siginfo(&info);
 	info.si_signo	= SIGBUS;
 	info.si_errno	= 0;
 	info.si_code	= BUS_MCEERR_AR;
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 73bd8c95ac71..2a5a2920203d 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -209,6 +209,7 @@ force_sig_info_fault(int si_signo, int si_code, unsigned long address,
 	unsigned lsb = 0;
 	siginfo_t info;
 
+	clear_siginfo(&info);
 	info.si_signo	= si_signo;
 	info.si_errno	= 0;
 	info.si_code	= si_code;
diff --git a/arch/xtensa/kernel/traps.c b/arch/xtensa/kernel/traps.c
index 32c5207f1226..51771929f341 100644
--- a/arch/xtensa/kernel/traps.c
+++ b/arch/xtensa/kernel/traps.c
@@ -334,6 +334,7 @@ do_unaligned_user (struct pt_regs *regs)
 			    "(pid = %d, pc = %#010lx)\n",
 			    regs->excvaddr, current->comm,
 			    task_pid_nr(current), regs->pc);
+	clear_siginfo(&info);
 	info.si_signo = SIGBUS;
 	info.si_errno = 0;
 	info.si_code = BUS_ADRALN;
diff --git a/arch/xtensa/mm/fault.c b/arch/xtensa/mm/fault.c
index 8b9b6f44bb06..f9323a3e61ce 100644
--- a/arch/xtensa/mm/fault.c
+++ b/arch/xtensa/mm/fault.c
@@ -45,6 +45,7 @@ void do_page_fault(struct pt_regs *regs)
 	int fault;
 	unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
 
+	clear_siginfo(&info);
 	info.si_code = SEGV_MAPERR;
 
 	/* We fault-in kernel-space virtual memory on-demand. The
diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index 919b2a0b0307..037bf0ef1ae9 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -345,7 +345,6 @@ extern void user_single_step_siginfo(struct task_struct *tsk,
 static inline void user_single_step_siginfo(struct task_struct *tsk,
 				struct pt_regs *regs, siginfo_t *info)
 {
-	memset(info, 0, sizeof(*info));
 	info->si_signo = SIGTRAP;
 }
 #endif
diff --git a/include/linux/tracehook.h b/include/linux/tracehook.h
index 26c152122a42..4a8841963c2e 100644
--- a/include/linux/tracehook.h
+++ b/include/linux/tracehook.h
@@ -124,6 +124,7 @@ static inline void tracehook_report_syscall_exit(struct pt_regs *regs, int step)
 {
 	if (step) {
 		siginfo_t info;
+		clear_siginfo(&info);
 		user_single_step_siginfo(current, regs, &info);
 		force_sig_info(SIGTRAP, &info, current);
 		return;
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 7f6a944db23d..8d90de213ce9 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1401,6 +1401,7 @@ static void kvm_send_hwpoison_signal(unsigned long address,
 {
 	siginfo_t info;
 
+	clear_siginfo(&info);
 	info.si_signo   = SIGBUS;
 	info.si_errno   = 0;
 	info.si_code    = BUS_MCEERR_AR;
-- 
2.14.1

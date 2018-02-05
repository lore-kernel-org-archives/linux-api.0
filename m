From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for 4.16 00/11] membarrier updates for 4.16
Date: Mon, 5 Feb 2018 22:21:32 +0100
Message-ID: <20180205212132.cbyqv25c2wouf4cp@gmail.com>
References: <20180129202020.8515-1-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180129202020.8515-1-mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Paul E . McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Maged Michael <maged.michael-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Avi Kivity <avi-VrcmuVmyx1hWk0Htik3J/w@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrea Parri <parri.andrea-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Russell King <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, Greg Hackmann <ghackmann-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, David
List-Id: linux-api@vger.kernel.org


Hi,

Find below the interdiff of the (minor) edits I've done to the series, before 
applying them to tip:sched/urgent.

I've also tidied up some of the changelogs.

Nothing earth-shattering.

Thanks,

	Ingo

=========>

 arch/powerpc/Kconfig      | 2 +-
 arch/x86/entry/entry_32.S | 2 +-
 arch/x86/entry/entry_64.S | 2 +-
 include/linux/sched/mm.h  | 6 +++---
 init/Kconfig              | 2 +-
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 09b02180b8a0..a2380de50878 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -140,7 +140,7 @@ config PPC
 	select ARCH_HAS_FORTIFY_SOURCE
 	select ARCH_HAS_GCOV_PROFILE_ALL
 	select ARCH_HAS_PMEM_API                if PPC64
-	select ARCH_HAS_MEMBARRIER_HOOKS
+	select ARCH_HAS_MEMBARRIER_CALLBACKS
 	select ARCH_HAS_SCALED_CPUTIME		if VIRT_CPU_ACCOUNTING_NATIVE
 	select ARCH_HAS_SG_CHAIN
 	select ARCH_HAS_TICK_BROADCAST		if GENERIC_CLOCKEVENTS_BROADCAST
diff --git a/arch/x86/entry/entry_32.S b/arch/x86/entry/entry_32.S
index d8ba23d0d77a..abee6d2b9311 100644
--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -567,7 +567,7 @@ ENTRY(entry_INT80_32)
 	RESTORE_REGS 4				# skip orig_eax/error_code
 .Lirq_return:
 	/*
-	 * ARCH_HAS_MEMBARRIER_SYNC_CORE rely on iret core serialization
+	 * ARCH_HAS_MEMBARRIER_SYNC_CORE rely on IRET core serialization
 	 * when returning from IPI handler and when returning from
 	 * scheduler to user-space.
 	 */
diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index 49852d9920da..5816858c8820 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -805,7 +805,7 @@ GLOBAL(restore_regs_and_return_to_kernel)
 	POP_C_REGS
 	addq	$8, %rsp	/* skip regs->orig_ax */
 	/*
-	 * ARCH_HAS_MEMBARRIER_SYNC_CORE rely on iret core serialization
+	 * ARCH_HAS_MEMBARRIER_SYNC_CORE rely on IRET core serialization
 	 * when returning from IPI handler.
 	 */
 	INTERRUPT_RETURN
diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
index a7840f0f8832..03a169087a18 100644
--- a/include/linux/sched/mm.h
+++ b/include/linux/sched/mm.h
@@ -41,7 +41,7 @@ extern void __mmdrop(struct mm_struct *);
 static inline void mmdrop(struct mm_struct *mm)
 {
 	/*
-	 * The implicit full barrier implied by atomic_dec_and_test is
+	 * The implicit full barrier implied by atomic_dec_and_test() is
 	 * required by the membarrier system call before returning to
 	 * user-space, after storing to rq->curr.
 	 */
@@ -232,7 +232,7 @@ enum {
 	MEMBARRIER_FLAG_SYNC_CORE	= (1U << 0),
 };
 
-#ifdef CONFIG_ARCH_HAS_MEMBARRIER_HOOKS
+#ifdef CONFIG_ARCH_HAS_MEMBARRIER_CALLBACKS
 #include <asm/membarrier.h>
 #endif
 
@@ -249,7 +249,7 @@ static inline void membarrier_execve(struct task_struct *t)
 	atomic_set(&t->mm->membarrier_state, 0);
 }
 #else
-#ifdef CONFIG_ARCH_HAS_MEMBARRIER_HOOKS
+#ifdef CONFIG_ARCH_HAS_MEMBARRIER_CALLBACKS
 static inline void membarrier_arch_switch_mm(struct mm_struct *prev,
 					     struct mm_struct *next,
 					     struct task_struct *tsk)
diff --git a/init/Kconfig b/init/Kconfig
index 30b65febeb23..e37f4b2a6445 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1412,7 +1412,7 @@ config USERFAULTFD
 	  Enable the userfaultfd() system call that allows to intercept and
 	  handle page faults in userland.
 
-config ARCH_HAS_MEMBARRIER_HOOKS
+config ARCH_HAS_MEMBARRIER_CALLBACKS
 	bool
 
 config ARCH_HAS_MEMBARRIER_SYNC_CORE

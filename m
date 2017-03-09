From: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: [PATCH v2 4/4] arm64/syscalls: Specific usage of
 verify_pre_usermode_state
Date: Thu, 9 Mar 2017 17:05:53 +0000
Message-ID: <20170309170553.GO21222@n2100.armlinux.org.uk>
References: <20170309012456.5631-1-thgarnie@google.com>
 <20170309012456.5631-4-thgarnie@google.com>
 <20170309122354.GB6320@leverpostej>
 <CAJcbSZGCFhUx79=bMkOxDRvbfuHmVBWU02HBgEU9T2s7mTChAw@mail.gmail.com>
 <20170309162613.GN21222@n2100.armlinux.org.uk>
 <CAJcbSZEBu1KnXc-aROvp+EbLpDSAcJV8PUCmNj05OCOtCfSqfA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-hardening-return-6977-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
Content-Disposition: inline
In-Reply-To: <CAJcbSZEBu1KnXc-aROvp+EbLpDSAcJV8PUCmNj05OCOtCfSqfA@mail.gmail.com>
Sender: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Thomas Garnier <thgarnie@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>, David Howells <dhowells@redhat.com>, Dave Hansen <dave.hansen@intel.com>, Arnd Bergmann <arnd@arndb.de>, Al Viro <viro@zeniv.linux.org.uk>, =?iso-8859-1?Q?Ren=E9?= Nyffenegger <mail@renenyffenegger.ch>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, "David S . Miller" <davem@davemloft.net>, Andy Lutomirski <luto@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Nicolas Pitre <nicolas.pitre@linaro.org>, Petr Mladek <pmladek@suse.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Helge Deller <deller@gmx.de>, Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>, John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Pavel
List-Id: linux-api@vger.kernel.org

On Thu, Mar 09, 2017 at 08:35:30AM -0800, Thomas Garnier wrote:
> On Thu, Mar 9, 2017 at 8:26 AM, Russell King - ARM Linux
> <linux@armlinux.org.uk> wrote:
> > I wouldn't call what you've done on ARM an "optimisation", because my
> > comment about making the fast path worthless still stands.
> 
> Why does it still stands on the latest proposal?

It's still having to needlessly save stuff when there's nothing wrong.
Remember, syscalls are a fast path, so the minimum we can do is good.
Calling into C functions is not ideal, because they will tend to be
_very_ expensive compared to hand crafted assembly, especially for
something like this.

It's possible to check the address limit in just three instructions,
which is way less than will be incurred by calling a C function.

Note: This patch is completely untested.

 arch/arm/kernel/entry-common.S | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
index eb5cd77bf1d8..6b43c6d73117 100644
--- a/arch/arm/kernel/entry-common.S
+++ b/arch/arm/kernel/entry-common.S
@@ -41,8 +41,11 @@
  UNWIND(.cantunwind	)
 	disable_irq_notrace			@ disable interrupts
 	ldr	r1, [tsk, #TI_FLAGS]		@ re-check for syscall tracing
+	ldr	r2, [tsk, #TI_ADDR_LIMIT]
 	tst	r1, #_TIF_SYSCALL_WORK | _TIF_WORK_MASK
 	bne	fast_work_pending
+	cmp	r2, #TASK_SIZE
+	blgt	addr_limit_fail
 
 	/* perform architecture specific actions before user return */
 	arch_ret_to_user r1, lr
@@ -67,6 +70,7 @@ ENDPROC(ret_fast_syscall)
 	str	r0, [sp, #S_R0 + S_OFF]!	@ save returned r0
 	disable_irq_notrace			@ disable interrupts
 	ldr	r1, [tsk, #TI_FLAGS]		@ re-check for syscall tracing
+	ldr	r2, [tsk, #TI_ADDR_LIMIT]
 	tst	r1, #_TIF_SYSCALL_WORK | _TIF_WORK_MASK
 	beq	no_work_pending
  UNWIND(.fnend		)
@@ -82,6 +86,7 @@ ENDPROC(ret_fast_syscall)
 	mov	r2, why				@ 'syscall'
 	bl	do_work_pending
 	cmp	r0, #0
+	ldreq	r2, [tsk, #TI_ADDR_LIMIT]
 	beq	no_work_pending
 	movlt	scno, #(__NR_restart_syscall - __NR_SYSCALL_BASE)
 	ldmia	sp, {r0 - r6}			@ have to reload r0 - r6
@@ -99,9 +104,12 @@ ENTRY(ret_to_user)
 	disable_irq_notrace			@ disable interrupts
 ENTRY(ret_to_user_from_irq)
 	ldr	r1, [tsk, #TI_FLAGS]
+	ldr	r2, [tsk, #TI_ADDR_LIMIT]
 	tst	r1, #_TIF_WORK_MASK
 	bne	slow_work_pending
 no_work_pending:
+	cmp	r2, #TASK_SIZE
+	blgt	addr_limit_fail
 	asm_trace_hardirqs_on save = 0
 
 	/* perform architecture specific actions before user return */
@@ -125,6 +133,16 @@ ENTRY(ret_from_fork)
 	b	ret_slow_syscall
 ENDPROC(ret_from_fork)
 
+addr_limit_fail:
+#ifdef CONFIG_BUG_ON_DATA_CORRUPTION
+	stmfd	sp!, {r0, lr}
+	bl	verify_pre_usermode_state
+	ldmfd	sp!, {r0, lr}
+#endif
+	mov	r2, #TASK_SIZE
+	str	r2, [tsk, #TI_ADDR_LIMIT]
+	ret	lr
+
 /*=============================================================================
  * SWI handler
  *-----------------------------------------------------------------------------


-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.

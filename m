From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH for 4.18 2/6] rseq: use get_user/put_user rather than
 __get_user/__put_user
Date: Mon, 9 Jul 2018 13:28:47 -0400 (EDT)
Message-ID: <854203778.2272.1531157327328.JavaMail.zimbra@efficios.com>
References: <20180708210330.27324-1-mathieu.desnoyers@efficios.com> <20180708210330.27324-3-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180708210330.27324-3-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael
List-Id: linux-api@vger.kernel.org

----- On Jul 8, 2018, at 5:03 PM, Mathieu Desnoyers mathieu.desnoyers@efficios.com wrote:

> In preparation to use __u64 for the rseq_cs pointer field, 32-bit
> architectures need to read this 64-bit value located in user-space
> addresses.
> 
> __get_user is used to read this value, given that its access check has
> already been performed with access_ok() on rseq registration.
> 
> arm does not implement 8-byte __get_user. Rather than trying to
> improve __get_user on ARM, use get_user/put_user across rseq instead.
> 
> If those end up showing up in benchmarks, the proper approach would be to
> use user_access_begin() / unsafe_get/put_user() / user_access_end()
> anyway.

So, another twist to this story: ppc32 does not implement u64 get_user().

I am tempted to ditch this patch (leaving the __get_user()/__put_user as is
for 32-bit accesses), and simply use __copy_from_user()/__copy_to_user() to
load/store the rseq_cs pointer. Considering that we don't need to load/store
the rseq_cs field with single-copy atomicity from the kernel anymore, it
should be fine.

Any objection ?

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/rseq/linux-rseq.git rseq/dev
head:   a100323919af0c11a150a9ba58c3f8ac986ea42d
commit: 23d0f99d280fa97ebcf8b915157468f457bc6e11 [4/21] rseq: uapi: declare rseq_cs field as union, update includes
config: powerpc-ppc6xx_defconfig (attached as .config)
compiler: powerpc-linux-gnu-gcc (Debian 7.2.0-11) 7.2.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        git checkout 23d0f99d280fa97ebcf8b915157468f457bc6e11
        # save the attached .config to linux build tree
        GCC_VERSION=7.2.0 make.cross ARCH=powerpc

All errors (new ones prefixed by >>):

   kernel/rseq.o: In function `__rseq_handle_notify_resume':
>> (.text+0x648): undefined reference to `__get_user_bad'

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

Thanks,

Mathieu

> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> CC: Thomas Gleixner <tglx@linutronix.de>
> Cc: Joel Fernandes <joelaf@google.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Dave Watson <davejwatson@fb.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Andi Kleen <andi@firstfloor.org>
> Cc: "H . Peter Anvin" <hpa@zytor.com>
> Cc: Chris Lameter <cl@linux.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Andrew Hunter <ahh@google.com>
> Cc: Michael Kerrisk <mtk.manpages@gmail.com>
> Cc: "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>
> Cc: Paul Turner <pjt@google.com>
> Cc: Boqun Feng <boqun.feng@gmail.com>
> Cc: Josh Triplett <josh@joshtriplett.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Ben Maurer <bmaurer@fb.com>
> Cc: linux-api@vger.kernel.org
> CC: linux-arm-kernel@lists.infradead.org
> Cc: Andy Lutomirski <luto@amacapital.net>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> ---
> kernel/rseq.c | 14 +++++++-------
> 1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/kernel/rseq.c b/kernel/rseq.c
> index 16b38c5342f9..2c8463acb50d 100644
> --- a/kernel/rseq.c
> +++ b/kernel/rseq.c
> @@ -85,9 +85,9 @@ static int rseq_update_cpu_id(struct task_struct *t)
> {
> 	u32 cpu_id = raw_smp_processor_id();
> 
> -	if (__put_user(cpu_id, &t->rseq->cpu_id_start))
> +	if (put_user(cpu_id, &t->rseq->cpu_id_start))
> 		return -EFAULT;
> -	if (__put_user(cpu_id, &t->rseq->cpu_id))
> +	if (put_user(cpu_id, &t->rseq->cpu_id))
> 		return -EFAULT;
> 	trace_rseq_update(t);
> 	return 0;
> @@ -100,14 +100,14 @@ static int rseq_reset_rseq_cpu_id(struct task_struct *t)
> 	/*
> 	 * Reset cpu_id_start to its initial state (0).
> 	 */
> -	if (__put_user(cpu_id_start, &t->rseq->cpu_id_start))
> +	if (put_user(cpu_id_start, &t->rseq->cpu_id_start))
> 		return -EFAULT;
> 	/*
> 	 * Reset cpu_id to RSEQ_CPU_ID_UNINITIALIZED, so any user coming
> 	 * in after unregistration can figure out that rseq needs to be
> 	 * registered again.
> 	 */
> -	if (__put_user(cpu_id, &t->rseq->cpu_id))
> +	if (put_user(cpu_id, &t->rseq->cpu_id))
> 		return -EFAULT;
> 	return 0;
> }
> @@ -120,7 +120,7 @@ static int rseq_get_rseq_cs(struct task_struct *t, struct
> rseq_cs *rseq_cs)
> 	u32 sig;
> 	int ret;
> 
> -	ret = __get_user(ptr, &t->rseq->rseq_cs);
> +	ret = get_user(ptr, &t->rseq->rseq_cs);
> 	if (ret)
> 		return ret;
> 	if (!ptr) {
> @@ -163,7 +163,7 @@ static int rseq_need_restart(struct task_struct *t, u32
> cs_flags)
> 	int ret;
> 
> 	/* Get thread flags. */
> -	ret = __get_user(flags, &t->rseq->flags);
> +	ret = get_user(flags, &t->rseq->flags);
> 	if (ret)
> 		return ret;
> 
> @@ -203,7 +203,7 @@ static int clear_rseq_cs(struct task_struct *t)
> 	 *
> 	 * Set rseq_cs to NULL with single-copy atomicity.
> 	 */
> -	return __put_user(0UL, &t->rseq->rseq_cs);
> +	return put_user(0UL, &t->rseq->rseq_cs);
> }
> 
> /*
> --
> 2.11.0

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

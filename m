From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH v7 7/7] Restartable sequences: self-tests
Date: Fri, 12 Aug 2016 18:11:45 +0000 (UTC)
Message-ID: <434180831.9286.1471025505641.JavaMail.zimbra@efficios.com>
References: <1469135662-31512-1-git-send-email-mathieu.desnoyers@efficios.com> <1590181502.79032.1469329777708.JavaMail.zimbra@efficios.com> <CO1PR15MB09825505EBF36E0C56AA037ADD0C0@CO1PR15MB0982.namprd15.prod.outlook.com> <374861479.8581.1470957990793.JavaMail.zimbra@efficios.com> <20160812012854.GC1740@tardis.cn.ibm.com> <365498072.8664.1470971438957.JavaMail.zimbra@efficios.com> <20160812053008.GA18611@tardis.cn.ibm.com> <20160812163542.GB18611@tardis.cn.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160812163542.GB18611-jkllrLZ6VuqyUtPGxGje5AC/G2K4zDHf@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

----- On Aug 12, 2016, at 12:35 PM, Boqun Feng boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> On Fri, Aug 12, 2016 at 01:30:15PM +0800, Boqun Feng wrote:
> [snip]
>> > > Besides, do we allow userspace programs do read-only access to the
>> > > memory objects modified by do_rseq(). If so, we have a problem when
>> > > there are two writes in a do_rseq()(either in the rseq critical section
>> > > or in the asm block), because in current implemetation, these two writes
>> > > are unordered, which makes the readers outside a do_rseq() could observe
>> > > the ordering of writes differently.
>> > > 
>> > > For rseq_finish2(), a simple solution would be making the "final" write
>> > > a RELEASE.
>> > 
>> > Indeed, we would need a release semantic for the final store here if this
>> > is the common use. Or we could duplicate the "flavors" of rseq_finish2 and
>> > add a rseq_finish2_release. We should find a way to eliminate code duplication
>> 
>> I'm in favor of a separate rseq_finish2_release().
>> 
>> > there. I suspect we'll end up doing macros.
>> > 
>> 
>> Me too. Lemme have a try ;-)
>> 
> 
> How about this? Although a little messy, I separated the asm block into
> several parts and implemented each part in a arch-diagnose way.

I find it rather hard to follow the per-arch assembly with this approach.
It might prove to be troublesome if we want to do arch-specific optimizations
in the future.

I've come up with the following macro approach instead, feedback welcome!


commit 4d27431d6aefaee617540ef04518962b0e4d14f4
Author: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Date:   Thu Aug 11 19:11:27 2016 -0400

    rseq_finish2, rseq_finish2_release (WIP)

diff --git a/tools/testing/selftests/rseq/param_test.c b/tools/testing/selftests/rseq/param_test.c
index 5f88b6b..59efc98 100644
--- a/tools/testing/selftests/rseq/param_test.c
+++ b/tools/testing/selftests/rseq/param_test.c
@@ -41,7 +41,8 @@ static __thread unsigned int yield_mod_cnt, nr_retry;
 	, [loop_cnt_1]"m"(loop_cnt[1]) \
 	, [loop_cnt_2]"m"(loop_cnt[2]) \
 	, [loop_cnt_3]"m"(loop_cnt[3]) \
-	, [loop_cnt_4]"m"(loop_cnt[4])
+	, [loop_cnt_4]"m"(loop_cnt[4]) \
+	, [loop_cnt_5]"m"(loop_cnt[5])
 
 #if defined(__x86_64__) || defined(__i386__)
 
@@ -548,7 +549,7 @@ static void show_usage(int argc, char **argv)
 	printf("	[-2 loops] Number of loops for delay injection 2\n");
 	printf("	[-3 loops] Number of loops for delay injection 3\n");
 	printf("	[-4 loops] Number of loops for delay injection 4\n");
-	printf("	[-5 loops] Number of loops for delay injection 5 (-1 to enable -m)\n");
+	printf("	[-5 loops] Number of loops for delay injection 5\n");
 	printf("	[-6 loops] Number of loops for delay injection 6 (-1 to enable -m)\n");
 	printf("	[-7 loops] Number of loops for delay injection 7 (-1 to enable -m)\n");
 	printf("	[-8 loops] Number of loops for delay injection 8 (-1 to enable -m)\n");
diff --git a/tools/testing/selftests/rseq/rseq.h b/tools/testing/selftests/rseq/rseq.h
index 5853b17..6da993d 100644
--- a/tools/testing/selftests/rseq/rseq.h
+++ b/tools/testing/selftests/rseq/rseq.h
@@ -269,7 +269,7 @@ struct rseq_state rseq_start(struct rseq_lock *rlock)
 		result.event_counter =
 			ACCESS_ONCE(result.rseqp->u.e.event_counter);
 		/* load event_counter before cpu_id. */
-		RSEQ_INJECT_C(5)
+		RSEQ_INJECT_C(6)
 		result.cpu_id = ACCESS_ONCE(result.rseqp->u.e.cpu_id);
 	}
 	/*
@@ -281,7 +281,7 @@ struct rseq_state rseq_start(struct rseq_lock *rlock)
 	 * preemption/signalling will cause them to restart, so they
 	 * don't interfere with the lock.
 	 */
-	RSEQ_INJECT_C(6)
+	RSEQ_INJECT_C(7)
 
 	if (!has_fast_acquire_release() && likely(rseq_has_sys_membarrier)) {
 		result.lock_state = ACCESS_ONCE(rlock->state);
@@ -304,192 +304,342 @@ struct rseq_state rseq_start(struct rseq_lock *rlock)
 	return result;
 }
 
-static inline __attribute__((always_inline))
-bool rseq_finish(struct rseq_lock *rlock,
-		intptr_t *p, intptr_t to_write,
-		struct rseq_state start_value)
-{
-	RSEQ_INJECT_C(9)
+/*
+ * The __rseq_table section can be used by debuggers to better handle
+ * single-stepping through the restartable critical sections.
+ */
 
-	if (unlikely(start_value.lock_state != RSEQ_LOCK_STATE_RESTART)) {
-		if (start_value.lock_state == RSEQ_LOCK_STATE_LOCK)
-			rseq_fallback_wait(rlock);
-		return false;
-	}
+#ifdef __x86_64__
 
-	/*
-	 * The __rseq_table section can be used by debuggers to better
-	 * handle single-stepping through the restartable critical
-	 * sections.
-	 */
+#define RSEQ_FINISH_ASM(_target_final, _to_write_final, _start_value, \
+		_failure, extra_store, extra_input) \
+	__asm__ __volatile__ goto ( \
+		".pushsection __rseq_table, \"aw\"\n\t" \
+		".balign 32\n\t" \
+		"3:\n\t" \
+		".quad 1f, 2f, %l[failure], 0x0\n\t" \
+		".popsection\n\t" \
+		"1:\n\t" \
+		RSEQ_INJECT_ASM(1) \
+		"movq $3b, (%[rseq_cs])\n\t" \
+		RSEQ_INJECT_ASM(2) \
+		"cmpl %[start_event_counter], %[current_event_counter]\n\t" \
+		"jnz %l[failure]\n\t" \
+		RSEQ_INJECT_ASM(3) \
+		extra_store \
+		"movq %[to_write_final], (%[target_final])\n\t" \
+		"2:\n\t" \
+		RSEQ_INJECT_ASM(5) \
+		"movq $0, (%[rseq_cs])\n\t" \
+		: /* no outputs */ \
+		: [start_event_counter]"r"((_start_value).event_counter), \
+		  [current_event_counter]"m"((_start_value).rseqp->u.e.event_counter), \
+		  [to_write_final]"r"(_to_write_final), \
+		  [target_final]"r"(_target_final), \
+		  [rseq_cs]"r"(&(_start_value).rseqp->rseq_cs) \
+		  extra_input \
+		  RSEQ_INJECT_INPUT \
+		: "memory", "cc" \
+		  RSEQ_INJECT_CLOBBER \
+		: _failure \
+	);
 
-#ifdef __x86_64__
-	__asm__ __volatile__ goto (
-		".pushsection __rseq_table, \"aw\"\n\t"
-		".balign 32\n\t"
-		"3:\n\t"
-		".quad 1f, 2f, %l[failure], 0x0\n\t"
-		".popsection\n\t"
-		"1:\n\t"
-		RSEQ_INJECT_ASM(1)
-		"movq $3b, (%[rseq_cs])\n\t"
-		RSEQ_INJECT_ASM(2)
-		"cmpl %[start_event_counter], %[current_event_counter]\n\t"
-		"jnz %l[failure]\n\t"
-		RSEQ_INJECT_ASM(3)
-		"movq %[to_write], (%[target])\n\t"
-		"2:\n\t"
+#define RSEQ_FINISH2_SPECULATIVE_STORE_ASM() \
+		"movq %[to_write_spec], (%[target_spec])\n\t" \
 		RSEQ_INJECT_ASM(4)
-		"movq $0, (%[rseq_cs])\n\t"
-		: /* no outputs */
-		: [start_event_counter]"r"(start_value.event_counter),
-		  [current_event_counter]"m"(start_value.rseqp->u.e.event_counter),
-		  [to_write]"r"(to_write),
-		  [target]"r"(p),
-		  [rseq_cs]"r"(&start_value.rseqp->rseq_cs)
-		  RSEQ_INJECT_INPUT
-		: "memory", "cc"
-		  RSEQ_INJECT_CLOBBER
-		: failure
-	);
+
+/* x86-64 is TSO */
+#define RSEQ_FINISH2_RELEASE_SPECULATIVE_STORE_ASM() \
+	RSEQ_FINISH2_SPECULATIVE_STORE_ASM()
+
+#define RSEQ_FINISH2_SPECULATIVE_STORE_INPUT_ASM(_target_spec, _to_write_spec) \
+		, [to_write_spec]"r"(_to_write_spec), \
+		[target_spec]"r"(_target_spec)
+
 #elif defined(__i386__)
-	__asm__ __volatile__ goto (
-		".pushsection __rseq_table, \"aw\"\n\t"
-		".balign 32\n\t"
-		"3:\n\t"
-		".long 1f, 0x0, 2f, 0x0, %l[failure], 0x0, 0x0, 0x0\n\t"
-		".popsection\n\t"
-		"1:\n\t"
-		RSEQ_INJECT_ASM(1)
-		"movl $3b, (%[rseq_cs])\n\t"
-		RSEQ_INJECT_ASM(2)
-		"cmpl %[start_event_counter], %[current_event_counter]\n\t"
-		"jnz %l[failure]\n\t"
-		RSEQ_INJECT_ASM(3)
-		"movl %[to_write], (%[target])\n\t"
-		"2:\n\t"
-		RSEQ_INJECT_ASM(4)
-		"movl $0, (%[rseq_cs])\n\t"
-		: /* no outputs */
-		: [start_event_counter]"r"(start_value.event_counter),
-		  [current_event_counter]"m"(start_value.rseqp->u.e.event_counter),
-		  [to_write]"r"(to_write),
-		  [target]"r"(p),
-		  [rseq_cs]"r"(&start_value.rseqp->rseq_cs)
-		  RSEQ_INJECT_INPUT
-		: "memory", "cc"
-		  RSEQ_INJECT_CLOBBER
-		: failure
+
+#define RSEQ_FINISH_ASM(_target_final, _to_write_final, _start_value, \
+		_failure, extra_store, extra_input) \
+	__asm__ __volatile__ goto ( \
+		".pushsection __rseq_table, \"aw\"\n\t" \
+		".balign 32\n\t" \
+		"3:\n\t" \
+		".long 1f, 0x0, 2f, 0x0, %l[failure], 0x0, 0x0, 0x0\n\t" \
+		".popsection\n\t" \
+		"1:\n\t" \
+		RSEQ_INJECT_ASM(1) \
+		"movl $3b, (%[rseq_cs])\n\t" \
+		RSEQ_INJECT_ASM(2) \
+		"cmpl %[start_event_counter], %[current_event_counter]\n\t" \
+		"jnz %l[failure]\n\t" \
+		RSEQ_INJECT_ASM(3) \
+		extra_store \
+		"movl %[to_write_final], (%[target_final])\n\t" \
+		"2:\n\t" \
+		RSEQ_INJECT_ASM(5) \
+		"movl $0, (%[rseq_cs])\n\t" \
+		: /* no outputs */ \
+		: [start_event_counter]"r"((_start_value).event_counter), \
+		  [current_event_counter]"m"((_start_value).rseqp->u.e.event_counter), \
+		  [to_write_final]"r"(_to_write_final), \
+		  [target_final]"r"(_target_final), \
+		  [rseq_cs]"r"(&(_start_value).rseqp->rseq_cs) \
+		  extra_input \
+		  RSEQ_INJECT_INPUT \
+		: "memory", "cc" \
+		  RSEQ_INJECT_CLOBBER \
+		: _failure \
 	);
-#elif defined(__ARMEL__)
-	__asm__ __volatile__ goto (
-		".pushsection __rseq_table, \"aw\"\n\t"
-		".balign 32\n\t"
-		".word 1f, 0x0, 2f, 0x0, %l[failure], 0x0, 0x0, 0x0\n\t"
-		".popsection\n\t"
-		"1:\n\t"
-		RSEQ_INJECT_ASM(1)
-		"adr r0, 3f\n\t"
-		"str r0, [%[rseq_cs]]\n\t"
-		RSEQ_INJECT_ASM(2)
-		"ldr r0, %[current_event_counter]\n\t"
-		"mov r1, #0\n\t"
-		"cmp %[start_event_counter], r0\n\t"
-		"bne %l[failure]\n\t"
-		RSEQ_INJECT_ASM(3)
-		"str %[to_write], [%[target]]\n\t"
-		"2:\n\t"
+
+#define RSEQ_FINISH2_SPECULATIVE_STORE_ASM() \
+		"movl %[to_write_spec], (%[target_spec])\n\t" \
 		RSEQ_INJECT_ASM(4)
-		"str r1, [%[rseq_cs]]\n\t"
-		"b 4f\n\t"
-		".balign 32\n\t"
-		"3:\n\t"
-		".word 1b, 0x0, 2b, 0x0, l[failure], 0x0, 0x0, 0x0\n\t"
-		"4:\n\t"
-		: /* no outputs */
-		: [start_event_counter]"r"(start_value.event_counter),
-		  [current_event_counter]"m"(start_value.rseqp->u.e.event_counter),
-		  [to_write]"r"(to_write),
-		  [target]"r"(p),
-		  [rseq_cs]"r"(&start_value.rseqp->rseq_cs)
-		  RSEQ_INJECT_INPUT
-		: "r0", "r1", "memory", "cc"
-		  RSEQ_INJECT_CLOBBER
-		: failure
+
+#define RSEQ_FINISH2_RELEASE_SPECULATIVE_STORE_ASM() \
+		RSEQ_FINISH2_SPECULATIVE_STORE_ASM() \
+		"lock; addl $0,0(%%esp)\n\t"
+
+#define RSEQ_FINISH2_SPECULATIVE_STORE_INPUT_ASM(_target_spec, _to_write_spec) \
+		, [to_write_spec]"r"(_to_write_spec), \
+		[target_spec]"r"(_target_spec)
+
+#elif defined(__ARMEL__)
+
+#define RSEQ_FINISH_ASM(_target_final, _to_write_final, _start_value, \
+		_failure, extra_store, extra_input) \
+	__asm__ __volatile__ goto ( \
+		".pushsection __rseq_table, \"aw\"\n\t" \
+		".balign 32\n\t" \
+		".word 1f, 0x0, 2f, 0x0, %l[failure], 0x0, 0x0, 0x0\n\t" \
+		".popsection\n\t" \
+		"1:\n\t" \
+		RSEQ_INJECT_ASM(1) \
+		"adr r0, 3f\n\t" \
+		"str r0, [%[rseq_cs]]\n\t" \
+		RSEQ_INJECT_ASM(2) \
+		"ldr r0, %[current_event_counter]\n\t" \
+		"mov r1, #0\n\t" \
+		"cmp %[start_event_counter], r0\n\t" \
+		"bne %l[failure]\n\t" \
+		RSEQ_INJECT_ASM(3) \
+		extra_store \
+		"str %[to_write_final], [%[target_final]]\n\t" \
+		"2:\n\t" \
+		RSEQ_INJECT_ASM(5) \
+		"str r1, [%[rseq_cs]]\n\t" \
+		"b 4f\n\t" \
+		".balign 32\n\t" \
+		"3:\n\t" \
+		".word 1b, 0x0, 2b, 0x0, l[failure], 0x0, 0x0, 0x0\n\t" \
+		"4:\n\t" \
+		: /* no outputs */ \
+		: [start_event_counter]"r"((_start_value).event_counter), \
+		  [current_event_counter]"m"((_start_value).rseqp->u.e.event_counter), \
+		  [to_write_final]"r"(_to_write_final), \
+		  [target_final]"r"(_target_final), \
+		  [rseq_cs]"r"(&(_start_value).rseqp->rseq_cs) \
+		  extra_input \
+		  RSEQ_INJECT_INPUT \
+		: "r0", "r1", "memory", "cc" \
+		  RSEQ_INJECT_CLOBBER \
+		: _failure \
 	);
-#elif __PPC64__
-	__asm__ __volatile__ goto (
-		".pushsection __rseq_table, \"aw\"\n\t"
-		".balign 32\n\t"
-		"3:\n\t"
-		".quad 1f, 2f, %l[failure], 0x0\n\t"
-		".popsection\n\t"
-		"1:\n\t"
-		RSEQ_INJECT_ASM(1)
-		"lis %%r17, (3b)@highest\n\t"
-		"ori %%r17, %%r17, (3b)@higher\n\t"
-		"rldicr %%r17, %%r17, 32, 31\n\t"
-		"oris %%r17, %%r17, (3b)@h\n\t"
-		"ori %%r17, %%r17, (3b)@l\n\t"
-		"std %%r17, 0(%[rseq_cs])\n\t"
-		RSEQ_INJECT_ASM(2)
-		"lwz %%r17, %[current_event_counter]\n\t"
-		"cmpw cr7, %[start_event_counter], %%r17\n\t"
-		"bne- cr7, %l[failure]\n\t"
-		RSEQ_INJECT_ASM(3)
-		"std %[to_write], 0(%[target])\n\t"
-		"2:\n\t"
+
+#define RSEQ_FINISH2_SPECULATIVE_STORE_ASM() \
+		"str %[to_write_spec], [%[target_spec]]\n\t" \
 		RSEQ_INJECT_ASM(4)
-		"li %%r17, 0\n\t"
-		"std %%r17, 0(%[rseq_cs])\n\t"
-		: /* no outputs */
-		: [start_event_counter]"r"(start_value.event_counter),
-		  [current_event_counter]"m"(start_value.rseqp->u.e.event_counter),
-		  [to_write]"r"(to_write),
-		  [target]"b"(p),
-		  [rseq_cs]"b"(&start_value.rseqp->rseq_cs)
-		  RSEQ_INJECT_INPUT
-		: "r17", "memory", "cc"
-		  RSEQ_INJECT_CLOBBER
-		: failure
+
+#define RSEQ_FINISH2_RELEASE_SPECULATIVE_STORE_ASM() \
+		RSEQ_FINISH2_SPECULATIVE_STORE_ASM() \
+		"dmb\n\t"
+
+#define RSEQ_FINISH2_SPECULATIVE_STORE_INPUT_ASM(_target_spec, _to_write_spec) \
+		, [to_write_spec]"r"(_to_write_spec), \
+		[target_spec]"r"(_target_spec)
+
+#elif __PPC64__
+
+#define RSEQ_FINISH_ASM(_target_final, _to_write_final, _start_value, \
+		_failure, extra_store, extra_input) \
+	__asm__ __volatile__ goto ( \
+		".pushsection __rseq_table, \"aw\"\n\t" \
+		".balign 32\n\t" \
+		"3:\n\t" \
+		".quad 1f, 2f, %l[failure], 0x0\n\t" \
+		".popsection\n\t" \
+		"1:\n\t" \
+		RSEQ_INJECT_ASM(1) \
+		"lis %%r17, (3b)@highest\n\t" \
+		"ori %%r17, %%r17, (3b)@higher\n\t" \
+		"rldicr %%r17, %%r17, 32, 31\n\t" \
+		"oris %%r17, %%r17, (3b)@h\n\t" \
+		"ori %%r17, %%r17, (3b)@l\n\t" \
+		"std %%r17, 0(%[rseq_cs])\n\t" \
+		RSEQ_INJECT_ASM(2) \
+		"lwz %%r17, %[current_event_counter]\n\t" \
+		"cmpw cr7, %[start_event_counter], %%r17\n\t" \
+		"bne- cr7, %l[failure]\n\t" \
+		RSEQ_INJECT_ASM(3) \
+		extra_store \
+		"std %[to_write_final], 0(%[target_final])\n\t" \
+		"2:\n\t" \
+		RSEQ_INJECT_ASM(5) \
+		"li %%r17, 0\n\t" \
+		"std %%r17, 0(%[rseq_cs])\n\t" \
+		: /* no outputs */ \
+		: [start_event_counter]"r"((_start_value).event_counter), \
+		  [current_event_counter]"m"((_start_value).rseqp->u.e.event_counter), \
+		  [to_write_final]"r"(_to_write_final), \
+		  [target_final]"b"(_target_final), \
+		  [rseq_cs]"b"(&(_start_value).rseqp->rseq_cs) \
+		  extra_input \
+		  RSEQ_INJECT_INPUT \
+		: "r17", "memory", "cc" \
+		  RSEQ_INJECT_CLOBBER \
+		: _failure \
 	);
-#elif __PPC__
-	__asm__ __volatile__ goto (
-		".pushsection __rseq_table, \"aw\"\n\t"
-		".balign 32\n\t"
-		"3:\n\t"
-		/* 32-bit only supported on BE */
-		".long 0x0, 1f, 0x0, 2f, 0x0, %l[failure], 0x0, 0x0\n\t"
-		".popsection\n\t"
-		"1:\n\t"
-		RSEQ_INJECT_ASM(1)
-		"lis %%r17, (3b)@ha\n\t"
-		"addi %%r17, %%r17, (3b)@l\n\t"
-		"stw %%r17, 0(%[rseq_cs])\n\t"
-		RSEQ_INJECT_ASM(2)
-		"lwz %%r17, %[current_event_counter]\n\t"
-		"cmpw cr7, %[start_event_counter], %%r17\n\t"
-		"bne- cr7, %l[failure]\n\t"
-		RSEQ_INJECT_ASM(3)
-		"stw %[to_write], 0(%[target])\n\t"
-		"2:\n\t"
+
+#define RSEQ_FINISH2_SPECULATIVE_STORE_ASM() \
+		"std %[to_write_spec], 0(%[target_spec])\n\t" \
 		RSEQ_INJECT_ASM(4)
-		"li %%r17, 0\n\t"
-		"stw %%r17, 0(%[rseq_cs])\n\t"
-		: /* no outputs */
-		: [start_event_counter]"r"(start_value.event_counter),
-		  [current_event_counter]"m"(start_value.rseqp->u.e.event_counter),
-		  [to_write]"r"(to_write),
-		  [target]"b"(p),
-		  [rseq_cs]"b"(&start_value.rseqp->rseq_cs)
-		  RSEQ_INJECT_INPUT
-		: "r17", "memory", "cc"
-		  RSEQ_INJECT_CLOBBER
-		: failure
+
+#define RSEQ_FINISH2_RELEASE_SPECULATIVE_STORE_ASM() \
+		RSEQ_FINISH2_SPECULATIVE_STORE_ASM() \
+		"lwsync\n\t"
+
+#define RSEQ_FINISH2_SPECULATIVE_STORE_INPUT_ASM(_target_spec, _to_write_spec) \
+		, [to_write_spec]"r"(_to_write_spec), \
+		[target_spec]"b"(_target_spec)
+
+#elif __PPC__
+
+#define RSEQ_FINISH_ASM(_target_final, _to_write_final, _start_value, \
+		_failure, extra_store, extra_input) \
+	__asm__ __volatile__ goto ( \
+		".pushsection __rseq_table, \"aw\"\n\t" \
+		".balign 32\n\t" \
+		"3:\n\t" \
+		/* 32-bit only supported on BE */ \
+		".long 0x0, 1f, 0x0, 2f, 0x0, %l[failure], 0x0, 0x0\n\t" \
+		".popsection\n\t" \
+		"1:\n\t" \
+		RSEQ_INJECT_ASM(1) \
+		"lis %%r17, (3b)@ha\n\t" \
+		"addi %%r17, %%r17, (3b)@l\n\t" \
+		"stw %%r17, 0(%[rseq_cs])\n\t" \
+		RSEQ_INJECT_ASM(2) \
+		"lwz %%r17, %[current_event_counter]\n\t" \
+		"cmpw cr7, %[start_event_counter], %%r17\n\t" \
+		"bne- cr7, %l[failure]\n\t" \
+		RSEQ_INJECT_ASM(3) \
+		extra_store \
+		"stw %[to_write_final], 0(%[target_final])\n\t" \
+		"2:\n\t" \
+		RSEQ_INJECT_ASM(5) \
+		"li %%r17, 0\n\t" \
+		"stw %%r17, 0(%[rseq_cs])\n\t" \
+		: /* no outputs */ \
+		: [start_event_counter]"r"((_start_value).event_counter), \
+		  [current_event_counter]"m"((_start_value).rseqp->u.e.event_counter), \
+		  [to_write_final]"r"(_to_write_final), \
+		  [target_final]"b"(_target_final), \
+		  [rseq_cs]"b"(&(_start_value).rseqp->rseq_cs) \
+		  extra_input \
+		  RSEQ_INJECT_INPUT \
+		: "r17", "memory", "cc" \
+		  RSEQ_INJECT_CLOBBER \
+		: _failure \
 	);
+
+#define RSEQ_FINISH2_SPECULATIVE_STORE_ASM() \
+		"stw %[to_write_spec], 0(%[target_spec])\n\t" \
+		RSEQ_INJECT_ASM(4)
+
+#define RSEQ_FINISH2_RELEASE_SPECULATIVE_STORE_ASM() \
+		RSEQ_FINISH2_SPECULATIVE_STORE_ASM() \
+		"lwsync\n\t"
+
+#define RSEQ_FINISH2_SPECULATIVE_STORE_INPUT_ASM(_target_spec, _to_write_spec) \
+		, [to_write_spec]"r"(_to_write_spec), \
+		[target_spec]"b"(_target_spec)
+
 #else
 #error unsupported target
 #endif
+
+static inline __attribute__((always_inline))
+bool rseq_finish(struct rseq_lock *rlock,
+		intptr_t *p, intptr_t to_write,
+		struct rseq_state start_value)
+{
+	RSEQ_INJECT_C(8)
+
+	if (unlikely(start_value.lock_state != RSEQ_LOCK_STATE_RESTART)) {
+		if (start_value.lock_state == RSEQ_LOCK_STATE_LOCK)
+			rseq_fallback_wait(rlock);
+		return false;
+	}
+
+	RSEQ_FINISH_ASM(p, to_write, start_value, failure, , );
+
+	return true;
+failure:
+	RSEQ_INJECT_FAILED
+	ACCESS_ONCE(start_value.rseqp->rseq_cs) = 0;
+	return false;
+}
+
+/*
+ * p_spec and to_write_spec are used for a speculative write attempted
+ * near the end of the restartable sequence. A rseq_finish2 may fail
+ * even after this write takes place.
+ *
+ * p_final and to_write_final are used for the final write. If this
+ * write takes place, the rseq_finish2 is guaranteed to succeed.
+ */
+static inline __attribute__((always_inline))
+bool rseq_finish2(struct rseq_lock *rlock,
+		intptr_t *p_spec, intptr_t to_write_spec,
+		intptr_t *p_final, intptr_t to_write_final,
+		struct rseq_state start_value)
+{
+	RSEQ_INJECT_C(9)
+
+	if (unlikely(start_value.lock_state != RSEQ_LOCK_STATE_RESTART)) {
+		if (start_value.lock_state == RSEQ_LOCK_STATE_LOCK)
+			rseq_fallback_wait(rlock);
+		return false;
+	}
+
+	RSEQ_FINISH_ASM(p_final, to_write_final, start_value, failure,
+		RSEQ_FINISH2_SPECULATIVE_STORE_ASM(),
+		RSEQ_FINISH2_SPECULATIVE_STORE_INPUT_ASM(p_spec, to_write_spec)
+	);
+	return true;
+failure:
+	RSEQ_INJECT_FAILED
+	ACCESS_ONCE(start_value.rseqp->rseq_cs) = 0;
+	return false;
+}
+
+static inline __attribute__((always_inline))
+bool rseq_finish2_release(struct rseq_lock *rlock,
+		intptr_t *p_spec, intptr_t to_write_spec,
+		intptr_t *p_final, intptr_t to_write_final,
+		struct rseq_state start_value)
+{
+	RSEQ_INJECT_C(9)
+
+	if (unlikely(start_value.lock_state != RSEQ_LOCK_STATE_RESTART)) {
+		if (start_value.lock_state == RSEQ_LOCK_STATE_LOCK)
+			rseq_fallback_wait(rlock);
+		return false;
+	}
+
+	RSEQ_FINISH_ASM(p_final, to_write_final, start_value, failure,
+		RSEQ_FINISH2_RELEASE_SPECULATIVE_STORE_ASM(),
+		RSEQ_FINISH2_SPECULATIVE_STORE_INPUT_ASM(p_spec, to_write_spec)
+	);
 	return true;
 failure:
 	RSEQ_INJECT_FAILED

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

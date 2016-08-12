From: Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH v7 7/7] Restartable sequences: self-tests
Date: Sat, 13 Aug 2016 00:35:50 +0800
Message-ID: <20160812163542.GB18611@tardis.cn.ibm.com>
References: <1469135662-31512-1-git-send-email-mathieu.desnoyers@efficios.com>
 <1469135662-31512-8-git-send-email-mathieu.desnoyers@efficios.com>
 <CO1PR15MB09822FC140F84DCEEF2004CDDD0B0@CO1PR15MB0982.namprd15.prod.outlook.com>
 <1590181502.79032.1469329777708.JavaMail.zimbra@efficios.com>
 <CO1PR15MB09825505EBF36E0C56AA037ADD0C0@CO1PR15MB0982.namprd15.prod.outlook.com>
 <374861479.8581.1470957990793.JavaMail.zimbra@efficios.com>
 <20160812012854.GC1740@tardis.cn.ibm.com>
 <365498072.8664.1470971438957.JavaMail.zimbra@efficios.com>
 <20160812053008.GA18611@tardis.cn.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160812053008.GA18611-jkllrLZ6VuqyUtPGxGje5AC/G2K4zDHf@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Aug 12, 2016 at 01:30:15PM +0800, Boqun Feng wrote:
[snip]
> > > Besides, do we allow userspace programs do read-only access to the
> > > memory objects modified by do_rseq(). If so, we have a problem when
> > > there are two writes in a do_rseq()(either in the rseq critical section
> > > or in the asm block), because in current implemetation, these two writes
> > > are unordered, which makes the readers outside a do_rseq() could observe
> > > the ordering of writes differently.
> > > 
> > > For rseq_finish2(), a simple solution would be making the "final" write
> > > a RELEASE.
> > 
> > Indeed, we would need a release semantic for the final store here if this
> > is the common use. Or we could duplicate the "flavors" of rseq_finish2 and
> > add a rseq_finish2_release. We should find a way to eliminate code duplication
> 
> I'm in favor of a separate rseq_finish2_release().
> 
> > there. I suspect we'll end up doing macros.
> > 
> 
> Me too. Lemme have a try ;-)
> 

How about this? Although a little messy, I separated the asm block into
several parts and implemented each part in a arch-diagnose way.

Compiled successfully on x86 and ppc64le, no more further tests.

Regards,
Boqun

-------------------->8
>From 3a4c40ded1320b824af462d875f942913e5c46a3 Mon Sep 17 00:00:00 2001
From: Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date: Sat, 13 Aug 2016 00:16:13 +0800
Subject: [PATCH] WIP1

Signed-off-by: Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 tools/testing/selftests/rseq/rseq.h | 541 ++++++++++++++----------------------
 1 file changed, 205 insertions(+), 336 deletions(-)

diff --git a/tools/testing/selftests/rseq/rseq.h b/tools/testing/selftests/rseq/rseq.h
index e8614e76b377..7e13aab2ec8b 100644
--- a/tools/testing/selftests/rseq/rseq.h
+++ b/tools/testing/selftests/rseq/rseq.h
@@ -304,6 +304,172 @@ struct rseq_state rseq_start(struct rseq_lock *rlock)
 	return result;
 }
 
+/*
+ * ASM code for building the rseq_cs table
+ */
+
+#if defined(__x86_64__) || defined(__PPC64__)
+# define RSEQ_CS_TABLE(table, start, post_commit, abort)	\
+	".balign 32\n\t"						\
+	table ":\n\t"						\
+	".quad " start "," post_commit "," abort ", 0x0\n\t"
+#elif defined(__ARMEL__)
+# define RSEQ_CS_TABLE(table, start, post_commit, abort)	\
+	".balign 32\n\t"						\
+	table ":\n\t"						\
+	".long " start ", 0x0," post_commit ", 0x0," abort ", 0x0, 0x0, 0x0\n\t"
+#elif defined(__PPC__) /* PPC32 */
+# define RSEQ_CS_TABLE(table, start_ip, post_commit_ip, abort_ip)	\
+	".balign 32\n\t"						\
+	table ":\n\t"							\
+	".long 0x0," start ", 0x0," post_commit ", 0x0," abort ", 0x0, 0x0\n\t"
+#else
+#endif
+
+/*
+ * ASM code for putting the rseq_cs table into a special section for debugging
+ */
+
+#define RSEQ_CS_TABLE_SECTION(table, start, post_commit, abort)		\
+	".pushsection __rseq_table, \"aw\"\n\t"				\
+	RSEQ_CS_TABLE(table, start, post_commit, abort)			\
+	".popsection\n\t"						\
+	start ":\n\t"
+
+
+/*
+ * ASM code to store the pointer of rseq_cs table into rseq structure, which
+ * indicates the start of rseq asm block
+ */
+#ifdef __x86_64__
+# define RSEQ_CS_STORE(cs_table, shadow_table, rseq_cs)			\
+	"movq $" cs_table ",(" rseq_cs ")\n\t"
+#elif defined(__i386__)
+# define RSEQ_CS_STORE(cs_table, shadow_table, rseq_cs)			\
+	"movl $" cs_table ",(" rseq_cs ")\n\t"
+#elif defined(__ARMEL__)
+# define RSEQ_CS_STORE(cs_table, shadow_table, rseq_cs)			\
+	"adr r0, " shadow_table "\n\t"					\
+	"str r0, [" rseq_cs "]\n\t"
+#elif defined(__PPC64__)
+# define RSEQ_CS_STORE(cs_table, shadow_table, rseq_cs)			\
+	"lis %%r17, (" cs_table ")@highest\n\t"			\
+	"ori %%r17, %%r17, (" cs_table ")@higher\n\t"			\
+	"rldicr %%r17, %%r17, 32, 31\n\t"				\
+	"oris %%r17, %%r17, (" cs_table ")@h\n\t"			\
+	"ori %%r17, %%r17, (" cs_table ")@l\n\t"			\
+	"std %%r17, 0(" rseq_cs ")\n\t"
+#elif defined(__PPC__)
+# define RSEQ_CS_STORE(cs_table, shadow_table, rseq_cs)			\
+	"lis %%r17, (" cs_table ")@ha\n\t"				\
+	"addi %%r17, %%r17, (" cs_table ")@l\n\t"			\
+	"stw %%r17, 0(" rseq_cs ")\n\t"
+#else
+# error unsupported target
+#endif
+
+/* ASM code to check whether the event_counter changed */
+#ifdef __x86_64__
+# define RSEQ_CHECK_COUNTER(start_counter, current_counter, abort_ip)	\
+	"cmpl " start_counter ", " current_counter "\n\t"		\
+	"jnz " abort_ip "\n\t"
+#elif defined(__i386__)
+# define RSEQ_CHECK_COUNTER(start_counter, current_counter, abort_ip)	\
+	"cmpl " start_counter ", " current_counter "\n\t"		\
+	"jnz " abort_ip "\n\t"
+#elif defined(__ARMEL__)
+# define RSEQ_CHECK_COUNTER(start_counter, current_counter, abort_ip)	\
+	"ldr r0, " current_counter "\n\t"				\
+	"cmp " start_counter ", r0\n\t"					\
+	"bne " abort_ip "\n\t"
+#elif defined(__PPC__)
+# define RSEQ_CHECK_COUNTER(start_counter, current_counter, abort_ip)	\
+	"lwz %%r17, " current_counter "\n\t"				\
+	"cmpw cr7, " start_counter ", %%r17\n\t"			\
+	"bne- cr7, " abort_ip "\n\t"
+#else
+# error unsupported target
+#endif
+
+/* ASM code to do a normal write in rseq block*/
+#ifdef __x86_64__
+# define RSEQ_WRITE(to_write, target_addr)				\
+	"movq " to_write ", (" target_addr ")\n\t"
+
+#elif defined(__i386__)
+# define RSEQ_WRITE(to_write, target_addr)				\
+	"movl " to_write ", (" target_addr ")\n\t"
+
+#elif defined(__ARMEL__)
+# define RSEQ_WRITE(to_write, target_addr)				\
+	"str " to_write ", [" target_addr "]\n\t"
+
+#elif defined(__PPC64__)
+# define RSEQ_WRITE(to_write, target_addr)				\
+	"std " to_write ", 0(" target_addr ")\n\t"
+
+#elif defined(__PPC__)
+# define RSEQ_WRITE(to_write, target_addr)				\
+	"stw " to_write ", 0(" target_addr ")\n\t"
+#else
+# error unsupported target
+#endif
+
+/* ASM code to do a commit(final) write */
+#define RSEQ_COMMIT_WRITE(to_write, target_addr, post_commit)		\
+	RSEQ_WRITE(to_write, target_addr)				\
+	post_commit ":\n\t"
+
+/*
+ * ASM code to zero the rseq_cs, which indicates the end of the rseq asm block
+ */
+#if defined(__x86_64__) || defined(__i386__)
+# define RSEQ_ZERO_CS(rseq_cs)						\
+	RSEQ_WRITE("$0", rseq_cs)
+
+#elif defined(__ARMEL__)
+# define RSEQ_ZERO_CS(rseq_cs)						\
+	"mov r0, #0\n\t"						\
+	RSEQ_WRITE("r0", rseq_cs)
+
+#elif defined(__PPC__)
+# define RSEQ_ZERO_CS(rseq_cs)						\
+	"li %%r17, 0\n\t"						\
+	RSEQ_WRITE("%%r17", rseq_cs)
+
+#else
+# error unsupported target
+#endif
+
+/* ARM use another table to set the rseq_cs */
+#if defined(__ARMEL__)
+# define RSEQ_CS_SHADOW_TABLE(table, start, post_commit, abort)	\
+	"b skip\n\t"						\
+	RSEQ_CS_TABLE(table, start, post_commit, abort)		\
+	"skip:\n\t"
+#else
+# define RSEQ_CS_SHADOW_TABLE(table, start, post_commit, abort)
+#endif
+
+#define RSEQ_VAR_REG(sym, expr)	[sym] "r" (expr)
+#define RSEQ_VAR_MEM(sym, expr)	[sym] "m" (expr)
+
+#ifdef __PPC__ /* PPC64 and PPC32 */
+# define RSEQ_ADDR_REG(sym, expr)	[sym] "b" (expr)
+#endif
+
+#ifndef RSEQ_ADDR_REG
+# define RSEQ_ADDR_REG(sym, expr)	RSEQ_VAR_REG(sym, expr)
+#endif
+
+#ifdef __PPC__
+# define RSEQ_REG_COBBLER	,"r17"
+#elif defined(__ARMEL__)
+# define RSEQ_REG_COBBLER	,"r0"
+#else
+# define RSEQ_REG_COBBLER	,"memory"
+#endif
+
 static inline __attribute__((always_inline))
 bool rseq_finish(struct rseq_lock *rlock,
 		intptr_t *p, intptr_t to_write,
@@ -322,174 +488,33 @@ bool rseq_finish(struct rseq_lock *rlock,
 	 * handle single-stepping through the restartable critical
 	 * sections.
 	 */
-
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
-		RSEQ_INJECT_ASM(4)
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
-#elif defined(__i386__)
 	__asm__ __volatile__ goto (
-		".pushsection __rseq_table, \"aw\"\n\t"
-		".balign 32\n\t"
-		"3:\n\t"
-		".long 1f, 0x0, 2f, 0x0, %l[failure], 0x0, 0x0, 0x0\n\t"
-		".popsection\n\t"
-		"1:\n\t"
+		RSEQ_CS_TABLE_SECTION("cs_table%=", "start%=", "post_commit%=", "%l[failure]")
+		/* start */
 		RSEQ_INJECT_ASM(1)
-		"movl $3b, (%[rseq_cs])\n\t"
+		RSEQ_CS_STORE("cs_table%=", "shadow_table%=", "%[rseq_cs]")
 		RSEQ_INJECT_ASM(2)
-		"cmpl %[start_event_counter], %[current_event_counter]\n\t"
-		"jnz %l[failure]\n\t"
+		RSEQ_CHECK_COUNTER("%[start_event_counter]",
+				   "%[current_event_counter]",
+				   "%l[failure]")
 		RSEQ_INJECT_ASM(3)
-		"movl %[to_write], (%[target])\n\t"
-		"2:\n\t"
+		RSEQ_COMMIT_WRITE("%[to_write]", "%[target]", "post_commit%=")
+		/* post_commit */
 		RSEQ_INJECT_ASM(4)
-		"movl $0, (%[rseq_cs])\n\t"
-		: /* no outputs */
-		: [start_event_counter]"r"(start_value.event_counter),
-		  [current_event_counter]"m"(start_value.rseqp->u.e.event_counter),
-		  [to_write]"r"(to_write),
-		  [target]"r"(p),
-		  [rseq_cs]"r"(&start_value.rseqp->rseq_cs)
+		RSEQ_ZERO_CS("%[rseq_cs]")
+		RSEQ_CS_SHADOW_TABLE("shadow_table%=", "start%=", "post_commit%=", "%l[failure]")
+		:
+		: RSEQ_VAR_REG(start_event_counter, start_value.event_counter),
+		  RSEQ_VAR_MEM(current_event_counter, start_value.rseqp->u.e.event_counter),
+		  RSEQ_VAR_REG(to_write, to_write),
+		  RSEQ_ADDR_REG(target, p),
+		  RSEQ_ADDR_REG(rseq_cs, &start_value.rseqp->rseq_cs)
 		  RSEQ_INJECT_INPUT
 		: "memory", "cc"
+		  RSEQ_REG_COBBLER
 		  RSEQ_INJECT_CLOBBER
 		: failure
-	);
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
-		RSEQ_INJECT_ASM(4)
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
-	);
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
-		RSEQ_INJECT_ASM(4)
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
-	);
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
-		RSEQ_INJECT_ASM(4)
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
-	);
-#else
-#error unsupported target
-#endif
+		);
 	return true;
 failure:
 	RSEQ_INJECT_FAILED
@@ -525,193 +550,37 @@ bool rseq_finish2(struct rseq_lock *rlock,
 	 * sections.
 	 */
 
-#ifdef __x86_64__
 	__asm__ __volatile__ goto (
-		".pushsection __rseq_table, \"aw\"\n\t"
-		".balign 32\n\t"
-		"3:\n\t"
-		".quad 1f, 2f, %l[failure], 0x0\n\t"
-		".popsection\n\t"
-		"1:\n\t"
+		RSEQ_CS_TABLE_SECTION("cs_table%=", "start%=", "post_commit%=", "%l[failure]")
+		/* start */
 		RSEQ_INJECT_ASM(1)
-		"movq $3b, (%[rseq_cs])\n\t"
+		RSEQ_CS_STORE("cs_table%=", "shadow_table%=", "%[rseq_cs]")
 		RSEQ_INJECT_ASM(2)
-		"cmpl %[start_event_counter], %[current_event_counter]\n\t"
-		"jnz %l[failure]\n\t"
+		RSEQ_CHECK_COUNTER("%[start_event_counter]",
+				   "%[current_event_counter]",
+				   "%l[failure]")
 		RSEQ_INJECT_ASM(3)
-		"movq %[to_write_spec], (%[target_spec])\n\t"
+		RSEQ_WRITE("%[to_write_spec]", "%[target_spec]")
 		RSEQ_INJECT_ASM(4)
-		"movq %[to_write_final], (%[target_final])\n\t"
-		"2:\n\t"
+		RSEQ_COMMIT_WRITE("%[to_write_final]", "%[target_final]", "post_commit%=")
+		/* post_commit */
 		RSEQ_INJECT_ASM(5)
-		"movq $0, (%[rseq_cs])\n\t"
-		: /* no outputs */
-		: [start_event_counter]"r"(start_value.event_counter),
-		  [current_event_counter]"m"(start_value.rseqp->u.e.event_counter),
-		  [to_write_spec]"r"(to_write_spec),
-		  [target_spec]"r"(p_spec),
-		  [to_write_final]"r"(to_write_final),
-		  [target_final]"r"(p_final),
-		  [rseq_cs]"r"(&start_value.rseqp->rseq_cs)
+		RSEQ_ZERO_CS("%[rseq_cs]")
+		RSEQ_CS_SHADOW_TABLE("shadow_table%=", "start%=", "post_commit%=", "%l[failure]")
+		:
+		: RSEQ_VAR_REG(start_event_counter, start_value.event_counter),
+		  RSEQ_VAR_MEM(current_event_counter, start_value.rseqp->u.e.event_counter),
+		  RSEQ_VAR_REG(to_write_spec, to_write_spec),
+		  RSEQ_ADDR_REG(target_spec, p_spec),
+		  RSEQ_VAR_REG(to_write_final, to_write_final),
+		  RSEQ_ADDR_REG(target_final, p_final),
+		  RSEQ_ADDR_REG(rseq_cs, &start_value.rseqp->rseq_cs)
 		  RSEQ_INJECT_INPUT
 		: "memory", "cc"
+		  RSEQ_REG_COBBLER
 		  RSEQ_INJECT_CLOBBER
 		: failure
-	);
-#elif defined(__i386__)
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
-		"movl %[to_write_spec], (%[target_spec])\n\t"
-		RSEQ_INJECT_ASM(4)
-		"movl %[to_write_final], (%[target_final])\n\t"
-		"2:\n\t"
-		RSEQ_INJECT_ASM(5)
-		"movl $0, (%[rseq_cs])\n\t"
-		: /* no outputs */
-		: [start_event_counter]"r"(start_value.event_counter),
-		  [current_event_counter]"m"(start_value.rseqp->u.e.event_counter),
-		  [to_write_spec]"r"(to_write_spec),
-		  [target_spec]"r"(p_spec),
-		  [to_write_final]"r"(to_write_final),
-		  [target_final]"r"(p_final),
-		  [rseq_cs]"r"(&start_value.rseqp->rseq_cs)
-		  RSEQ_INJECT_INPUT
-		: "memory", "cc"
-		  RSEQ_INJECT_CLOBBER
-		: failure
-	);
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
-		"str %[to_write_spec], [%[target_spec]]\n\t"
-		RSEQ_INJECT_ASM(4)
-		"str %[to_write_final], [%[target_final]]\n\t"
-		"2:\n\t"
-		RSEQ_INJECT_ASM(5)
-		"str r1, [%[rseq_cs]]\n\t"
-		"b 4f\n\t"
-		".balign 32\n\t"
-		"3:\n\t"
-		".word 1b, 0x0, 2b, 0x0, l[failure], 0x0, 0x0, 0x0\n\t"
-		"4:\n\t"
-		: /* no outputs */
-		: [start_event_counter]"r"(start_value.event_counter),
-		  [current_event_counter]"m"(start_value.rseqp->u.e.event_counter),
-		  [to_write_spec]"r"(to_write_spec),
-		  [target_spec]"r"(p_spec),
-		  [to_write_final]"r"(to_write_final),
-		  [target_final]"r"(p_final),
-		  [rseq_cs]"r"(&start_value.rseqp->rseq_cs)
-		  RSEQ_INJECT_INPUT
-		: "r0", "r1", "memory", "cc"
-		  RSEQ_INJECT_CLOBBER
-		: failure
-	);
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
-		"std %[to_write_spec], 0(%[target_spec])\n\t"
-		RSEQ_INJECT_ASM(4)
-		"std %[to_write_final], 0(%[target_final])\n\t"
-		"2:\n\t"
-		RSEQ_INJECT_ASM(5)
-		"li %%r17, 0\n\t"
-		"std %%r17, 0(%[rseq_cs])\n\t"
-		: /* no outputs */
-		: [start_event_counter]"r"(start_value.event_counter),
-		  [current_event_counter]"m"(start_value.rseqp->u.e.event_counter),
-		  [to_write_spec]"r"(to_write_spec),
-		  [target_spec]"b"(p_spec),
-		  [to_write_final]"r"(to_write_final),
-		  [target_final]"b"(p_final),
-		  [rseq_cs]"b"(&start_value.rseqp->rseq_cs)
-		  RSEQ_INJECT_INPUT
-		: "r17", "memory", "cc"
-		  RSEQ_INJECT_CLOBBER
-		: failure
-	);
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
-		"stw %[to_write_spec], 0(%[target_spec])\n\t"
-		RSEQ_INJECT_ASM(4)
-		"stw %[to_write_final], 0(%[target_final])\n\t"
-		"2:\n\t"
-		RSEQ_INJECT_ASM(5)
-		"li %%r17, 0\n\t"
-		"stw %%r17, 0(%[rseq_cs])\n\t"
-		: /* no outputs */
-		: [start_event_counter]"r"(start_value.event_counter),
-		  [current_event_counter]"m"(start_value.rseqp->u.e.event_counter),
-		  [to_write_spec]"r"(to_write_spec),
-		  [target_spec]"b"(p_spec),
-		  [to_write_final]"r"(to_write_final),
-		  [target_final]"b"(p_final),
-		  [rseq_cs]"b"(&start_value.rseqp->rseq_cs)
-		  RSEQ_INJECT_INPUT
-		: "r17", "memory", "cc"
-		  RSEQ_INJECT_CLOBBER
-		: failure
-	);
-#else
-#error unsupported target
-#endif
+		);
 	return true;
 failure:
 	RSEQ_INJECT_FAILED
-- 
2.9.0

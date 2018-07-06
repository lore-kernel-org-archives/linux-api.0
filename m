From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH for 4.18 3/5] rseq: uapi: declare rseq_cs field as
 union, update includes
Date: Fri, 6 Jul 2018 15:23:39 -0400 (EDT)
Message-ID: <436937568.1359.1530905019620.JavaMail.zimbra@efficios.com>
References: <20180705180601.18423-1-mathieu.desnoyers@efficios.com> <20180705180601.18423-4-mathieu.desnoyers@efficios.com> <1846432971.1245.1530892973439.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1846432971.1245.1530892973439.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael
List-Id: linux-api@vger.kernel.org

----- On Jul 6, 2018, at 12:02 PM, Mathieu Desnoyers mathieu.desnoyers@efficios.com wrote:

> ----- On Jul 5, 2018, at 2:05 PM, Mathieu Desnoyers
> mathieu.desnoyers@efficios.com wrote:
> 
[...]
> The 0-day bot noticed that __get_user() is unimplemented for 64-bit
> values on arm32 (although get_user() is implemented).
> 
> The following diff fixes this discrepancy, and allows this rseq patch
> to build on arm32:
> 

For -rc, I would favor the following simpler approach. Or I could even
just use get_user() instead. Thoughts ?

    rseq: implement work-around for missing 8-byte __get_user on arm
    
    Now that rseq uses __u64 for its pointer fields, 32-bit architectures
    need to read this 64-bit value from user-space.
    
    __get_user is used to read this value, given that its access check has
    already been performed with access_ok() on rseq registration.
    
    arm does not implement 8-byte __get_user. Work-around this limitation
    by using get_user() on ARM instead, with its redundant access check.
    
    Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    CC: Thomas Gleixner <tglx@linutronix.de>
    Cc: Joel Fernandes <joelaf@google.com>
    Cc: Peter Zijlstra <peterz@infradead.org>
    Cc: Catalin Marinas <catalin.marinas@arm.com>
    Cc: Dave Watson <davejwatson@fb.com>
    Cc: Will Deacon <will.deacon@arm.com>
    Cc: Andi Kleen <andi@firstfloor.org>
    Cc: "H . Peter Anvin" <hpa@zytor.com>
    Cc: Chris Lameter <cl@linux.com>
    Cc: Russell King <linux@arm.linux.org.uk>
    Cc: Andrew Hunter <ahh@google.com>
    Cc: Michael Kerrisk <mtk.manpages@gmail.com>
    Cc: "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>
    Cc: Paul Turner <pjt@google.com>
    Cc: Boqun Feng <boqun.feng@gmail.com>
    Cc: Josh Triplett <josh@joshtriplett.org>
    Cc: Steven Rostedt <rostedt@goodmis.org>
    Cc: Ben Maurer <bmaurer@fb.com>
    Cc: linux-api@vger.kernel.org
    CC: linux-arm-kernel@lists.infradead.org
    Cc: Andy Lutomirski <luto@amacapital.net>
    Cc: Andrew Morton <akpm@linux-foundation.org>
    Cc: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/kernel/rseq.c b/kernel/rseq.c
index 3081e67..0e67625 100644
--- a/kernel/rseq.c
+++ b/kernel/rseq.c
@@ -18,6 +18,16 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/rseq.h>
 
+/*
+ * ARM does not implement 8 bytes __get_user. Use get_user on that
+ * architecture instead.
+ */
+#ifdef CONFIG_ARM
+#define __rseq_get_user                get_user
+#else
+#define __rseq_get_user                __get_user
+#endif
+
 #define RSEQ_CS_PREEMPT_MIGRATE_FLAGS (RSEQ_CS_FLAG_NO_RESTART_ON_MIGRATE | \
                                       RSEQ_CS_FLAG_NO_RESTART_ON_PREEMPT)
 
@@ -120,7 +130,7 @@ static int rseq_get_rseq_cs(struct task_struct *t, struct rs
        u32 sig;
        int ret;
 
-       ret = __get_user(ptr, &t->rseq->rseq_cs.ptr64);
+       ret = __rseq_get_user(ptr, &t->rseq->rseq_cs.ptr64);
        if (ret)
                return ret;
        if (!ptr) {



-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH for 4.18] rseq: use __u64 for rseq_cs fields,
 validate user inputs
Date: Tue, 3 Jul 2018 20:28:37 +0200
Message-ID: <20180703182837.GC2494@hirez.programming.kicks-ass.net>
References: <858886246.10882.1530583291379.JavaMail.zimbra@efficios.com>
 <20180703164048.i2te5gjemcafqzwf@two.firstfloor.org>
 <CA+55aFzYEQgEhCnrwtbGuCy36Wh+aiw0_9rgMcjUgbn1JtZAPQ@mail.gmail.com>
 <20180703173451.GX2494@hirez.programming.kicks-ass.net>
 <399697782.11820.1530639539750.JavaMail.zimbra@efficios.com>
 <20180703174833.GZ2494@hirez.programming.kicks-ass.net>
 <1048940999.11846.1530640717837.JavaMail.zimbra@efficios.com>
 <20180703181143.GB2494@hirez.programming.kicks-ass.net>
 <1708848118.11868.1530641734202.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1708848118.11868.1530641734202.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <andi@firstfloor.org>, heiko carstens <heiko.carstens@de.ibm.com>, Andy Lutomirski <luto@amacapital.net>, Thomas Gleixner <tglx@linutronix.de>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Catalin Marinas <catalin.marinas@arm.com>, Will
List-Id: linux-api@vger.kernel.org

On Tue, Jul 03, 2018 at 02:15:34PM -0400, Mathieu Desnoyers wrote:
> ----- On Jul 3, 2018, at 2:11 PM, Peter Zijlstra peterz@infradead.org wrote:
> 
> > On Tue, Jul 03, 2018 at 01:58:37PM -0400, Mathieu Desnoyers wrote:
> >> I can modify the ABI to put the cpu_id_start and cpu_id fields inside
> >> a union, and update it with a single store.
> >> 
> >> Thoughts ?
> > 
> > Let's keep them for now, we can always frob this later, they are aligned
> > and proper, no need to expose that union to userspace.
> 
> Isn't it weird to change the API of an exposed public uapi header ?

Sure, just keep it as is. We don't need an exposed union to do a single
store there.

Something like the ugly below preserves API but still does a single
store.

But sure, if you want to expose that union for some reason, then now is
the time.

diff --git a/kernel/rseq.c b/kernel/rseq.c
index 22b6acf1ad63..e956c48b5f83 100644
--- a/kernel/rseq.c
+++ b/kernel/rseq.c
@@ -85,10 +85,17 @@ static int rseq_update_cpu_id(struct task_struct *t)
 {
 	u32 cpu_id = raw_smp_processor_id();
 
-	if (__put_user(cpu_id, &t->rseq->cpu_id_start))
-		return -EFAULT;
-	if (__put_user(cpu_id, &t->rseq->cpu_id))
+	union {
+		struct {
+			u32 cpu_id_start;
+			u32 cpu_id;
+		};
+		u64 val;
+	} x = { { .cpu_id_start = cpu_id, .cpu_id = cpu_id, } };
+
+	if (__put_user(x.val, (u64 *)&t->rseq->cpu_id_start))
 		return -EFAULT;
+
 	trace_rseq_update(t);
 	return 0;
 }

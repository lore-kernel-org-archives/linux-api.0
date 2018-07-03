From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH for 4.18] rseq: use __u64 for rseq_cs fields,
 validate user inputs
Date: Tue, 3 Jul 2018 14:15:34 -0400 (EDT)
Message-ID: <1708848118.11868.1530641734202.JavaMail.zimbra@efficios.com>
References: <858886246.10882.1530583291379.JavaMail.zimbra@efficios.com> <20180703164048.i2te5gjemcafqzwf@two.firstfloor.org> <CA+55aFzYEQgEhCnrwtbGuCy36Wh+aiw0_9rgMcjUgbn1JtZAPQ@mail.gmail.com> <20180703173451.GX2494@hirez.programming.kicks-ass.net> <399697782.11820.1530639539750.JavaMail.zimbra@efficios.com> <20180703174833.GZ2494@hirez.programming.kicks-ass.net> <1048940999.11846.1530640717837.JavaMail.zimbra@efficios.com> <20180703181143.GB2494@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180703181143.GB2494@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <andi@firstfloor.org>, heiko carstens <heiko.carstens@de.ibm.com>, Andy Lutomirski <luto@amacapital.net>, Thomas Gleixner <tglx@linutronix.de>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Catalin Marinas <catalin.marinas@arm.com>, Will
List-Id: linux-api@vger.kernel.org

----- On Jul 3, 2018, at 2:11 PM, Peter Zijlstra peterz@infradead.org wrote:

> On Tue, Jul 03, 2018 at 01:58:37PM -0400, Mathieu Desnoyers wrote:
>> I can modify the ABI to put the cpu_id_start and cpu_id fields inside
>> a union, and update it with a single store.
>> 
>> Thoughts ?
> 
> Let's keep them for now, we can always frob this later, they are aligned
> and proper, no need to expose that union to userspace.

Isn't it weird to change the API of an exposed public uapi header ? What
if userspace chooses to do sizeof(__rseq_abi.cpu_id) ? We would break
this unless we use a transparent union, which puts constraints I would
hope not to have on compilers supporting transparent unions (I recall
C++ had issues with this).

I'd prefer to expose the union right away if it's fine with you.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

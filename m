From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH v7 1/7] Restartable sequences system call
Date: Wed, 10 Aug 2016 17:40:39 +0000 (UTC)
Message-ID: <1547727714.7430.1470850839903.JavaMail.zimbra@efficios.com>
References: <1469135662-31512-1-git-send-email-mathieu.desnoyers@efficios.com> <1806206514.82247.1469502139408.JavaMail.zimbra@efficios.com> <20160803122717.GL6862@twins.programming.kicks-ass.net> <CALCETrWw0M9YLWTR7_ruxY8cW9_5XRONdw1QN+_pBp0Y63L8pA@mail.gmail.com> <20160804042710.GA13232@tardis.cn.ibm.com> <CALCETrW7t89BWXW5JbWyLVciKS1HJMXe7feopM31wkqL4AtoFA@mail.gmail.com> <20160809161328.GA1740@tardis.cn.ibm.com> <CALCETrWrQWFg-r5+rhiSi3veoLiipxH+TJkTxKXkBpCahadV_g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrWrQWFg-r5+rhiSi3veoLiipxH+TJkTxKXkBpCahadV_g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Boqun Feng <boqun.feng@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Dave Watson <davejwatson@fb.com>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

----- On Aug 10, 2016, at 4:01 AM, Andy Lutomirski luto@amacapital.net wrote:

> On Tue, Aug 9, 2016 at 9:13 AM, Boqun Feng <boqun.feng@gmail.com> wrote:

<snip>

> 
>> However, I'm thinking maybe we can use some tricks to avoid unnecessary
>> aborts-on-preemption.
>>
>> First of all, I notice we haven't make any constraint on what kind of
>> memory objects could be "protected" by rseq critical sections yet. And I
>> think this is something we should decide before adding this feature into
>> kernel.
>>
>> We can do some optimization if we have some constraints. For example, if
>> the memory objects inside the rseq critical sections could only be
>> modified by userspace programs, we therefore don't need to abort
>> immediately when userspace task -> kernel task context switch.
> 
> True, although trying to do a syscall in an rseq critical section
> seems like a bad idea in general.

The scenario above does not require the rseq critical section to perform
an explicit system call. It can happen from simple timer-driven preemption
of user-space.

<snip>

> 
> But do we need to protect MAP_SHARED objects?  If not, maybe we could
> only track context switches between different tasks sharing the same
> mm.

I have tracing use-cases involving MAP_SHARED objects for rseq: per-cpu
buffers.

Moreover, if you only track context switch between tasks with the same
mm, you run into issues if you have:

Process A
  Thread 1 (rseq)
  Thread 2 (rseq)

Process B
  Thread 1

Scheduling: A.1 -> B.1 -> A.2 -> B.1 -> A.1

There is no scheduling between threads of the same process here, but
the entire chain involves two threads of the same process accessing
the same per-cpu data concurrently.

Thanks,

Mathieu


> 
> --Andy

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

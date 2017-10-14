From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH v9 for 4.15 01/14] Restartable sequences system call
Date: Sat, 14 Oct 2017 11:37:31 +0000 (UTC)
Message-ID: <1226073208.41138.1507981051739.JavaMail.zimbra@efficios.com>
References: <20171012230326.19984-1-mathieu.desnoyers@efficios.com> <20171012230326.19984-2-mathieu.desnoyers@efficios.com> <CA+55aFy54Sk63VkS3HFnd4MPiSbgV6==NaYwr+D9sjG6KZGmHQ@mail.gmail.com> <DM5PR15MB1690DA99E4AA74FBE54CF7F9CF480@DM5PR15MB1690.namprd15.prod.outlook.com> <CA+55aFzPBES0JOYuZhuNM7NKN+G9ytZQT2daueFPw0j9HGpdGQ@mail.gmail.com> <20171014030116.GM2482@two.firstfloor.org> <CA+55aFxZo_K41mvgWzbHSnUSZd3SbH3F_PqWF9ZqK4shdqynVg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFxZo_K41mvgWzbHSnUSZd3SbH3F_PqWF9ZqK4shdqynVg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Ben Maurer <bmaurer@fb.com>, David Goldblatt <davidgoldblatt@fb.com>, Qi Wang <qiwang@fb.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Josh Triplett <josh@joshtriplett.org>, Will Deacon <will.deacon@arm.com>, linux-kernel <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Chris Lameter <cl@linux.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, rostedt <rostedt@goodmis.org>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Catalin
List-Id: linux-api@vger.kernel.org

----- On Oct 14, 2017, at 12:05 AM, Linus Torvalds torvalds@linux-foundation.org wrote:

> On Fri, Oct 13, 2017 at 8:01 PM, Andi Kleen <andi@firstfloor.org> wrote:
>>
>> As far as I can see the current model fundamentally only works for
>> one user per process (because there is only a single range and abort IP)
> 
> No, it should work for libraries, you just need to always initialize
> the proper start/commit/abort IP's for every transaction. Then
> everybody should be fine.

Yes, it does work for libraries. I have used it in my lttng-ust and
liburcu prototypes, which are libraries. LTTng-UST requires at least
two distinct critical sections (reserve and commit). For use in
both executable and multiple libraries, we need each to declare the
struct rseq TLS as a weak symbol, so only one gets picked throughout the
process.

One clarification about your statement above: the user-space fast-path
does not need to initialize much at runtime: one "rseq_cs descriptor"
is created by each rseq_finish assembly section. Each of those is
initialized by the dynamic loader with the proper addresses.

All the user-space fast-path really needs to do is to store the address
to that descriptor into the TLS "rseq_cs" field. It does not even have to
clear it after the critical section: the kernel can do it lazily.

> 
> So I _think_ it's all good. But I really would want to see that
> actually being the case.

There is one other use-case I've been made aware of in the past months:
Will Deacon want to use rseq on aarch64 to read PMU counters on
big.LITTLE to prevent migration and use of an unsupported PMC on a
LITTLE core, which could trigger a fault.

You had a really good point about cpu hotplug by the way. I recently
realize that algorithms that have multiple non-atomic steps may
_require_ to execute a series of steps on the same CPU.
One example is lttng-ust ring buffer: it works on per-cpu buffers,
and does a series of operations: reserve, [write to buffer], commit.
Both reserve and commit can benefit from rseq, but we really need
the commit to happen on the right CPU. Currently, in order to handle
CPU hotplug, lttng-ust allocates CPU buffers for all possible cpus.
If a CPU is hotunplugged between the reserve and commit though, we
would run into a scenario where the "commit" could never be completed
on the right CPU. I've actually prepared a follow-up patch [1]
yesterday that fixes this in the cpu_opv() system call: it detects
situations where the target CPU is possible but not online, prevents
cpu hotplug, grabs a mutex, and performs the requested operation
from whichever CPU it happens to run on.

Those are the kind of use-cases I want to gather more feedback on
before we integrate those system calls for good.

Thanks,

Mathieu

[1] https://github.com/compudj/linux-percpu-dev/commit/b602821e446f7bd8a0a2de44c598f257cf4120f5


> 
>                 Linus

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

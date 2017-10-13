From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH v9 for 4.15 01/14] Restartable sequences system call
Date: Fri, 13 Oct 2017 14:27:58 +0000 (UTC)
Message-ID: <66195899.40613.1507904878681.JavaMail.zimbra@efficios.com>
References: <20171012230326.19984-1-mathieu.desnoyers@efficios.com> <20171012230326.19984-2-mathieu.desnoyers@efficios.com> <19edaac0-98d7-e7a0-aceb-b861a2befce4@redhat.com> <695804241.40580.1507902016119.JavaMail.zimbra@efficios.com> <0043559c-c4e0-523a-b634-eded6ced886c@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0043559c-c4e0-523a-b634-eded6ced886c@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Josh Triplett <josh@joshtriplett.org>, Will Deacon <will.deacon@arm.com>, linux-kernel <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Catalin Marinas <catalin.>
List-Id: linux-api@vger.kernel.org

----- On Oct 13, 2017, at 9:56 AM, Florian Weimer fweimer@redhat.com wrote:

> On 10/13/2017 03:40 PM, Mathieu Desnoyers wrote:
>> The proposed ABI does not require to store any function pointer. For a given
>> rseq_finish() critical section, pointers to specific instructions (within a
>> function) are emitted at link-time into a struct rseq_cs:
>> 
>> struct rseq_cs {
>>          RSEQ_FIELD_u32_u64(start_ip);
>>          RSEQ_FIELD_u32_u64(post_commit_ip);
>>          RSEQ_FIELD_u32_u64(abort_ip);
>>          uint32_t flags;
>> } __attribute__((aligned(4 * sizeof(uint64_t))));
>> 
>> Then, at runtime, the fast-path stores the address of that struct rseq_cs
>> into the TLS struct rseq "rseq_cs" field.
>> 
>> So all we store at runtime is a pointer to data, not a pointer to functions.
>> 
>> But you seem to hint that having a pointer to data containing pointers to code
>> may still be making it easier for exploit writers. Can you elaborate on the
>> scenario ?
> 
> I'm concerned that the exploit writer writes a totally made up struct
> rseq_cs object into writable memory, along with function pointers, and
> puts the address of that in to the rseq_cs field.
> 
> This would be comparable to how C++ vtable pointers are targeted
> (including those in the glibc libio implementation of stdio streams).
> 
> Does this answer your questions?

Yes, it does. How about we add a "canary" field to the TLS struct rseq, e.g.:

struct rseq {
        union rseq_cpu_event u;
        RSEQ_FIELD_u32_u64(rseq_cs);  -> pointer to struct rseq_cs
        uint32_t flags;
        uint32_t canary;   -> 32 low bits of rseq_cs ^ canary_mask
};

We could then add a "uint32_t canary_mask" argument to sys_rseq, e.g.:

SYSCALL_DEFINE3(rseq, struct rseq __user *, rseq, uint32_t, canary_mask, int, flags);

So a thread which does not care about hardening would simply register its
struct rseq TLS with a canary mask of "0". Nothing changes on the fast-path.

A thread belonging to a process that cares about hardening could use a random
value as canary, and pass it as canary_mask argument to the syscall. The
fast-path could then set the struct rseq "canary" value to
(32-low-bits of rseq_cs) ^ canary_mask just surrounding the critical section,
and set it back to 0 afterward.

In the kernel, whenever the rseq_cs pointer would be loaded, its 32 low bits
would be checked to match (canary ^ canary_mask). If it differs, then the
kernel kills the process with SIGSEGV.

Would that take care of your concern ?

Thanks,

Mathieu

> 
> Thanks,
> Florian

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH v9 for 4.15 01/14] Restartable sequences system call
Date: Fri, 13 Oct 2017 13:40:16 +0000 (UTC)
Message-ID: <695804241.40580.1507902016119.JavaMail.zimbra@efficios.com>
References: <20171012230326.19984-1-mathieu.desnoyers@efficios.com> <20171012230326.19984-2-mathieu.desnoyers@efficios.com> <19edaac0-98d7-e7a0-aceb-b861a2befce4@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <19edaac0-98d7-e7a0-aceb-b861a2befce4@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Josh Triplett <josh@joshtriplett.org>, Will Deacon <will.deacon@arm.com>, linux-kernel <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Catalin Marinas <catalin.>
List-Id: linux-api@vger.kernel.org

----- On Oct 13, 2017, at 8:50 AM, Florian Weimer fweimer@redhat.com wrote:

> On 10/13/2017 01:03 AM, Mathieu Desnoyers wrote:
>> Expose a new system call allowing each thread to register one userspace
>> memory area to be used as an ABI between kernel and user-space for two
>> purposes: user-space restartable sequences and quick access to read the
>> current CPU number value from user-space.
>> 
>> * Restartable sequences (per-cpu atomics)
>> 
>> Restartables sequences allow user-space to perform update operations on
>> per-cpu data without requiring heavy-weight atomic operations.
>> 
>> The restartable critical sections (percpu atomics) work has been started
>> by Paul Turner and Andrew Hunter. It lets the kernel handle restart of
>> critical sections. [1] [2] The re-implementation proposed here brings a
>> few simplifications to the ABI which facilitates porting to other
>> architectures and speeds up the user-space fast path.

This part:

>> A locking-based
>> fall-back, purely implemented in user-space, is proposed here to deal
>> with debugger single-stepping. This fallback interacts with rseq_start()
>> and rseq_finish(), which force retries in response to concurrent
>> lock-based activity.

should have been updated in this series to:

A second system call, cpu_opv(), is proposed as fallback to deal with debugger
single-stepping. cpu_opv() executes a sequence of operations on behalf of
user-space with preemption disabled.

> This functionality essentially relies on writable function pointers (or
> pointers to data containing function pointers), right?  Is there a way
> to make this a less attractive target for exploit writers?

The proposed ABI does not require to store any function pointer. For a given
rseq_finish() critical section, pointers to specific instructions (within a
function) are emitted at link-time into a struct rseq_cs:

struct rseq_cs {
        RSEQ_FIELD_u32_u64(start_ip);
        RSEQ_FIELD_u32_u64(post_commit_ip);
        RSEQ_FIELD_u32_u64(abort_ip);
        uint32_t flags;
} __attribute__((aligned(4 * sizeof(uint64_t))));

Then, at runtime, the fast-path stores the address of that struct rseq_cs
into the TLS struct rseq "rseq_cs" field.

So all we store at runtime is a pointer to data, not a pointer to functions.

But you seem to hint that having a pointer to data containing pointers to code
may still be making it easier for exploit writers. Can you elaborate on the
scenario ?

Thanks,

Mathieu


> 
> Thanks,
> Florian

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [RFC PATCH v9 for 4.15 01/14] Restartable sequences system call
Date: Fri, 13 Oct 2017 15:56:15 +0200
Message-ID: <0043559c-c4e0-523a-b634-eded6ced886c@redhat.com>
References: <20171012230326.19984-1-mathieu.desnoyers@efficios.com>
 <20171012230326.19984-2-mathieu.desnoyers@efficios.com>
 <19edaac0-98d7-e7a0-aceb-b861a2befce4@redhat.com>
 <695804241.40580.1507902016119.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <695804241.40580.1507902016119.JavaMail.zimbra@efficios.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Josh Triplett <josh@joshtriplett.org>, Will Deacon <will.deacon@arm.com>, linux-kernel <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Catalin Marinas <catalin.>
List-Id: linux-api@vger.kernel.org

On 10/13/2017 03:40 PM, Mathieu Desnoyers wrote:
> The proposed ABI does not require to store any function pointer. For a given
> rseq_finish() critical section, pointers to specific instructions (within a
> function) are emitted at link-time into a struct rseq_cs:
> 
> struct rseq_cs {
>          RSEQ_FIELD_u32_u64(start_ip);
>          RSEQ_FIELD_u32_u64(post_commit_ip);
>          RSEQ_FIELD_u32_u64(abort_ip);
>          uint32_t flags;
> } __attribute__((aligned(4 * sizeof(uint64_t))));
> 
> Then, at runtime, the fast-path stores the address of that struct rseq_cs
> into the TLS struct rseq "rseq_cs" field.
> 
> So all we store at runtime is a pointer to data, not a pointer to functions.
> 
> But you seem to hint that having a pointer to data containing pointers to code
> may still be making it easier for exploit writers. Can you elaborate on the
> scenario ?

I'm concerned that the exploit writer writes a totally made up struct 
rseq_cs object into writable memory, along with function pointers, and 
puts the address of that in to the rseq_cs field.

This would be comparable to how C++ vtable pointers are targeted 
(including those in the glibc libio implementation of stdio streams).

Does this answer your questions?

Thanks,
Florian

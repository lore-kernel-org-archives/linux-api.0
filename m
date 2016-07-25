From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH v7 7/7] Restartable sequences: self-tests
Date: Mon, 25 Jul 2016 18:12:50 +0000 (UTC)
Message-ID: <2085982979.81688.1469470370270.JavaMail.zimbra@efficios.com>
References: <1469135662-31512-1-git-send-email-mathieu.desnoyers@efficios.com> <1469135662-31512-8-git-send-email-mathieu.desnoyers@efficios.com> <CO1PR15MB09822FC140F84DCEEF2004CDDD0B0@CO1PR15MB0982.namprd15.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CO1PR15MB09822FC140F84DCEEF2004CDDD0B0@CO1PR15MB0982.namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Watson <davejwatson@fb.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Peter Zijlstra <peterz@infradead.org>, Andy Lutomirski <luto@amacapital.net>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Boqun Feng <boqun.feng@gmail.com>
List-Id: linux-api@vger.kernel.org

----- On Jul 23, 2016, at 5:26 PM, Dave Watson davejwatson@fb.com wrote:

[...]

> +static inline __attribute__((always_inline))
> +bool rseq_finish(struct rseq_lock *rlock,
> + intptr_t *p, intptr_t to_write,
> + struct rseq_state start_value)
> +{
> + RSEQ_INJECT_C(9)
> +
> + if (unlikely(start_value.lock_state != RSEQ_LOCK_STATE_RESTART)) {
> + if (start_value.lock_state == RSEQ_LOCK_STATE_LOCK)
> + rseq_fallback_wait(rlock);
> + return false;
> + }
> +
> +#ifdef __x86_64__
> + /*
> + * The __rseq_table section can be used by debuggers to better
> + * handle single-stepping through the restartable critical
> + * sections.
> + */
> + __asm__ __volatile__ goto (
> + ".pushsection __rseq_table, \"aw\"\n\t"
> + ".balign 8\n\t"
> + "4:\n\t"
> + ".quad 1f, 2f, 3f\n\t"
> + ".popsection\n\t"

> Is there a reason we're also passing the start ip? It looks unused.
> I see the "for debuggers" comment, but it looks like all the debugger
> support is done in userspace.

I notice I did not answer this question. This __rseq_table section is
populated by struct rseq_cs elements. This has two uses:

1) Interface with the kernel: only fields "post_commit_ip" and "abort_ip"
   are currently used by the kernel. This is a "critical section descriptor".
   User-space stores a pointer to this descriptor in the struct rseq
   "rseq_cs" field to tell the kernel that it needs to handle the
   rseq assembly block critical section, and it is set back to 0 when
   exiting the critical section.

2) Interface for debuggers: all three fields are used: "start_ip",
   "post_commit_ip", and "abort_ip". When a debugger single-steps
   through the rseq assembly block by placing breakpoints at the
   following instruction (I observed this behavior with gdb on arm32),
   it needs to be made aware that, when single-stepping instructions
   between "start_ip" (included) and "post_commit_ip" (excluded), it
   should also place a breakpoint at "abort_ip", or single-stepping
   would be fooled by an abort.

On 32-bit and 64-bit x86, we can combine the structures for (1) and (2)
and only keep one structure for both. The assembly fast-path can therefore
use the address within the __rseq_table section as pointer to descriptor.

On 32-bit ARM, as an optimization, we keep two copies of this structure:
one is in the __rseq_table section (for debuggers), and the other is
placed near the instruction pointer, so a cheaper ip-relative "adr"
instruction can be used to calculate the address of the descriptor.

If my understanding if correct, you suggest we do the following instead:

struct rseq_cs {
        RSEQ_FIELD_u32_u64(post_commit_ip);
        RSEQ_FIELD_u32_u64(abort_ip);
};

struct rseq_debug_cs {
        struct rseq_cs rseq_cs;
        RSEQ_FIELD_u32_u64(start_ip);
};

So we put struct rseq_debug_cs elements within the __rseq_table section,
and only expose the struct rseq_cs part to the kernel ABI.

Thinking a bit more about this, I think we should use the start_ip in the
kernel too. The idea here is that the end of critical sections (user-space fast
path) currently looks like this tangled mess (e.g. x86-64):

                "cmpl %[start_event_counter], %[current_event_counter]\n\t"
                "jnz 3f\n\t"                         <--- branch in case of failure
                "movq %[to_write], (%[target])\n\t"  <--- commit instruction
                "2:\n\t"
                "movq $0, (%[rseq_cs])\n\t"
                "jmp %l[succeed]\n\t"                <--- jump over the failure path
                "3: movq $0, (%[rseq_cs])\n\t"

Where we basically need to jump over the failure path at the end of the
successful fast path, all because the failure path needs to be placed
at addresses greater or equal to the post_commit_ip.

In the kernel, if rather than testing for:

if ((void __user *)instruction_pointer(regs) < post_commit_ip) {

we could test for both start_ip and post_commit_ip:

if ((void __user *)instruction_pointer(regs) < post_commit_ip
    && (void __user *)instruction_pointer(regs) >= start_ip) {

We could perform the failure path (storing NULL into the rseq_cs
field of struct rseq) in C rather than being required to do it in
assembly at addresses >= to post_commit_ip, all because the kernel
would test whether we are within the assembly block address range
using both the lower and upper bounds (start_ip and post_commit_ip).

The extra check with start_ip in the kernel is only done in a slow
path (in the notify resume handler), and only if the rseq_cs field
of struct rseq is non-NULL (when the kernel actually preempts or
delivers a signal over a rseq critical section), so it should not
matter at all in terms of kernel performance.

Removing this extra jump from the user-space fast-path might not have
much impact on x86, but I expect it to be more important on
architectures like ARM32, where the architecture is less forgiving
when fed sub-optimal assembly.

Thoughts ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

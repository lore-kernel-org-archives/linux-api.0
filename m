From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [RFC PATCH 0/3] restartable sequences v2: fast user-space percpu
 critical sections
Date: Thu, 7 Apr 2016 09:43:33 -0700
Message-ID: <CALCETrVGo1Di3qamxx1NAFUSN_o=-HnYRDpeVp7zrQEBwe5u-g@mail.gmail.com>
References: <20151027235635.16059.11630.stgit@pjt-glaptop.roam.corp.google.com>
 <CALCETrW=3bZyC9d5tUoESEsNt-rc-uhNhZpgEgeSC8W4FAVYkg@mail.gmail.com>
 <20160407120254.GY3448@twins.programming.kicks-ass.net> <CALCETrV0vcYcnBrs0axykJD=_BM28wKWVMG6bMzK8zh8R3m5fg@mail.gmail.com>
 <20160407152432.GZ3448@twins.programming.kicks-ass.net> <CALCETrU5ZL6Jajc=9up-j86vY_Xtt-gTFjdQE0sB0d=d-CJZ6A@mail.gmail.com>
 <20160407155312.GA3448@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160407155312.GA3448-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Turner <commonly-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Apr 7, 2016 at 8:53 AM, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> On Thu, Apr 07, 2016 at 08:44:38AM -0700, Andy Lutomirski wrote:
>> On Thu, Apr 7, 2016 at 8:24 AM, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>> > On Thu, Apr 07, 2016 at 07:35:26AM -0700, Andy Lutomirski wrote:
>> >> What I meant was: rather than shoving individual values into the TLABI
>> >> thing, shove in a pointer:
>> >>
>> >> struct commit_info {
>> >>   u64 post_commit_rip;
>> >>   u32 cpu;
>> >>   u64 *event;
>> >>   // whatever else;
>> >> };
>> >>
>> >> and then put a commit_info* in TLABI.
>> >>
>> >> This would save some bytes in the TLABI structure.
>> >
>> > But would cost us extra indirections. The whole point was getting this
>> > stuff at a constant offset from the TLS segment register.
>>
>> I don't think the extra indirections would matter much.  The kernel
>> would have to chase the pointer, but only in the very rare case where
>> it resumes userspace during a commit or on the immediately following
>> instruction.
>
> Its about userspace finding these values, not the kernel.

But userspace never reads post_commit_rip or the abort address AFAIK.

>
>> At the very least, post_commit_rip and the abort address (which I
>> forgot about) could both live in a static structure,
>
> Paul keeps the abort address in rcx.

So it's probably a wash.  Paul's way is to load the abort address in
rcx (one instruction, no memory access) and to put post_commit_rip in
TLABI (one store).  Mine is to put a pointer to a descriptor into
TLABI (one store).  Should barely matter.

>
>> and shoving a
>> pointer to *that* into TLABI space is one store instead of two.
>
>> > Ah, so what happens if the signal happens before the commit but after
>> > the load of the seqcount?
>> >
>> > Then, even if the signal motifies the count, we'll not observe.
>> >
>>
>> Where exactly?
>>
>> In my scheme, nothing except the kernel ever loads the seqcount.  The
>> user code generates a fresh value, writes it to memory, and then, just
>> before commit, writes that same value to the TLABI area and then
>> double-checks that the value it wrote at the beginning is still there.
>>
>> If the signal modifies the count, then the user code won't directly
>> notice, but prepare_exit_to_usermode on the way out of the signal will
>> notice that the (restored) TLABI state doesn't match the counter that
>> the signal handler changed and will just to the abort address.
>
>
> OK, you lost me..  commit looks like:
>
> +       __asm__ __volatile__ goto (
> +                       "movq $%l[failed], %%rcx\n"
> +                       "movq $1f, %[commit_instr]\n"
> +                       "cmpq %[start_value], %[current_value]\n"
>
> If we get preempted/signaled here without the preemption/signal entry
> checking for the post_commit_instr, we'll fail hard.

Not if I'm thinking about this right.  Because, in my scheme, we'd be
storing both the address of the counter [1] and the value that we
expect it to be (current_value?  something's confused in the asm or
the variable naming, or I'm just not following exactly which variable
is which) in registers or TLABI, and the kernel would notice that
*counter != expected_counter when it resumes and would send us to the
abort label.

Presumably there would be one register hard-coded as the expected
counter value and another register hard-coded as the address of the
counter.  That would avoid a bunch of stores to TLABI, and the kernel
could still find them.  If the C optimizer did a good job, the
resulting code would be simple.

[1] In my scheme, there would be no reason for the counter to live in
TLABI.  In contrast, there would be an excellent reason for it to
*not* live in TLABI -- user code could have more than one set of
counters, and they wouldn't interfere with each other.  This would be
nice if one of them protects something that uses long enough code in
the critical sections that it's likely to be preempted.

>
> +                       "jnz %l[failed]\n"
> +                       "movq %[to_write], (%[target])\n"
> +                       "1: movq $0, %[commit_instr]\n"
> +         : /* no outputs */
> +         : [start_value]"d"(start_value.storage),
> +           [current_value]"m"(__rseq_state),
> +           [to_write]"r"(to_write),
> +           [target]"r"(p),
> +           [commit_instr]"m"(__rseq_state.post_commit_instr)
> +         : "rcx", "memory"
> +         : failed
> +       );


More concretely, this looks like (using totally arbitrary register
assingments -- probably far from ideal, especially given how GCC's
constraints work):

enter the critical section:
1:
movq %[cpu], %%r12
movq {address of counter for our cpu}, %%r13
movq {some fresh value}, (%%r13)
cmpq %[cpu], %%r12
jne 1b

... do whatever setup or computation is needed...

movq $%l[failed], %%rcx
movq $1f, %[commit_instr]
cmpq {whatever counter we chose}, (%%r13)
jne %l[failed]
cmpq %[cpu], %%r12
jne %l[failed]

<-- a signal in here that conflicts with us would clobber (%%r13), and
the kernel would notice and send us to the failed label

movq %[to_write], (%[target])
1: movq $0, %[commit_instr]

In contrast to Paul's scheme, this has two additional (highly
predictable) branches and requires generation of a seqcount in
userspace.  In its favor, though, it doesnt need preemption hooks,
it's inherently debuggable, and it allows multiple independent
rseq-protected things to coexist without forcing each other to abort.

The first cmpq might not be necessary.  I put it there to ensure that
"some fresh value" is visible on the chosen CPU before any other loads
happen, but it's possible that the other cpu double-check is enough.


(Off topic: some of those movq instructions should probably be
rip-relative leaq instead.)

If my descriptor approach were used, we'd save the write to rcx.
Instead we'd do:

.pushsection .rodata
2:
.quad %l[failed] - .  /* or similar */
.quad 1b - .
.popsection
leaq 2b(%rip), %[tlabi_rseq_desc]

That's the optimization I was talking about above, although I did a
bad job of describing it.

--Andy

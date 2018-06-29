From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH for 4.18 1/2] rseq: validate rseq_cs fields are <
 TASK_SIZE
Date: Fri, 29 Jun 2018 12:07:12 -0400 (EDT)
Message-ID: <247789350.9741.1530288432573.JavaMail.zimbra@efficios.com>
References: <20180628162359.9054-1-mathieu.desnoyers@efficios.com> <9200ED2A-AE4B-4094-81C9-E92240B4840F@amacapital.net> <CA+55aFzpD5xF80iiFNd+EMkJnRQdKPumM5p24Sr+LeBt8Gg=wg@mail.gmail.com> <1706339668.9644.1530281144560.JavaMail.zimbra@efficios.com> <CA+55aFxRJWjbgLeSQ_swi3F5nF1SYgZnC-R7QsOvZdcuSaWeaw@mail.gmail.com> <729451355.9702.1530284622326.JavaMail.zimbra@efficios.com> <CA+55aFw==YnFJn7iGnKMW=RbPT74YHNa0QDF96mEdMPA2oX9SA@mail.gmail.com> <CA+55aFwJWxsE_LL=-8WgB7uH_mYeMSu=boWF4N5KdOW673g4hA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFwJWxsE_LL=-8WgB7uH_mYeMSu=boWF4N5KdOW673g4hA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deaco>
List-Id: linux-api@vger.kernel.org

----- On Jun 29, 2018, at 11:54 AM, Linus Torvalds torvalds@linux-foundation.org wrote:

> On Fri, Jun 29, 2018 at 8:27 AM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> You simply can't have it both ways.
> 
> Put another way.
> 
> This is ok in the native path:
> 
>        if ((unsigned long) rseq_cs->abort_ip != rseq_cs->abort_ip)
>                return -EINVAL;
> 
> because it's checking that the value fits in the native register size
> (and it also ends up being a no-op if the native size is the same size
> as abort_ip).
> 
> And this is very much ok in a compat syscall:
> 
>        if (rseq_cs->abort_ip & ~(unsigned long)-1u)
>                return -EINVAL;
> 
> because it's checking that the pointer doesn't have (invalid in
> compat) high bits set.
> 
> But it is NOT OK to say "the rseq system call doesn't have any compat
> syscall, but we'll do that compat check in the native case, because we
> worry about compat issues".
> 
> See what I'm saying? Either you worry about compat issues (and have a
> compat syscall), or you don't.
> 
> The whole "let's not do a compat syscall, but then check compat issues
> at run-time in the native system call because compat processes will
> use it" is braindamage.

This code is not invoked from syscalls, but rather on return from
interrupt/trap after a preemption.

So a compat system call does not solve it. Unless we grab the "compat"
state on rseq registration, save it in a rseq_compat flag within the
task struct, and then use it on return from interrupt/trap/syscall.
Otherwise we need to figure out whether we are dealing with a compat
task when interrupt and trap context return to userspace. We had
is_compat_task() for that before, but now it has vanished from x86.
We could use user_64bit_mode(struct pt_regs *) on x86, but it does not
exist on other architectures.

One possibility is to introduce a new API that calls user_64bit_mode()
on x86, and is_compat_task() on other archs.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

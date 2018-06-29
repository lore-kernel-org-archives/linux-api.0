From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [RFC PATCH for 4.18 1/2] rseq: validate rseq_cs fields are < TASK_SIZE
Date: Fri, 29 Jun 2018 09:07:36 -0700
Message-ID: <CALCETrW_Uj22bpFD09_ESXi-6Xs2v=YRq+rPeExRa+Uqqte8Aw@mail.gmail.com>
References: <20180628162359.9054-1-mathieu.desnoyers@efficios.com>
 <CA+55aFxZrv9koOGKNzpBjcpzwaKQBg9ybqcvQ9u=5d94y1F+mQ@mail.gmail.com>
 <CALCETrUrXk3wRg8SKhWf98v8jK=HwX9XLvP+Ypi+TktZoNx_Jg@mail.gmail.com>
 <CA+55aFzxCjkSbfRUeX3W_oXSJ6LMUdRVYB=DR2b3rUNkiixM1A@mail.gmail.com>
 <9200ED2A-AE4B-4094-81C9-E92240B4840F@amacapital.net> <CA+55aFzpD5xF80iiFNd+EMkJnRQdKPumM5p24Sr+LeBt8Gg=wg@mail.gmail.com>
 <1706339668.9644.1530281144560.JavaMail.zimbra@efficios.com>
 <CA+55aFxRJWjbgLeSQ_swi3F5nF1SYgZnC-R7QsOvZdcuSaWeaw@mail.gmail.com>
 <729451355.9702.1530284622326.JavaMail.zimbra@efficios.com> <CA+55aFw==YnFJn7iGnKMW=RbPT74YHNa0QDF96mEdMPA2oX9SA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFw==YnFJn7iGnKMW=RbPT74YHNa0QDF96mEdMPA2oX9SA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Andrew Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Catalin Marinas <catalin.marinas@arm.com>, Will
List-Id: linux-api@vger.kernel.org

On Fri, Jun 29, 2018 at 8:27 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Fri, Jun 29, 2018, 08:03 Mathieu Desnoyers
> <mathieu.desnoyers@efficios.com> wrote:
>>
>>
>> Considering those inconsistencies between architectures (either
>> the task gets killed, or the top bits are silently cleared), I'm
>> very much tempted to be restrictive in the inputs accepted by
>> rseq, and not rely on architectures as providing consistent
>> validation of the return IP.
>>
>> Thoughts ?
>
>
> Then you need to make it a compat system call, since clearly you and Andy
> want the 32-bit case to do something different from the 64-bit case.

I personally would like the compat and non-compat cases to do exactly
the same thing.  If abort_ip is the address (as a u64) of a valid
executable instruction and an abort happens, then that instruction
should get executed.  If abort_ip does not point to user-executable
memory, then the process should get a signal.

The problem isn't with rseq per se -- it's with the daft way that the
x86 return-to-userspace instructions work.  If I apply this patch:

diff --git a/arch/x86/entry/common.c b/arch/x86/entry/common.c
index 3b2490b81918..26e4ba44e87b 100644
--- a/arch/x86/entry/common.c
+++ b/arch/x86/entry/common.c
@@ -346,6 +346,8 @@ __visible void do_int80_syscall_32(struct pt_regs *regs)
 {
        enter_from_user_mode();
        local_irq_enable();
+       if (!user_64bit_mode(regs))
+               regs->ip |= (1UL << 32);
        do_syscall_32_irqs_on(regs);
 }

the kernel *still works*.  But this unconditionally uses the IRET
path, and I don't even want to speculate as to what the hell happens
if we exit using SYSRETL, or LRET, or SYSEXITL, or if Intel or AMD
ever gives us a new mode that gets rid of the espfix shite.  IOW, I
don't think that the x86 entry code should make a promise that it will
continue ignoring the high bits of regs->ip when
!user_64bit_mode(regs) on a 64-bit kernel.

The problem with rseq as it stands is that this oddity gets
accidentally exposed all the way to userspace.  If we're not careful,
it'll be possible for a slightly buggy user program to goof up the
code that generates the data structure that supplies abort_ip such
that the high bits are garbage (0xcccccccc due to padding, for
example), and the kernel will do exactly what the user code requested,
and we'll get regs->ip = 0xcccccccc00000000 | (the actual intended
abort_ip), and we'll pass that crap value all the way to IRET, and
IRET will truncate it back down to the correct value.  And then some
CPU will add new behavior or we'll invoke SYSRETL or whatever on some
weird CPU, and the program will crash.  And we'll be sad.

I suppose we could handle this in the entry code by coming up with a
way to reject out-of-bounds regs->ip for 32-bit tasks, but that's
going to be a bit messy and will slow down normal code that doesn't
use rseq.

Other than rseq, I don't think that there's any real issue.  The only
ways to get regs->ip >= 2^32 in a 32-bit task involve ptrace or manual
fiddling with signal contexts, and I don't expect to ever have any
real software depend on precisely what happens.

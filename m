From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [RFC PATCH v1] pin_on_cpu: Introduce thread CPU pinning system call
Date: Thu, 30 Jan 2020 12:10:00 +0100
Message-ID: <87blql5hfb.fsf@oldenburg2.str.redhat.com>
References: <20200121160312.26545-1-mathieu.desnoyers@efficios.com>
        <430172781.596271.1579636021412.JavaMail.zimbra@efficios.com>
        <CAG48ez2Z5CesMfandNK+S32Rrgp_QGQHqQ1Fpd5-YTsCWGfHeg@mail.gmail.com>
        <2049164886.596497.1579641536619.JavaMail.zimbra@efficios.com>
        <alpine.DEB.2.21.2001212141590.1231@www.lameter.com>
        <1648013936.596672.1579655468604.JavaMail.zimbra@efficios.com>
        <ead7a565-9a23-a7d7-904d-c4860f63952a@zytor.com>
        <87a76efuux.fsf@oldenburg2.str.redhat.com>
        <134428560.600911.1580153955842.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <134428560.600911.1580153955842.JavaMail.zimbra@efficios.com>
        (Mathieu Desnoyers's message of "Mon, 27 Jan 2020 14:39:15 -0500
        (EST)")
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Chris Lameter <cl@linux.com>, Jann Horn <jannh@google.com>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, linux-kernel <linux-kernel@vger.kernel.org>, Joel Fernandes <joelaf@google.com>, Ingo Molnar <mingo@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>, Dave Watson <davejwatson@fb.com>, Will Deacon <will.deacon@arm.com>, shuah <shuah@kernel.org>, Andi Kleen <andi@firstfloor.org>, linux-kselftest <linux-kselftest@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>, Michael Kerrisk <mtk.manpages@gmail.com>, Paul <paulmck@linux.vnet.ibm.com>, Paul Turner <pjt@google.com>, Boqun Feng <boqun.feng@gmail.com>, Josh Triplett <josh@joshtriplett.org>, rostedt <rostedt@goodmis.org>, Be
List-Id: linux-api@vger.kernel.org

* Mathieu Desnoyers:

> It brings an interesting idea to the table though. Let's assume for now that
> the only intended use of pin_on_cpu(2) would be to allow rseq(2) critical
> sections to update per-cpu data on specific cpu number targets. In fact,
> considering that userspace can be preempted at any point, we still need a
> mechanism to guarantee atomicity with respect to other threads running on
> the same runqueue, which rseq(2) provides. Therefore, that assumption does
> not appear too far-fetched.
>
> There are 2 scenarios we need to consider here:
>
> A) pin_on_cpu(2) targets a CPU which is not part of the affinity mask.
>
> This case is easy: pin_on_cpu can return an error, and the caller needs to act
> accordingly (e.g. figure out that this is a design error and report it, or
> decide that it really did not want to touch that per-cpu data that badly and
> make the entire process fall-back to a mechanism which does not use per-cpu
> data at all from that point onwards)

Affinity masks currently are not like process memory: there is an
expectation that they can be altered from outside the process.

Given that the caller may not have any ways to recover from the
suggested pin_on_cpu behavior, that seems problematic.

What I would expect is that if pin_on_cpu cannot achieve implied
exclusion by running on the associated CPU, it acquires a lock that
prevents others pin_on_cpu calls from entering the critical section, and
tasks in the same task group from running on that CPU (if the CPU
becomes available to the task group).  The second part should maintain
exclusion of rseq sequences even if their fast path is not changed.

(On the other hand, I'm worried that per-CPU data structures are a dead
end for user space unless we get containerized affinity masks, so that
contains only see resources that are actually available to them.)

Thanks,
Florian

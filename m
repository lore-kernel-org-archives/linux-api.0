From: Daniel Colascione <dancol@google.com>
Subject: Re: [RFC PATCH for 4.18 00/14] Restartable Sequences
Date: Thu, 03 May 2018 17:18:58 +0000
Message-ID: <CAKOZueve1K8bmS0pmeCAAburoJtzRA4DeN=OCyW3kHiNo8WO=A@mail.gmail.com>
References: <20180430224433.17407-1-mathieu.desnoyers@efficios.com>
 <CAKOZuesa338sc_=w6-wvro25idrSN_zx_zrHFyo-bDiORs7FZw@mail.gmail.com>
 <660904075.9201.1525276988842.JavaMail.zimbra@efficios.com>
 <CAKOZueu_7Ha_WXMyxqMEScXo1aHWr9qYRxqyb-Rpd4k1JP3xHA@mail.gmail.com>
 <1718748931.10084.1525363941807.JavaMail.zimbra@efficios.com> <CAJWu+opXjYrjrz1=k0TjjCqiYQ0y=6jRMiRWNvb8_dHAtSByug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAJWu+opXjYrjrz1=k0TjjCqiYQ0y=6jRMiRWNvb8_dHAtSByug@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joel Fernandes <joelaf@google.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Peter Zijlstra <peterz@infradead.org>, Paul McKenney <paulmck@linux.vnet.ibm.com>, boqun.feng@gmail.com, luto@amacapital.net, davejwatson@fb.com, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, linux@arm.linux.org.uk, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, Andrew Hunter <ahh@google.com>, andi@firstfloor.org, cl@linux.com, bmaurer@fb.com, rostedt@goodmis.org, josh@joshtriplett.org, torvalds@linux-foundation.org, catalin.marinas@arm.com, will.deacon@arm.com, Michael Kerrisk-manpages <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

On Thu, May 3, 2018 at 9:48 AM Joel Fernandes <joelaf@google.com> wrote:
> > > can skip the manual schedule we were going to perform.

> > By the way, if we eventually find a way to enhance user-space mutexes in
> the
> > fashion you describe here, it would belong to another TLS area, and
would
> > be registered by another system call than rseq. I proposed a more
generic

> Right. Also I still don't see any good reason why optimistic spinning in
> the kernel with FUTEX_LOCK, as Peter described, can't be used instead of
> using the rseq implementation and spinning in userspace, for such a case.
I
> don't really fully buy that we need to design this interface assuming any
> privilege transition level time.

> If privilege level transitions are slow,
> we're going to have bad performance anyway.

That's not the case. There's a large class of program that does useful work
while seldom entering the kernel: just ask the user-space network stack
people.

It's not wise to design interfaces around system calls being cheap. Even if
system calls are currently cheap enough on some architectures some of the
time, there's no guarantee that they'll stay that way, especially relative
to straight-line user-mode execution. A pure user-space approach, on the
other hand, involves no work in the kernel, and doing nothing is always the
optimal strategy. Besides, there are environments where system calls end up
being more expensive than you might think: consider strace or rr. If the
kernel needs to get involved on some path, it's best that its involvement
be as light as possible.

> we should really stick to using FUTEX_LOCK and
> reuse all the work that went into that area for Android and otherwise (and
> work with Waiman and others on improving that if there are any problems
> with it).

FUTEX_LOCK is a return to the bad old days when systems gave you a fixed
list of synchronization primitives and if you wanted something else, tough.
That the latest version of the FUTEX_LOCK patch includes a separate
FUTEX_LOCK_SHARED mode is concerning. The functionality the kernel provides
to userspace should be more general-purpose and allow more experimentation
without changes in the kernel. I see no reason to force userspace into 1)
reserving 30 bits of its lockword for a TID and 2) adopting the kernel's
idea of spin time heuristics and lock stealing when the same basic
functionality can be provided in a generic way while reserving only one
bit. That this mechanism happens to be more efficient as well is a bonus.

"Mechanism not policy" is still a good design principle.

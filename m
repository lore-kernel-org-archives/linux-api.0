From: Daniel Colascione <dancol@google.com>
Subject: Re: [RFC PATCH for 4.18 00/14] Restartable Sequences
Date: Wed, 02 May 2018 16:55:44 +0000
Message-ID: <CAKOZuetA0A8ML9V23aoFPSGqFiVgJ4enBTmjR2HEL7hE1QAJiQ@mail.gmail.com>
References: <20180430224433.17407-1-mathieu.desnoyers@efficios.com>
 <CAKOZuesa338sc_=w6-wvro25idrSN_zx_zrHFyo-bDiORs7FZw@mail.gmail.com>
 <660904075.9201.1525276988842.JavaMail.zimbra@efficios.com>
 <CAKOZueu_7Ha_WXMyxqMEScXo1aHWr9qYRxqyb-Rpd4k1JP3xHA@mail.gmail.com> <20180502124253.145253cb@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180502124253.145253cb@gandalf.local.home>
Sender: linux-kernel-owner@vger.kernel.org
To: rostedt@goodmis.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Peter Zijlstra <peterz@infradead.org>, Paul McKenney <paulmck@linux.vnet.ibm.com>, boqun.feng@gmail.com, luto@amacapital.net, davejwatson@fb.com, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, linux@arm.linux.org.uk, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, Andrew Hunter <ahh@google.com>, andi@firstfloor.org, cl@linux.com, bmaurer@fb.com, josh@joshtriplett.org, torvalds@linux-foundation.org, catalin.marinas@arm.com, will.deacon@arm.com, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Joel Fernandes <joelaf@google.com>
List-Id: linux-api@vger.kernel.org

On Wed, May 2, 2018 at 9:42 AM Steven Rostedt <rostedt@goodmis.org> wrote:

> On Wed, 02 May 2018 16:07:48 +0000
> Daniel Colascione <dancol@google.com> wrote:

> > Why couldn't we take a page fault just before schedule? The reason we
can't
> > take a page fault in atomic context is that doing so might call
schedule.
> > Here, we're about to call schedule _anyway_, so what harm does it do to
> > call something that might call schedule? If we schedule via that call,
we
> > can skip the manual schedule we were going to perform.

> Another issue is slowing down something that is considered a fast path.

There are two questions: 1) does this feature slow down schedule when
you're not using it? and 2) is schedule unacceptably slow when you are
using this feature?

The answer to #1 is no; rseq already tests current->rseq during task switch
(via rseq_set_notify_resume), so adding a single further branch (which we'd
only test when we follow the current->rseq path anyway) isn't a problem.

Regarding #2: yes, a futex operation will increase path length for that one
task switch, but in the no-page-fault case, only by a tiny amount. We can
run benchmarks of course, but I don't see any reason to suspect that the
proposal would make task switching unacceptably slow. If we *do* take a
page fault, we won't have done much additional work overall, since
*somebody* is going to take that page fault anyway when the lock is
released, and the latency of the task switch shouldn't increase, since the
futex code will very quickly realize that it needs to sleep and call
schedule anyway.

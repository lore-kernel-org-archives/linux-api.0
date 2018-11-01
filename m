From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH for 4.21 03/16] mm: Replace BUG_ON() by WARN_ON() in vm_unmap_ram()
Date: Thu, 1 Nov 2018 15:00:34 -0700
Message-ID: <CAHk-=wiOm8x5KnBQH+FYN76sSjCeP2_9cxgzu4WArR3jP0MD8g@mail.gmail.com>
References: <20181101095844.24462-1-mathieu.desnoyers@efficios.com>
 <20181101095844.24462-4-mathieu.desnoyers@efficios.com> <alpine.DEB.2.21.1811011320160.1642@nanos.tec.linutronix.de>
 <20181101144623.61d43102@gandalf.local.home> <278477314.3995.1541102273591.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <278477314.3995.1541102273591.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: rostedt@goodmis.org, tglx@linutronix.de, Peter Zijlstra <peterz@infradead.org>, Paul McKenney <paulmck@linux.vnet.ibm.com>, boqun.feng@gmail.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, luto@amacapital.net, davejwatson@fb.com, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, linux@arm.linux.org.uk, Ingo Molnar <mingo@redhat.com>, Peter Anvin <hpa@zytor.com>, andi@firstfloor.org, Christoph Lameter <cl@linux.com>, bmaurer@fb.com, josh@joshtriplett.org, Catalin Marinas <catalin.marinas@arm.com>, will.deacon@arm.com, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Joel Fernandes <joelaf@google.com>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, mawilcox@microsoft.com
List-Id: linux-api@vger.kernel.org

On Thu, Nov 1, 2018 at 12:57 PM Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
>
> > I think the graceful recovery is to simply return:
> >
> >       if (WARN_ON(cond))
> >               return;
> >
> > is better than just
> >
> >       BUG_ON(cond);
> >
> > As that's what Linus made pretty clear at the Maintainer's Summit.
>
> That's it. For an unmap function, this basically boils down to
> print a warning and leak the memory on internal unmap error.
>
> I will update the commit message describing this behavior.

It might be even better to use WARN_ON_ONCE().

If it's a "this shouldn't happen" situation, the advantage of
WARN_ON_ONCE() is that it will still show the backtrace of the "how
the heck did it happen after all" situation, but if it turns ouit to
be user-triggerable (or simply triggerable by some odd hw situation),
it won't spam your logs forever.

Obviously, things like rate limiting etc can also be good ideas, but
that's just overkill for "this really should never happen" cases.

(Side note: WARN_ON_ONCE() will _warn_ just once, but will always
return the condition that it warns for, so the return value is _not_
"I have warned", but "I have seen the condition that I should warn
about". Just in case people are worried about it).

                  Linus

From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH for 4.18 00/14] Restartable Sequences
Date: Wed, 2 May 2018 10:43:28 +0200
Message-ID: <20180502084328.GE12180@hirez.programming.kicks-ass.net>
References: <20180430224433.17407-1-mathieu.desnoyers@efficios.com>
 <CAKOZuesa338sc_=w6-wvro25idrSN_zx_zrHFyo-bDiORs7FZw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKOZuesa338sc_=w6-wvro25idrSN_zx_zrHFyo-bDiORs7FZw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Colascione <dancol@google.com>
Cc: mathieu.desnoyers@efficios.com, paulmck@linux.vnet.ibm.com, boqun.feng@gmail.com, luto@amacapital.net, davejwatson@fb.com, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, pjt@google.com, Andrew Morton <akpm@linux-foundation.org>, linux@arm.linux.org.uk, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, Andrew Hunter <ahh@google.com>, andi@firstfloor.org, cl@linux.com, bmaurer@fb.com, rostedt@goodmis.org, josh@joshtriplett.org, torvalds@linux-foundation.org, catalin.marinas@arm.com, will.deacon@arm.com, mtk.manpages@gmail.com, Joel Fernandes <joelaf@google.com>
List-Id: linux-api@vger.kernel.org

On Wed, May 02, 2018 at 03:53:47AM +0000, Daniel Colascione wrote:
> The usual approach to "better" is an "adaptive mutex". Such a thing, when
> it attempts to acquire a lock another thread owns, spins for some number of
> iterations, then falls back to futex. I guess that's a little better than
> immediately jumping to futex, but it's not optimal. We can still spin when
> the lock owner isn't scheduled, and the spin count is usually some guess
> (either specified manually or estimated statistically) that's not
> guaranteed to produce decent results. Even if we do pick a good spin count,
> we run a very good chance of under- or over-spinning on any given
> lock-acquire. We always want to sleep when spinning would be pointless.

Look for the FUTEX_LOCK patches from Waiman.

From: Christopher Lameter <cl@linux.com>
Subject: Re: [RFC PATCH for 4.17 02/21] rseq: Introduce restartable sequences
 system call (v12)
Date: Mon, 2 Apr 2018 10:03:58 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1804021000290.23911@nuc-kabylake>
References: <20180327160542.28457-1-mathieu.desnoyers@efficios.com> <20180327160542.28457-3-mathieu.desnoyers@efficios.com> <20180401171356.085a2a33@alans-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180401171356.085a2a33@alans-desktop>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.>
List-Id: linux-api@vger.kernel.org

On Sun, 1 Apr 2018, Alan Cox wrote:

> >        Restartable sequences are atomic  with  respect  to  preemption
> >        (making  it atomic with respect to other threads running on the
> >        same CPU), as well as  signal  delivery  (user-space  execution
> >        contexts nested over the same thread).
>
> CPU generally means 'big lump with legs on it'. You are not atomic to the
> same CPU, because that CPU may have 30+ cores with 8 threads per core.
>
> It could do with some better terminology (hardware thread, CPU context ?)

Well we call it a "CPU" in the scheduler context I think.  We could use
better terminology throughout the kernel tools and source.

Hardware Execution Context?

> >        In  a  typical  usage scenario, the thread registering the rseq
> >        structure will be performing  loads  and  stores  from/to  that
> >        structure.  It  is  however also allowed to read that structure
> >        from other threads.  The rseq field updates  performed  by  the
> >        kernel  provide  relaxed  atomicity  semantics, which guarantee
> >        that other threads performing relaxed atomic reads of  the  cpu
> >        number cache will always observe a consistent value.
>
> So what happens to your API if the kernel atomics get improved ? You are
> effectively exporting rseq behaviour from private to public.

There is already a pretty complex coherency model guiding kernel atomics.
Improvements/changes to that are difficult and the effect will ripple
throughout the kernel. So I would suggest that these areas of the kernel
are pretty "petrified" (or written in stone).

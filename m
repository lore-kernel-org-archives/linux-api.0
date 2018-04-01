From: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: [RFC PATCH for 4.17 02/21] rseq: Introduce restartable
 sequences system call (v12)
Date: Sun, 1 Apr 2018 17:13:56 +0100
Message-ID: <20180401171356.085a2a33@alans-desktop>
References: <20180327160542.28457-1-mathieu.desnoyers@efficios.com>
        <20180327160542.28457-3-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180327160542.28457-3-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>
List-Id: linux-api@vger.kernel.org

On Tue, 27 Mar 2018 12:05:23 -0400
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> Expose a new system call allowing each thread to register one userspace
> memory area to be used as an ABI between kernel and user-space for two
> purposes: user-space restartable sequences and quick access to read the
> current CPU number value from user-space.

What is the *worst* case timing achievable by using the atomics ? What
does it do to real time performance requirements ? For cpu_opv you now
give an answer but your answer is assuming there isn't another thread
actively thrashing the cache or store buffers, and that the user didn't
sneakily pass in a page of uncacheable memory (eg framebuffer, or GPU
space).

I don't see anything that restricts it to cached pages. With that check
in place for x86 at least it would probably be ok and I think the sneaky
attacks to make it uncacheable would fail becuase you've got the pages
locked so trying to give them to an accelerator will block until you are
done.

I still like the idea it's just the latencies concern me.

>        Restartable sequences are atomic  with  respect  to  preemption
>        (making  it atomic with respect to other threads running on the
>        same CPU), as well as  signal  delivery  (user-space  execution
>        contexts nested over the same thread).

CPU generally means 'big lump with legs on it'. You are not atomic to the
same CPU, because that CPU may have 30+ cores with 8 threads per core.

It could do with some better terminology (hardware thread, CPU context ?)

>        In  a  typical  usage scenario, the thread registering the rseq
>        structure will be performing  loads  and  stores  from/to  that
>        structure.  It  is  however also allowed to read that structure
>        from other threads.  The rseq field updates  performed  by  the
>        kernel  provide  relaxed  atomicity  semantics, which guarantee
>        that other threads performing relaxed atomic reads of  the  cpu
>        number cache will always observe a consistent value.

So what happens to your API if the kernel atomics get improved ? You are
effectively exporting rseq behaviour from private to public.

Alan

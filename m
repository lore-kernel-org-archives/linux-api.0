From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH v4 1/5] glibc: Perform rseq(2) registration at nptl
 init and thread creation
Date: Mon, 26 Nov 2018 14:22:05 -0500 (EST)
Message-ID: <2125113706.12987.1543260125953.JavaMail.zimbra@efficios.com>
References: <20181121183936.8176-1-mathieu.desnoyers@efficios.com> <865273158.11687.1542995541389.JavaMail.zimbra@efficios.com> <20181123183558.GM23599@brightrain.aerifal.cx> <1758017676.12041.1543007347347.JavaMail.zimbra@efficios.com> <87bm6cqm31.fsf@oldenburg.str.redhat.com> <688718071.12798.1543247469553.JavaMail.zimbra@efficios.com> <874lc3omh5.fsf@oldenburg.str.redhat.com> <20181126171045.GQ23599@brightrain.aerifal.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181126171045.GQ23599@brightrain.aerifal.cx>
Sender: linux-kernel-owner@vger.kernel.org
To: Rich Felker <dalias@libc.org>
Cc: Florian Weimer <fweimer@redhat.com>, carlos <carlos@redhat.com>, Joseph Myers <joseph@codesourcery.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

----- On Nov 26, 2018, at 12:10 PM, Rich Felker dalias@libc.org wrote:

> On Mon, Nov 26, 2018 at 05:03:02PM +0100, Florian Weimer wrote:
>> * Mathieu Desnoyers:
>> 
>> > So let's make __rseq_abi and __rseq_refcount strong symbols then ?
>> 
>> Yes, please.  (But I'm still not sure we need the reference counter.)
> 
> The reference counter is needed for out-of-libc implementations
> interacting and using the dtor hack. An in-libc implementation doesn't
> need to inspect/honor the reference counter, but it does seem to need
> to indicate that it has a reference, if you want it to be compatible
> with out-of-libc implementations, so that the out-of-libc one will not
> unregister the rseq before libc is done with it.

Let's consider two use-cases here: one (simpler) is use of rseq TLS
from thread context by out-of-libc implementations. The other is use of
rseq TLS from signal handler by out-of-libc implementations.

If we only care about users of rseq from thread context, then libc
could simply set the refcount value to 1 on thread start,
and should not care about the value on thread exit. The libc can
either directly call rseq unregister, or rely on thread calling exit
to implicitly unregister rseq, which depends on its own TLS life-time
guarantees. For instance, if the IE-model TLS is valid up until call
to exit, just calling the exit system call is fine. However, if a libc
has a window at thread exit during which the kernel can preempt the
thread with the IE-model TLS area being already reclaimed, then it
needs to explicitly call rseq unregister before freeing the TLS.

The second use-case is out-of-libc implementations using rseq from
signal handler. This one is trickier. First, pthread_key setspecific
is unfortunately not async-signal-safe. I can't find a good way to
seamlessly integrate rseq into out-of-libc signal handlers while
performing lazy registration without races on thread exit. If we
figure out a way to do this though, we should increment the refcount
at thread start in libc (rather than just set it to 1) in case a
signal handler gets nested immediately over the start of the thread
and registers rseq as well.

It looks like it's not the only issue I have with calling lttng-ust
instrumentation from signal handlers, here is the list I have so
far:

* glibc global-dynamic TLS variables are not async-signal-safe,
  and lttng-ust cannot use IE-model TLS because it is meant to be
  dlopen'd,
* pthread_setspecific is not async-signal-safe,

There should be ways to eventually solve those issues, but it would
be nice if for now the way rseq is implemented in libc does not add
yet another limitation for signal handlers.

> 
> Alternatively another protocol could be chosen for this purpose, but
> if has to be something stable and agreed upon, since things would
> break badly if libc and the library providing rseq disagreed.

Absolutely. We need to agree on that protocol before user-space
applications/libraries start using rseq.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

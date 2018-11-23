From: Rich Felker <dalias@libc.org>
Subject: Re: [RFC PATCH v4 1/5] glibc: Perform rseq(2) registration at nptl
 init and thread creation
Date: Fri, 23 Nov 2018 12:30:19 -0500
Message-ID: <20181123173019.GK23599@brightrain.aerifal.cx>
References: <20181121183936.8176-1-mathieu.desnoyers@efficios.com>
 <686626451.10113.1542901620250.JavaMail.zimbra@efficios.com>
 <87wop5xeit.fsf@oldenburg.str.redhat.com>
 <1045257294.10291.1542905262086.JavaMail.zimbra@efficios.com>
 <87k1l5xd33.fsf@oldenburg.str.redhat.com>
 <20181122171010.GH23599@brightrain.aerifal.cx>
 <871s7cvt1l.fsf@oldenburg.str.redhat.com>
 <20181123142843.GJ23599@brightrain.aerifal.cx>
 <1150466925.11664.1542992720871.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <libc-alpha-return-97506-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
Content-Disposition: inline
In-Reply-To: <1150466925.11664.1542992720871.JavaMail.zimbra@efficios.com>
Sender: Rich Felker <dalias@aerifal.cx>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Florian Weimer <fweimer@redhat.com>, carlos <carlos@redhat.com>, Joseph Myers <joseph@codesourcery.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Nov 23, 2018 at 12:05:20PM -0500, Mathieu Desnoyers wrote:
> ----- On Nov 23, 2018, at 9:28 AM, Rich Felker dalias@libc.org wrote:
> [...]
> > 
> > Absolutely. As long as it's in libc, implicit destruction will happen.
> > Actually I think the glibc code shound unconditionally unregister the
> > rseq address at exit (after blocking signals, so no application code
> > can run) in case a third-party rseq library was linked and failed to
> > do so before thread exit (e.g. due to mismatched ref counts) rather
> > than respecting the reference count, since it knows it's the last
> > user. This would make potentially-buggy code safer.
> 
> OK, let me go ahead with a few ideas/questions along that path.
                                                 ^^^^^^^^^^^^^^^
> 
> Let's say our stated goal is to let the "exit" system call from the
> glibc thread exit path perform rseq unregistration (without explicit
> unregistration beforehand). Let's look at what we need.

This is not "along that path". The above-quoted text is not about
assuming it's safe to make SYS_exit without unregistering the rseq
object, but rather about glibc being able to perform the
rseq-unregister syscall without caring about reference counts, since
it knows no other code that might depend on rseq can run after it.

> First, we need the TLS area to be valid until the exit system call
> is invoked by the thread. If glibc defines __rseq_abi as a weak symbol,
> I'm not entirely sure we can guarantee the IE model if another library
> gets its own global-dynamic weak symbol elected at execution time. Would
> it be better to switch to a "strong" symbol for the glibc __rseq_abi
> rather than weak ?

This doesn't help; still whichever comes first in link order would
override. Either way __rseq_abi would be in static TLS, though,
because any dynamically-loaded library is necessarily loaded after
libc, which is loaded at initial exec time.

> There has been presumptions about signals being blocked when the thread
> exits throughout this email thread. Out of curiosity, what code is
> responsible for disabling signals in this situation ? Related to this,
> is it valid to access a IE model TLS variable from a signal handler at
> _any_ point where the signal handler nests over thread's execution ?
> This includes early start and just before invoking the exit system call.

It should be valid to access *any* TLS object like this, but the
standards don't cover it well. Right now access to dynamic TLS from
signal handlers is unsafe in glibc, but static is safe.

Rich

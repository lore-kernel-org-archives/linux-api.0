From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH v4 1/5] glibc: Perform rseq(2) registration at nptl
 init and thread creation
Date: Fri, 23 Nov 2018 12:05:20 -0500 (EST)
Message-ID: <1150466925.11664.1542992720871.JavaMail.zimbra@efficios.com>
References: <20181121183936.8176-1-mathieu.desnoyers@efficios.com> <686626451.10113.1542901620250.JavaMail.zimbra@efficios.com> <87wop5xeit.fsf@oldenburg.str.redhat.com> <1045257294.10291.1542905262086.JavaMail.zimbra@efficios.com> <87k1l5xd33.fsf@oldenburg.str.redhat.com> <20181122171010.GH23599@brightrain.aerifal.cx> <871s7cvt1l.fsf@oldenburg.str.redhat.com> <20181123142843.GJ23599@brightrain.aerifal.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181123142843.GJ23599@brightrain.aerifal.cx>
Sender: linux-kernel-owner@vger.kernel.org
To: Rich Felker <dalias@libc.org>
Cc: Florian Weimer <fweimer@redhat.com>, carlos <carlos@redhat.com>, Joseph Myers <joseph@codesourcery.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

----- On Nov 23, 2018, at 9:28 AM, Rich Felker dalias@libc.org wrote:
[...]
> 
> Absolutely. As long as it's in libc, implicit destruction will happen.
> Actually I think the glibc code shound unconditionally unregister the
> rseq address at exit (after blocking signals, so no application code
> can run) in case a third-party rseq library was linked and failed to
> do so before thread exit (e.g. due to mismatched ref counts) rather
> than respecting the reference count, since it knows it's the last
> user. This would make potentially-buggy code safer.

OK, let me go ahead with a few ideas/questions along that path.

Let's say our stated goal is to let the "exit" system call from the
glibc thread exit path perform rseq unregistration (without explicit
unregistration beforehand). Let's look at what we need.

First, we need the TLS area to be valid until the exit system call
is invoked by the thread. If glibc defines __rseq_abi as a weak symbol,
I'm not entirely sure we can guarantee the IE model if another library
gets its own global-dynamic weak symbol elected at execution time. Would
it be better to switch to a "strong" symbol for the glibc __rseq_abi
rather than weak ?

If we rely on implicit unregistration by the exit system call, then we
need to be really sure that the __rseq_abi TLS area can be accessed
(load and store) from kernel preemption up to the point where exit
is invoked. If we have that guarantee with the IE model, then we should
be fine. This means the memory area with the __rseq_abi sits can only
be re-used after the tid field in the TLB is set to 0 by the exit system
call. Looking at allocatestack.c, it looks like the FREE_P () macro
does exactly that.

With all the above respected, we could rely on implicit rseq unregistration
by thread exit rather than do an explicit unregister. We could still need
to increment the __rseq_refcount upon thread start however, so we can
ensure early adopter libraries won't unregister rseq while glibc is using
it. No need to bring the refcount back to 0 in glibc though.

There has been presumptions about signals being blocked when the thread
exits throughout this email thread. Out of curiosity, what code is
responsible for disabling signals in this situation ? Related to this,
is it valid to access a IE model TLS variable from a signal handler at
_any_ point where the signal handler nests over thread's execution ?
This includes early start and just before invoking the exit system call.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

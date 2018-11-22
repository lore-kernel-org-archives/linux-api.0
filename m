From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH v4 1/5] glibc: Perform rseq(2) registration at nptl
 init and thread creation
Date: Thu, 22 Nov 2018 10:47:00 -0500 (EST)
Message-ID: <686626451.10113.1542901620250.JavaMail.zimbra@efficios.com>
References: <20181121183936.8176-1-mathieu.desnoyers@efficios.com> <20181122143603.GD23599@brightrain.aerifal.cx> <782067422.9852.1542899056778.JavaMail.zimbra@efficios.com> <20181122151444.GE23599@brightrain.aerifal.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181122151444.GE23599@brightrain.aerifal.cx>
Sender: linux-kernel-owner@vger.kernel.org
To: Rich Felker <dalias@libc.org>
Cc: carlos <carlos@redhat.com>, Florian Weimer <fweimer@redhat.com>, Joseph Myers <joseph@codesourcery.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

----- On Nov 22, 2018, at 10:14 AM, Rich Felker dalias@libc.org wrote:

> On Thu, Nov 22, 2018 at 10:04:16AM -0500, Mathieu Desnoyers wrote:
>> ----- On Nov 22, 2018, at 9:36 AM, Rich Felker dalias@libc.org wrote:
>> 
>> > On Wed, Nov 21, 2018 at 01:39:32PM -0500, Mathieu Desnoyers wrote:
>> >> Register rseq(2) TLS for each thread (including main), and unregister
>> >> for each thread (excluding main). "rseq" stands for Restartable
>> >> Sequences.
>> > 
>> > Maybe I'm missing something obvious, but "unregister" does not seem to
>> > be a meaningful operation. Can you clarify what it's for?
>> 
>> There are really two ways rseq TLS can end up being unregistered: either
>> through an explicit call to the rseq "unregister", or when the OS frees the
>> thread's task struct.
>> 
>> You bring an interesting point here: do we need to explicitly unregister
>> rseq at thread exit, or can we leave that to the OS ?
>> 
>> The key thing to look for here is whether it's valid to access the
>> TLS area of the thread from preemption or signal delivery happening
>> at the very end of START_THREAD_DEFN. If it's OK to access it until
>> the very end of the thread lifetime, then we could do without an
>> explicit unregistration. However, if at any given point of the late
>> thread lifetime we end up in a situation where reading or writing to
>> that TLS area can cause corruption, then we need to carefully
>> unregister it before that memory is reclaimed/reused.
> 
> The thread memory cannot be reused until after kernel task exit,
> reported via the set_tid_address futex. Also, assuming signals are
> blocked (which is absolutely necessary for other reasons) nothing in
> userspace can touch the rseq state after this point anyway.

As discussed in the other leg of the email thread, disabling signals is
not enough to prevent the kernel to access the rseq TLS area on preemption.

> I was more confused about the need for reference counting, though.
> Where would anything be able to observe a state other than "refcnt>0"?
> -- in which case tracking it makes no sense. If the goal is to make an
> ABI thatsupports environments where libc doesn't have rseq support,
> and a third-party library is providing a compatible ABI, it seems all
> that would be needed it a boolean thread-local "is_initialized" flag.
> There does not seem to be any safe way such a library could be
> dynamically unloaded (which would require unregistration in all
> threads) and thus no need for a count.

Here is one scenario: we have 2 early adopter libraries using rseq which
are deployed in an environment with an older glibc (which does not
support rseq).

Of course, none of those libraries can be dlclose'd unless they somehow
track all registered threads. But let's focus on how exactly those
libraries can handle lazily registering rseq. They can use pthread_key,
and pthread_setspecific on first use by the thread to setup a destructor
function to be invoked at thread exit. But each early adopter library
is unaware of the other, so if we just use a "is_initialized" flag, the
first destructor to run will unregister rseq while the second library
may still be using it.

The same problem arises if we have an application early adopter which
explicitly deal with rseq, with a library early adopter. The issue is
similar, except that the application will explicitly want to unregister
rseq before exiting the thread, which leaves a race window where rseq
is unregistered, but the library may still need to use it.

The reference counter solves this: only the last rseq user for a thread
performs unregistration.

Thanks,

Mathieu



-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

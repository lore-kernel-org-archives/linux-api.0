From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [RFC PATCH v4 1/5] glibc: Perform rseq(2) registration at nptl init and thread creation
Date: Thu, 22 Nov 2018 17:28:42 +0100
Message-ID: <87wop5xeit.fsf@oldenburg.str.redhat.com>
References: <20181121183936.8176-1-mathieu.desnoyers@efficios.com>
        <20181122143603.GD23599@brightrain.aerifal.cx>
        <782067422.9852.1542899056778.JavaMail.zimbra@efficios.com>
        <20181122151444.GE23599@brightrain.aerifal.cx>
        <686626451.10113.1542901620250.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <686626451.10113.1542901620250.JavaMail.zimbra@efficios.com>
        (Mathieu Desnoyers's message of "Thu, 22 Nov 2018 10:47:00 -0500
        (EST)")
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Rich Felker <dalias@libc.org>, carlos <carlos@redhat.com>, Joseph Myers <joseph@codesourcery.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

* Mathieu Desnoyers:

> Here is one scenario: we have 2 early adopter libraries using rseq which
> are deployed in an environment with an older glibc (which does not
> support rseq).
>
> Of course, none of those libraries can be dlclose'd unless they somehow
> track all registered threads.

Well, you can always make them NODELETE so that dlclose is not an issue.
If the library is small enough, that shouldn't be a problem.

> But let's focus on how exactly those libraries can handle lazily
> registering rseq. They can use pthread_key, and pthread_setspecific on
> first use by the thread to setup a destructor function to be invoked
> at thread exit. But each early adopter library is unaware of the
> other, so if we just use a "is_initialized" flag, the first destructor
> to run will unregister rseq while the second library may still be
> using it.

I don't think you need unregistering if the memory is initial-exec TLS
memory.  Initial-exec TLS memory is tied directly to the TCB and cannot
be freed while the thread is running, so it should be safe to put the
rseq area there even if glibc knows nothing about it.  Then you'll only
need a mechanism to find the address of the actually active rseq area
(which you probably have to store in a TLS variable for performance
reasons).  And that part you need whether you have reference counter or
not.

> The same problem arises if we have an application early adopter which
> explicitly deal with rseq, with a library early adopter. The issue is
> similar, except that the application will explicitly want to unregister
> rseq before exiting the thread, which leaves a race window where rseq
> is unregistered, but the library may still need to use it.
>
> The reference counter solves this: only the last rseq user for a thread
> performs unregistration.

If you do explicit unregistration, you will run into issues related to
destructor ordering.  You should really find a way to avoid that.

Thanks,
Florian

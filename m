From: Rich Felker <dalias@libc.org>
Subject: Re: [RFC PATCH v4 1/5] glibc: Perform rseq(2) registration at nptl
 init and thread creation
Date: Thu, 22 Nov 2018 12:10:10 -0500
Message-ID: <20181122171010.GH23599@brightrain.aerifal.cx>
References: <20181121183936.8176-1-mathieu.desnoyers@efficios.com>
 <20181122143603.GD23599@brightrain.aerifal.cx>
 <782067422.9852.1542899056778.JavaMail.zimbra@efficios.com>
 <20181122151444.GE23599@brightrain.aerifal.cx>
 <686626451.10113.1542901620250.JavaMail.zimbra@efficios.com>
 <87wop5xeit.fsf@oldenburg.str.redhat.com>
 <1045257294.10291.1542905262086.JavaMail.zimbra@efficios.com>
 <87k1l5xd33.fsf@oldenburg.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <libc-alpha-return-97473-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
Content-Disposition: inline
In-Reply-To: <87k1l5xd33.fsf@oldenburg.str.redhat.com>
Sender: Rich Felker <dalias@aerifal.cx>
To: Florian Weimer <fweimer@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, carlos <carlos@redhat.com>, Joseph Myers <joseph@codesourcery.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Nov 22, 2018 at 05:59:44PM +0100, Florian Weimer wrote:
> * Mathieu Desnoyers:
> 
> > ----- On Nov 22, 2018, at 11:28 AM, Florian Weimer fweimer@redhat.com wrote:
> >
> >> * Mathieu Desnoyers:
> >> 
> >>> Here is one scenario: we have 2 early adopter libraries using rseq which
> >>> are deployed in an environment with an older glibc (which does not
> >>> support rseq).
> >>>
> >>> Of course, none of those libraries can be dlclose'd unless they somehow
> >>> track all registered threads.
> >> 
> >> Well, you can always make them NODELETE so that dlclose is not an issue.
> >> If the library is small enough, that shouldn't be a problem.
> >
> > That's indeed what I do with lttng-ust, mainly due to use of pthread_key.
> >
> >> 
> >>> But let's focus on how exactly those libraries can handle lazily
> >>> registering rseq. They can use pthread_key, and pthread_setspecific on
> >>> first use by the thread to setup a destructor function to be invoked
> >>> at thread exit. But each early adopter library is unaware of the
> >>> other, so if we just use a "is_initialized" flag, the first destructor
> >>> to run will unregister rseq while the second library may still be
> >>> using it.
> >> 
> >> I don't think you need unregistering if the memory is initial-exec TLS
> >> memory.  Initial-exec TLS memory is tied directly to the TCB and cannot
> >> be freed while the thread is running, so it should be safe to put the
> >> rseq area there even if glibc knows nothing about it.
> >
> > Is it true for user-supplied stacks as well ?
> 
> I'm not entirely sure because the glibc terminology is confusing, but I
> think it places intial-exec TLS into the static TLS area (so that it has
> a fixed offset from the TCB).  The static TLS area is placed on the
> user-supplied stack.

This is an implementation detail that should not leak to applications,
and I believe it's still considered a bug, in that, with large static
TLS, it could overflow or leave unusably little space left on an
otherwise-plenty-large application-provided stack.

> > One issue here is that early adopter libraries cannot always use
> > the IE model. I tried using it for other TLS variables in lttng-ust, and
> > it ended up hanging our CI tests when tracing a sample application with
> > lttng-ust under a Java virtual machine: being dlopen'd in a process that
> > possibly already exhausts the number of available backup TLS IE entries
> > seems to have odd effects. This is why I'm worried about using the IE model
> > within lttng-ust.
> 
> You can work around this by preloading the library.  I'm not sure if
> this is a compelling reason not to use initial-exec TLS memory.

Use of IE model from a .so file (except possibly libc.so or something
else that inherently needs to be present at program startup for other
reasons) should be a considered a bug and unsupported usage.
Encouraging libraries to perpetuate this behavior is going backwards
on progress that's being made to end it.

> >>> The same problem arises if we have an application early adopter which
> >>> explicitly deal with rseq, with a library early adopter. The issue is
> >>> similar, except that the application will explicitly want to unregister
> >>> rseq before exiting the thread, which leaves a race window where rseq
> >>> is unregistered, but the library may still need to use it.
> >>>
> >>> The reference counter solves this: only the last rseq user for a thread
> >>> performs unregistration.
> >> 
> >> If you do explicit unregistration, you will run into issues related to
> >> destructor ordering.  You should really find a way to avoid that.
> >
> > The per-thread reference counter is a way to avoid issues that arise from
> > lack of destructor ordering. Is it an acceptable approach for you, or
> > you have something else in mind ?
> 
> Only for the involved libraries.  It will not help if other TLS
> destructors run and use these libraries.

Presumably they should have registered their need for rseq too,
thereby incrementing the reference count. I'm not sure this is a good
idea, but I think I understand it now.

Rich

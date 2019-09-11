From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [PATCH glibc 2.31 1/5] glibc: Perform rseq(2) registration at C startup and thread creation (v12)
Date: Wed, 11 Sep 2019 20:26:21 +0200
Message-ID: <8736h2sn8y.fsf@oldenburg2.str.redhat.com>
References: <20190807142726.2579-1-mathieu.desnoyers@efficios.com>
        <20190807142726.2579-2-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190807142726.2579-2-mathieu.desnoyers@efficios.com> (Mathieu
        Desnoyers's message of "Wed, 7 Aug 2019 10:27:22 -0400")
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Carlos O'Donell <carlos@redhat.com>, Joseph Myers <joseph@codesourcery.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha@sourceware.org, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Rich Felker <dalias@libc.org>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

* Mathieu Desnoyers:

> +#ifdef SHARED
> +  if (rtld_active ())
> +    {
> +      /* Register rseq ABI to the kernel.   */
> +      (void) rseq_register_current_thread ();
> +    }
> +#else

I think this will need *another* check for the inner libc in an audit
module.  See what we do in malloc.  __libc_multiple_libcs is supposed to
cover that, but it's unfortunately not reliable.

I believe without that additional check, the first audit module we load
will claim rseq, and the main program will not have control over the
rseq area.  Reversed roles would be desirable here.

In October, I hope to fix __libc_multiple_libcs, and then you can use
just that.  (We have a Fedora patch that is supposed to fix it, I need
to documen the mechanism and upstream it.)

> +/* Advertise Restartable Sequences registration ownership across
> +   application and shared libraries.
> +
> +   Libraries and applications must check whether this variable is zero or
> +   non-zero if they wish to perform rseq registration on their own. If it
> +   is zero, it means restartable sequence registration is not handled, and
> +   the library or application is free to perform rseq registration. In
> +   that case, the library or application is taking ownership of rseq
> +   registration, and may set __rseq_handled to 1. It may then set it back
> +   to 0 after it completes unregistering rseq.
> +
> +   If __rseq_handled is found to be non-zero, it means that another
> +   library (or the application) is currently handling rseq registration.
> +
> +   Typical use of __rseq_handled is within library constructors and
> +   destructors, or at program startup.  */
> +
> +int __rseq_handled;

Are there any programs that use __rseq_handled *today*?

I'm less convinced that we actually need this.  I don't think we have
ever done anything like that before, and I don't think it's necessary.
Any secondary rseq library just needs to note if it could perform
registration, and if it failed to do so, do not perform unregistration
in a pthread destructor callback.

Sure, there's the matter of pthread destructor ordering, but that
problem is not different from any other singleton (thread-local or not),
and the fix for the last time this has come up (TLS destructors vs
dlclose) was to upgrade glibc.

Thanks,
Florian

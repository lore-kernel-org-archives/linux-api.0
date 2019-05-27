From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [PATCH 1/5] glibc: Perform rseq(2) registration at C startup and thread creation (v10)
Date: Mon, 27 May 2019 13:19:36 +0200
Message-ID: <87h89gjgaf.fsf@oldenburg2.str.redhat.com>
References: <20190503184219.19266-1-mathieu.desnoyers@efficios.com>
        <20190503184219.19266-2-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190503184219.19266-2-mathieu.desnoyers@efficios.com> (Mathieu
        Desnoyers's message of "Fri, 3 May 2019 14:42:15 -0400")
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Carlos O'Donell <carlos@redhat.com>, Joseph Myers <joseph@codesourcery.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha@sourceware.org, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Rich Felker <dalias@libc.org>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

* Mathieu Desnoyers:

> +/* volatile because fields can be read/updated by the kernel.  */
> +__thread volatile struct rseq __rseq_abi = {
> +  .cpu_id = RSEQ_CPU_ID_UNINITIALIZED,
> +};

As I've explained repeatedly, the volatile qualifier is wrong because it
is impossible to get rid of it.  (Accessing an object declared volatile
using non-volatile pointers is undefined.)  Code using __rseq_abi should
use relaxed MO atomics or signal fences/compiler barriers, as
appropriate.

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

It's not clear to me whether the intent is that __rseq_handled reflects
kernel support for rseq or not.  Currently, it only tells us whether
glibc has been built with rseq support or not.  It does not reflect
kernel support.  I'm still not convinced that this symbol is necessary,
especially if we mandate a kernel header version which defines __NR_rseq
for building glibc (which may happen due to the time64_t work).

Furthermore, the reference to ELF constructors is misleading.  I believe
the code you added to __libc_start_main to initialize __rseq_handled and
register __seq_abi with the kernel runs *after* ELF constructors have
executed (and not at all if the main program is written in Go, alas).
All initialization activity for the shared case needs to happen in
elf/rtld.c or called from there, probably as part of the security
initialization code or thereabouts.

Thanks,
Florian

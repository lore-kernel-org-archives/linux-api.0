From: Florian Weimer <fweimer@redhat.com>
Subject: Re: Supporting core-specific instruction sets (e.g. big.LITTLE) with restartable sequences
Date: Fri, 02 Nov 2018 20:18:12 +0100
Message-ID: <877ehvb85n.fsf@oldenburg.str.redhat.com>
References: <313542172.8.1541171544337.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <313542172.8.1541171544337.JavaMail.zimbra@efficios.com> (Mathieu
        Desnoyers's message of "Fri, 2 Nov 2018 11:12:24 -0400 (EDT)")
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Richard Henderson <rth@twiddle.net>, Will Deacon <will.deacon@arm.com>, linux-kernel <linux-kernel@vger.kernel.org>, libc-alpha <libc-alpha@sourceware.org>, Carlos O'Donell <carlos@redhat.com>, Joseph Myers <joseph@codesourcery.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

* Mathieu Desnoyers:

> Basically, the use-cases targeted are those where some cores on the
> system support a larger instruction set than others. So for instance,
> some cores could use a faster atomic add instruction than others,
> which should rely on a slower fallback. This is also the same story
> for reading the performance monitoring unit counters from user-space:
> it depends on the feature-set supported by the CPU on which the
> instruction is issued. Same applies to cores having different
> cache-line sizes.

The kernel needs to present a consistent view to userspace, the common
denominator.  I don't think there is any other way.

The situation is not new at all, by the way.  It also arises with VM and
process migration.  In glibc, we do not re-run CPU feature selection
upon resume (and how could we? function pointers would have to change),
and we have no plans to implement anything differently.

Thanks,
Florian

From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [PATCH 1/5] glibc: Perform rseq(2) registration at C startup and thread creation (v10)
Date: Thu, 06 Jun 2019 13:57:23 +0200
Message-ID: <87wohzorj0.fsf@oldenburg2.str.redhat.com>
References: <20190503184219.19266-1-mathieu.desnoyers@efficios.com>
        <140718133.18261.1559144710554.JavaMail.zimbra@efficios.com>
        <2022553041.20966.1559249801435.JavaMail.zimbra@efficios.com>
        <875zprm4jo.fsf@oldenburg2.str.redhat.com>
        <732661684.21584.1559314109886.JavaMail.zimbra@efficios.com>
        <87muj2k4ov.fsf@oldenburg2.str.redhat.com>
        <1528929896.22217.1559326257155.JavaMail.zimbra@efficios.com>
        <87o93d4lqb.fsf@oldenburg2.str.redhat.com>
        <117220011.27079.1559663870037.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: carlos <carlos@redhat.com>, Joseph Myers <joseph@codesourcery.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Rich Felker <dalias@libc.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

* Mathieu Desnoyers:

> Should we plan ahead for such scheme to override which library "owns" rseq
> registration from a LD_PRELOAD library ? If so, then we would want glibc to
> set __rseq_handled _after_ LD_PRELOAD ctors are executed.

I don't think so.  The LD_PRELOAD phase is not clearly delineated from
the non-preload phase.  So it's not clear to me what this would even
mean in practice.

Let me ask the key question again: Does it matter if code observes the
rseq area first without kernel support, and then with kernel support?
If we don't expect any problems immediately, we do not need to worry
much about the constructor ordering right now.  I expect that over time,
fixing this properly will become easier.

>> The final remaining case is static dlopen.  There is a copy of ld.so on
>> the dynamic side, but it is completely inactive and has never run.  I do
>> not think we need to support that because multi-threading does not work
>> reliably in this scenario, either.  However, we should skip rseq
>> registration in a nested libc (see the rtld_active function).
>
> So for SHARED, if (!rtld_active ()), we should indeed leave the state of
> __rseq_handled as it is, because we are within a nested inactive ld.so.

I think we should add __rseq_handled initialization to ld.so, so it will
only run once, ever.

It's the registration from libc.so which needs some care.  In
particular, we must not override an existing registration.

Thanks,
Florian

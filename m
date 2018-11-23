From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [RFC PATCH v4 1/5] glibc: Perform rseq(2) registration at nptl init and thread creation
Date: Fri, 23 Nov 2018 14:29:18 +0100
Message-ID: <87sgzrvs5t.fsf@oldenburg.str.redhat.com>
References: <20181121183936.8176-1-mathieu.desnoyers@efficios.com>
        <20181122143603.GD23599@brightrain.aerifal.cx>
        <782067422.9852.1542899056778.JavaMail.zimbra@efficios.com>
        <20181122151444.GE23599@brightrain.aerifal.cx>
        <686626451.10113.1542901620250.JavaMail.zimbra@efficios.com>
        <87wop5xeit.fsf@oldenburg.str.redhat.com>
        <1045257294.10291.1542905262086.JavaMail.zimbra@efficios.com>
        <87k1l5xd33.fsf@oldenburg.str.redhat.com>
        <644835950.10383.1542907783295.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <644835950.10383.1542907783295.JavaMail.zimbra@efficios.com>
        (Mathieu Desnoyers's message of "Thu, 22 Nov 2018 12:29:43 -0500
        (EST)")
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Rich Felker <dalias@libc.org>, carlos <carlos@redhat.com>, Joseph Myers <joseph@codesourcery.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

* Mathieu Desnoyers:

>>>> I don't think you need unregistering if the memory is initial-exec TLS
>>>> memory.  Initial-exec TLS memory is tied directly to the TCB and cannot
>>>> be freed while the thread is running, so it should be safe to put the
>>>> rseq area there even if glibc knows nothing about it.
>>>
>>> Is it true for user-supplied stacks as well ?
>> 
>> I'm not entirely sure because the glibc terminology is confusing, but I
>> think it places intial-exec TLS into the static TLS area (so that it has
>> a fixed offset from the TCB).  The static TLS area is placed on the
>> user-supplied stack.
>
> You said earlier in the email thread that user-supplied stack can be
> reclaimed by __free_tcb () while the thread still runs, am I correct ?
> If so, then we really want to unregister the rseq TLS before that.

No, dynamic TLS can be reclaimed.  Static TLS (which I assume includes
initial-exec TLS) is not deallocated.

> I notice that __free_tcb () calls __deallocate_stack (), which invokes
> _dl_deallocate_tls (). Accessing the TLS from the kernel upon preemption
> would appear fragile after this call.

_dl_deallocate_tls only covers dynamic TLS.

Thanks,
Florian

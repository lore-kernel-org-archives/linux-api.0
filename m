From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [RFC PATCH v4 1/5] glibc: Perform rseq(2) registration at nptl init and thread creation
Date: Thu, 22 Nov 2018 16:21:02 +0100
Message-ID: <875zwpyw81.fsf@oldenburg.str.redhat.com>
References: <20181121183936.8176-1-mathieu.desnoyers@efficios.com>
        <20181122143603.GD23599@brightrain.aerifal.cx>
        <782067422.9852.1542899056778.JavaMail.zimbra@efficios.com>
        <87a7m1ywni.fsf@oldenburg.str.redhat.com>
        <20181122151710.GF23599@brightrain.aerifal.cx>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181122151710.GF23599@brightrain.aerifal.cx> (Rich Felker's
        message of "Thu, 22 Nov 2018 10:17:10 -0500")
Sender: linux-kernel-owner@vger.kernel.org
To: Rich Felker <dalias@libc.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, carlos <carlos@redhat.com>, Joseph Myers <joseph@codesourcery.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

* Rich Felker:

> On Thu, Nov 22, 2018 at 04:11:45PM +0100, Florian Weimer wrote:
>> * Mathieu Desnoyers:
>> 
>> > Thoughts ?
>> >
>> >   /* Unregister rseq TLS from kernel. */
>> >   if (has_rseq && __rseq_unregister_current_thread ())
>> >     abort();
>> >
>> >   advise_stack_range (pd->stackblock, pd->stackblock_size, (uintptr_t) pd,
>> >                       pd->guardsize);
>> >
>> >   /* If the thread is detached free the TCB.  */
>> >   if (IS_DETACHED (pd))
>> >     /* Free the TCB.  */
>> >     __free_tcb (pd);
>> 
>> Considering that we proceed to free the TCB, I really hope that all
>> signals are blocked at this point.  (I have not checked this, though.)
>> 
>> Wouldn't this address your concern about access to the rseq area?
>
> I'm not familiar with glibc's logic here, but for other reasons, I
> don't think freeing it is safe until the kernel task exit futex (set
> via clone or set_tid_address) has fired. I would guess __free_tcb just
> sets up for it to be reclaimable when this happens rather than
> immediately freeing it for reuse.

Right, but in case of user-supplied stacks, we actually free TLS memory
at this point, so signals need to be blocked because the TCB is
(partially) gone after that.

Thanks,
Florian

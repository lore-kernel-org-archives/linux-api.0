From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [RFC PATCH v4 1/5] glibc: Perform rseq(2) registration at nptl init and thread creation
Date: Thu, 22 Nov 2018 16:11:45 +0100
Message-ID: <87a7m1ywni.fsf@oldenburg.str.redhat.com>
References: <20181121183936.8176-1-mathieu.desnoyers@efficios.com>
        <20181122143603.GD23599@brightrain.aerifal.cx>
        <782067422.9852.1542899056778.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <782067422.9852.1542899056778.JavaMail.zimbra@efficios.com>
        (Mathieu Desnoyers's message of "Thu, 22 Nov 2018 10:04:16 -0500
        (EST)")
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Rich Felker <dalias@libc.org>, carlos <carlos@redhat.com>, Joseph Myers <joseph@codesourcery.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

* Mathieu Desnoyers:

> Thoughts ?
>
>   /* Unregister rseq TLS from kernel. */
>   if (has_rseq && __rseq_unregister_current_thread ())
>     abort();
>
>   advise_stack_range (pd->stackblock, pd->stackblock_size, (uintptr_t) pd,
>                       pd->guardsize);
>
>   /* If the thread is detached free the TCB.  */
>   if (IS_DETACHED (pd))
>     /* Free the TCB.  */
>     __free_tcb (pd);

Considering that we proceed to free the TCB, I really hope that all
signals are blocked at this point.  (I have not checked this, though.)

Wouldn't this address your concern about access to the rseq area?

Thanks,
Florian

From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [PATCH 1/5] glibc: Perform rseq(2) registration at C startup and thread creation (v10)
Date: Fri, 31 May 2019 10:06:19 +0200
Message-ID: <875zprm4jo.fsf@oldenburg2.str.redhat.com>
References: <20190503184219.19266-1-mathieu.desnoyers@efficios.com>
        <20190503184219.19266-2-mathieu.desnoyers@efficios.com>
        <87h89gjgaf.fsf@oldenburg2.str.redhat.com>
        <1239705947.14878.1558985272873.JavaMail.zimbra@efficios.com>
        <140718133.18261.1559144710554.JavaMail.zimbra@efficios.com>
        <2022553041.20966.1559249801435.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2022553041.20966.1559249801435.JavaMail.zimbra@efficios.com>
        (Mathieu Desnoyers's message of "Thu, 30 May 2019 16:56:41 -0400
        (EDT)")
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: carlos <carlos@redhat.com>, Joseph Myers <joseph@codesourcery.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Rich Felker <dalias@libc.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

* Mathieu Desnoyers:

> I found that it's because touching a __thread variable from
> ld-linux-x86-64.so.2 ends up setting the DF_STATIC_TLS flag
> for that .so, which is really not expected.
>
> Even if I tweak the assert to make it more lenient there,
> touching the __thread variable ends up triggering a SIGFPE.

Sorry, I got distracted at this critical juncture.  Yes, I forgot that
there isn't TLS support in the dynamic loader today.

> So rather than touching the TLS from ld-linux-x86-64.so.2,
> I've rather experimented with moving the rseq initialization
> for both SHARED and !SHARED cases to a library constructor
> within libc.so.
>
> Are you aware of any downside to this approach ?

The information whether the kernel supports rseq would not be available
to IFUNC resolvers.  And in some cases, ELF constructors for application
libraries could run before the libc.so.6 constructor, so applications
would see a transition from lack of kernel support to kernel support.

> +static
> +__attribute__ ((constructor))
> +void __rseq_libc_init (void)
> +{
> +  rseq_init ();
> +  /* Register rseq ABI to the kernel.   */
> +  (void) rseq_register_current_thread ();
> +}

I think the call to rseq_init (and the __rseq_handled variable) should
still be part of the dynamic loader.  Otherwise there could be confusion
about whether glibc handles the registration (due the constructor
ordering issue).

Thanks,
Florian

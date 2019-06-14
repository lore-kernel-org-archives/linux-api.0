From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [PATCH 1/5] glibc: Perform rseq(2) registration at C startup and thread creation (v10)
Date: Fri, 14 Jun 2019 15:42:26 +0200
Message-ID: <87imt8tha5.fsf@oldenburg2.str.redhat.com>
References: <20190503184219.19266-1-mathieu.desnoyers@efficios.com>
        <1635690189.3049.1560507249693.JavaMail.zimbra@efficios.com>
        <87tvcsv1pk.fsf@oldenburg2.str.redhat.com>
        <1190407525.3131.1560516910936.JavaMail.zimbra@efficios.com>
        <1085273942.3137.1560517301721.JavaMail.zimbra@efficios.com>
        <87d0jguxdk.fsf@oldenburg2.str.redhat.com>
        <1779359826.3226.1560518318701.JavaMail.zimbra@efficios.com>
        <87wohoti47.fsf@oldenburg2.str.redhat.com>
        <189377747.3315.1560519247118.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <189377747.3315.1560519247118.JavaMail.zimbra@efficios.com>
        (Mathieu Desnoyers's message of "Fri, 14 Jun 2019 09:34:07 -0400
        (EDT)")
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: carlos <carlos@redhat.com>, Joseph Myers <joseph@codesourcery.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Rich Felker <dalias@libc.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

* Mathieu Desnoyers:

> +  /* Publicize rseq registration ownership.  This must be performed
> +     after rtld re-relocation, before invoking constructors of
> +     preloaded libraries.  */
> +  rseq_init ();

Please add a comment that IFUNC resolvers do not see the initialized
value.  I think this is okay because we currently do not support access
to extern variables in IFUNC resolvers.

>    /* Do any necessary cleanups for the startup OS interface code.
>       We do these now so that no calls are made after rtld re-relocation
>       which might be resolved to different functions than we expect.
>
> It works fine now!

Great.

Thanks,
Florian

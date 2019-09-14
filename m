From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [PATCH glibc 2.31 1/5] glibc: Perform rseq(2) registration at C startup and thread creation (v12)
Date: Fri, 13 Sep 2019 21:36:51 -0400
Message-ID: <87ef0j4q18.fsf@oldenburg2.str.redhat.com>
References: <20190807142726.2579-1-mathieu.desnoyers@efficios.com>
        <20190807142726.2579-2-mathieu.desnoyers@efficios.com>
        <8736h2sn8y.fsf@oldenburg2.str.redhat.com>
        <7db64714-3dc5-b322-1edc-736b08ee7d63@redhat.com>
        <1137395748.2754.1568390288746.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1137395748.2754.1568390288746.JavaMail.zimbra@efficios.com>
        (Mathieu Desnoyers's message of "Fri, 13 Sep 2019 11:58:08 -0400
        (EDT)")
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: carlos <carlos@redhat.com>, Joseph Myers <joseph@codesourcery.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Rich Felker <dalias@libc.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

* Mathieu Desnoyers:

> I'm unsure whether there are changes I need to do in my rseq patchset, or
> if this is a separate issue that will be fixed separately before glibc 2.31
> is out, which would then update the rseq bits accordingly ?

Someone else (perhaps me) has to fix __libc_multiple_libcs.  Then you
can use it instead/in addition to the rtld_active check (depending on
the semantics we agree upon for __libc_multiple_libcs).

Fixing __libc_multiple_libcs may also address the early initialization
issue because for that to be always correct, we need to run the
initialization code before ELF constructors.

>>> I'm less convinced that we actually need this.  I don't think we have
>>> ever done anything like that before, and I don't think it's necessary.
>>> Any secondary rseq library just needs to note if it could perform
>>> registration, and if it failed to do so, do not perform unregistration
>>> in a pthread destructor callback.
>
> If that secondary rseq library happens to try to perform registration within
> its library constructor (before glibc has performed the __rseq_abi TLS
> registration), we end up in a situation where the secondary library takes
> ownership of rseq, even though libc would require ownership. This is a
> scenario we want to avoid.

We can avoid that if we run the glibc initialization before user code
(except IFUNC resolvers).  glibc itself doesn't have to do the
initialization from an ELF constructor.

> Making sure libc reserves ownership through __rseq_handled (which is
> a non-TLS variable that can be accessed early in the program lifetime)
> protects against this.

If that's it's only purpose, I don't think it's necessary.  If the
kernel can fail the second registration attempt, that would be all the
information the alternative rseq implementation needs (plus the matter
of destruction).

Thanks,
Florian

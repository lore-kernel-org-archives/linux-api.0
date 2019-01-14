From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [RFC PATCH glibc 1/4] glibc: Perform rseq(2) registration at nptl init and thread creation (v4)
Date: Mon, 14 Jan 2019 19:57:03 +0100
Message-ID: <87bm4j9if4.fsf@oldenburg2.str.redhat.com>
References: <20181204192141.4684-1-mathieu.desnoyers@efficios.com>
        <87h8fkz6qx.fsf@oldenburg2.str.redhat.com>
        <1681283664.1380.1547152315426.JavaMail.zimbra@efficios.com>
        <1488546469.1564.1547169116539.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1488546469.1564.1547169116539.JavaMail.zimbra@efficios.com>
        (Mathieu Desnoyers's message of "Thu, 10 Jan 2019 20:11:56 -0500
        (EST)")
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: carlos <carlos@redhat.com>, Joseph Myers <joseph@codesourcery.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Rich Felker <dalias@libc.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

* Mathieu Desnoyers:

> Now that I think about it, it's important to move the rseq registration
> done at nptl init (in my current code) to some lower-level csu initialiation,
> so applications that happen _not_ to link against libpthread also get
> registered rseq for the main thread.

Yes.  In general, we want to avoid to force libraries which do not
create threads to link against libpthread, and try to provide interfaces
which are required for synchronization within libc.

Thanks,
Florian

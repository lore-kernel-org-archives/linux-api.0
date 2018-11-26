From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [RFC PATCH v4 1/5] glibc: Perform rseq(2) registration at nptl init and thread creation
Date: Mon, 26 Nov 2018 17:03:02 +0100
Message-ID: <874lc3omh5.fsf@oldenburg.str.redhat.com>
References: <20181121183936.8176-1-mathieu.desnoyers@efficios.com>
        <20181123142843.GJ23599@brightrain.aerifal.cx>
        <1150466925.11664.1542992720871.JavaMail.zimbra@efficios.com>
        <20181123173019.GK23599@brightrain.aerifal.cx>
        <865273158.11687.1542995541389.JavaMail.zimbra@efficios.com>
        <20181123183558.GM23599@brightrain.aerifal.cx>
        <1758017676.12041.1543007347347.JavaMail.zimbra@efficios.com>
        <87bm6cqm31.fsf@oldenburg.str.redhat.com>
        <688718071.12798.1543247469553.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <688718071.12798.1543247469553.JavaMail.zimbra@efficios.com>
        (Mathieu Desnoyers's message of "Mon, 26 Nov 2018 10:51:09 -0500
        (EST)")
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Rich Felker <dalias@libc.org>, carlos <carlos@redhat.com>, Joseph Myers <joseph@codesourcery.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

* Mathieu Desnoyers:

> So let's make __rseq_abi and __rseq_refcount strong symbols then ?

Yes, please.  (But I'm still not sure we need the reference counter.)

Thanks,
Florian

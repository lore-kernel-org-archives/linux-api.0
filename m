From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [RFC PATCH v4 1/5] glibc: Perform rseq(2) registration at nptl init and thread creation
Date: Mon, 26 Nov 2018 09:28:34 +0100
Message-ID: <87bm6cqm31.fsf@oldenburg.str.redhat.com>
References: <20181121183936.8176-1-mathieu.desnoyers@efficios.com>
        <20181122171010.GH23599@brightrain.aerifal.cx>
        <871s7cvt1l.fsf@oldenburg.str.redhat.com>
        <20181123142843.GJ23599@brightrain.aerifal.cx>
        <1150466925.11664.1542992720871.JavaMail.zimbra@efficios.com>
        <20181123173019.GK23599@brightrain.aerifal.cx>
        <865273158.11687.1542995541389.JavaMail.zimbra@efficios.com>
        <20181123183558.GM23599@brightrain.aerifal.cx>
        <1758017676.12041.1543007347347.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1758017676.12041.1543007347347.JavaMail.zimbra@efficios.com>
        (Mathieu Desnoyers's message of "Fri, 23 Nov 2018 16:09:07 -0500
        (EST)")
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Rich Felker <dalias@libc.org>, carlos <carlos@redhat.com>, Joseph Myers <joseph@codesourcery.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

* Mathieu Desnoyers:

> Using a "weak" symbol in early adopter libraries is important, so they
> can be loaded together into the same process without causing loader
> errors due to many definitions of the same strong symbol.

This is not how ELF dynamic linking works.  If the symbol name is the
same, one definition interposes the others.

You need to ensure that the symbol has the same size everywhere, though.
There are some tricky interactions with symbol versions, too.  (The
interposing libraries must not use symbol versioning.)

Thanks,
Florian

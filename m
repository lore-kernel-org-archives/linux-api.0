From: Florian Weimer <fw@deneb.enyo.de>
Subject: Re: [RFC PATCH v9 for 4.15 01/14] Restartable sequences system call
Date: Thu, 19 Oct 2017 19:01:52 +0200
Message-ID: <87efpz2hrz.fsf@mid.deneb.enyo.de>
References: <20171012230326.19984-1-mathieu.desnoyers@efficios.com>
        <20171012230326.19984-2-mathieu.desnoyers@efficios.com>
        <CY4PR15MB1688286D6B1283A1C234BAE6CF4E0@CY4PR15MB1688.namprd15.prod.outlook.com>
        <515879378.43966.1508350299712.JavaMail.zimbra@efficios.com>
        <14399397.44601.1508412942855.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <14399397.44601.1508412942855.JavaMail.zimbra@efficios.com>
        (Mathieu Desnoyers's message of "Thu, 19 Oct 2017 11:35:42 +0000
        (UTC)")
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Ben Maurer <bmaurer@fb.com>, Carlos O'Donell <carlos@redhat.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Josh Triplett <josh@joshtriplett.org>, Will Deacon <will.deacon@arm.com>, linux-kernel <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, rostedt <rostedt@goodmis.org>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.u>
List-Id: linux-api@vger.kernel.org

* Mathieu Desnoyers:

> Speaking of optimization, I think the rseq.c helper library
> (and eventually glibc) should define the __rseq_abi TLS
> variable with __attribute__((tls_model("initial-exec"))).
> It provides faster, and signal-safe, accesses to the TLS
> variable from libraries.
>
> The idea you were suggesting where the application could
> override the glibc symbol with its own just ends up enforcing
> an initial-exec model, but it looks like we can do this
> directly from the library.

This really depends on how the programming model turns out once
multiple libraries are involved.  I think it's premature to discuss
such details.

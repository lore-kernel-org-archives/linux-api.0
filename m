From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH for 4.16 08/10] membarrier: x86: Provide core serializing
 command (v3)
Date: Tue, 16 Jan 2018 19:29:33 +0100 (CET)
Message-ID: <alpine.DEB.2.20.1801161928110.2366@nanos>
References: <20180115191104.12437-1-mathieu.desnoyers@efficios.com> <20180115191104.12437-9-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180115191104.12437-9-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andrew Hunter <ahh@google.com>, Maged Michael <maged.michael@gmail.com>, Avi Kivity <avi@scylladb.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Dave Watson <davejwatson@fb.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrea Parri <parri.andrea@gmail.com>, Russell King <linux@armlinux.org.uk>, Greg Hackmann <ghackmann@google.com>, Will Deacon <will.deacon@arm.com>, David Sehr <sehr@google.com>Linus Torvalds <to>
List-Id: linux-api@vger.kernel.org

On Mon, 15 Jan 2018, Mathieu Desnoyers wrote:

> There are two places where core serialization is needed by membarrier:
> 
> 1) When returning from the membarrier IPI,
> 2) After scheduler updates curr to a thread with a different mm, before
>    going back to user-space, since the curr->mm is used by membarrier to
>    check whether it needs to send an IPI to that CPU.

This wants to be split into x86 and core changes. Ideally you make the core
changes before the previous patch and add the empty inline into
linux/processor.h....

Thanks,

	tglx

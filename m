From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH for 4.16 07/10] x86: Introduce sync_core_before_usermode
 (v2)
Date: Tue, 16 Jan 2018 19:28:07 +0100 (CET)
Message-ID: <alpine.DEB.2.20.1801161927400.2366@nanos>
References: <20180115191104.12437-1-mathieu.desnoyers@efficios.com> <20180115191104.12437-8-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180115191104.12437-8-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andrew Hunter <ahh@google.com>, Maged Michael <maged.michael@gmail.com>, Avi Kivity <avi@scylladb.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Dave Watson <davejwatson@fb.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrea Parri <parri.andrea@gmail.com>, Russell King <linux@armlinux.org.uk>, Greg Hackmann <ghackmann@google.com>, Will Deacon <will.deacon@arm.com>, David Sehr <sehr@google.com>Linus Torvalds <to>
List-Id: linux-api@vger.kernel.org

On Mon, 15 Jan 2018, Mathieu Desnoyers wrote:

> Introduce an architecture function that ensures the current CPU
> issues a core serializing instruction before returning to usermode.
> 
> This is needed for the membarrier "sync_core" command.
> 
> Architectures defining the sync_core_before_usermode() static inline
> need to select ARCH_HAS_SYNC_CORE_BEFORE_USERMODE.

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>

From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [RFC PATCH for 4.18 10/16] powerpc: Wire up restartable sequences system call
Date: Tue, 05 Jun 2018 15:18:44 +1000
Message-ID: <874lihbykr.fsf@concordia.ellerman.id.au>
References: <20180602124408.8430-1-mathieu.desnoyers@efficios.com> <20180602124408.8430-11-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180602124408.8430-11-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Joel Fernandes <joelaf@google.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Benjamin Herrenschmidt <benh>
List-Id: linux-api@vger.kernel.org

Mathieu Desnoyers <mathieu.desnoyers@efficios.com> writes:

> From: Boqun Feng <boqun.feng@gmail.com>
>
> Wire up the rseq system call on powerpc.
>
> This provides an ABI improving the speed of a user-space getcpu
> operation on powerpc by skipping the getcpu system call on the fast
> path, as well as improving the speed of user-space operations on per-cpu
> data compared to using load-reservation/store-conditional atomics.
>
> Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> CC: Paul Mackerras <paulus@samba.org>
> CC: Michael Ellerman <mpe@ellerman.id.au>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> CC: linuxppc-dev@lists.ozlabs.org
> ---
>  arch/powerpc/include/asm/systbl.h      | 1 +
>  arch/powerpc/include/asm/unistd.h      | 2 +-
>  arch/powerpc/include/uapi/asm/unistd.h | 1 +
>  3 files changed, 3 insertions(+), 1 deletion(-)

Looks fine to me.

I don't have any other new syscalls in my next, so this should not
conflict with anything for 4.18.

Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)


cheers

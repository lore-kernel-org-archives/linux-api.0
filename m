From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC PATCH for 4.17 02/21] rseq: Introduce restartable
 sequences system call (v12)
Date: Thu, 29 Mar 2018 12:24:39 -0400
Message-ID: <20180329122439.4a909c72@gandalf.local.home>
References: <20180327160542.28457-1-mathieu.desnoyers@efficios.com>
        <20180328152814.GI4082@hirez.programming.kicks-ass.net>
        <533214853.56.1522251426819.JavaMail.zimbra@efficios.com>
        <20180328174935.GK4082@hirez.programming.kicks-ass.net>
        <181076499.279.1522268382303.JavaMail.zimbra@efficios.com>
        <alpine.DEB.2.21.1803282305030.1496@nanos.tec.linutronix.de>
        <87410797.545.1522331641598.JavaMail.zimbra@efficios.com>
        <20180329142338.GD4043@hirez.programming.kicks-ass.net>
        <544124089.623.1522337940950.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <544124089.623.1522337940950.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>W
List-Id: linux-api@vger.kernel.org

On Thu, 29 Mar 2018 11:39:00 -0400 (EDT)
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> Enforcing SIGSEGV on syscall entry when nested in a rseq critical section
> will not be free both in terms of syscall overhead, and in terms of code
> maintenance: we'd need to add those checks into entry.S for each architecture
> supported, which pretty much doubles the amount of architecture-specific
> code we need to implement for rseq. Currently, all we need is to hook in
> signal delivery and wire up the system call numbers.

Why not have the check on syscall exit? Then we could use the ptrace
type mechanism to only go that path when a rseq exists for the program.

-- Steve

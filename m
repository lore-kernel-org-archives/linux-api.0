From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC PATCH for 4.17 02/21] rseq: Introduce restartable
 sequences system call (v12)
Date: Thu, 29 Mar 2018 14:07:52 -0400
Message-ID: <20180329140752.12661138@gandalf.local.home>
References: <20180327160542.28457-1-mathieu.desnoyers@efficios.com>
        <20180328174935.GK4082@hirez.programming.kicks-ass.net>
        <181076499.279.1522268382303.JavaMail.zimbra@efficios.com>
        <alpine.DEB.2.21.1803282305030.1496@nanos.tec.linutronix.de>
        <87410797.545.1522331641598.JavaMail.zimbra@efficios.com>
        <20180329142338.GD4043@hirez.programming.kicks-ass.net>
        <544124089.623.1522337940950.JavaMail.zimbra@efficios.com>
        <20180329122439.4a909c72@gandalf.local.home>
        <21903915.856.1522346553810.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <21903915.856.1522346553810.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>W
List-Id: linux-api@vger.kernel.org

On Thu, 29 Mar 2018 14:02:33 -0400 (EDT)
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> Currently, anyone using ptrace on a process has pretty much given up all
> hopes of performance. Processes will use rseq to gain performance, not the
> opposite, so this deterioration will be unwelcome.

The ptrace path has nothing to do with ptrace anymore, and probably be
hard to notice the performance hit. You simply set a TIF flag, and on
exit of the syscall it jumps to a path that checks special cases
(tracing system calls being one of them). It's called the ptrace path
because ptrace was the first one to use it (I'm guessing, I haven't
actually looked at the history).

This is used to add any system call checks that are not done during
normal operation. And this certainly falls under that category.

-- Steve

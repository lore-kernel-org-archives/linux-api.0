From: Christopher Lameter <cl@linux.com>
Subject: Re: [RFC PATCH for 4.16 02/21] rseq: Introduce restartable sequences
 system call (v12)
Date: Thu, 14 Dec 2017 15:14:00 -0600 (CST)
Message-ID: <alpine.DEB.2.20.1712141512360.8945@nuc-kabylake>
References: <20171214161403.30643-1-mathieu.desnoyers@efficios.com> <20171214161403.30643-3-mathieu.desnoyers@efficios.com> <alpine.DEB.2.20.1712141033100.6249@nuc-kabylake> <12046460.34426.1513275177081.JavaMail.zimbra@efficios.com>
 <alpine.DEB.2.20.1712141238180.8340@nuc-kabylake> <1537392285.34532.1513279478488.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1537392285.34532.1513279478488.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>
List-Id: linux-api@vger.kernel.org

On Thu, 14 Dec 2017, Mathieu Desnoyers wrote:

> If we port this concept to kernel-space (as I start to understand
> would be your wish), then a simple pointer store to the current
> task_struct would suffice.

Certainly such a port would be beneficial for non x86 archs.

But my company has extensive user space code that maintains a lot of
counters and does other tricks to get full performance out of the
hardware. Such a mechanism would also be good from user space. Why keep
the good stuff only inside the kernel?

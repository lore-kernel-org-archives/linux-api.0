From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC PATCH for 4.17 02/21] rseq: Introduce restartable
 sequences system call (v12)
Date: Thu, 29 Mar 2018 14:47:14 -0400
Message-ID: <20180329144714.09321ccf@gandalf.local.home>
References: <20180327160542.28457-1-mathieu.desnoyers@efficios.com>
        <alpine.DEB.2.21.1803282305030.1496@nanos.tec.linutronix.de>
        <87410797.545.1522331641598.JavaMail.zimbra@efficios.com>
        <20180329142338.GD4043@hirez.programming.kicks-ass.net>
        <544124089.623.1522337940950.JavaMail.zimbra@efficios.com>
        <20180329122439.4a909c72@gandalf.local.home>
        <21903915.856.1522346553810.JavaMail.zimbra@efficios.com>
        <20180329140752.12661138@gandalf.local.home>
        <1657598086.875.1522348516598.JavaMail.zimbra@efficios.com>
        <20180329144605.599a8f46@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180329144605.599a8f46@gandalf.local.home>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Dave Watson <davejwatson@fb.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>W
List-Id: linux-api@vger.kernel.org

On Thu, 29 Mar 2018 14:46:05 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> This gives us more incentive to help Andy make it faster ;-)

And with Meltdown, I doubt this makes as big of a difference anymore :-/

-- Steve

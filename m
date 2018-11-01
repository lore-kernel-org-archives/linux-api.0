From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC PATCH for 4.21 03/16] mm: Replace BUG_ON() by WARN_ON() in
 vm_unmap_ram()
Date: Thu, 1 Nov 2018 14:46:23 -0400
Message-ID: <20181101144623.61d43102@gandalf.local.home>
References: <20181101095844.24462-1-mathieu.desnoyers@efficios.com>
        <20181101095844.24462-4-mathieu.desnoyers@efficios.com>
        <alpine.DEB.2.21.1811011320160.1642@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1811011320160.1642@nanos.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: linux-api@vger.kernel.org

On Thu, 1 Nov 2018 13:21:12 +0100 (CET)
Thomas Gleixner <tglx@linutronix.de> wrote:

> Mathieu,
> 
> On Thu, 1 Nov 2018, Mathieu Desnoyers wrote:
> 
> > It is encouraged to warn and return rather than use BUG_ON() when
> > the condition can be recovered from in ways that are more graceful than
> > halting the whole system.  
> 
> You're failing to desribe how that graceful recovery works.
> 

I think the graceful recovery is to simply return:

	if (WARN_ON(cond))
		return;

is better than just

	BUG_ON(cond);

As that's what Linus made pretty clear at the Maintainer's Summit.

-- Steve

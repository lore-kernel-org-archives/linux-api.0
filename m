From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC PATCH for 4.15 v12 00/22] Restartable sequences and CPU op
 vector
Date: Thu, 23 Nov 2017 13:49:07 -0800
Message-ID: <20171123214907.GO2482@two.firstfloor.org>
References: <20171121141900.18471-1-mathieu.desnoyers@efficios.com>
 <20171121172144.GL2482@two.firstfloor.org>
 <740195164.19702.1511301908907.JavaMail.zimbra@efficios.com>
 <20171122193219.GI3165@worktop.lehotels.local>
 <2130360737.21248.1511471602798.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2130360737.21248.1511471602798.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin
List-Id: linux-api@vger.kernel.org

> Also, turning both line-level and instruction-level single-stepping into
> infinite loops looks pretty much like a new kernel facility that breaks
> user-space. It's a no-go from my point of view.

You could fix it at the debugger level with suitable annotation. Just
turn the whole rseq into an extended line, and make sure it is handled
for instruction stepping too.

-Andi

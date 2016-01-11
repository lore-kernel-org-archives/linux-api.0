From: Josh Triplett <josh@joshtriplett.org>
Subject: Re: [RFC PATCH 0/3] Implement getcpu_cache system call
Date: Mon, 11 Jan 2016 15:03:06 -0800
Message-ID: <20160111230306.GC28717@cloud>
References: <1451977320-4886-1-git-send-email-mathieu.desnoyers@efficios.com>
 <DDB9C85B850785449757F9914A034FCB4450ACF7@G9W0766.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <DDB9C85B850785449757F9914A034FCB4450ACF7@G9W0766.americas.hpqcorp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Seymour, Shane M" <shane.seymour@hpe.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Peter Zijlstra <peterz@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Andi Kleen <andi@firstfloor.org>, Dave Watson <davejwatson@fb.com>, Chris Lameter <cl@linux.com>, Ingo Molnar <mingo@redhat.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

On Mon, Jan 11, 2016 at 10:38:28PM +0000, Seymour, Shane M wrote:
> I have some concerns and suggestions for you about this.
> 
> What's to stop someone in user space from requesting an arbitrarily large number of CPU # cache locations that the kernel needs to allocate memory to track and each time the task migrates to a new CPU it needs to update them all? Could you use it to dramatically slow down a system/task switching? Should there be a ulimit type value or a sysctl setting to limit the number that you're allowed to register per-task?

The documented behavior of the syscall allows only one location per
thread, so the kernel can track that one and only address rather easily
in the task_struct.  Allowing dynamic allocation definitely doesn't seem
like a good idea.

- Josh Triplett

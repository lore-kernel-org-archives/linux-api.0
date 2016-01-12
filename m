From: Josh Triplett <josh@joshtriplett.org>
Subject: Re: [RFC PATCH 0/3] Implement getcpu_cache system call
Date: Mon, 11 Jan 2016 18:45:49 -0800
Message-ID: <20160112024549.GA6488@x>
References: <1451977320-4886-1-git-send-email-mathieu.desnoyers@efficios.com>
 <DDB9C85B850785449757F9914A034FCB4450ACF7@G9W0766.americas.hpqcorp.net>
 <20160111230306.GC28717@cloud>
 <137700396.343696.1452559758752.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <137700396.343696.1452559758752.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Shane M Seymour <shane.seymour@hpe.com>, Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org, linux-api <linux-api@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Andi Kleen <andi@firstfloor.org>, Dave Watson <davejwatson@fb.com>, Chris Lameter <cl@linux.com>, Ingo Molnar <mingo@redhat.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

On Tue, Jan 12, 2016 at 12:49:18AM +0000, Mathieu Desnoyers wrote:
> ----- On Jan 11, 2016, at 6:03 PM, Josh Triplett josh@joshtriplett.org wrote:
> 
> > On Mon, Jan 11, 2016 at 10:38:28PM +0000, Seymour, Shane M wrote:
> >> I have some concerns and suggestions for you about this.
> >> 
> >> What's to stop someone in user space from requesting an arbitrarily large number
> >> of CPU # cache locations that the kernel needs to allocate memory to track and
> >> each time the task migrates to a new CPU it needs to update them all? Could you
> >> use it to dramatically slow down a system/task switching? Should there be a
> >> ulimit type value or a sysctl setting to limit the number that you're allowed
> >> to register per-task?
> > 
> > The documented behavior of the syscall allows only one location per
> > thread, so the kernel can track that one and only address rather easily
> > in the task_struct.  Allowing dynamic allocation definitely doesn't seem
> > like a good idea.
> 
> The current implementation now allows more than one location per
> thread. Which piece of documentation states that only one location
> per thread is allowed ? This was indeed the case for the prior
> implementations, but I moved to implementing a linked-list of
> cpu_cache areas per thread to allow the getcpu_cache system call to
> be used by more than a single shared object within a given program.

Ah, I missed that change.

> Without the linked list, as soon as more than one shared object try
> to register their cache, the first one will prohibit all others from
> doing so.
> 
> We could perhaps try to document that this system call should only
> ever be used by *libc, and all libraries and applications should
> then use the libc TLS cache variable, but it seems rather fragile,
> and any app/lib could try to register its own cache.

That does seem a bit fragile, true; on the other hand, the linked-list
approach would allow userspace to allocate an unbounded amount of kernel
memory, without any particular control on it.  That doesn't seem
reasonable.  Introducing an rlimit or similar for this seems like
massive overkill, and hardcoding a fixed limit breaks the 0-1-infinity
rule.

Given that any registered location will always provide the same value,
allowing only a single registration doesn't seem *too* problematic;
libc-based programs can use the libc implementation, and non-libc-based
programs can register a location themselves.  And users of this API will
already likely want to use some TLS mechanism, which already interacts
heavily with libc (set_thread_area/clone).

Allowing only one registration at a time seems preferable to introducing
another way to allocate kernel resources on a process's behalf.

- Josh Triplett

From: Will Deacon <will.deacon@arm.com>
Subject: Re: [RFC PATCH 1/3] getcpu_cache system call: cache CPU number of
 running thread
Date: Tue, 5 Jan 2016 12:04:01 +0000
Message-ID: <20160105120400.GD10705@arm.com>
References: <1451977320-4886-1-git-send-email-mathieu.desnoyers@efficios.com>
 <1451977320-4886-2-git-send-email-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1451977320-4886-2-git-send-email-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, Andi Kleen <andi@firstfloor.org>, Dave Watson <davejwatson@fb.com>, Chris Lameter <cl@linux.com>, Ingo Molnar <mingo@redhat.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

Hi Mathieu,

On Tue, Jan 05, 2016 at 02:01:58AM -0500, Mathieu Desnoyers wrote:
> Expose a new system call allowing threads to register userspace memory
> areas where to store the CPU number on which the calling thread is
> running. Scheduler migration sets the TIF_NOTIFY_RESUME flag on the
> current thread. Upon return to user-space, a notify-resume handler
> updates the current CPU value within each registered user-space memory
> area. User-space can then read the current CPU number directly from
> memory.

What guarantees do you provide if a thread other than the one which
registered the cache tries to access the value? Obviously, there's a
potential data race here with the kernel issuing a parallel update, but
are you intending to have single-copy atomicity semantics (like relaxed
atomics in C11) or is this simply going to give you junk?

I ask because, in the absence of alignment checks on the cache pointer,
we can't guarantee single-copy atomicity on ARM when the kernel writes
the current CPU value.

Cheers,

Will

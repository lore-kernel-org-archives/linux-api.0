From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [RFC PATCH 2/2] thread_local_abi: wire up ARM system call
Date: Thu, 10 Dec 2015 16:27:23 +0000
Message-ID: <20151210162723.GN8644@n2100.arm.linux.org.uk>
References: <1449761990-23525-1-git-send-email-mathieu.desnoyers@efficios.com>
 <1449761990-23525-2-git-send-email-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1449761990-23525-2-git-send-email-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Peter Zijlstra <peterz@infradead.org>, Andy Lutomirski <luto@amacapital.net>, Andi Kleen <andi@firstfloor.org>, Dave Watson <davejwatson@fb.com>, Chris Lameter <cl@linux.com>, Ingo Molnar <mingo@redhat.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Dec 10, 2015 at 10:39:50AM -0500, Mathieu Desnoyers wrote:
> Wire up the thread local ABI on ARM32. Call the
> getcpu_cache_handle_notify_resume() function on return to userspace if
> TIF_NOTIFY_RESUME thread flag is set.
> 
> This provides a way to implement a sched_getcpu() on ARM without
> requiring to perform a system call on the fast path.
> 
> [ Untested. ]

Why are you sending this _to_ Thomas?  Shouldn't you be sending it to me
as the arch maintainer?

> diff --git a/arch/arm/include/asm/unistd.h b/arch/arm/include/asm/unistd.h
> index 7b84657..ef55382 100644
> --- a/arch/arm/include/asm/unistd.h
> +++ b/arch/arm/include/asm/unistd.h
> @@ -19,7 +19,7 @@
>   * This may need to be greater than __NR_last_syscall+1 in order to
>   * account for the padding in the syscall table
>   */
> -#define __NR_syscalls  (392)
> +#define __NR_syscalls  (393)

That will cause a build error.  Please leave this alone until we get to
syscall 392, where upon it will need to be incremented by four.

Also, I tend to wait until after -rc1 before adding any syscalls, when
all the new syscalls are obvious and known - this avoids ending up with
two different trees having allocated the same syscall number (which is
why arch maintainers should be the only people who are responsible for
merging updates to their arch's syscall numbering.)

Sure, if multiple different people end up merging patches via different
routes, the conflicts can be resolved when those different routes come
together, but what happens if someone adds the syscall number that they
thought they had to (eg) glibc, and then have to change it later because
come -rc1 it ends up being different...

I'd much rather that all patches to unistd.h are only mergable via the
respective arch maintainers to keep the numbering sane.

(I personally want to follow x86's syscall numbering order as much as
possible.)

-- 
RMK's Patch system: http://www.arm.linux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.

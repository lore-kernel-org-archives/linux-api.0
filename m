From: Josh Triplett <josh@joshtriplett.org>
Subject: Re: [RFC PATCH v2 1/3] getcpu_cache system call: cache CPU number of
 running thread
Date: Wed, 27 Jan 2016 11:16:45 -0800
Message-ID: <20160127191645.GA8045@cloud>
References: <1453913683-28915-1-git-send-email-mathieu.desnoyers@efficios.com>
 <1453913683-28915-2-git-send-email-mathieu.desnoyers@efficios.com>
 <20160127172044.GA7514@cloud>
 <alpine.DEB.2.11.1601271822190.3886@nanos>
 <2049061625.6140.1453916208296.JavaMail.zimbra@efficios.com>
 <20160127180353.GB7514@cloud>
 <604294939.6161.1453920216268.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <604294939.6161.1453920216268.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org, linux-api <linux-api@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Andi Kleen <andi@firstfloor.org>, Dave Watson <davejwatson@fb.com>, Chris Lameter <cl@linux.com>, Ingo Molnar <mingo@redhat.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

On Wed, Jan 27, 2016 at 06:43:36PM +0000, Mathieu Desnoyers wrote:
> ----- On Jan 27, 2016, at 1:03 PM, Josh Triplett josh@joshtriplett.org wrote:
> 
> > On Wed, Jan 27, 2016 at 05:36:48PM +0000, Mathieu Desnoyers wrote:
> >> ----- On Jan 27, 2016, at 12:24 PM, Thomas Gleixner tglx@linutronix.de wrote:
> >> > On Wed, 27 Jan 2016, Josh Triplett wrote:
> >> >> With the dynamic allocation removed, this seems sensible to me.  One
> >> >> minor nit: s/int32_t/uint32_t/g, since a location intended to hold a CPU
> >> >> number should never need to hold a negative number.
> >> > 
> >> > You try to block the future of computing: https://lwn.net/Articles/638673/
> >> 
> >> Besides impossible architectures, there is actually a use-case for
> >> signedness here. It makes it possible to initialize the cpu number
> >> cache to a negative value, e.g. -1, in userspace. Then, a check for
> >> value < 0 can be used to figure out cases where the getcpu_cache
> >> system call is not implemented, and where a fallback (vdso or getcpu
> >> syscall) needs to be used.
> >> 
> >> This is why I have chosen a signed type for the cpu cache so far.
> > 
> > If getcpu_cache doesn't exist, you'll get ENOSYS.  If getcpu_cache
> > returns 0, then you can assume the kernel will give you a valid CPU
> > number.
> 
> I'm referring to the code path that read the content of the cache.
> This code don't call the getcpu_cache system call each time (this
> would defeat the entire purpose of this cache), but still has to
> know whether it can rely on the cache content to contain the current
> CPU number. Seeing a "-1" there is a nice way to tell the fast path
> that it needs to go through a fallback.
> 
> Or perhaps you have another mechanism in mind for that ? How do
> you intend to communicate the ENOSYS from the kernel to all
> eventual readers of the cache, without adding extra function
> call overhead on the fast path ?

Have the fast path assume the cache, without even checking for -1; only
use that fast path if getcpu_cache exists.  If you don't have
getcpu_cache, don't even attempt to use the fast path; substitute in a
fallback implementation.  Don't have a conditional in either version;
just decide which version to use based on system capabilities.

Alternatively, use the implementation you have with a placeholder value,
and just use 0xFFFFFFFF as the placeholder; that seems no more or
less valid.

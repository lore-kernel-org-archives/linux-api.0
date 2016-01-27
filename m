From: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Subject: Re: [RFC PATCH v2 1/3] getcpu_cache system call: cache CPU number of
 running thread
Date: Wed, 27 Jan 2016 13:30:05 -0800
Message-ID: <20160127213005.GA8701@cloud>
References: <1453913683-28915-1-git-send-email-mathieu.desnoyers@efficios.com>
 <1453913683-28915-2-git-send-email-mathieu.desnoyers@efficios.com>
 <20160127172044.GA7514@cloud>
 <alpine.DEB.2.11.1601271822190.3886@nanos>
 <2049061625.6140.1453916208296.JavaMail.zimbra@efficios.com>
 <20160127180353.GB7514@cloud>
 <604294939.6161.1453920216268.JavaMail.zimbra@efficios.com>
 <20160127191645.GA8045@cloud>
 <2037701859.6303.1453928564519.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2037701859.6303.1453928564519.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jan 27, 2016 at 09:02:44PM +0000, Mathieu Desnoyers wrote:
> ----- On Jan 27, 2016, at 2:16 PM, Josh Triplett josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org wrote:
> 
> > On Wed, Jan 27, 2016 at 06:43:36PM +0000, Mathieu Desnoyers wrote:
> >> ----- On Jan 27, 2016, at 1:03 PM, Josh Triplett josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org wrote:
> >> 
> >> > On Wed, Jan 27, 2016 at 05:36:48PM +0000, Mathieu Desnoyers wrote:
> >> >> ----- On Jan 27, 2016, at 12:24 PM, Thomas Gleixner tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org wrote:
> >> >> > On Wed, 27 Jan 2016, Josh Triplett wrote:
> >> >> >> With the dynamic allocation removed, this seems sensible to me.  One
> >> >> >> minor nit: s/int32_t/uint32_t/g, since a location intended to hold a CPU
> >> >> >> number should never need to hold a negative number.
> >> >> > 
> >> >> > You try to block the future of computing: https://lwn.net/Articles/638673/
> >> >> 
> >> >> Besides impossible architectures, there is actually a use-case for
> >> >> signedness here. It makes it possible to initialize the cpu number
> >> >> cache to a negative value, e.g. -1, in userspace. Then, a check for
> >> >> value < 0 can be used to figure out cases where the getcpu_cache
> >> >> system call is not implemented, and where a fallback (vdso or getcpu
> >> >> syscall) needs to be used.
> >> >> 
> >> >> This is why I have chosen a signed type for the cpu cache so far.
> >> > 
> >> > If getcpu_cache doesn't exist, you'll get ENOSYS.  If getcpu_cache
> >> > returns 0, then you can assume the kernel will give you a valid CPU
> >> > number.
> >> 
> >> I'm referring to the code path that read the content of the cache.
> >> This code don't call the getcpu_cache system call each time (this
> >> would defeat the entire purpose of this cache), but still has to
> >> know whether it can rely on the cache content to contain the current
> >> CPU number. Seeing a "-1" there is a nice way to tell the fast path
> >> that it needs to go through a fallback.
> >> 
> >> Or perhaps you have another mechanism in mind for that ? How do
> >> you intend to communicate the ENOSYS from the kernel to all
> >> eventual readers of the cache, without adding extra function
> >> call overhead on the fast path ?
> > 
> > Have the fast path assume the cache, without even checking for -1; only
> > use that fast path if getcpu_cache exists.  If you don't have
> > getcpu_cache, don't even attempt to use the fast path; substitute in a
> > fallback implementation.  Don't have a conditional in either version;
> > just decide which version to use based on system capabilities.
> 
> I'm under the impression that we are talking past each other, because
> I still don't get how your proposal works in practice without relying on
> dynamic code patching.

I assumed that you could select one of two implementations at runtime,
where both implementations did not contain conditionals.  That doesn't
necessarily require dynamic code patching, except in the case where you
inline this code into applications at compile time as you mention below.
I didn't have that detail.

> Let's consider the following scenario:
> 
> Let's suppose getcpu_cache syscall gets a number assigned on ARM for kernel
> 4.6. We build an application against those kernel headers, so the application
> will attempt to perform the getcpu_cache syscall to register the cache for
> each thread.
> 
> However, said application is deployed on an older kernel, for which getcpu_cache
> returns -1, errno=ENOSYS.

I understood that much.

> Within the fast-path, in our scenario, it would be a load instruction
> fetching the cache within an inline assembly. How are we supposed to
> turn that instruction into something else without dynamically patching
> userspace code ?
>
> One important aspect here is that we are not doing a function call to
> get to the fast-path: the fast-path is inlined within the application
> code.

That changes things, then.

> > Alternatively, use the implementation you have with a placeholder value,
> > and just use 0xFFFFFFFF as the placeholder; that seems no more or
> > less valid.
> 
> If we expect this comparison to be performed at every fast-path, it
> would appear to produce slightly more compact code to compare against
> 0 (< 0) than to compare != 0xFFFFFFFF (even though cmp and test have
> the same instruction throughput and latency based on Intel optimization
> manuals).

I had assumed an '== -1', but the same concept applies: just go ahead
and check <0 then, without changing the type.  You can always cast the
pointer you pass to the kernel if you want to make that assumption.  Or
you could perform a single 64-bit read of a number and a boolean.

It seems unfortunate to use a semantically inappropriate type in the
kernel implementation based on constraints in planned userspace code.
>From the kernel's perspective, it seems odd to use int32_t for something
the kernel will only ever write a CPU number into.

That said, I also didn't expect this suggestion to add complexity,
either.  I certainly didn't make this suggestion as future-proofing
against future systems with two billion CPUs. :)

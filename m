From: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Subject: Re: [RFC PATCH v2 1/3] getcpu_cache system call: cache CPU number of
 running thread
Date: Wed, 27 Jan 2016 10:03:53 -0800
Message-ID: <20160127180353.GB7514@cloud>
References: <1453913683-28915-1-git-send-email-mathieu.desnoyers@efficios.com>
 <1453913683-28915-2-git-send-email-mathieu.desnoyers@efficios.com>
 <20160127172044.GA7514@cloud>
 <alpine.DEB.2.11.1601271822190.3886@nanos>
 <2049061625.6140.1453916208296.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2049061625.6140.1453916208296.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jan 27, 2016 at 05:36:48PM +0000, Mathieu Desnoyers wrote:
> ----- On Jan 27, 2016, at 12:24 PM, Thomas Gleixner tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org wrote:
> > On Wed, 27 Jan 2016, Josh Triplett wrote:
> >> With the dynamic allocation removed, this seems sensible to me.  One
> >> minor nit: s/int32_t/uint32_t/g, since a location intended to hold a CPU
> >> number should never need to hold a negative number.
> > 
> > You try to block the future of computing: https://lwn.net/Articles/638673/
> 
> Besides impossible architectures, there is actually a use-case for
> signedness here. It makes it possible to initialize the cpu number
> cache to a negative value, e.g. -1, in userspace. Then, a check for
> value < 0 can be used to figure out cases where the getcpu_cache
> system call is not implemented, and where a fallback (vdso or getcpu
> syscall) needs to be used.
> 
> This is why I have chosen a signed type for the cpu cache so far.

If getcpu_cache doesn't exist, you'll get ENOSYS.  If getcpu_cache
returns 0, then you can assume the kernel will give you a valid CPU
number.

- Josh Triplett

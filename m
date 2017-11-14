From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [RFC PATCH 0/2] x86: Fix missing core serialization on migration
Date: Tue, 14 Nov 2017 17:08:42 +0100
Message-ID: <20171114160842.GH3857@worktop>
References: <20171110211249.10742-1-mathieu.desnoyers@efficios.com>
 <CA+55aFzbroWqi+FTdYhRVSwUZ-M0wDVxjXqDbh40JEnXc2LdgQ@mail.gmail.com>
 <885227610.13045.1510351034488.JavaMail.zimbra@efficios.com>
 <617343212.13932.1510592207202.JavaMail.zimbra@efficios.com>
 <4d47fbb8-8f99-19d3-a9cf-66841aeffac3@scylladb.com>
 <4431530.14831.1510672632887.JavaMail.zimbra@efficios.com>
 <20171114160541.GC3165@worktop.lehotels.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171114160541.GC3165-IIpfhp3q70x9+YH6RuovlLjjLBE8jN/0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Avi Kivity <avi-VrcmuVmyx1hWk0Htik3J/w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, maged michael <maged.michael-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrea Parri <parri.andrea-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Russell King, ARM Linux" <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, Greg Hackmann <ghackmann-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Nov 14, 2017 at 05:05:41PM +0100, Peter Zijlstra wrote:
> On Tue, Nov 14, 2017 at 03:17:12PM +0000, Mathieu Desnoyers wrote:
> > I've tried to create a small single-threaded self-modifying loop in
> > user-space to trigger a trace cache or speculative execution quirk,
> > but I have not succeeded yet. I suspect that I would need to know
> > more about the internals of the processor architecture to create the
> > right stalls that would allow speculative execution to move further
> > ahead, and trigger an incoherent execution flow. Ideas on how to
> > trigger this would be welcome.
> 
> I thought the whole problem was per definition multi-threaded.
> 
> Single-threaded stuff can't get out of sync with itself; you'll always
> observe your own stores.

And even if you could, you can always execute a local serializing
instruction like CPUID to force things.

> And ISTR the JIT scenario being something like the JIT overwriting
> previously executed but supposedly no longer used code. And in this
> scenario you'd want to guarantee all CPUs observe the new code before
> jumping into it.
> 
> The current approach is using mprotect(), except that on a number of
> platforms the TLB invalidate from that is not guaranteed to be strong
> enough to sync for code changes.
> 
> On x86 the mprotect() should work just fine, since we broadcast IPIs for
> the TLB invalidate and the IRET from those will get the things synced up
> again (if nothing else; very likely we'll have done a MOV-CR3 which will
> of course also have sufficient syncness on it).
> 
> But PowerPC, s390, ARM et al that do TLB invalidates without interrupts
> and don't guarantee their TLB invalidate sync against execution units
> are left broken by this scheme.
> 

From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [RFC PATCH 0/2] x86: Fix missing core serialization on migration
Date: Tue, 14 Nov 2017 17:31:59 +0100
Message-ID: <20171114163159.GD3165@worktop.lehotels.local>
References: <20171110211249.10742-1-mathieu.desnoyers@efficios.com>
 <CA+55aFzbroWqi+FTdYhRVSwUZ-M0wDVxjXqDbh40JEnXc2LdgQ@mail.gmail.com>
 <885227610.13045.1510351034488.JavaMail.zimbra@efficios.com>
 <617343212.13932.1510592207202.JavaMail.zimbra@efficios.com>
 <4d47fbb8-8f99-19d3-a9cf-66841aeffac3@scylladb.com>
 <4431530.14831.1510672632887.JavaMail.zimbra@efficios.com>
 <20171114160541.GC3165@worktop.lehotels.local>
 <CALCETrVpBocmrd+R5-R-d+QBvp6h8iZkjo7Xjy6V6x1rPfh25w@mail.gmail.com>
 <alpine.DEB.2.20.1711141713050.2044@nanos>
 <CALCETrXpR7ai047pHtdQe5J+FpuFO5ekeeEqLUt1wVLopyNt_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrXpR7ai047pHtdQe5J+FpuFO5ekeeEqLUt1wVLopyNt_Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Avi Kivity <avi-VrcmuVmyx1hWk0Htik3J/w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, maged michael <maged.michael-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrea Parri <parri.andrea-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Russell King, ARM Linux" <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, Greg Hackmann <ghackmann@go>
List-Id: linux-api@vger.kernel.org

On Tue, Nov 14, 2017 at 08:16:09AM -0800, Andy Lutomirski wrote:
> What guarantees that there's an IPI?  Do we never do a syscall, get
> migrated during syscall processing (due to cond_resched(), for
> example), and land on another CPU that just happened to already be
> scheduling?

Possible, the other CPU could've pulled the task because it went idle.
No IPIs involved in that scenario.

And if it was running a different thread of the same process prior to
that, we'll also not do switch_mm().

So yes, it is possible to construct a migration scenario without core
serializing instructions (of the CPUID/MOV-CR kind, not the LOCK prefix
kind).

Note that that still requires a multi-threaded process.

There is another scenario; where the NOHZ load-balancer moves the task;
such that the NOHZ load balancing CPU is a 3rd CPU. In that case there
is an interrupt (to affect the load-balancing) but it will not land on
the CPU that's going to run the task.

This could happen for a single threaded task; since I suppose the NOHZ
idle CPU that's going to be the victim could have ran our task last and
still lazily have the mm.

Very tricky to make work, not to mention that I suspect actually going
idle will kill a whole bunch of state real quick.

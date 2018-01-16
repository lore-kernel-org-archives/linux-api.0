From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH for 4.16 04/10] membarrier: provide SHARED_EXPEDITED
 command (v2)
Date: Tue, 16 Jan 2018 20:04:18 +0100 (CET)
Message-ID: <alpine.DEB.2.20.1801162003070.2366@nanos>
References: <20180115191104.12437-1-mathieu.desnoyers@efficios.com> <20180115191104.12437-5-mathieu.desnoyers@efficios.com> <alpine.DEB.2.20.1801161915090.2366@nanos> <1577189631.3966.1516129345161.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1577189631.3966.1516129345161.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, maged michael <maged.michael-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Avi Kivity <avi-VrcmuVmyx1hWk0Htik3J/w@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrea Parri <parri.andrea-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Russell King, ARM Linux" <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, Greg Hackmann <ghackmann-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, David
List-Id: linux-api@vger.kernel.org

On Tue, 16 Jan 2018, Mathieu Desnoyers wrote:
> ----- On Jan 16, 2018, at 1:20 PM, Thomas Gleixner tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org wrote:
> > And I really have to ask whether this should be named _GLOBAL_ instead of
> > _SHARED_.
> > 
> > Hmm?
> 
> I agree with you that this behavior fits better a "global" definition
> than a "shared" one, especially given that it does not target a specific
> shared memory mapping. The main issue I have is due to the pre-existing
> MEMBARRIER_CMD_SHARED introduced in Linux 4.3. That one should also have
> been called "MEMBARRIER_CMD_GLOBAL" based on the current line of thoughts.
> 
> Do you envision a way to transition forward to a new "MEMBARRIER_CMD_GLOBAL" for
> the currently existing MEMBARRIER_CMD_SHARED ?
> 
> Perhaps with a duplicated enum entry ?
> 
> enum membarrier_cmd {
>         MEMBARRIER_CMD_QUERY                                    = 0,
>         MEMBARRIER_CMD_SHARED                                   = (1 << 0), /* use MEMBARRIER_CMD_GLOBAL instead */
>         MEMBARRIER_CMD_GLOBAL                                   = (1 << 0),

That should work. Though I doubt that you ever can get rid of CMD_SHARED,
but at least the code is clearer that way.

Thanks,

	tglx

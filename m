From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v4 1/5] getcpu_cache system call: cache CPU number of
 running thread
Date: Sat, 27 Feb 2016 15:58:09 +0100
Message-ID: <20160227145809.GD6356@twins.programming.kicks-ass.net>
References: <1456270120-7560-1-git-send-email-mathieu.desnoyers@efficios.com>
 <alpine.DEB.2.11.1602261719440.3638@nanos>
 <967083634.8940.1456507201156.JavaMail.zimbra@efficios.com>
 <alpine.DEB.2.11.1602261855100.3638@nanos>
 <724964987.9217.1456518255392.JavaMail.zimbra@efficios.com>
 <7096DA23-3908-40DC-A46B-C4CF2252CEE8@zytor.com>
 <1150363257.9781.1456533630895.JavaMail.zimbra@efficios.com>
 <56D14132.5050100@zytor.com>
 <2053850250.10158.1456582501604.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2053850250.10158.1456582501604.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sat, Feb 27, 2016 at 02:15:01PM +0000, Mathieu Desnoyers wrote:
> I'm concerned that this thread-local ABI structure may become messy.
> Let's just imagine how we would first introduce a "cpu_id" field (int32_t),
> and eventually add a "seqnum" field for rseq in the future (unsigned long).

The rseq seq number can be uint32_t, in fact it is in Paul's patches.

(This is true because every seq increment will guarantee a userspace
exception and reload of the value, its impossible to wrap the thing and
get a false positive.)

Paul's patches have the following structure:

struct thread_local_abi {
	union {
		struct {
			u32	cpu_id;
			u32	seq;
		};
		u64 cpu_seq;
	};
	unsigned long post_commit_ip;
};

Although he allows the post_commit_ip to be a separate field (which I
don't think makes sense).

> /* This structure needs to be aligned on pointer size. */

I would mandate the thing be cacheline aligned, and sod packed, that can
lead to horrible layouts.

> If the goal is really to keep the burden on the task struct
> small, we could use kmalloc()/kfree() to allocate and free an
> array of pointers to the various per-thread features, rather

*groan*, no that's even worse, then you get even more loads to update
the fields. The point is to reduce the total overhead of having this
stuff.

Having a single pointer with known offsets is best because then its
guaranteed a single load, then having the whole data structure in a
single cacheline again saves on memops, you can only miss once.

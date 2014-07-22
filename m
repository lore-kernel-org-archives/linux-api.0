From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [RFC PATCH 0/5] futex: introduce an optimistic spinning futex
Date: Tue, 22 Jul 2014 10:39:17 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1407221034260.20847@nanos>
References: <871tte3bjw.fsf@tassilo.jf.intel.com> <CFF29A00.9D44A%dvhart@linux.intel.com> <CFF29E4A.9D44E%dvhart@linux.intel.com> <alpine.DEB.2.10.1407212025130.20847@nanos> <20140721212740.GS3935@laptop> <CALCETrXSaWM6-nxr4ggtMh5qcfTQg4wRvkW8FTSbri5+_1ZbVg@mail.gmail.com>
 <alpine.DEB.2.10.1407212344130.20847@nanos> <CFF2E3D6.9D525%dvhart@linux.intel.com> <alpine.DEB.2.10.1407220047490.20847@nanos> <20140721213457.46623e2f@gandalf.local.home> <20140722074719.GV3935@laptop>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140722074719.GV3935@laptop>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Waiman Long <Waiman.Long-VXdhtT5mjnY@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Davidlohr Bueso <davidlohr-VXdhtT5mjnY@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Low <jason.low2-VXdhtT5mjnY@public.gmane.org>, Scott J Norton <scott.norton-VXdhtT5mjnY@public.gmane.org>, Robert Haas <robertmhaas-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, 22 Jul 2014, Peter Zijlstra wrote:
> Anyway, there is one big fail in the entire futex stack that we 'need'
> to sort some day and that is NUMA. Some people (again database people)
> explicitly do not use futexes and instead use sysvsem because of this.
> 
> The problem with numa futexes is that because they're vaddr based there
> is no (persistent) node information. You always end up having to fall
> back to looking in all nodes before you can guarantee there is no
> matching futex.
> 
> One way to achieve it is by extending the futex value to include a node
> number, but that's obviously a complete ABI break. Then again, it should
> be pretty straight fwd, since the node number doesn't need to be part of
> the actual atomic update part, just part of the userspace storage.

So you want per node hash buckets, right? Fair enough, but how do you
make sure, that no thread/process on a different node is fiddling with
that "node bound" futex as well?

Thanks,

	tglx

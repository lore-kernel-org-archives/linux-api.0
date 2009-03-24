From: Roland McGrath <roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch 0/3] add rt_tgsigqueueinfo syscall [RESEND]
Date: Mon, 23 Mar 2009 23:58:58 -0700 (PDT)
Message-ID: <20090324065858.153BAFC3AB@magilla.sf.frob.com>
References: <20090226133339.875832967@linutronix.de>
	<cfd18e0f0902261319v20ba7bd1pcc91ccc4b2c7d577@mail.gmail.com>
	<20090227000352.7D32BFC339@magilla.sf.frob.com>
	<alpine.LFD.2.00.0903231213180.29264@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: Thomas Gleixner's message of  Monday, 23 March 2009 12:14:59 +0100 <alpine.LFD.2.00.0903231213180.29264-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Oleg Nesterov <oleg-6lXkIZvqkOAvJsYlp49lxw@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Sukadev Bhattiprolu <sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

> > I don't see any rationale for rt_tgsigqueueinfo and rt_sigqueueinfo to
> > differ in their treatment of si_pid/si_uid (whatever that is).  It just
> > seems like common sense that they would match.
> > 
> > Oleg and/or Sukadev have some patches floating around (maybe all in -mm?)
> > that relate to setting those.
> 
> You mean having the same logic as we have in {t,tg,}kill syscalls for
> rt_sigqueueinfo as well ?

I mean just what I said: rt_tgsigqueueinfo's treatment of the siginfo_t
should match rt_sigqueueinfo's.  Make it match rt_sigqueueinfo today and
make sure that if rt_sigqueueinfo changes, then rt_tgsigqueueinfo will
change to match.

> Is there anything else which stands in the way of getting the
> rt_tgsigqueueinfo interface merged ?

I don't see any problem.  But you should at least make sure that Ulrich
likes the syscall interface for implementing pthread_sigqueue or whatever
it will be.


Thanks,
Roland
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

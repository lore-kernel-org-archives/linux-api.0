From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [patch 0/3] add rt_tgsigqueueinfo syscall [RESEND]
Date: Mon, 23 Mar 2009 12:14:59 +0100 (CET)
Message-ID: <alpine.LFD.2.00.0903231213180.29264@localhost.localdomain>
References: <20090226133339.875832967@linutronix.de> <cfd18e0f0902261319v20ba7bd1pcc91ccc4b2c7d577@mail.gmail.com> <20090227000352.7D32BFC339@magilla.sf.frob.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20090227000352.7D32BFC339-nL1rrgvulkc2UH6IwYuUx0EOCMrvLtNR@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland McGrath <roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Oleg Nesterov <oleg-6lXkIZvqkOAvJsYlp49lxw@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Sukadev Bhattiprolu <sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Roland,

On Thu, 26 Feb 2009, Roland McGrath wrote:

> I don't see any rationale for rt_tgsigqueueinfo and rt_sigqueueinfo to
> differ in their treatment of si_pid/si_uid (whatever that is).  It just
> seems like common sense that they would match.
> 
> Oleg and/or Sukadev have some patches floating around (maybe all in -mm?)
> that relate to setting those.

You mean having the same logic as we have in {t,tg,}kill syscalls for
rt_sigqueueinfo as well ?

Is there anything else which stands in the way of getting the
rt_tgsigqueueinfo interface merged ?

Thanks,

	tglx
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

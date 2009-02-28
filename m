From: Roland McGrath <roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch 0/3] add rt_tgsigqueueinfo syscall [RESEND]
Date: Fri, 27 Feb 2009 18:44:24 -0800 (PST)
Message-ID: <20090228024424.D237CFC3DA@magilla.sf.frob.com>
References: <20090226133339.875832967@linutronix.de>
	<cfd18e0f0902261319v20ba7bd1pcc91ccc4b2c7d577@mail.gmail.com>
	<alpine.LFD.2.00.0902262311350.9135@localhost.localdomain>
	<cfd18e0f0902271753ld9b432tae6c0ee783a24480@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: Michael Kerrisk's message of  Saturday, 28 February 2009 14:53:23 +1300 <cfd18e0f0902271753ld9b432tae6c0ee783a24480-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Oleg Nesterov <oleg-6lXkIZvqkOAvJsYlp49lxw@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, drepper-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

> With respect to the first point, it seems to me reasonably likely that
> there would be use cases where the receiving thread wants to know the
> thread ID of the sender -- especially when sender and receiver are in
> the same process.

But expecting si_pid to play that role is bizarre.  It's never what any
POSIX-like program would do, both since POSIX says si_pid is a process ID,
and because there are no POSIX-like interfaces at all that use Linux TIDs
to refer to threads.

Wanting this only seems plausible within one process.  In that case, sender
and recipient know they share memory.  The normal thing to do (and what
POSIX applications will do) is to store that info somewhere pointed to by
the sigval.


Thanks,
Roland
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

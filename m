From: Michael Kerrisk <mtk.manpages-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Subject: Re: [patch 0/3] add rt_tgsigqueueinfo syscall [RESEND]
Date: Sat, 28 Feb 2009 21:46:35 +1300
Message-ID: <cfd18e0f0902280046k3171c97uaf9d984bd7894e82@mail.gmail.com>
References: <20090226133339.875832967@linutronix.de>
	 <cfd18e0f0902261319v20ba7bd1pcc91ccc4b2c7d577@mail.gmail.com>
	 <alpine.LFD.2.00.0902262311350.9135@localhost.localdomain>
	 <cfd18e0f0902271753ld9b432tae6c0ee783a24480@mail.gmail.com>
	 <20090228024424.D237CFC3DA@magilla.sf.frob.com>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20090228024424.D237CFC3DA-nL1rrgvulkc2UH6IwYuUx0EOCMrvLtNR@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland McGrath <roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Oleg Nesterov <oleg-6lXkIZvqkOAvJsYlp49lxw@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, drepper-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 2/28/09, Roland McGrath <roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> With respect to the first point, it seems to me reasonably likely that
>> there would be use cases where the receiving thread wants to know the
>> thread ID of the sender -- especially when sender and receiver are in
>> the same process.
>
> But expecting si_pid to play that role is bizarre.

Oh -- I wasn't suggeting that si_pid do that task; I was instead
wondering if we needed an additional si_threadid field (or some such).

> It's never what any
> POSIX-like program would do, both since POSIX says si_pid is a process ID,
> and because there are no POSIX-like interfaces at all that use Linux TIDs
> to refer to threads.

(Nod.)

> Wanting this only seems plausible within one process.

We are in agreement.

> In that case, sender
> and recipient know they share memory.  The normal thing to do (and what
> POSIX applications will do) is to store that info somewhere pointed to by
> the sigval.

Good point.  That would be another of dealing with point I wondered
about, and probably better than my idea.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

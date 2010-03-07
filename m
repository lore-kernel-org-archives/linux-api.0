From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch 050/160] prctl: add PR_SET_PROCTITLE_AREA option for
	prctl()
Date: Sun, 7 Mar 2010 20:28:26 +0100
Message-ID: <20100307192826.GA18616@redhat.com>
References: <201003052142.o25Lgbpg029522@imap1.linux-foundation.org> <alpine.LFD.2.00.1003061100170.4530@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1003061100170.4530-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org, bdonlan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, drepper-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, tss-X3B1VOXEql0@public.gmane.org, xiyou.wangcong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 03/06, Linus Torvalds wrote:
>
> On Fri, 5 Mar 2010, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org wrote:
> >
> > This patch makes it possible for userspace to implement setproctitle()
> > cleanly.  It adds a new PR_SET_PROCTITLE_AREA option for prctl(), which
> > updates task's mm_struct->arg_start and arg_end to the given area.
>
> This looks overly complicated. Why do you change the whole locking rules,
> instead of protecting _only_ the "arg_start/arg_end" case?
>
> The thing is, there's no reason to hold the mmap_sem over the whole thing,
> and I don't think this is important enough to be a valid reason for
> exposing a whole new "locked" access variant, when a simple "protect just
> the arg_start/end" would handle it.

It was me who suggested to re-use mm->mmap_sem instead of adding the new
lock, but looking at this patch again I do not understand the reason this
lock should be held throughout in proc_pid_cmdline(). If there is no such
a reason, then the new access_process_vm_locked (cough, also suggested by
me ;) is not needed.

Oleg.

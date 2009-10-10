From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [resend][PATCH] Added PR_SET_PROCTITLE_AREA option for prctl()
Date: Fri, 9 Oct 2009 19:42:50 -0700
Message-ID: <20091009194250.eb76e338.akpm@linux-foundation.org>
References: <20091009134354.12A7.A69D9226@jp.fujitsu.com>
	<20091009171344.3fc5f28b.akpm@linux-foundation.org>
	<3e8340490910091922g7891b31al649e91f15ffae687@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3e8340490910091922g7891b31al649e91f15ffae687-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bryan Donlan <bdonlan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ulrich Drepper <drepper-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, 9 Oct 2009 22:22:10 -0400 Bryan Donlan <bdonlan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Fri, Oct 9, 2009 at 8:13 PM, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> 
> >> + __ __ __ __ __ __ res = access_process_vm(task, mm->arg_start, buffer, len, 0);
> >> +
> >> + __ __ __ __ __ __ if (mm->arg_end != mm->env_start)
> >> + __ __ __ __ __ __ __ __ __ __ /* PR_SET_PROCTITLE_AREA used */
> >> __ __ __ __ __ __ __ __ __ __ __ res = strnlen(buffer, res);
> >
> > Hang on.
> >
> > If PR_SET_PROCTITLE_AREA installed a bad address then
> > access_process_vm() will return -EFAULT and nothing was written to
> > `buffer'?
> >
> > Also, concurrent PR_SET_PROCTITLE_AREA could cause arg_start and
> > arg_end to have inconsistent/incoherent values. __This might result in a
> > fault but it also might result in a read of garbage userspace memory.
> >
> > I guess all of these issues could be written off as "userspace bugs",
> > but our behaviour here isn't nice. __We should at least return that
> > -EFAULT!.
> 
> access_process_vm() does not return an error code - just the number of
> bytes successfully transferred. If there's a fault, we just get 0 (or
> some intermediate value) back

OK.

> (as discussed on lkml).

That's not code documentation :(

> >> + __ __ __ __ __ __ __ __ __ __ __ __ __ __ res += access_process_vm(task, mm->env_start,

Your email client is converting tabs to non-ascii crap.  gmail.  Sigh.

> > __ __ __ __ __ __ __ __mm->arg_start = addr;
> > __ __ __ __ __ __ __ __mm->arg_end = addr + len;
> > __ __ __ __ __ __ __ __spin_unlock(mm->lock);
> >
> > and
> >
> > __ __ __ __proc_pid_cmdline()
> > __ __ __ __{
> > __ __ __ __ __ __ __ __unsigned long addr;
> > __ __ __ __ __ __ __ __unsigned long end;
> >
> > __ __ __ __ __ __ __ __spin_lock(mm->lock);
> > __ __ __ __ __ __ __ __addr = mm->arg_start;
> > __ __ __ __ __ __ __ __end = mm->arg_end;
> > __ __ __ __ __ __ __ __spin_unlock(mm->lock);
> >
> > __ __ __ __ __ __ __ __<use `addr' and `len'>
> > __ __ __ __}
> >
> > ?
> 
> As discussed on the lkml thread, this opens up a nasty race:
> 
> Process A: calls PR_SET_PROCTITLE_AREA
> Process B: read cmdline:
> Process B: spin_lock
> Process B: read mm->arg_*
> Process B: unlock
> Process A: mm->arg_* = ...
> Process A: free(old_cmdline_area)
> Process A: secret_password = malloc(...)
> Process A: strcpy(secret_password, stuff);
> Process B: access_process_vm
> 
> If secret_password == arg_start, then process B just read secret
> information from process A's address space. Since process A has no
> idea when or even if process B will complete its read, it has no way
> of protecting itself from this, save from never reusing any memory
> which has ever been assigned to a proctitle area.

OK.

But there's no way in which the reader of either the patch or the
resulting code can discover this subtlety.

> The solution is to use the seqlock to detect this, and prevent the
> secret information from ever making it back to process B's userspace.
> Note that it's not enough to just recheck arg_start, as process A may
> reassign the proctitle area back to its original position after having
> it somewhere else for a while.

Well seqlock is _a_ solution.  Another is to use a mutex or an rwsem
around the whole operation.

With the code as you propose it, what happens if a process sits in a
tight loop running setproctitle?  Do other processes running `ps' get
stuck in a livelock until the offending process gets scheduled out?


--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

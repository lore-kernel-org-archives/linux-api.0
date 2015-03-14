From: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Subject: Re: [PATCH 6/6] clone4: Introduce new CLONE_FD flag to get task exit
 notification via fd
Date: Sat, 14 Mar 2015 12:48:17 -0700
Message-ID: <20150314194817.GF22130@thin>
References: <cover.1426180120.git.josh@joshtriplett.org>
 <9c39c576e1d9a9912b4aec54d833a73a84d2f592.1426180120.git.josh@joshtriplett.org>
 <20150314143558.GB12086@redhat.com>
 <20150314191500.GC22130@thin>
 <20150314192456.GA8707@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150314192456.GA8707-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Thiago Macieira <thiago.macieira-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sat, Mar 14, 2015 at 08:24:56PM +0100, Oleg Nesterov wrote:
> On 03/14, Josh Triplett wrote:
> >
> > On Sat, Mar 14, 2015 at 03:35:58PM +0100, Oleg Nesterov wrote:
> > > On 03/12, Josh Triplett wrote:
> > > >
> > > > @@ -598,7 +600,9 @@ static void exit_notify(struct task_struct *tsk, int group_dead)
> > > >  	if (group_dead)
> > > >  		kill_orphaned_pgrp(tsk->group_leader, NULL);
> > > >
> > > > -	if (unlikely(tsk->ptrace)) {
> > > > +	if (tsk->autoreap) {
> > > > +		autoreap = true;
> > > > +	} else if (unlikely(tsk->ptrace)) {
> > > >  		int sig = thread_group_leader(tsk) &&
> > > >  				thread_group_empty(tsk) &&
> > > >  				!ptrace_reparented(tsk) ?
> > > > @@ -612,8 +616,10 @@ static void exit_notify(struct task_struct *tsk, int group_dead)
> > > >  	}
> > > >
> > > >  	tsk->exit_state = autoreap ? EXIT_DEAD : EXIT_ZOMBIE;
> > > > -	if (tsk->exit_state == EXIT_DEAD)
> > > > +	if (tsk->exit_state == EXIT_DEAD) {
> > > >  		list_add(&tsk->ptrace_entry, &dead);
> > > > +		clonefd_do_notify(tsk);
> > > > +	}
> > >
> > > And even ignoring semantics issues, this change looks simply buggy anyway ;)
> > >
> > > How can we do list_add(&tsk->ptrace_entry) if it is traced by _another_ task?
> > > ->ptrace_entry is used by debugger.
> >
> > That list_add was there before; I didn't change that.
> 
> But this doesn't matter,
> 
> > I just added a
> > second line inside the EXIT_DEAD case, to call clonefd_do_notify (which
> > wakes up potential callers of poll/read).
> 
> No. Please read this code before and after your patch. You also added
> 
> 	if (tsk->autoreap)
> 		autoreap = true;
> 
> at the start. At this can trigger the _wrong_ list_add(&tsk->ptrace_entry),
> when the task is traced by another thread.
> 
> The current code can only use ->ptrace_entry if it was untraced (by us).

Ugh.  I finally realized just how magic the logic is there; thanks for
catching this.  The call to forget_original_parent at the top of
exit_notify can potentially add the process to the list "dead" here,
either in exit_ptrace() or in reparent_leader() (the latter of which has
its own duplicate of part of exit_notify's logic, including
do_notify_parent and setting exit_state).  Then exit_notify can add the
task to "dead" itself under some conditions that clearly depend on the
exact nature of the existing three-way conditional above.  And finally
exit_notify loops over "dead" and releases all the tasks there.

I'll investigate this further and make sure the ptrace case gets
handled correctly.

- Josh Triplett

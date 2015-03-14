From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 6/6] clone4: Introduce new CLONE_FD flag to get task
	exit notification via fd
Date: Sat, 14 Mar 2015 20:24:56 +0100
Message-ID: <20150314192456.GA8707@redhat.com>
References: <cover.1426180120.git.josh@joshtriplett.org> <9c39c576e1d9a9912b4aec54d833a73a84d2f592.1426180120.git.josh@joshtriplett.org> <20150314143558.GB12086@redhat.com> <20150314191500.GC22130@thin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150314191500.GC22130@thin>
Sender: linux-kernel-owner@vger.kernel.org
To: Josh Triplett <josh@joshtriplett.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>, Rik van Riel <riel@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Thiago Macieira <thiago.macieira@intel.com>, Michael Kerrisk <mtk.manpages@gmail.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On 03/14, Josh Triplett wrote:
>
> On Sat, Mar 14, 2015 at 03:35:58PM +0100, Oleg Nesterov wrote:
> > On 03/12, Josh Triplett wrote:
> > >
> > > @@ -598,7 +600,9 @@ static void exit_notify(struct task_struct *tsk, int group_dead)
> > >  	if (group_dead)
> > >  		kill_orphaned_pgrp(tsk->group_leader, NULL);
> > >
> > > -	if (unlikely(tsk->ptrace)) {
> > > +	if (tsk->autoreap) {
> > > +		autoreap = true;
> > > +	} else if (unlikely(tsk->ptrace)) {
> > >  		int sig = thread_group_leader(tsk) &&
> > >  				thread_group_empty(tsk) &&
> > >  				!ptrace_reparented(tsk) ?
> > > @@ -612,8 +616,10 @@ static void exit_notify(struct task_struct *tsk, int group_dead)
> > >  	}
> > >
> > >  	tsk->exit_state = autoreap ? EXIT_DEAD : EXIT_ZOMBIE;
> > > -	if (tsk->exit_state == EXIT_DEAD)
> > > +	if (tsk->exit_state == EXIT_DEAD) {
> > >  		list_add(&tsk->ptrace_entry, &dead);
> > > +		clonefd_do_notify(tsk);
> > > +	}
> >
> > And even ignoring semantics issues, this change looks simply buggy anyway ;)
> >
> > How can we do list_add(&tsk->ptrace_entry) if it is traced by _another_ task?
> > ->ptrace_entry is used by debugger.
>
> That list_add was there before; I didn't change that.

But this doesn't matter,

> I just added a
> second line inside the EXIT_DEAD case, to call clonefd_do_notify (which
> wakes up potential callers of poll/read).

No. Please read this code before and after your patch. You also added

	if (tsk->autoreap)
		autoreap = true;

at the start. At this can trigger the _wrong_ list_add(&tsk->ptrace_entry),
when the task is traced by another thread.

The current code can only use ->ptrace_entry if it was untraced (by us).

Oleg.

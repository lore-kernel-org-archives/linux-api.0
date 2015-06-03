From: Tycho Andersen <tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [PATCH] seccomp: add ptrace commands for suspend/resume
Date: Wed, 3 Jun 2015 08:43:03 -0600
Message-ID: <20150603144303.GC3160@smitten>
References: <1433186918-9626-1-git-send-email-tycho.andersen@canonical.com>
 <20150602182829.GA23449@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150602182829.GA23449-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jun 02, 2015 at 08:28:29PM +0200, Oleg Nesterov wrote:
> On 06/01, Tycho Andersen wrote:
> >
> > --- a/include/linux/seccomp.h
> > +++ b/include/linux/seccomp.h
> > @@ -25,6 +25,9 @@ struct seccomp_filter;
> >  struct seccomp {
> >  	int mode;
> >  	struct seccomp_filter *filter;
> > +#ifdef CONFIG_CHECKPOINT_RESTORE
> > +	bool suspended;
> > +#endif
> 
> Then afaics you need to change copy_seccomp() to clear ->suspended.
> At least if the child is not traced.

Yes, thank you.

> > @@ -691,6 +697,11 @@ u32 seccomp_phase1(struct seccomp_data *sd)
> >  	int this_syscall = sd ? sd->nr :
> >  		syscall_get_nr(current, task_pt_regs(current));
> >  
> > +#ifdef CONFIG_CHECKPOINT_RESTORE
> > +	if (unlikely(current->seccomp.suspended))
> > +		return SECCOMP_PHASE1_OK;
> > +#endif
> > +
> 
> I am wondering if PTRACE_SUSPEND_SECCOMP can just clear/set TIF_SECCOMP.
> Of course, it is not that resume_seccomp() can simply do set_tsk_thread_flag,
> it should be more careful. And prctl_set_seccomp() paths will need some
> changes. Probably not, this would be more complex.
> 
> So perhaps it would be better to add PTRACE_O_SUSPEND_SECCOMP? This also
> solves the problem with the killed tracer. Except TIF_NOTSC...
> 
> But why do we bother to play with TIF_NOTSC, could you explain?

The procedure for restoring is to call seccomp suspend, restore the
seccomp filters (and potentially other stuff), and then resume them at
the end. If the other stuff happens to use RDTSC, the process gets
killed because TIF_NOTSC has been set. It seems to me that since
seccomp is the one setting TIF_NOTSC, suspending seccomp should unset
it.

We can work around this in criu by doing the seccomp restore as the
very last thing before the final sigreturn, but that seems like the
seccomp suspend API is incomplete, IMO. However, since both you and
Andy complained, perhaps I should remove it :)

> > +int suspend_seccomp(struct task_struct *task)
> > +{
> > +	int ret = -EACCES;
> > +
> > +	spin_lock_irq(&task->sighand->siglock);
> > +
> > +	if (!capable(CAP_SYS_ADMIN))
> > +		goto out;
> 
> I am puzzled ;) Why do we need ->siglock? And even if we need it, why
> we can't check CAP_SYS_ADMIN lockless?

I'm not sure, other pieces of the seccomp code
(seccomp_set_mode_strict() and friends) take the lock when
manipulating the seccomp mode, so I just followed suit here. You're
right that we can do the capability check lockless, I'll make that
change.

> And I am not sure I understand why do we need the additional security
> check, but I leave this to you and Andy.

Yes, it is required to prevent the case Pavel mentions (although there
are other ways to get around seccomp with ptrace, the goal here is to
not depend on that behavior so that when it is eventually fixed this
doesn't break).

> If you have the rights to trace this task, then you can do anything
> the tracee could do without the filtering.
>
> > +
> > +	task->seccomp.suspended = true;
> > +
> > +#ifdef TIF_NOTSC
> > +	if (task->seccomp.mode == SECCOMP_MODE_STRICT)
> > +		clear_tsk_thread_flag(task, TIF_NOTSC);
> > +#endif
> > +
> > +	ret = 0;
> > +out:
> > +	spin_unlock_irq(&task->sighand->siglock);
> > +
> > +	return ret;
> > +}
> > +
> > +int resume_seccomp(struct task_struct *task)
> > +{
> > +	int ret = -EACCES;
> > +
> > +	spin_lock_irq(&task->sighand->siglock);
> > +
> > +	if (!capable(CAP_SYS_ADMIN))
> > +		goto out;
> > +
> > +	task->seccomp.suspended = false;
> > +
> > +#ifdef TIF_NOTSC
> > +	if (task->seccomp.mode == SECCOMP_MODE_STRICT)
> > +		set_tsk_thread_flag(task, TIF_NOTSC);
> > +#endif
> > +
> > +	ret = 0;
> > +out:
> > +	spin_unlock_irq(&task->sighand->siglock);
> > +
> > +	return ret;
> > +}
> > +#endif /* CONFIG_CHECKPOINT_RESTORE */
> 
> Well, I do not think we need 2 helpers, just one which takes a boolean
> will look better, imo.

Ok, this has changed slightly with the "always resume on
detach/unlink" change Pavel suggested, but I'll see if I can find a
nice way to merge them.

Thanks for taking a look.

Tycho

> Oleg.
> 

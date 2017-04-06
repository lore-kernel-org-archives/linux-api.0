From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC][PATCH v2 5/5] signal: Don't allow accessing signal_struct
 by old threads after exec
Date: Thu, 6 Apr 2017 17:48:38 +0200
Message-ID: <20170406154837.GA7444@redhat.com>
References: <87d1dyw5iw.fsf@xmission.com>
 <87tw7aunuh.fsf@xmission.com>
 <87lgsmunmj.fsf_-_@xmission.com>
 <20170304170312.GB13131@redhat.com>
 <8760ir192p.fsf@xmission.com>
 <878tnkpv8h.fsf_-_@xmission.com>
 <874ly6a0h1.fsf_-_@xmission.com>
 <87zify76z9.fsf_-_@xmission.com>
 <20170405161812.GD14536@redhat.com>
 <87zifu90to.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87zifu90to.fsf-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Aleksa Sarai <asarai-IBi9RG/b67k@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Attila Fazekas <afazekas-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ulrich Obergfell <uobergfe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eugene Syromiatnikov <esyr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 04/05, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:
>
> >> --- a/kernel/signal.c
> >> +++ b/kernel/signal.c
> >> @@ -995,6 +995,10 @@ static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
> >>  			from_ancestor_ns || (info == SEND_SIG_FORCED)))
> >>  		goto ret;
> >>
> >> +	/* Don't allow thread group signals after exec */
> >> +	if (group && (t->signal->exec_id != t->self_exec_id))
> >> +		goto ret;
> >
> > Hmm. Either we do not need this exec_id check at all, or we should not
> > take "group" into account; a fatal signal (say SIGKILL) will kill the
> > whole thread-group.
>
> Wow.  Those are crazy semantics for fatal signals.  Sending a tkill
> should not affect the entire thread group.

How so? SIGKILL or any fatal signal should kill the whole process, even if
it was sent by tkill().

> Oleg I think this is a bug
> you introduced and likely requires a separate fix.
>
> I really don't understand the logic in:
>
> commit 5fcd835bf8c2cde06404559b1904e2f1dfcb4567
> Author: Oleg Nesterov <oleg-6lXkIZvqkOAvJsYlp49lxw@public.gmane.org>
> Date:   Wed Apr 30 00:52:55 2008 -0700
>
>     signals: use __group_complete_signal() for the specific signals too

No. You can even forget about "send" path for the moment. Just suppose that
a thread dequeues SIGKILL sent by tkill(). In this case it will call
do_group_exit() and kill the group anyway. It is not possible to kill an
individual thread, and linux never did this.

Afaics, this commit also fixes the case when SIGKILL can be lost when tkill()
races with the exiting target. Or if the target is a zombie-leader. Exactly
because they obviously can't dequeue SIGKILL.

Plus we want to shutdown the whole thread-group "asap", that is why
complete_signal() sets SIGNAL_GROUP_EXIT and sends SIGKILL to other threads
in the "send" path.

This btw reminds me that we want to do the same with sig_kernel_coredump()
signals too, but this is not simple.

> >> @@ -1247,7 +1251,8 @@ struct sighand_struct *__lock_task_sighand(struct task_struct *tsk,
> >>  		 * must see ->sighand == NULL.
> >>  		 */
> >>  		spin_lock(&sighand->siglock);
> >> -		if (likely(sighand == tsk->sighand)) {
> >> +		if (likely((sighand == tsk->sighand) &&
> >> +			   (tsk->self_exec_id == tsk->signal->exec_id))) {
> >
> > Oh, this doesn't look good to me. Yes, with your approach we probably need
> > this to, say, ensure that posix-cpu-timer can't kill the process after exec,
> > but I'd rather add the exit_state check into run_posix_timers().
>
> The entire point of lock_task_sighand is to not operate on
> tasks/processes that have exited.

Well, the entire point of lock_task_sighand() is take ->siglock if possible.

> The fact it even sighand in there is
> deceptive because it is all about siglock and nothing to do with
> sighand.

Not sure I understand what you mean...

Yes, lock_task_sighand() can obviously fail, and yes the failure is used
as an indication that this thread has gone. But a zombie thread controlled
by the parent/debugger has not gone yet.

> > ====================================================================
> > Now lets fix another problem. A mt exec suceeds and apllication does
> > sys_seccomp(SECCOMP_FILTER_FLAG_TSYNC) which fails because it finds
> > another (zombie) SECCOMP_MODE_FILTER thread.
> >
> > And after we fix this problem, what else we will need to fix?
> >
> >
> > I really think that - whatever we do - there should be no other threads
> > after exec, even zombies.
>
> I see where you are coming from.
>
> I need to stare at this a bit longer.  Because you are right.  Reusing
> the signal_struct and leaving zombies around is very prone to bugs.  So
> it is not very maintainable.

Yes, yes, yes. This is what I was arguing with.

> I suspect the answer here is to simply allocate a new sighand_struct and
> a new signal_struct if there we are not single threaded by the time we
> get down to the end of de_thread.

May be. Not sure. Looks very nontrivial.

And I still think that if we do this, we should fix the bug first, then try
to do something like this.

Oleg.

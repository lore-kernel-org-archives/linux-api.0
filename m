From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/2] fix the traced mt-exec deadlock
Date: Sat, 4 Mar 2017 17:54:41 +0100
Message-ID: <20170304165440.GA13131@redhat.com>
References: <20170213141452.GA30203@redhat.com> <20170224160354.GA845@redhat.com> <87shmv6ufl.fsf@xmission.com> <20170303173326.GA17899@redhat.com> <87tw7axlr0.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87tw7axlr0.fsf-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Aleksa Sarai <asarai-IBi9RG/b67k@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Attila Fazekas <afazekas-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ulrich Obergfell <uobergfe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 03/03, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:
>
> >> @@ -699,8 +701,6 @@ static void exit_notify(struct task_struct *tsk, int group_dead)
> >>  	}
> >>
> >>  	tsk->exit_state = autoreap ? EXIT_DEAD : EXIT_ZOMBIE;
> >> -	if (tsk->exit_state == EXIT_DEAD)
> >> -		list_add(&tsk->ptrace_entry, &dead);
> >>
> >>  	/* mt-exec, de_thread() is waiting for group leader */
> >>  	if (unlikely(tsk->signal->notify_count < 0))
> >> @@ -711,6 +711,8 @@ static void exit_notify(struct task_struct *tsk, int group_dead)
> >>  		list_del_init(&p->ptrace_entry);
> >>  		release_task(p);
> >>  	}
> >> +	if (autoreap)
> >> +		release_task(tsk);
> >
> > These 2 changes are not needed. release_task(tsk) will be called by
> > list_for_each_entry_safe() above if autoreap == T.
>
> Except for the practical case that for threads that are ptraced
> tsk->ptrace_entry is already in use.  Which means we can't use
> list_add(&tsk->ptrace_entry, &dead).

Yes, I was wrong here, thanks for correcting me.

Oleg.

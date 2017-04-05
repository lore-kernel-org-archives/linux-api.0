From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC][PATCH v2 5/5] signal: Don't allow accessing
        signal_struct by old threads after exec
Date: Wed, 5 Apr 2017 18:18:12 +0200
Message-ID: <20170405161812.GD14536@redhat.com>
References: <20170303173326.GA17899@redhat.com> <87tw7axlr0.fsf@xmission.com> <87d1dyw5iw.fsf@xmission.com> <87tw7aunuh.fsf@xmission.com> <87lgsmunmj.fsf_-_@xmission.com> <20170304170312.GB13131@redhat.com> <8760ir192p.fsf@xmission.com> <878tnkpv8h.fsf_-_@xmission.com> <874ly6a0h1.fsf_-_@xmission.com> <87zify76z9.fsf_-_@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87zify76z9.fsf_-_-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Aleksa Sarai <asarai-IBi9RG/b67k@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Attila Fazekas <afazekas-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ulrich Obergfell <uobergfe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 04/02, Eric W. Biederman wrote:
>
> Add exec_id to signal_struct and compare it at a few choice moments.

I really dislike this change no matter what, sorry.

Firstly, task_struct->*_exec_id should simply die (I already have the
patch), or at least they should be moved into signal_struct simply
because this is per-process thing.

> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -995,6 +995,10 @@ static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
>  			from_ancestor_ns || (info == SEND_SIG_FORCED)))
>  		goto ret;
>
> +	/* Don't allow thread group signals after exec */
> +	if (group && (t->signal->exec_id != t->self_exec_id))
> +		goto ret;

Hmm. Either we do not need this exec_id check at all, or we should not
take "group" into account; a fatal signal (say SIGKILL) will kill the
whole thread-group.

> @@ -1247,7 +1251,8 @@ struct sighand_struct *__lock_task_sighand(struct task_struct *tsk,
>  		 * must see ->sighand == NULL.
>  		 */
>  		spin_lock(&sighand->siglock);
> -		if (likely(sighand == tsk->sighand)) {
> +		if (likely((sighand == tsk->sighand) &&
> +			   (tsk->self_exec_id == tsk->signal->exec_id))) {

Oh, this doesn't look good to me. Yes, with your approach we probably need
this to, say, ensure that posix-cpu-timer can't kill the process after exec,
but I'd rather add the exit_state check into run_posix_timers().

But OK, suppose that we fix the problems with signal-after-exec.

====================================================================
Now lets fix another problem. A mt exec suceeds and apllication does
sys_seccomp(SECCOMP_FILTER_FLAG_TSYNC) which fails because it finds
another (zombie) SECCOMP_MODE_FILTER thread.

And after we fix this problem, what else we will need to fix?


I really think that - whatever we do - there should be no other threads
after exec, even zombies.

Oleg.

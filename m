From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC][PATCH 2/2] exec: If possible don't wait for ptraced
 threads to be reaped
Date: Sun, 2 Apr 2017 17:35:17 +0200
Message-ID: <20170402153517.GA12637@redhat.com>
References: <87shmv6ufl.fsf@xmission.com>
 <20170303173326.GA17899@redhat.com>
 <87tw7axlr0.fsf@xmission.com>
 <87d1dyw5iw.fsf@xmission.com>
 <87tw7aunuh.fsf@xmission.com>
 <87lgsmunmj.fsf_-_@xmission.com>
 <20170304170312.GB13131@redhat.com>
 <8760ir192p.fsf@xmission.com>
 <878tnkpv8h.fsf_-_@xmission.com>
 <87vaqooggs.fsf_-_@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87vaqooggs.fsf_-_-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Aleksa Sarai <asarai-IBi9RG/b67k@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Attila Fazekas <afazekas-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ulrich Obergfell <uobergfe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 04/01, Eric W. Biederman wrote:
>
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1052,6 +1052,7 @@ static int de_thread(struct task_struct *tsk)
>  	struct signal_struct *sig = tsk->signal;
>  	struct sighand_struct *oldsighand = tsk->sighand;
>  	spinlock_t *lock = &oldsighand->siglock;
> +	bool may_hang;
>
>  	if (thread_group_empty(tsk))
>  		goto no_thread_group;
> @@ -1069,9 +1070,10 @@ static int de_thread(struct task_struct *tsk)
>  		return -EAGAIN;
>  	}
>
> +	may_hang = atomic_read(&oldsighand->count) != 1;
>  	sig->group_exit_task = tsk;
> -	sig->notify_count = zap_other_threads(tsk);
> -	if (!thread_group_leader(tsk))
> +	sig->notify_count = zap_other_threads(tsk, may_hang ? 1 : -1);

Eric, this is amazing. So with this patch exec does different things depening
on whether sighand is shared with another CLONE_SIGHAND task or not. To me
this doesn't look sane in any case.

And of course you do realize that it doesn't solve the problem entirely? If I
modify my test-case a little bit

	int xxx(void *arg)
	{
		for (;;)
			pause();
	}

	void *thread(void *arg)
	{
		ptrace(PTRACE_TRACEME, 0,0,0);
		return NULL;
	}

	int main(void)
	{
		int pid = fork();

		if (!pid) {
			pthread_t pt;
			char stack[16 * 1024];

			clone(xxx, stack + 16*1024, CLONE_SIGHAND|CLONE_VM, NULL);

			pthread_create(&pt, NULL, thread, NULL);
			pthread_join(pt, NULL);
			execlp("echo", "echo", "passed", NULL);
		}

		sleep(1);
		// or anything else which needs ->cred_guard_mutex,
		// say open(/proc/$pid/mem)
		ptrace(PTRACE_ATTACH, pid, 0,0);
		kill(pid, SIGCONT);

		return 0;
	}

it should deadlock the same way?

So what is the point to make the, well imo insane, patch if it doesn't solve
the problem?

And btw zap_other_threads(may_hang == 0) is racy. Either you need tasklist or
exit_notify() should set tsk->exit_state under siglock, otherwise zap() can
return the wrong count.

Finally. This patch creates the nice security hole. Let me modify my test-case
again:

	void *thread(void *arg)
	{
		ptrace(PTRACE_TRACEME, 0,0,0);
		return NULL;
	}

	int main(void)
	{
		int pid = fork();

		if (!pid) {
			pthread_t pt;
			pthread_create(&pt, NULL, thread, NULL);
			pthread_join(pt, NULL);
			execlp(path-to-setuid-binary, args);
		}

		sleep(1);

		// Now we can send the signals to setiuid app
		kill(pid+1, ANYSIGNAL);

		return 0;
	}

I see another email from your with another proposal. I disagree, will reply soon.

Oleg.

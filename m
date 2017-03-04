From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [RFC][PATCH] exec: Don't wait for ptraced threads to be reaped.
Date: Sat, 4 Mar 2017 18:03:13 +0100
Message-ID: <20170304170312.GB13131@redhat.com>
References: <20170213141452.GA30203@redhat.com> <20170224160354.GA845@redhat.com> <87shmv6ufl.fsf@xmission.com> <20170303173326.GA17899@redhat.com> <87tw7axlr0.fsf@xmission.com> <87d1dyw5iw.fsf@xmission.com> <87tw7aunuh.fsf@xmission.com> <87lgsmunmj.fsf_-_@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87lgsmunmj.fsf_-_@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Aleksa Sarai <asarai@suse.com>, Andy Lutomirski <luto@amacapital.net>, Attila Fazekas <afazekas@redhat.com>, Jann Horn <jann@thejh.net>, Kees Cook <keescook@chromium.org>, Michal Hocko <mhocko@kernel.org>, Ulrich Obergfell <uobergfe@redhat.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 03/03, Eric W. Biederman wrote:
>
> Ever since CLONE_THREAD support was added to the kernel it has been
> possible to dead-lock userspace by ptracing a process and not reaping
> it's child threads.

Hmm. I disagree... I do not think this is a bug. But lets discuss this
separately, perhaps I misunderstood you.

> With use of the cred_guard_mutex in proc the ways
> userspace can unknowningly trigger a dead-lock have grown.

I think this particular problem did not exist until cred_guard_mutex
was introduced. Debugger can obviously "delay" exec if it doesn't
reap a zombie sub-thread, but this is another thing and not a bug imo.


> Sovle this by modifying exec to only wait until all of the other
> threads are zombies, and not waiting until the other threads
> are reaped.

This patch looks wrong in many ways.

> @@ -1065,11 +1065,8 @@ static int de_thread(struct task_struct *tsk)
>  	}
>
>  	sig->group_exit_task = tsk;
> -	sig->notify_count = zap_other_threads(tsk);
> -	if (!thread_group_leader(tsk))
> -		sig->notify_count--;
> -
> -	while (sig->notify_count) {
> +	zap_other_threads(tsk);
> +	while (atomic_read(&sig->live) > 1) {
>  		__set_current_state(TASK_KILLABLE);
>  		spin_unlock_irq(lock);
>  		schedule();

Very nice. So de_thread() returns as soon as all other threads decrement
signal->live in do_exit(). Before they do, say, exit_mm(). This is already
wrong, for example this breaks OOM. Plus a lot more problems afaics,  but
lets ignore this.

Note that de_thread() also unshares ->sighand before return. So in the
case of mt exec it will likely see oldsighand->count != 1 and alloc the
new sighand_struct and this breaks the locking.

Because the execing thread will use newsighand->siglock to protect its
signal_struct while the zombie threads will use oldsighand->siglock to
protect the same signal struct. Yes, tasklist_lock + the fact irq_disable
implies rcu_lock mostly save us but not entirely, say, a foreign process
doing __send_signal() can take the right or the wrong lock depending on
/dev/random.


> @@ -818,6 +808,8 @@ void __noreturn do_exit(long code)
>  		if (tsk->mm)
>  			setmax_mm_hiwater_rss(&tsk->signal->maxrss, tsk->mm);
>  	}
> +	if ((group_left == 1) && tsk->signal->group_exit_task)
> +		wake_up_process(tsk->signal->group_exit_task);

This is racy, but this is minor.

Oleg.

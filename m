From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH 0/2] fix the traced mt-exec deadlock
Date: Fri, 03 Mar 2017 12:23:31 -0600
Message-ID: <87tw7axlr0.fsf@xmission.com>
References: <20170213141452.GA30203@redhat.com>
        <20170224160354.GA845@redhat.com> <87shmv6ufl.fsf@xmission.com>
        <20170303173326.GA17899@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170303173326.GA17899-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> (Oleg Nesterov's message of
        "Fri, 3 Mar 2017 18:33:26 +0100")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Aleksa Sarai <asarai-IBi9RG/b67k@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Attila Fazekas <afazekas-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ulrich Obergfell <uobergfe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


Cc'd linux-api as we are talking about a deliberate user visible API
change here.

Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:

> On 03/02, Eric W. Biederman wrote:
>>
>> Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:
>>
>> > our discussion was a bit confusing, and it seems that we did not
>> > fully convince each other. So let me ask what do you finally think
>> > about this fix.
>> >
>> > Let me repeat. Even if I do not agree with some of your objections,
>> > I do agree that 1/2 does not look nice and clean. And we seem to
>> > agree that either way, with or without this fix, we need more changes
>> > in this area.
>> >
>> > But we need a simple and backportable fix for stable trees, say for
>> > rhel7. This bug was reported many times, and this is the simplest
>> > solution I was able to find.
>>
>> I am not 100% convinced that we need a backportable solution,
>
> I think we need, this was already requested,
>
>> but
>> regardless my experience is that good clean solutions are almost always
>> easier to backport that something we just settle for.
>
> Sure.
>
>> The patch below needs a little more looking and testing but arguably
>> it is sufficient.
>>
>> It implements autoreaping for non-leader threads always.  We might want
>> to limit this to the case of exec.
>
> I should have mentioned this. Of course, this change was proposed from the
> very beginning, when this problem was reported first time. And of course
> I like this fix much more than my patch (but yes, we shouldd limit it to
> the case of exec).
>
> The only problem is that it is incompatible change, and I have no idea what
> can be broken.
>
> Trivial test-case:
>
> 	void *thread(void *arg)
> 	{
> 		for (;;)
> 			pause();
> 		return NULL;
> 	}
>
> 	int main(void)
> 	{
> 		pthread_t pt;
> 		pthread_create(&pt, NULL, thread, NULL);
> 		execlp("true", "true", NULL);
> 	}
>
> with your patch applied
>
> 	$ strace -f ./test
> 	strace: wait4(__WALL): No child processes
>
> Yes, this is just a warning, but still. Now we need to change strace. And we
> can't know what else can be confused/broken by this change.
>
> man(ptrace) even documents that all other threads except the thread group leader
> report death as if they exited via _exit(2).
>
> Yes, yes, it also says that other threads stop in PTRACE_EVENT_EXIT stop,
> so 2/2 (which we need with your change too) is is not compatible too and
> I am worried, but:
>
> 	- this was never really true, an already exiting thread won't stop
> 	  if it races with exec
>
> 	- PTRACE_O_TRACEEXEC is not used that often, it never really worked
>
> 	- man(ptrace) also mentions that PTRACE_EVENT_EXIT behaviour may be
> 	  change in the future.
>
> In short. Of course I considered this change. Looks too risky to me. But.
> I will be happy if you send this change and take all the blame ;) I won't
> argue (if you limit it to execve case).

Unfortunately you have found what already looks like a userspace
regression.  So I don't think we can do that.

I do think the user space visible change of modifying a multi-threaded
exec no to wait  for the other threads to be reaped is the least
dangerous change.

The big lesson for me, and what was not obvious from your change
description is that we are changing the user space visible semantics
of exec+ptrace and that cred_guard_mutex is not at all the problem (as
we always take cred_guard_mutex in a killable or interruptible way).

So I tentatively agree that we need to deliberately change the semantics
of exec to not wait for zombies in fs/exec.c:de_thread.  That is what I
would expect of exec and that seems to the minimal change.

As part of that change I expect we want to call __cleanup_sighand from
do_exit rather than release_task.  Semantically we sould not need the
sighand_struct for zombie process.

>> --- a/kernel/exit.c
>> +++ b/kernel/exit.c
>> @@ -690,7 +690,9 @@ static void exit_notify(struct task_struct *tsk, int group_dead)
>>  				thread_group_empty(tsk) &&
>>  				!ptrace_reparented(tsk) ?
>>  			tsk->exit_signal : SIGCHLD;
>> -		autoreap = do_notify_parent(tsk, sig);
>> +		do_notify_parent(tsk, sig);
>> +		/* Autoreap threads even when ptraced */
>> +		autoreap = !thread_group_leader(tsk);
>>  	} else if (thread_group_leader(tsk)) {
>>  		autoreap = thread_group_empty(tsk) &&
>>  			do_notify_parent(tsk, tsk->exit_signal);
>
> This is all you need,
>
>> @@ -699,8 +701,6 @@ static void exit_notify(struct task_struct *tsk, int group_dead)
>>  	}
>>
>>  	tsk->exit_state = autoreap ? EXIT_DEAD : EXIT_ZOMBIE;
>> -	if (tsk->exit_state == EXIT_DEAD)
>> -		list_add(&tsk->ptrace_entry, &dead);
>>
>>  	/* mt-exec, de_thread() is waiting for group leader */
>>  	if (unlikely(tsk->signal->notify_count < 0))
>> @@ -711,6 +711,8 @@ static void exit_notify(struct task_struct *tsk, int group_dead)
>>  		list_del_init(&p->ptrace_entry);
>>  		release_task(p);
>>  	}
>> +	if (autoreap)
>> +		release_task(tsk);
>
> These 2 changes are not needed. release_task(tsk) will be called by
> list_for_each_entry_safe() above if autoreap == T.

Except for the practical case that for threads that are ptraced
tsk->ptrace_entry is already in use.  Which means we can't use
list_add(&tsk->ptrace_entry, &dead).

Or in short we get a really pretty oops because we corrupt one of the
ptrace lists if we don't have my extra two hunks.  But I agree logically
they are separate changes.

Eric

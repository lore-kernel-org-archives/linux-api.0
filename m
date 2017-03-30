From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [RFC][PATCH] exec: Don't wait for ptraced threads to be reaped.
Date: Thu, 30 Mar 2017 03:07:42 -0500
Message-ID: <8760ir192p.fsf@xmission.com>
References: <20170213141452.GA30203@redhat.com>
        <20170224160354.GA845@redhat.com> <87shmv6ufl.fsf@xmission.com>
        <20170303173326.GA17899@redhat.com> <87tw7axlr0.fsf@xmission.com>
        <87d1dyw5iw.fsf@xmission.com> <87tw7aunuh.fsf@xmission.com>
        <87lgsmunmj.fsf_-_@xmission.com> <20170304170312.GB13131@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170304170312.GB13131@redhat.com> (Oleg Nesterov's message of
        "Sat, 4 Mar 2017 18:03:13 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Aleksa Sarai <asarai@suse.com>, Andy Lutomirski <luto@amacapital.net>, Attila Fazekas <afazekas@redhat.com>, Jann Horn <jann@thejh.net>, Kees Cook <keescook@chromium.org>, Michal Hocko <mhocko@kernel.org>, Ulrich Obergfell <uobergfe@redhat.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> On 03/03, Eric W. Biederman wrote:
>> @@ -1065,11 +1065,8 @@ static int de_thread(struct task_struct *tsk)
>>  	}
>>
>>  	sig->group_exit_task = tsk;
>> -	sig->notify_count = zap_other_threads(tsk);
>> -	if (!thread_group_leader(tsk))
>> -		sig->notify_count--;
>> -
>> -	while (sig->notify_count) {
>> +	zap_other_threads(tsk);
>> +	while (atomic_read(&sig->live) > 1) {
>>  		__set_current_state(TASK_KILLABLE);
>>  		spin_unlock_irq(lock);
>>  		schedule();
>
> Very nice. So de_thread() returns as soon as all other threads decrement
> signal->live in do_exit(). Before they do, say, exit_mm(). This is already
> wrong, for example this breaks OOM. Plus a lot more problems afaics,  but
> lets ignore this.

Which means that we need to keep sig->notify_count.

> Note that de_thread() also unshares ->sighand before return. So in the
> case of mt exec it will likely see oldsighand->count != 1 and alloc the
> new sighand_struct and this breaks the locking.
>
> Because the execing thread will use newsighand->siglock to protect its
> signal_struct while the zombie threads will use oldsighand->siglock to
> protect the same signal struct. Yes, tasklist_lock + the fact irq_disable
> implies rcu_lock mostly save us but not entirely, say, a foreign process
> doing __send_signal() can take the right or the wrong lock depending on
> /dev/random.

Which leads to the question how can we get back tot he 2.4 behavior
of freeing sighand_struct in do_exit?

At which point as soon as we free sighand_struct if we are the last
to dying thread notify de_thread and everything works.

There are only two uses of sighand->siglock that I can see in
release_task:  __ptrace_unlink and __exit_signal.

For what __ptrace_unlink is doing we should just be able to skip
acquiring of siglock if PF_EXITING is set.

__exit_signal is a little more interesting but half of what it is
doing looks like it was pulled out of do_exit and just needs to
be put back.

Which probably adds up to 4 or 5 small carefully written patches to sort
out that part of the exit path, but I think it leads to a very simple
and straight forward result.  With the only side effect that we
can exec a process and still have a debugger reaping zombie threads.

Oleg does that sound reasonable to you?

Eric

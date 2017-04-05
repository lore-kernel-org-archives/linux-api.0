From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [RFC][PATCH v2 5/5] signal: Don't allow accessing signal_struct by old threads after exec
Date: Wed, 05 Apr 2017 13:16:51 -0500
Message-ID: <87zifu90to.fsf@xmission.com>
References: <20170303173326.GA17899@redhat.com> <87tw7axlr0.fsf@xmission.com>
        <87d1dyw5iw.fsf@xmission.com> <87tw7aunuh.fsf@xmission.com>
        <87lgsmunmj.fsf_-_@xmission.com> <20170304170312.GB13131@redhat.com>
        <8760ir192p.fsf@xmission.com> <878tnkpv8h.fsf_-_@xmission.com>
        <874ly6a0h1.fsf_-_@xmission.com> <87zify76z9.fsf_-_@xmission.com>
        <20170405161812.GD14536@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170405161812.GD14536-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> (Oleg Nesterov's message of
        "Wed, 5 Apr 2017 18:18:12 +0200")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Aleksa Sarai <asarai-IBi9RG/b67k@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Attila Fazekas <afazekas-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ulrich Obergfell <uobergfe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:

> On 04/02, Eric W. Biederman wrote:
>>
>> Add exec_id to signal_struct and compare it at a few choice moments.
>
> I really dislike this change no matter what, sorry.
>
> Firstly, task_struct->*_exec_id should simply die (I already have the
> patch), or at least they should be moved into signal_struct simply
> because this is per-process thing.

I am quite happy to find a better way to implement this.  More than
anything this was my proof of concept that it is possible to close
the security holes created if we allow our zombies to be normal zombies.


>> --- a/kernel/signal.c
>> +++ b/kernel/signal.c
>> @@ -995,6 +995,10 @@ static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
>>  			from_ancestor_ns || (info == SEND_SIG_FORCED)))
>>  		goto ret;
>>
>> +	/* Don't allow thread group signals after exec */
>> +	if (group && (t->signal->exec_id != t->self_exec_id))
>> +		goto ret;
>
> Hmm. Either we do not need this exec_id check at all, or we should not
> take "group" into account; a fatal signal (say SIGKILL) will kill the
> whole thread-group.

Wow.  Those are crazy semantics for fatal signals.  Sending a tkill
should not affect the entire thread group.  Oleg I think this is a bug
you introduced and likely requires a separate fix.

I really don't understand the logic in:

commit 5fcd835bf8c2cde06404559b1904e2f1dfcb4567
Author: Oleg Nesterov <oleg-6lXkIZvqkOAvJsYlp49lxw@public.gmane.org>
Date:   Wed Apr 30 00:52:55 2008 -0700

    signals: use __group_complete_signal() for the specific signals too
    
    Based on Pavel Emelyanov's suggestion.
    
    Rename __group_complete_signal() to complete_signal() and use it to process
    the specific signals too.  To do this we simply add the "int group" argument.
    
    This allows us to greatly simply the signal-sending code and adds a useful
    behaviour change.  We can avoid the unneeded wakeups for the private signals
    because wants_signal() is more clever than sigismember(blocked), but more
    importantly we now take into account the fatal specific signals too.
    
    The latter allows us to kill some subtle checks in handle_stop_signal() and
    makes the specific/group signal's behaviour more consistent.  For example,
    currently sigtimedwait(FATAL_SIGNAL) behaves differently depending on was the
    signal sent by kill() or tkill() if the signal was not blocked.
    
    And.  This allows us to tweak/fix the behaviour when the specific signal is
    sent to the dying/dead ->group_leader.
    
    Signed-off-by: Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
    Signed-off-by: Oleg Nesterov <oleg-6lXkIZvqkOAvJsYlp49lxw@public.gmane.org>
    Cc: Roland McGrath <roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    Signed-off-by: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
    Signed-off-by: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

>> @@ -1247,7 +1251,8 @@ struct sighand_struct *__lock_task_sighand(struct task_struct *tsk,
>>  		 * must see ->sighand == NULL.
>>  		 */
>>  		spin_lock(&sighand->siglock);
>> -		if (likely(sighand == tsk->sighand)) {
>> +		if (likely((sighand == tsk->sighand) &&
>> +			   (tsk->self_exec_id == tsk->signal->exec_id))) {
>
> Oh, this doesn't look good to me. Yes, with your approach we probably need
> this to, say, ensure that posix-cpu-timer can't kill the process after exec,
> but I'd rather add the exit_state check into run_posix_timers().

The entire point of lock_task_sighand is to not operate on
tasks/processes that have exited. The fact it even sighand in there is
deceptive because it is all about siglock and nothing to do with
sighand.

> But OK, suppose that we fix the problems with signal-after-exec.
>
> ====================================================================
> Now lets fix another problem. A mt exec suceeds and apllication does
> sys_seccomp(SECCOMP_FILTER_FLAG_TSYNC) which fails because it finds
> another (zombie) SECCOMP_MODE_FILTER thread.
>
> And after we fix this problem, what else we will need to fix?
>
>
> I really think that - whatever we do - there should be no other threads
> after exec, even zombies.

I see where you are coming from.

I need to stare at this a bit longer.  Because you are right.  Reusing
the signal_struct and leaving zombies around is very prone to bugs.  So
it is not very maintainable.

I suspect the answer here is to simply allocate a new sighand_struct and
a new signal_struct if there we are not single threaded by the time we
get down to the end of de_thread.

However even if it is a case of whack-a-mole semantically
not-blocking-for-zombies looks like the right thing to do and we need to
figure out how to do it maintainably.

Eric

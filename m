From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: scope of cred_guard_mutex.
Date: Mon, 03 Apr 2017 17:49:59 -0500
Message-ID: <87fuhpjeco.fsf_-_@xmission.com>
References: <87shmv6ufl.fsf@xmission.com> <20170303173326.GA17899@redhat.com>
        <87tw7axlr0.fsf@xmission.com> <87d1dyw5iw.fsf@xmission.com>
        <87tw7aunuh.fsf@xmission.com> <87lgsmunmj.fsf_-_@xmission.com>
        <20170304170312.GB13131@redhat.com> <8760ir192p.fsf@xmission.com>
        <20170402161518.GC12637@redhat.com> <87inmmbjsq.fsf@xmission.com>
        <20170403183728.GB31390@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170403183728.GB31390-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> (Oleg Nesterov's message of
        "Mon, 3 Apr 2017 20:37:28 +0200")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Aleksa Sarai <asarai-IBi9RG/b67k@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Attila Fazekas <afazekas-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ulrich Obergfell <uobergfe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:

> On 04/02, Eric W. Biederman wrote:
>>
>> Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:
>>
>> > Anyway, Eric, even if we can and want to do this, why we can't do this on
>> > top of my fix?
>>
>> Because your reduction in scope of cred_guard_mutex is fundamentally
>> broken and unnecessary.
>
> And you never explained why it is wrong, or I failed to understand you.
>
>> > I simply fail to understand why you dislike it that much. Yes it is not
>> > pretty, I said this many times, but it is safe in that it doesn't really
>> > change the current behaviour.
>>
>> No it is not safe.  And it promotes wrong thinking which is even more
>> dangerous.
>
> So please explain why it is not safe and why it is dangerous.
>
> Just in case, if you mean flush_signal_handlers() outside of cred_guard_mutex,
> please explain what I have missed in case you still think this is wrong.

>> I reviewed the code and cred_guard_mutex needs to cover what it covers.
>
> I strongly, strongly disagree. Its scope is unnecessary huge, we should narrow
> it in any case, even if the current code was not bugy. But this is almost
> offtopic, lets discuss this separately.

You have asked why I have problems with your patch and so I am going to
try to explain.  Partly I want to see a clean set of patches that we
can merge into Linus's tree before we make any compromises.  Because the
work preparing a clean patchset may inform us of something better.  Plus
we need to make something clean and long term maintainable in any event.

Partly I object because your understanding and my understanding of
cred_guard_mutex are very different.

As I read and understand the code the job of cred_guard_mutex is to keep
ptrace (and other threads of the proccess) from interferring in
exec and to ensure old resources are accessed with permission checks
using our original credentials and that new and modified resources are
accessed with permission checks using our new credentials.


I object to your patch in particular because you deliberately mess up
the part of only making old resources available with old creds and
new resources available with new creds.  Even if the current permission
checks are a don't care it still remains conceptually wrong.  And
conceptually wrong tends code tends towards maintenance problems
and real surprises when someone makes small changes to the code.  Which
is what I mean when I say your patch is dangerous.


AKA What I see neededing to be protected looks something like:
	mutex_lock();
        new_cred = compute_new_cred(tsk);
        new_mm = compute_new_mm(tsk);
        tsk->mm = new_mm;
        tsk->cred = new_cred;
        zap_other_threads(tsk);
        update_sighand(tsk);
        update_signal(tsk);
        do_close_on_exec();
        update_tsk_fields(tsk);
        mutex_unlock();

The only way I can see of reducing the scope of cred_guard_mutex is
performing work in such a way that ptrace and the other threads can't
interfere and then taking the lock.  Computing the new mm and the new
credentials are certainly candidates for that kind of treatment.

Eric

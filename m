From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [RFC][PATCH] exec: Don't wait for ptraced threads to be reaped.
Date: Sun, 02 Apr 2017 16:07:17 -0500
Message-ID: <87inmmbjsq.fsf@xmission.com>
References: <20170213141452.GA30203@redhat.com>
        <20170224160354.GA845@redhat.com> <87shmv6ufl.fsf@xmission.com>
        <20170303173326.GA17899@redhat.com> <87tw7axlr0.fsf@xmission.com>
        <87d1dyw5iw.fsf@xmission.com> <87tw7aunuh.fsf@xmission.com>
        <87lgsmunmj.fsf_-_@xmission.com> <20170304170312.GB13131@redhat.com>
        <8760ir192p.fsf@xmission.com> <20170402161518.GC12637@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170402161518.GC12637-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> (Oleg Nesterov's message of
        "Sun, 2 Apr 2017 18:15:18 +0200")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Aleksa Sarai <asarai-IBi9RG/b67k@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Attila Fazekas <afazekas-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ulrich Obergfell <uobergfe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:

> Perhaps I am wrong, but I think you underestimate the problems, and it is
> not clear to me if we really want this.

I worked through quite a bit of it and I realized a few fundamental
issues.  The task struct must remain visible until it is reaped
and we use siglock to protect in unhash process to protect that reaping.
Further tsk->sighand == NULL winds up being a flag used to tell
if release_task has been called.

To get an usable count on sighand struct all that needed to be done
was to change the reference counting of sighand_struct to count
processes and not threads.

Which is what I wound up posting.

> Anyway, Eric, even if we can and want to do this, why we can't do this on
> top of my fix?

Because your reduction in scope of cred_guard_mutex is fundamentally
broken and unnecessary.

> I simply fail to understand why you dislike it that much. Yes it is not
> pretty, I said this many times, but it is safe in that it doesn't really
> change the current behaviour.

No it is not safe.  And it promotes wrong thinking which is even more
dangerous.

I reviewed the code and cred_guard_mutex needs to cover what it covers.

> I am much more worried about 2/2 you didn't argue with, this patch _can_
> break something and this is obviously not good even if PTRACE_EVENT_EXIT
> was always broken.

I don't know who actually useses PTRACE_O_TRACEEXIT so I don't actually
know what the implications of changing it are.  Let's see...

gdb - no
upstart - no
lldb - yes
strace - no


It looks like lldb is worth testing with your PTRACE_EVENT_EXIT change
to see if anything breaks.

I think we can get away with changing the exec case but it does look
worth testing.  I hadn't realized you hadn't looked to see what was
using PTRACE_O_TRACEEXIT to see if any part of userspace cares.

Hmm.  This is interesting.  From the strace documentation:
> Tracer cannot assume that ptrace-stopped tracee exists. There are many
> scenarios when tracee may die while stopped (such as SIGKILL).
> Therefore, tracer must always be prepared to handle ESRCH error on any
> ptrace operation. Unfortunately, the same error is returned if tracee
> exists but is not ptrace-stopped (for commands which require stopped
> tracee), or if it is not traced by process which issued ptrace call.
> Tracer needs to keep track of stopped/running state, and interpret
> ESRCH as "tracee died unexpectedly" only if it knows that tracee has
> been observed to enter ptrace-stop. Note that there is no guarantee
> that waitpid(WNOHANG) will reliably report tracee's death status if
> ptrace operation returned ESRCH. waitpid(WNOHANG) may return 0 instead.
> IOW: tracee may be "not yet fully dead" but already refusing ptrace
> ops.

If delivering a second SIGKILL to a ptraced stopped processes will
make it continue we have a very interesting out..

When we stop in ptrace_stop we stop in TASK_TRACED == (TASK_WAKEKILL|__TASK_TRACED)

Delivery of a SIGKILL to that task has queue SIGKILL
and call signal_wake_up_state(t, TASK_WAKEKILL).
Which becomes wake_up_state(t, TASK_INTERRUPTIBLE | TASK_WAKEKILL)
Which wakes up the process.

So userspace can absolutely kill a processes in PTRACE_EVENT_EXIT
before the tracers find it.

Therefore we are only talking a quality of implementation issue
if we actually stop and wait for the tracer or not.

....

Which brings us to your PTRACE_EVENT_EXIT patch.

I think may_ptrace_stop is tested in the wrong place,
and is probably buggy.

- We should send the signal in all cases except when the ptracing parent
  does not exist aka (!current->ptrace).  The siginfo contains enough
  information to understand what happened if anyone is listening.

- Then we should send the group stop.

- Then if we don't want to wait we should:
  __set_current_state(TASK_RUNNING)

- Then we should drop the locks and only call freezable_schedule if
  we want to wait.

That way userspace thinks someone else just sent a SIGKILL and killed
the thread before it had a chance to look (which is effectively what
we are doing).  That sounds idea for both core-dumps and this case.

Eric

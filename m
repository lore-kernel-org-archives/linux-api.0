From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [RFC][PATCH] exec: Don't wait for ptraced threads to be reaped.
Date: Mon, 03 Apr 2017 17:49:17 -0500
Message-ID: <87h925jedu.fsf@xmission.com>
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

> Eric,
>
> I see another series from you, but I simply failed to force myself to read
> it carefully. Because at first glance it makes me really sad, I do dislike
> it even if it is correct. Yes, yes, sure, I can be wrong. Will try
> tomorrow.

Yes.  I needed to get my thoughts concrete.  I missed fixing the race in
zap_other_threads.  But overall I think things are moving in a good
direction.

>>
>> I don't know who actually useses PTRACE_O_TRACEEXIT so I don't actually
>> know what the implications of changing it are.  Let's see...
>
> And nobody knows ;) This is the problem, even the clear ptrace bugfix can
> break something, this happened before and we had to revert the obviously-
> correct patches; the bug was already used as feature.

Yes that is the challenge of changing userspace.   Which is why it helps
to test as much of a userspace change as possible.  Or to get very
clever, and figure out how to avoid the userspace change.

So I think it is worth knowing the lldb actually uses
PTRACE_O_TRACEEXIT.  So we can test at least some programs to verify
that all is well.

I don't see any way around cleaning up PTRACE_O_TRACEEXIT.  As
we fundamentally have the non-thread-group-leader exec problem.
We have to reap that previous leader thread with release_task.
Which means we can't stop for a PTRACE_O_TRACEEXIT.


>> If delivering a second SIGKILL
> ...
>> So userspace can absolutely kill a processes in PTRACE_EVENT_EXIT
>> before the tracers find it.
>>
>> Therefore we are only talking a quality of implementation issue
>> if we actually stop and wait for the tracer or not.
>
> Oh, this is another story, needs another discussion. We really need some
> changes in this area, we need to distinguish SIGKILL sent from user-space
> and (say) from group-exit, and we need to decide when should we stop.
>
> But at least I think the tracee should never stop if SIGKILL comes from
> user space. And yes ptrace_stop() is ugly and wrong, just look at the
> arch_ptrace_stop_needed() check. The problem, again, is that any fix will
> be user-visible.

The only issue I see is that arch_ptrace_stop() may sleep (sparc and
ia64 do as they flush the register stack to memory).  As the
code may sleep it means we can't set TASK_TRACED until after calling
arch_ptrace_stop().

My inclination is to just solve that by saying:
if (!sigkill_pending(current))
	set_current_task(TASK_TRACED);

That removes the special case.  We have to handle SIGKILL being
delivered immediately after set_current_state in any event.  And as we
are talking about something that happens on rare architecutres I don't
see any problem with tweaking that code at all.

It is closely enough related I will fold that into the next version of
my patch.

Eric

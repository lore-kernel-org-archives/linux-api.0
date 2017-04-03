From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC][PATCH] exec: Don't wait for ptraced threads to be reaped.
Date: Mon, 3 Apr 2017 20:37:28 +0200
Message-ID: <20170403183728.GB31390@redhat.com>
References: <87shmv6ufl.fsf@xmission.com>
 <20170303173326.GA17899@redhat.com>
 <87tw7axlr0.fsf@xmission.com>
 <87d1dyw5iw.fsf@xmission.com>
 <87tw7aunuh.fsf@xmission.com>
 <87lgsmunmj.fsf_-_@xmission.com>
 <20170304170312.GB13131@redhat.com>
 <8760ir192p.fsf@xmission.com>
 <20170402161518.GC12637@redhat.com>
 <87inmmbjsq.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87inmmbjsq.fsf-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Aleksa Sarai <asarai-IBi9RG/b67k@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Attila Fazekas <afazekas-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ulrich Obergfell <uobergfe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Eric,

I see another series from you, but I simply failed to force myself to read
it carefully. Because at first glance it makes me really sad, I do dislike
it even if it is correct. Yes, yes, sure, I can be wrong. Will try tomorrow.

On 04/02, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:
>
> > Anyway, Eric, even if we can and want to do this, why we can't do this on
> > top of my fix?
>
> Because your reduction in scope of cred_guard_mutex is fundamentally
> broken and unnecessary.

And you never explained why it is wrong, or I failed to understand you.

> > I simply fail to understand why you dislike it that much. Yes it is not
> > pretty, I said this many times, but it is safe in that it doesn't really
> > change the current behaviour.
>
> No it is not safe.  And it promotes wrong thinking which is even more
> dangerous.

So please explain why it is not safe and why it is dangerous.

Just in case, if you mean flush_signal_handlers() outside of cred_guard_mutex,
please explain what I have missed in case you still think this is wrong.

> I reviewed the code and cred_guard_mutex needs to cover what it covers.

I strongly, strongly disagree. Its scope is unnecessary huge, we should narrow
it in any case, even if the current code was not bugy. But this is almost
offtopic, lets discuss this separately.

> > I am much more worried about 2/2 you didn't argue with, this patch _can_
> > break something and this is obviously not good even if PTRACE_EVENT_EXIT
> > was always broken.
>
> I don't know who actually useses PTRACE_O_TRACEEXIT so I don't actually
> know what the implications of changing it are.  Let's see...

And nobody knows ;) This is the problem, even the clear ptrace bugfix can
break something, this happened before and we had to revert the obviously-
correct patches; the bug was already used as feature.

> If delivering a second SIGKILL
...
> So userspace can absolutely kill a processes in PTRACE_EVENT_EXIT
> before the tracers find it.
>
> Therefore we are only talking a quality of implementation issue
> if we actually stop and wait for the tracer or not.

Oh, this is another story, needs another discussion. We really need some
changes in this area, we need to distinguish SIGKILL sent from user-space
and (say) from group-exit, and we need to decide when should we stop.

But at least I think the tracee should never stop if SIGKILL comes from
user space. And yes ptrace_stop() is ugly and wrong, just look at the
arch_ptrace_stop_needed() check. The problem, again, is that any fix will
be user-visible.

Oleg.

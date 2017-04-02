From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC][PATCH] exec: Don't wait for ptraced threads to be reaped.
Date: Sun, 2 Apr 2017 18:15:18 +0200
Message-ID: <20170402161518.GC12637@redhat.com>
References: <20170213141452.GA30203@redhat.com>
 <20170224160354.GA845@redhat.com>
 <87shmv6ufl.fsf@xmission.com>
 <20170303173326.GA17899@redhat.com>
 <87tw7axlr0.fsf@xmission.com>
 <87d1dyw5iw.fsf@xmission.com>
 <87tw7aunuh.fsf@xmission.com>
 <87lgsmunmj.fsf_-_@xmission.com>
 <20170304170312.GB13131@redhat.com>
 <8760ir192p.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <8760ir192p.fsf-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Aleksa Sarai <asarai-IBi9RG/b67k@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Attila Fazekas <afazekas-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ulrich Obergfell <uobergfe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 03/30, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:
>
> > Very nice. So de_thread() returns as soon as all other threads decrement
> > signal->live in do_exit(). Before they do, say, exit_mm(). This is already
> > wrong, for example this breaks OOM. Plus a lot more problems afaics,  but
> > lets ignore this.
>
> Which means that we need to keep sig->notify_count.

Yes, although we need to make it less ugly.

> > Note that de_thread() also unshares ->sighand before return. So in the
> > case of mt exec it will likely see oldsighand->count != 1 and alloc the
> > new sighand_struct and this breaks the locking.
> >
> > Because the execing thread will use newsighand->siglock to protect its
> > signal_struct while the zombie threads will use oldsighand->siglock to
> > protect the same signal struct. Yes, tasklist_lock + the fact irq_disable
> > implies rcu_lock mostly save us but not entirely, say, a foreign process
> > doing __send_signal() can take the right or the wrong lock depending on
> > /dev/random.
>
> Which leads to the question how can we get back tot he 2.4 behavior
> of freeing sighand_struct in do_exit?
>
> At which point as soon as we free sighand_struct if we are the last
> to dying thread notify de_thread and everything works.

I was thinking about the similar option, see below, but decided that we
should not do this at least right now.

> For what __ptrace_unlink is doing we should just be able to skip
> acquiring of siglock if PF_EXITING is set.

We can even remove it from release_task() path, this is simple.

> __exit_signal is a little more interesting but half of what it is
> doing looks like it was pulled out of do_exit and just needs to
> be put back.

That is. I think we should actually unhash the exiting sub-thread even
if it is traced. IOW, remove it from thread/pid/parent/etc lists and
nullify its ->sighand. IMO, whatever we do thread_group_empty(current)
should be true after exec.

So the exiting sub-trace should look almost a EXIT_DEAD task except it
still should report to debugger.

But this is dangerous. Say, wait4(upid <= 0) becomes unsafe because
task_pid_type(PIDTYPE_PGID) won't work.

> Which probably adds up to 4 or 5 small carefully written patches to sort
> out that part of the exit path,

Perhaps I am wrong, but I think you underestimate the problems, and it is
not clear to me if we really want this.

=========================================================================
Anyway, Eric, even if we can and want to do this, why we can't do this on
top of my fix?

I simply fail to understand why you dislike it that much. Yes it is not
pretty, I said this many times, but it is safe in that it doesn't really
change the current behaviour.

I am much more worried about 2/2 you didn't argue with, this patch _can_
break something and this is obviously not good even if PTRACE_EVENT_EXIT
was always broken.

Oleg.

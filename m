From: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Subject: Re: [PATCH 6/6] clone4: Introduce new CLONE_FD flag to get task exit
 notification via fd
Date: Sat, 14 Mar 2015 13:14:03 -0700
Message-ID: <20150314201402.GH22130@thin>
References: <cover.1426180120.git.josh@joshtriplett.org>
 <20150314141414.GA11062@redhat.com>
 <20150314143235.GA12086@redhat.com>
 <28025621.k7WkrfHd4d@tjmaciei-mobl4>
 <20150314190132.GB22130@thin>
 <20150314191836.GA8416@redhat.com>
 <20150314194721.GA9654@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150314194721.GA9654-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Thiago Macieira <thiago.macieira-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sat, Mar 14, 2015 at 08:47:21PM +0100, Oleg Nesterov wrote:
> On 03/14, Oleg Nesterov wrote:
> >
> > On 03/14, Josh Triplett wrote:
> > >
> > > On Sat, Mar 14, 2015 at 11:38:29AM -0700, Thiago Macieira wrote:
> > > > On Saturday 14 March 2015 15:32:35 Oleg Nesterov wrote:
> > > > > It is not clear to me what do_wait() should do with ->autoreap child, even
> > > > > ignoring ptrace.
> > > > >
> > > > > Just suppose that real_parent has a single "autoreap" child. Should
> > > > > wait(NULL) hanf then?
> > > >
> > > > It should ignore the child that is set to autoreap. wait(NULL) should return -
> > > > ECHILD, indicating there are no children waiting to be reaped.
> > >
> > > Right.  And I don't think the current code does this.  I think we need
> > > to change wait_consider_task to early-return for ->autoreap just as it
> > > does for task_state == EXIT_DEAD.
> >
> > No. This EXIT_DEAD is absolutely different. And this is another indication
> > that you might use it wrongly ;)
> >
> > What we actually want is BUG_ON(task_state == EXIT_DEAD) here. We do not
> > want the EXIT_DEAD tasks in ->children/ptraced lists. These EXIT_DEAD tasks
> > complicate the exit/wait/reparent paths.
> >
> > However, currently this is TODO. The main problem is the locking in
> > wait_task_zombie(), we can set EXIT_DEAD and remove the task from list
> > under read_lock().
> 
> Let me clarify in case I confused you.
> 
> The EXIT_DEAD check in do_wait() paths doesn't mean "autoreap". It means
> that this thread/process (depending on ptrace) was already reaped. It was
> reaped by our sub-thread, or it was reaped because we ignore SIGCHLD, or
> other reasons. This doesn't matter.
> 
> In short, EXIT_DEAD means: we have to keep this thread on lists until the
> task which set this state calls release_task().

That much I already understood from reading through the code, since
exit_notify doesn't set task_state to EXIT_DEAD until the task is
actually completely dead.  When wait_consider_task sees p->task_state ==
EXIT_DEAD, that task isn't eligible for waiting at all.

What I was proposing was that a task that isn't yet dead, but that is
going to be autoreaped, is not eligible for waiting either.  All the
various wait* familiy of system calls should pretend it doesn't exist at
all, because returning an autoreaped task from a wait* call introduces a
race condition if the parent tries to *do* anything with the returned
PID.  If you launch a process with CLONE_FD, you need to manage it
exclusively with that fd, not with the wait* family of system calls.

That also implies that the child-stop and child-continued mechanisms
(do_notify_parent_cldstop, WSTOPPED, WCONTINUED) should ignore the task
too.  In the future there could be a flag to clone4 that lets you get
stop and continue notifications through the file descriptor.

- Josh Triplett

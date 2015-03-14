From: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Subject: Re: [PATCH 6/6] clone4: Introduce new CLONE_FD flag to get task exit
 notification via fd
Date: Sat, 14 Mar 2015 13:03:18 -0700
Message-ID: <20150314200318.GG22130@thin>
References: <cover.1426180120.git.josh@joshtriplett.org>
 <20150314141414.GA11062@redhat.com>
 <20150314143235.GA12086@redhat.com>
 <28025621.k7WkrfHd4d@tjmaciei-mobl4>
 <20150314190132.GB22130@thin>
 <20150314191836.GA8416@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150314191836.GA8416-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Thiago Macieira <thiago.macieira-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sat, Mar 14, 2015 at 08:18:36PM +0100, Oleg Nesterov wrote:
> On 03/14, Josh Triplett wrote:
> >
> > On Sat, Mar 14, 2015 at 11:38:29AM -0700, Thiago Macieira wrote:
> > > On Saturday 14 March 2015 15:32:35 Oleg Nesterov wrote:
> > > > It is not clear to me what do_wait() should do with ->autoreap child, even
> > > > ignoring ptrace.
> > > >
> > > > Just suppose that real_parent has a single "autoreap" child. Should
> > > > wait(NULL) hanf then?
> > >
> > > It should ignore the child that is set to autoreap. wait(NULL) should return -
> > > ECHILD, indicating there are no children waiting to be reaped.
> >
> > Right.  And I don't think the current code does this.  I think we need
> > to change wait_consider_task to early-return for ->autoreap just as it
> > does for task_state == EXIT_DEAD.
> 
> No. This EXIT_DEAD is absolutely different. And this is another indication
> that you might use it wrongly ;)

Is there any information somewhere on how this state machine of doom is
*supposed* to work? :)  Why would "p->task_state == EXIT_DEAD" mean
something different in wait_consider_task?

> What we actually want is BUG_ON(task_state == EXIT_DEAD) here. We do not
> want the EXIT_DEAD tasks in ->children/ptraced lists. These EXIT_DEAD tasks
> complicate the exit/wait/reparent paths.

Pulling the EXIT_DEAD tasks out of those lists completely does sound
like a good simplification.  However, that doesn't seem to be the
current expectation in wait_consider_task, which just returns if
p->task_state == EXIT_DEAD to skip considering that task.

And an autoreaping task isn't necessarily dead yet; it just shouldn't be
waited on.

> However, currently this is TODO. The main problem is the locking in
> wait_task_zombie(), we can set EXIT_DEAD and remove the task from list
> under read_lock().

That appears to be only reachable for zombies, which an autoreaping task
should never become.

> And please see another email from me. So far  I disagree that wait(NULL)
> should return ECHILD unconditionally. At least unless this is discussed
> separately.

I'll respond in that separate thread, but one issue there: waiting for
any child process cannot safely return an autoreaping child process,
because that would introduce a race condition.  The PID the parent gets
back can disappear at any time, so there's nothing useful the parent can
do with it.

- Josh Triplett

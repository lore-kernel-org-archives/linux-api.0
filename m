From: josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org
Subject: Re: [PATCH v2 0/7] CLONE_FD: Task exit notification via file
 descriptor
Date: Mon, 16 Mar 2015 16:29:49 -0700
Message-ID: <20150316232949.GB31751@cloud>
References: <cover.1426376419.git.josh@joshtriplett.org>
 <CAGXu5jLmLLgVNCP=cyUiXuiszVXsS88SNUK2iBqArbA2V6vdHA@mail.gmail.com>
 <2381173.VxaIO6vGG3@tjmaciei-mobl4>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2381173.VxaIO6vGG3@tjmaciei-mobl4>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thiago Macieira <thiago.macieira-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Mar 16, 2015 at 03:14:14PM -0700, Thiago Macieira wrote:
> On Monday 16 March 2015 14:44:20 Kees Cook wrote:
> > >               O_CLOEXEC
> > >                      Set  the  close-on-exec  flag on the new file
> > >descriptor. See the description of the O_CLOEXEC flag in open(2)  for
> > >reasons why this may be useful.
> > 
> > This begs the question: what happens when all CLONE_FD fds for a
> > process are closed? Will the parent get SIGCHLD instead, will it
> > auto-reap, or will it be un-wait-able (I assume not this...)
> 
> Depends on CLONE_AUTOREAP. If it's on, then no one gets SIGCHLD, no one can 
> wait() on it and the process autoreaps itself.

Minor nit: CLONE_AUTOREAP makes the process autoreap and nobody can wait
on it, but if you pass SIGCHLD or some other exit signal to clone then
you'll still get that signal.

> If it's no active, then the old rules apply: parent gets SIGCHILD and can 
> wait(). If the parent exited first, then the child gets reparented to init, 
> which can do the wait().

Right.

> A child without CLONE_AUTOREAP should be wait()able. If it gets wait()ed 
> before the clonefd is read, the clonefd() will return a 0 read. If it gets 
> read before wait, then wait() reaps another child or returns -ECHILD. That's 
> no different than two threads doing simultaneous wait() on the same child.

Hrm?  That isn't the semantics we implemented; you'll *always* get an
exit notification via the clonefd if you have it open, with or without
autoreap and whether or not a wait has occurred yet.  And reading from
the clonefd does not serve as a wait; if you don't pass CLONE_AUTOREAP,
you'll still need to wait on the process.

- Josh Triplett

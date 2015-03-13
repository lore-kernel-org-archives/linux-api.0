From: josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org
Subject: Re: [PATCH 6/6] clone4: Introduce new CLONE_FD flag to get task
 exit notification via fd
Date: Fri, 13 Mar 2015 15:34:09 -0700
Message-ID: <20150313223409.GE10954@cloud>
References: <cover.1426180120.git.josh@joshtriplett.org>
 <9c39c576e1d9a9912b4aec54d833a73a84d2f592.1426180120.git.josh@joshtriplett.org>
 <20150313162113.GA25966@redhat.com>
 <20150313195707.GA10487@cloud>
 <CALCETrVkZVa6zsd6gpW_AnQSO2cC___U8M3Dc7c6=PJdEiT9Pg@mail.gmail.com>
 <20150313222052.GC10954@cloud>
 <CALCETrVRqgsbpi9pPRwy42cuXiDzyPgWRJmfSRSQM7eGFfsZYA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrVRqgsbpi9pPRwy42cuXiDzyPgWRJmfSRSQM7eGFfsZYA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Thiago Macieira <thiago.macieira-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Mar 13, 2015 at 03:28:26PM -0700, Andy Lutomirski wrote:
> On Fri, Mar 13, 2015 at 3:20 PM,  <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org> wrote:
> > On Fri, Mar 13, 2015 at 02:34:58PM -0700, Andy Lutomirski wrote:
> >> On Fri, Mar 13, 2015 at 12:57 PM,  <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org> wrote:
> >> > A process launching a new process with CLONE_FD is explicitly requesting
> >> > that the process be automatically reaped without any other process
> >> > having to wait on it.  The task needs to not become a zombie, because
> >> > otherwise, it'll show up in waitpid(-1, ...) calls in the parent
> >> > process, which would break the ability to use this to completely
> >> > encapsulate process management within a library and not interfere with
> >> > the parent's process handling via SIGCHLD and wait{pid,3,4}.
> >>
> >> Wouldn't the correct behavior be to keep it alive as a zombie but
> >> *not* show it in waitpid, etc?
> >
> > That's a significant change to the semantics of waitpid.  And then
> > someone would still need to wait on the process, which we'd like to
> > avoid.  (We don't want to have magic "reap on read(2)" semantics,
> > because among other things, what if we add a means in the future to get
> > an additional file descriptor corresponding to an existing process?)
> 
> Do we not already have a state "dead, successfully waited on by
> parent, but still around because ptraced"?  If not, shouldn't we?
> Isn't that what PTRACE_SEIZE does?  Or am I just confused?

I don't think that affects the task's exit_state though.

- Josh Triplett

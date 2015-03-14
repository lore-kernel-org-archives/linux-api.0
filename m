From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 6/6] clone4: Introduce new CLONE_FD flag to get task
	exit notification via fd
Date: Sat, 14 Mar 2015 15:32:35 +0100
Message-ID: <20150314143235.GA12086@redhat.com>
References: <cover.1426180120.git.josh@joshtriplett.org> <9c39c576e1d9a9912b4aec54d833a73a84d2f592.1426180120.git.josh@joshtriplett.org> <20150313162113.GA25966@redhat.com> <20150313195707.GA10487@cloud> <20150314141414.GA11062@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150314141414.GA11062-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Thiago Macieira <thiago.macieira-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

And let me add another note before I forget...

On 03/14, Oleg Nesterov wrote:
>
> On 03/13, josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org wrote:
> >
> >
> > A process launching a new process with CLONE_FD is explicitly requesting
> > that the process be automatically reaped without any other process
> > having to wait on it.  The task needs to not become a zombie, because
> > otherwise, it'll show up in waitpid(-1, ...)
>
> This is clear.
>
> But please note that this task can be traced/debugged by unrelated process,
> not its real_parent/creator. Say, the system admin does "strace -p". This
> simply breaks the current API.
>
> Again, again, I didn't read this series yet. But the proper solution (afaics)
> should move this "autoreap" check in release_task/__ptrace_detach(). If the
> task is traced. Debugger should check ->autoreap and skip another
> do_notify_parent().
>
> Speaking of autoreap... If ->exit_signal is zero, then the exiting child
> doesn't send the notification to its parent, still it doesn't autoreap
> itself. To me this looks strange, and in fact it seems to me that this
> is only by mistake. I am wondering if we can treat ->exit_signal == 0
> as "autoreap" too. As usual, most probably the answer is "no, because it
> is too late to change the historical behaviour". But this is off-topic.


It is not clear to me what do_wait() should do with ->autoreap child, even
ignoring ptrace.

Just suppose that real_parent has a single "autoreap" child. Should wait(NULL)
hanf then?

If yes, who will wake the parent up?

If no, I do not see the necessary changes in wait_cosnider_task().

Oleg.

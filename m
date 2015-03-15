From: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Subject: Re: [PATCH v2 5/7] clone4: Add a CLONE_AUTOREAP flag to
 automatically reap the child process
Date: Sun, 15 Mar 2015 10:18:55 -0700
Message-ID: <20150315171855.GA30620@thin>
References: <cover.1426376419.git.josh@joshtriplett.org>
 <6d002995485d446e659105f6931307f3e532ce89.1426376419.git.josh@joshtriplett.org>
 <20150315145223.GA21887@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150315145223.GA21887-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thiago Macieira <thiago.macieira-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sun, Mar 15, 2015 at 03:52:23PM +0100, Oleg Nesterov wrote:
> On 03/15, Josh Triplett wrote:
> > Add a CLONE_AUTOREAP flag to request this behavior unconditionally,
> 
> Yes, CLONE_AUTOREAP is much better. And I agree (mostly) with that
> we should rely on do_notify_parent().
> 
> Howver the patch still doesn't look right. First of all, ->autoreap
> should be per-process, not per-thread.

Ah, you're thinking of the case where the parent process launches a
child with CLONE_AUTOREAP, that child process launches siblings with
CLONE_THREAD and without CLONE_AUTOREAP, and one of those siblings is
the last to exit?  That seems easy enough to handle: instead of setting
->autoreap unconditionally in copy_process, I can set it only in the
non-CLONE_THREAD case, and otherwise let it inherit.  Then every task in
the group will have the same value for autoreap.

(As an aside, what *is* the use case for CLONE_PARENT without
CLONE_THREAD?)

> And there are ptrace/mt issues,
> it seems. Just for example, we should avoid EXIT_TRACE if autoreap in
> wait_task_zombie() even if we are going to re-notify parent.

I don't see how EXIT_TRACE can happen in wait_task_zombie if autoreap is
set.  wait_task_zombie does a cmpxchg with exit_state and doesn't
proceed unless exit_state was EXIT_ZOMBIE, and I don't see how we can
ever reach the EXIT_ZOMBIE state if autoreap.

> EXCEPT: do we really want SIGCHLD from the exiting child? I think we
> do not. I won't really argue though, but this should be discussed and
> documented. IIUC, with your patch it is still sent.

I think we do, yes.  The caller of clone can already specify what signal
they want, including no signal at all.  If they specify a signal
(SIGCHLD or otherwise) along with CLONE_AUTOREAP, we can send that
signal.  I don't think that causes any particular problem.

That's the same semantic you'd get if you have a SIGCHLD handler with
SA_NOCLDWAIT: you'd still get the signal, even though you don't need to
(and can't) wait on the child process.

> Josh, please give me some time to think and re-check, I'll write another
> email next week. I am not sure this is really needed, but it seems to
> me that we need the preparation patch to make this change clear/simple.

I'd appreciate any feedback you can offer on this series, including any
potential subtle interactions with ptrace.

- Josh Triplett

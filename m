From: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Subject: Re: [PATCH v2 5/7] clone4: Add a CLONE_AUTOREAP flag to
 automatically reap the child process
Date: Sun, 15 Mar 2015 16:34:40 -0700
Message-ID: <20150315233439.GA31890@thin>
References: <cover.1426376419.git.josh@joshtriplett.org>
 <6d002995485d446e659105f6931307f3e532ce89.1426376419.git.josh@joshtriplett.org>
 <20150315145223.GA21887@redhat.com>
 <20150315171855.GA30620@thin>
 <20150315195506.GA29475@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150315195506.GA29475-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thiago Macieira <thiago.macieira-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sun, Mar 15, 2015 at 08:55:06PM +0100, Oleg Nesterov wrote:
> On 03/15, Josh Triplett wrote:
> > On Sun, Mar 15, 2015 at 03:52:23PM +0100, Oleg Nesterov wrote:
> > > On 03/15, Josh Triplett wrote:
> > > > Add a CLONE_AUTOREAP flag to request this behavior unconditionally,
> > >
> > > Yes, CLONE_AUTOREAP is much better. And I agree (mostly) with that
> > > we should rely on do_notify_parent().
> > >
> > > Howver the patch still doesn't look right. First of all, ->autoreap
> > > should be per-process, not per-thread.
> >
> > Ah, you're thinking of the case where the parent process launches a
> > ...
> 
> Not really, although we probably need more sanity checks.
> 
> It should be per-process simply because this "autoreap" affects the whole
> process. And the sub-threads are already "autoreap". And these 2 autoreap's
> semantics differ, we should not confuse them.

Will the approach I suggested, of having clones with CLONE_THREAD
inherit the autoreap value rather than setting it from CLONE_AUTOREAP,
implement the semantics you're looking for?

Also, are you suggesting that CLONE_AUTOREAP with CLONE_THREAD should
produce -EINVAL, or just that it should be ignored?

> > (As an aside, what *is* the use case for CLONE_PARENT without
> > CLONE_THREAD?)
> 
> To me CLONE_PARENT is another historical mistake and the source of misc
> problems ;)

I kinda figured. :)

> > > And there are ptrace/mt issues,
> > > it seems. Just for example, we should avoid EXIT_TRACE if autoreap in
> > > wait_task_zombie() even if we are going to re-notify parent.
> >
> > I don't see how EXIT_TRACE can happen in wait_task_zombie if autoreap is
> > set.  wait_task_zombie does a cmpxchg with exit_state and doesn't
> > proceed unless exit_state was EXIT_ZOMBIE, and I don't see how we can
> > ever reach the EXIT_ZOMBIE state if autoreap.
> 
> Because you again forgot about ptrace ;)
> 
> Josh. Let me try to summarise this later when I have time. Again, I am
> not sure, perhaps this is even simpler than I currently think. And let
> me apologize in advance, most probably I will be busy tomorrow.

I look forward to your later review and feedback.

- Josh Triplett

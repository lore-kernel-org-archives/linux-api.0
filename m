From: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Subject: Re: [PATCH 6/6] clone4: Introduce new CLONE_FD flag to get task exit
 notification via fd
Date: Sat, 14 Mar 2015 15:14:18 -0700
Message-ID: <20150314221417.GK22130@thin>
References: <cover.1426180120.git.josh@joshtriplett.org>
 <20150314141414.GA11062@redhat.com>
 <20150314143235.GA12086@redhat.com>
 <28025621.k7WkrfHd4d@tjmaciei-mobl4>
 <20150314190132.GB22130@thin>
 <20150314191836.GA8416@redhat.com>
 <20150314194721.GA9654@redhat.com>
 <20150314201402.GH22130@thin>
 <20150314203029.GA11656@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150314203029.GA11656-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Thiago Macieira <thiago.macieira-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sat, Mar 14, 2015 at 09:30:29PM +0100, Oleg Nesterov wrote:
> On 03/14, Josh Triplett wrote:
> >
> > What I was proposing was that a task that isn't yet dead, but that is
> > going to be autoreaped, is not eligible for waiting either.  All the
> > various wait* familiy of system calls should pretend it doesn't exist at
> > all, because returning an autoreaped task from a wait* call introduces a
> > race condition if the parent tries to *do* anything with the returned
> > PID.  If you launch a process with CLONE_FD, you need to manage it
> > exclusively with that fd, not with the wait* family of system calls.
> >
> > That also implies that the child-stop and child-continued mechanisms
> > (do_notify_parent_cldstop, WSTOPPED, WCONTINUED) should ignore the task
> > too.  In the future there could be a flag to clone4 that lets you get
> > stop and continue notifications through the file descriptor.
> 
> So far I strongly disagree, and I think that "autoreap" feature should
> not depend on CLONE_FD.

After reading your other mail and thinking about this, I agree that the
two can be separated; see my othermail for the details.

> Plus we should also discuss the reparenting. Ok, let me leave this
> discussion until I read 0/4 at least.

I think you can safely wait for v2 of the last patch, though the first
four patches should be almost completely identical in v2.

- Josh Triplett

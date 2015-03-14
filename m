From: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Subject: Re: [PATCH 6/6] clone4: Introduce new CLONE_FD flag to get task exit
 notification via fd
Date: Sat, 14 Mar 2015 15:03:08 -0700
Message-ID: <20150314220307.GI22130@thin>
References: <cover.1426180120.git.josh@joshtriplett.org>
 <20150314141414.GA11062@redhat.com>
 <20150314143235.GA12086@redhat.com>
 <28025621.k7WkrfHd4d@tjmaciei-mobl4>
 <20150314185424.GA6813@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150314185424.GA6813-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Thiago Macieira <thiago.macieira-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sat, Mar 14, 2015 at 07:54:24PM +0100, Oleg Nesterov wrote:
> On 03/14, Thiago Macieira wrote:
> > On Saturday 14 March 2015 15:32:35 Oleg Nesterov wrote:
> > > It is not clear to me what do_wait() should do with ->autoreap child, even
> > > ignoring ptrace.
> > >
> > > Just suppose that real_parent has a single "autoreap" child. Should
> > > wait(NULL) hanf then?
> >
> > It should ignore the child that is set to autoreap. wait(NULL) should return -
> > ECHILD, indicating there are no children waiting to be reaped.
> 
> I disagree. I won't really argue now, because I think that this needs
> a separate discussion.

We should certainly discuss it further, but why a "separate" discussion
rather than just discussing the semantics of autoreap and wait here?

> And imo "autoreap" should come as a separate feature.

Thinking about this further, I originally thought that CLONE_FD would
*have* to imply autoreap, because otherwise the calling process still
has to call a wait function on the process after getting the exit
notification via the file descriptor.  However, with the current version
(which holds a reference to the task via the task_struct and generates
the data in ->read), it could potentially make sense to have a file
descriptor for a process that still gets zombified until the parent
waits on it.

Autoreap would still be a potentially useful addition to simplify
process management; it would effectively become "always treat this child
as though the parent had the signal ignored or SA_NOCLDWAIT set", which
would just be a simple change to do_notify_parent, rather than a complex
one to exit_notify that potentially interacts with ptrace.  Matching the
semantics of SA_NOCLDWAIT seems reasonable.

Thiago, see below for a question about switching to the semantics of
SA_NOCLDWAIT.

> I think that wait(NULL) should hang like it hangs even if the parent ignores
> SIGCHLD. But in this case the parent should be woken up when the "autoreap"
> child exits.

I had to think about this for a while, but I think it makes sense now.
wait should *not* ever return the PID of an autoreaped process, because
that would introduce a race condition (the caller cannot safely do
*anything* with the PID of an autoreaped process, since by the time it
does, the process may be gone and the PID may be reused).  However, that
doesn't mean wait cannot block on the process, and then subsequently
wake up and return -ECHILD (or keep waiting on some other child process
if there is one).  That's apparently the semantic used with SA_NOCLDWAIT
or if you have SIGCHLD set to SIG_IGN, and matching that seems
appropriate.

Thiago, could your QProcess implementation handle that modified autoreap
semantic?  The downside there is that if your calling process has a
process-wide loop that waits for all processes (and explicitly passes
the Linux-specific __WCLONE or __WALL flag, since your processes
launched with a 0 signal would count as "clone" children), they'd get
back the processes you launch, too.  (That would happen with your
userspace-emulated version too for calls *without* __WCLONE or __WALL.)
You'd still get the exit status you need via the clonefd, without a
race, and you wouldn't need to touch process-wide signal handling, so I
think this should still work and avoid any races.

I'm going to try implementing that semantic, which should significantly
simplify the last patch of this series.

> If nothing else. Suppose that the parent does waitid(WEXITED|WSTOPPED).
> Should WSTOPPED work? I think it should.

Yeah, I guess it should.  Arguably there ought to be a clone flag that
lets you receive stop/continue notifications for that process via the
file descriptor instead (to allow a library to handle job control for a
process without touching process-wide signal handling), but that can
come later.

> At the same time, if we add autoreap then probably it also makes sense to add
> WEXITIED_UNLESS_AUTOREAP.

Potentially, though for many applications you could also just pass a
signal of 0 and avoid passing __WALL or __WCLONE.

- Josh Triplett

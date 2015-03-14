From: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Subject: Re: [PATCH 0/6] CLONE_FD: Task exit notification via file descriptor
Date: Sat, 14 Mar 2015 12:29:40 -0700
Message-ID: <20150314192940.GD22130@thin>
References: <CAHse=S9hnGm=Z8FR4f+z_TFwnrjBLkcV4wVwjDYgKuOSemdVrA@mail.gmail.com>
 <CALCETrWwkdWkNCsrcSAn+7f9SJCuYA-TV9=AygWMhXCC9Njp9Q@mail.gmail.com>
 <4467745.tgv2QnPHiH@tjmaciei-mobl4>
 <2279556.Wl6mCVq5Zi@tjmaciei-mobl4>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2279556.Wl6mCVq5Zi@tjmaciei-mobl4>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thiago Macieira <thiago.macieira-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sat, Mar 14, 2015 at 12:03:12PM -0700, Thiago Macieira wrote:
> On Friday 13 March 2015 18:11:32 Thiago Macieira wrote:
> > On Friday 13 March 2015 14:51:47 Andy Lutomirski wrote:
> > > In any event, we should find out what FreeBSD does in response to
> > > read(2) on the fd.
> > 
> > I've just successfully installed FreeBSD and compiled qtbase (main package
> > of Qt 5) on it.
> > 
> > I'll test pdfork during the weekend and report its behaviour.
> 
> Here are my findings about pdfork.
> 
> Source: http://fxr.watson.org/fxr/source/kern/sys_procdesc.c?v=FREEBSD10
> Qt adaptations: https://codereview.qt-project.org/108561
> 
> Processes created with pdfork() are normal processes that still send SIGCHLD 
> to their parents. The only difference is that you get the extra file descriptor 
> that can be passed to the pdgetpid() system call and works on select()/poll(). 
> Trying to read from that file descriptor will result in EOPNOTSUPP.

OK, since read() doesn't work on a pdfork() file descriptor, we don't
have to worry about compatibility with pdfork()'s read result.

However, if the expectation is that pdfork()ed child processes still
send SIGCHLD, then I don't see how we can be compatible there, nor do I
think we want to; as you mention below, that breaks the ability to
encapsulate management of the created process entirely within a library.

> Since they've never implemented pdwait4() (it's not even declared in the 
> headers), the only way to reap a child if you only have the file descriptor is 
> to first pdgetpid() and then call wait4() or wait6().

Which suggests that we shouldn't try to implement pdwait4() in glibc
until FreeBSD implements it in their kernel, since we won't know the
exact semantics they expect.

> If you don't pass PD_DAEMON, the child process gets killed with SIGKILL when 
> the file closes.

OK, that makes sense.  We could certainly implement a
CLONE_FD_KILL_ON_CLOSE flag with those semantics, if we want one in the
future.

> Conclusion: 
> Pros: this is the bare minimum that we'd need to disentangle the SIGCHLD mess. 
> As long as all child process activations use this feature, the problem is 
> solved.
> 
> Cons: it requires cooperation from all child starters. If some other library 
> or the application installs a global SIGCHLD handler that waits on all child 
> processes, like libvlc used to do and Glib and Ecore still do, you won't be 
> able to get the child exit status.
> 
> I have not tested what happens if you try to pass the file descriptor to other 
> processes (can you even do that on FreeBSD?). But even if you could and got 
> notifications, you couldn't wait on the child to get its exit status -- unless 
> they implement pdwait4.

Even if they do implement pdwait4, they might not bypass the "must be
the parent process" restriction.  Let's wait to see what semantics they
go with.

>  - pdfork: can be emulated with clone4 + CLONE_FD (+ CLONEFD_KILL_ON_CLOSE)
>  - pdwait4: can be emulated with read()
>  - pdgetpid: needs an ioctl
>  - pdkill: needs an ioctl [or just write()]

I think that should be a dedicated syscall, not an ioctl.

It's unfortunate that rt_sigqueueinfo doesn't take a flags argument.
However, I just realized that it takes a 32-bit "int" for the signal
number, yet signal numbers fit in 8 bits.  So we could just add flags in
the high 24 bits of that argument, and in particular add a flag
indicating that the first argument is a file descriptor rather than a
PID.

- Josh Triplett

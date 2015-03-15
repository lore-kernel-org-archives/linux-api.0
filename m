From: Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH 0/6] CLONE_FD: Task exit notification via file descriptor
Date: Sun, 15 Mar 2015 03:59:56 -0700
Message-ID: <20150315105956.GA29839@thin>
References: <CAHse=S9hnGm=Z8FR4f+z_TFwnrjBLkcV4wVwjDYgKuOSemdVrA@mail.gmail.com>
 <CALCETrWwkdWkNCsrcSAn+7f9SJCuYA-TV9=AygWMhXCC9Njp9Q@mail.gmail.com>
 <4467745.tgv2QnPHiH@tjmaciei-mobl4>
 <2279556.Wl6mCVq5Zi@tjmaciei-mobl4>
 <20150314192940.GD22130@thin>
 <CAHse=S9OLvyXCpbNSzA-qxYOm8VscFkKV0d2oyexM9gUjomN3g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHse=S9OLvyXCpbNSzA-qxYOm8VscFkKV0d2oyexM9gUjomN3g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Drysdale <drysdale@google.com>
Cc: Thiago Macieira <thiago.macieira@intel.com>, Andy Lutomirski <luto@amacapital.net>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>, Oleg Nesterov <oleg@redhat.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>, Rik van Riel <riel@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk <mtk.manpages@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, X86 ML <x86@kernel.org>
List-Id: linux-api@vger.kernel.org

On Sun, Mar 15, 2015 at 10:18:05AM +0000, David Drysdale wrote:
> On Sat, Mar 14, 2015 at 7:29 PM, Josh Triplett <josh@joshtriplett.org> wrote:
> > On Sat, Mar 14, 2015 at 12:03:12PM -0700, Thiago Macieira wrote:
> >> On Friday 13 March 2015 18:11:32 Thiago Macieira wrote:
> >> > On Friday 13 March 2015 14:51:47 Andy Lutomirski wrote:
> >> > > In any event, we should find out what FreeBSD does in response to
> >> > > read(2) on the fd.
> >> >
> >> > I've just successfully installed FreeBSD and compiled qtbase (main package
> >> > of Qt 5) on it.
> >> >
> >> > I'll test pdfork during the weekend and report its behaviour.
> >>
> >> Here are my findings about pdfork.
> >>
> >> Source: http://fxr.watson.org/fxr/source/kern/sys_procdesc.c?v=FREEBSD10
> >> Qt adaptations: https://codereview.qt-project.org/108561
> >>
> >> Processes created with pdfork() are normal processes that still send SIGCHLD
> >> to their parents. The only difference is that you get the extra file descriptor
> >> that can be passed to the pdgetpid() system call and works on select()/poll().
> >> Trying to read from that file descriptor will result in EOPNOTSUPP.
> >
> > OK, since read() doesn't work on a pdfork() file descriptor, we don't
> > have to worry about compatibility with pdfork()'s read result.
> >
> > However, if the expectation is that pdfork()ed child processes still
> > send SIGCHLD, then I don't see how we can be compatible there, nor do I
> > think we want to; as you mention below, that breaks the ability to
> > encapsulate management of the created process entirely within a library.
> 
> I didn't think that was the case -- my understanding was that pdfork()ed
> children would not generate SIGCHLD (and that does seem to be the
> case with a quick test program).

Well, either way, v2 of this series is capable of producing either
behavior.  You can have a clonefd and still receive SIGCHLD or any other
signal, or none at all, and you can decide independently from that if
you want autoreaping or waiting.

> As an aside, I do think there are some aspects of FreeBSD's process
> descriptors that aren't quite right yet, particularly their interaction with
> waitpid(-1, ...) -- IIRC pdfork()ed children are visible to it, but I'd expect
> them not to be (to allow libraries to use sub-processes invisibly to the
> programs using them). There's a thread at:
> https://lists.cam.ac.uk/pipermail/cl-capsicum-discuss/2014-March/thread.html
> but I'm not sure that anything came of that discussion.

As long as you don't use the Linux-specific flags __WALL or __WCLONE, a
process created with clone will be invisible to wait if it has an exit
signal other than SIGCHLD.  That's true independent of this patch
series.  So you can decide if you want processes visible to wait or not.

> As it happens, I'm meeting Robert Watson (one of the progenitors
> of Capsicum/process descriptors) tomorrow, so I'll chase further.

Sounds good.

> >> Since they've never implemented pdwait4() (it's not even declared in the
> >> headers), the only way to reap a child if you only have the file descriptor is
> >> to first pdgetpid() and then call wait4() or wait6().
> >
> > Which suggests that we shouldn't try to implement pdwait4() in glibc
> > until FreeBSD implements it in their kernel, since we won't know the
> > exact semantics they expect.
> 
> By the way, I should point out one part of the FreeBSD design
> which might help explain some of the semantics.
> 
> Process descriptors are particularly designed to be used with
> Capsicum, which is a security framework where file descriptors
> get extra rights associated with them, and the kernel polices
> the use of those rights (e.g. you need CAP_READ for read(2)
> operations; normal file descriptors implicitly have all of the
> rights for back-compatibility).
>   https://www.freebsd.org/cgi/man.cgi?query=capsicum&sektion=4
> 
> Capsicum also includes 'capability mode', where system calls
> that access global namespaces are disabled -- including the
> pid namespace.
> 
> So process descriptors are the only way to manipulate child
> processes when a program is in capability mode -- and this
> means that pdkill() is then genuinely needed over and above
> kill(pdgetpid(),...).

Thanks for the explanation.  I've seen some details about Capsicum, and
I found it quite interesting.  I'm particularly interested in the notion
of getting rid of global namespaces in favor of descriptors or similar
mechanisms that you need specific rights to.

Does Capsicum do anything to eliminate the global namespace of UIDs and
GIDs?

> >> If you don't pass PD_DAEMON, the child process gets killed with SIGKILL when
> >> the file closes.
> >
> > OK, that makes sense.  We could certainly implement a
> > CLONE_FD_KILL_ON_CLOSE flag with those semantics, if we want one in the
> > future.
> >
> >> Conclusion:
> >> Pros: this is the bare minimum that we'd need to disentangle the SIGCHLD mess.
> >> As long as all child process activations use this feature, the problem is
> >> solved.
> >>
> >> Cons: it requires cooperation from all child starters. If some other library
> >> or the application installs a global SIGCHLD handler that waits on all child
> >> processes, like libvlc used to do and Glib and Ecore still do, you won't be
> >> able to get the child exit status.
> >>
> >> I have not tested what happens if you try to pass the file descriptor to other
> >> processes (can you even do that on FreeBSD?). But even if you could and got
> >> notifications, you couldn't wait on the child to get its exit status -- unless
> >> they implement pdwait4.
> >
> > Even if they do implement pdwait4, they might not bypass the "must be
> > the parent process" restriction.  Let's wait to see what semantics they
> > go with.
> 
> Hmm, interesting point.  FreeBSD certainly allows FD passing, but
> I'm not sure what the interactions are when it's a process descriptor
> that's passed.
> 
> Given the object-capability background to Capsicum, I'd assume that a
> holder of the process descriptor should be able to do whatever operations
> are allowed by the rights associated with the descriptor (CAP_PDGETPID,
> CAP_PDKILL and CAP_PDWAIT exist as specific rights allowing those
> operations, and a non-restricted descriptor will have all of them by default).

Possibly, but given that pdwait4 isn't actually implemented yet, it
wouldn't surprise me if the future implementation looks up the process
and then calls the same internal function that wait4 does, with the same
"must be the parent process" restriction.

> But I'll add some test cases for this to the Capsicum test suite to check
> whether theory matches practice...
>   https://github.com/google/capsicum-test/blob/dev/procdesc.cc

Excellent; that seems like a good way to make sure the current and
future behavior matches expectations.

- Josh Triplett

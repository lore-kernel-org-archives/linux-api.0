From: Thiago Macieira <thiago.macieira@intel.com>
Subject: Re: [PATCH 0/6] CLONE_FD: Task exit notification via file descriptor
Date: Fri, 13 Mar 2015 14:16:07 -0700
Message-ID: <8029771.gA9WzoLePv@tjmaciei-mobl4>
References: <20150313194252.GA10317@cloud>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20150313194252.GA10317@cloud>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Josh Triplett <josh@joshtriplett.org>
Cc: David Drysdale <drysdale@google.com>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>, Oleg Nesterov <oleg@redhat.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>, Rik van Riel <riel@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk <mtk.manpages@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel@vger.kernel.org, X86 ML <x86@kernel.org>
List-Id: linux-api@vger.kernel.org

On Friday 13 March 2015 12:42:52 Josh Triplett wrote:
> > Hi Josh,
> > 
> > From the overall description (i.e. I haven't looked at the code yet)
> > this looks very interesting.  However, it seems to cover a lot of the
> > same ground as the process descriptor feature that was added to FreeBSD
> > 
> > in 9.x/10.x:
> >   https://www.freebsd.org/cgi/man.cgi?query=pdfork&sektion=2
> 
> Interesting.

Hi Josh, David

I wasn't aware of the FreeBSD implementation of pdfork(). It is actually 
exactly what I need in userspace. The only difference between pdfork() and and 
my proposed forkfd() is where the PID and where the file descriptor are 
returned (meaning, which is optional and which isn't).

Josh and I opted to return the file descriptor in the regular return value in 
forkfd and in clone4 because getting the file descriptor the whole objective of 
using the forkfd or clone4-with-CLONE_FD in the first place: the file descriptor 
is not optional, but the PID is.

> Agreed; however, I think it's reasonable to provide appropriate Linux
> system calls, and then let glibc or libbsd or similar provide the
> BSD-compatible calls on top of those.  I don't think the kernel
> interface needs to exactly match FreeBSD's, as long as it's a superset
> of the functionality.
> 
> For example, pdfork can just call clone4 with CLONE_FD and return the
> resulting file descriptor.

Agreed, we should recommend libc implement pdfork(), pdkill() and pdwait4().

I'm not too attached to the forkfd() interface, but I find it slightly superior 
for the reasons above.

If we want the PD_DAEMON flag, it will have to translate to a clone flag, like 
CLONEFD_DAEMON or inverted like CLONEFD_KILL_ON_CLOSE.

> In the future, I plan to add an fd-based equivalent of
> rt_{,tg}sigqueueinfo (likely a single syscall with a flag to determine
> whether to kill a process or thread) which is a superset of pdkill.
> pdkill could then call that and just not pass the extra info.
> 
> A fair bit of pdwait4 could be implemented on top of read(), other than
> the full rusage information (see below), and the ability to wait for
> STOP/CONT (which the CLONE_FD file descriptor could support if desired,
> but it'd have to be set via a flag at clone time).
> 
> I think it's a feature to use read() rather than an additional magic
> system call.

Indeed, even if the libc provides a wrapper for you, like glibc does for 
eventfd (eventfd_read, eventfd_write).

Josh and I didn't want to submit "killfd" (or pdkill in the FreeBSD name) in 
the initial patch set, but it was part of the plans.

> > >               clone4() will never return a file descriptor in the range
> > >               0-2 to
> > >               the caller, to avoid ambiguity with the return of 0 in the
> > >               child
> > >               process.  Only the  calling  process  will  have  the  new
> > >                file
> > >               descriptor open; the child process will not.
> > 
> > FreeBSD's pdfork(2) returns a PID but also takes an int *fdp argument to
> > return the file descriptor separately, which avoids the need for special
> > case processing for low FD values (and means that POSIX's "lowest file
> > descriptor not currently open" behaviour can be preserved if desired).
> 
> That'd be easy to implement if desired, by adding an outbound pointer to
> clone4_args.
>
> The (very mild) reason I'd dropped the PID: with CLONE_FD and future
> syscalls that use the fd as an identifier, PIDs can hopefully become
> mostly unnecessary.  However, I'm not that attached to changing the
> return value; it'd be trivial to switch to an outbound parameter
> instead, and then drop the "not 0-2".

See above for more motivation on making the PID optional.

As for the file descriptor range, if we need to be able to return 0, we can 
implement a magic constant to mean the child process, like the userspace 
forkfd() does (FFD_CHILD_PROCESS). We'd probably choose the value -4096 on 
Linux, since that is neither a valid file descriptor nor a valid errno value.

> > [FreeBSD theoretically has pdwait4(2) to do wait4-like operations on a
> > process descriptor, including rusage retrieval.  However, I don't think
> > 
> > they actually implemented it:
> >   http://fxr.watson.org/fxr/source/kern/syscalls.master#L928]
> 
> That's a pretty good argument that we don't need to either, at least not
> yet.

pdwait4() can be implemented on top of read(), with the WNOHANG flag being just 
toggling the O_NONBLOCK bit. The problem is with the rest of the flags. We 
could implement it via more ioctls to be done prior to read() if we don't want 
to add a syscall...

Another alternative is to add a P_PD flag that can be passed as the first 
argument to waitid(), making the second argument a file descriptor instead of a 
PID or pgrp.

> > FreeBSD also implements fstat(2) for its process descriptors, although
> > only a few of the fields get filled in.
> 
> I looked at what they provide, and that seems like more of a novelty
> than something particularly useful (since most of the stat fields aren't
> meaningful), but if that's useful for compatibility then adding it seems
> fine.

I don't think we need to do anything: anon_inode will do it for us.

If I stat an eventfd:

	stat("/proc/107751/fd/4", {st_dev=makedev(0, 9), st_ino=3943, 
st_mode=0600, st_nlink=1, st_uid=0, st_gid=0, st_blksize=4096, st_blocks=0, 
st_size=0, st_atime=2015/03/07-16:40:28, st_mtime=2015/03/12-16:12:00, 
st_ctime=2015/03/12-16:12:00}) = 0

And just out of curiosity, in the following order: epoll, signalfd, timerfd 
and inotify:

	stat("/proc/1462/fd/4", {st_dev=makedev(0, 9), st_ino=3943, st_mode=0600, 
st_nlink=1, st_uid=0, st_gid=0, st_blksize=4096, st_blocks=0, st_size=0, 
st_atime=2015/03/07-16:40:28, st_mtime=2015/03/12-16:12:00, 
st_ctime=2015/03/12-16:12:00}) = 0
	stat("/proc/1462/fd/5", {st_dev=makedev(0, 9), st_ino=3943, st_mode=0600, 
st_nlink=1, st_uid=0, st_gid=0, st_blksize=4096, st_blocks=0, st_size=0, 
st_atime=2015/03/07-16:40:28, st_mtime=2015/03/12-16:12:00, 
st_ctime=2015/03/12-16:12:00}) = 0
	stat("/proc/1462/fd/7", {st_dev=makedev(0, 9), st_ino=3943, st_mode=0600, 
st_nlink=1, st_uid=0, st_gid=0, st_blksize=4096, st_blocks=0, st_size=0, 
st_atime=2015/03/07-16:40:28, st_mtime=2015/03/12-16:12:00, 
st_ctime=2015/03/12-16:12:00}) = 0
	stat("/proc/1462/fd/8", {st_dev=makedev(0, 9), st_ino=3943, st_mode=0600, 
st_nlink=1, st_uid=0, st_gid=0, st_blksize=4096, st_blocks=0, st_size=0, 
st_atime=2015/03/07-16:40:28, st_mtime=2015/03/12-16:12:00, 
st_ctime=2015/03/12-16:12:00}) = 0

(that process is systemd --user)

> > >               poll(2), select(2), epoll(7) (and similar)
> > >               
> > >                      The  file  descriptor  is readable (the select(2)
> > >                      readfds
> > >                      argument; the poll(2) POLLIN flag) if the new
> > >                      process has
> > >                      exited.
> > 
> > FreeBSD uses POLLHUP here.
> 
> That makes sense given that they provide the information via a separate
> call rather than read.  Since the CLONE_FD file descriptor uses read, it
> needs to provide POLLIN, but I have no objection to using *both* POLLIN
> and POLLHUP if that'd be at all useful.

I think we should provide both, since we're notifying that there are things to 
be read and that the file descriptor has closed.

> > FreeBSD has two different behaviours for close(2), depending on a flag
> > value (PD_DAEMON).  With the flag set it's roughly like this, but
> > without PD_DAEMON a close(2) operation on the (last open) file
> > descriptor terminates the child process.
> > 
> > This can be quite useful, particularly for the use case where some
> > userspace library has an FD-controlled subprocess -- if the application
> > using the library terminates, the process descriptor is closed and so
> > the subprocess is automatically terminated.
> 
> That's an interesting idea.  I don't think it makes sense for that to be
> the default behavior, but if someone wanted to add an additional flag
> to implement that behavior, that seems fine.  A FreeBSD-compatible
> pdfork could then use that flag when not passed PD_DAEMON and not use it
> when passed PD_DAEMON.
> 
> How does it kill the process when the last open descriptor closes?
> SIGKILL?  SIGTERM?  The former seems unfriendly (preventing graceful
> termination), and the latter blockable.  There's a reason init systems
> send TERM, then wait, then KILL.

I was wondering if it shouldn't be a SIGHUP, since we're talking about a file 
descriptor closing. We could make it configurable too, but I'd rather not use 
the current CSIGNAL field -- better move to the arguments structure, just in 
case someone is passing SIGCHLD there, they should get EINVAL instead of 
silently sending SIGCHLD to the child process to ask it to terminate.

-- 
Thiago Macieira - thiago.macieira (AT) intel.com
  Software Architect - Intel Open Source Technology Center


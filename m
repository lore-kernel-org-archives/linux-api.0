From: Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH 0/6] CLONE_FD: Task exit notification via file
 descriptor
Date: Fri, 13 Mar 2015 12:42:52 -0700
Message-ID: <20150313194252.GA10317@cloud>
References: <CAHse=S9hnGm=Z8FR4f+z_TFwnrjBLkcV4wVwjDYgKuOSemdVrA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHse=S9hnGm=Z8FR4f+z_TFwnrjBLkcV4wVwjDYgKuOSemdVrA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Drysdale <drysdale@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>, Oleg Nesterov <oleg@redhat.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>, Rik van Riel <riel@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Thiago Macieira <thiago.macieira@intel.com>, Michael Kerrisk <mtk.manpages@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel@vger.kernel.org, X86 ML <x86@kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Mar 13, 2015 at 04:05:29PM +0000, David Drysdale wrote:
> On Fri, Mar 13, 2015 at 1:40 AM, Josh Triplett <josh@joshtriplett.org=
> wrote:
> > This patch series introduces a new clone flag, CLONE_FD, which lets=
 the caller
> > handle child process exit notification via a file descriptor rather=
 than
> > SIGCHLD.  CLONE_FD makes it possible for libraries to safely launch=
 and manage
> > child processes on behalf of their caller, *without* taking over pr=
ocess-wide
> > SIGCHLD handling (either via signal handler or signalfd).
>=20
> Hi Josh,
>=20
> From the overall description (i.e. I haven't looked at the code yet)
> this looks very interesting.  However, it seems to cover a lot of the
> same ground as the process descriptor feature that was added to FreeB=
SD
> in 9.x/10.x:
>   https://www.freebsd.org/cgi/man.cgi?query=3Dpdfork&sektion=3D2

Interesting.

> I think it would ideally be nice for a userspace library developer to=
 be
> able to do subprocess management (without SIGCHLD) in a similar way
> across both platforms, without lots of complicated autoconf shenaniga=
ns.
>
> So could we look at the overlap and seeing if we can come up with
> something that covers your requirements and also allows for something
> that looks like FreeBSD's process descriptors?

Agreed; however, I think it's reasonable to provide appropriate Linux
system calls, and then let glibc or libbsd or similar provide the
BSD-compatible calls on top of those.  I don't think the kernel
interface needs to exactly match FreeBSD's, as long as it's a superset
of the functionality.

=46or example, pdfork can just call clone4 with CLONE_FD and return the
resulting file descriptor.

In my further comments below, I'll suggest ways that the FreeBSD librar=
y
calls could be implemented on top of Linux system calls.

> (I've actually got some rough patches to add process descriptor
> functionality on Linux, so I can look at how the two approaches compa=
re
> and contrast.)
>=20
> > Note that signalfd for SIGCHLD does not suffice here, because that =
still
> > receives notification for all child processes, and interferes with =
process-wide
> > signal handling.
> >
> > The CLONE_FD file descriptor uniquely identifies a process on the s=
ystem in a
> > race-free way, by holding a reference to the task_struct.  In the f=
uture, we
> > may introduce APIs that support using process file descriptors inst=
ead of PIDs.
>=20
> FreeBSD has pdkill(2) and (theoretically) pdwait4(2) along these line=
s.
> I suspect we need either need pdkill(2) or a way to retrieve a PID fr=
om
> a process file descriptor, so that there's a way to send signals to t=
he
> child.

The original caller of clone4 with CLONE_FD can pass CLONE_PARENT_SETTI=
D
to get the PID.

In the future, I plan to add an fd-based equivalent of
rt_{,tg}sigqueueinfo (likely a single syscall with a flag to determine
whether to kill a process or thread) which is a superset of pdkill.
pdkill could then call that and just not pass the extra info.

A fair bit of pdwait4 could be implemented on top of read(), other than
the full rusage information (see below), and the ability to wait for
STOP/CONT (which the CLONE_FD file descriptor could support if desired,
but it'd have to be set via a flag at clone time).

I think it's a feature to use read() rather than an additional magic
system call.

> > Introducing CLONE_FD required two additional bits of yak shaving: S=
ince clone
> > has no more usable flags (with the three currently unused flags unu=
sable
> > because old kernels ignore them without EINVAL), also introduce a n=
ew clone4
> > system call with more flag bits and an extensible argument structur=
e.  And
> > since the magic pt_regs-based syscall argument processing for clone=
's tls
> > argument would otherwise prevent introducing a sane clone4 system c=
all, fix
> > that too.
> >
> > I tested the CLONE_SETTLS changes with a thread-local storage test =
program (two
> > threads independently reading and writing a __thread variable), on =
both 32-bit
> > and 64-bit, and I observed no issues there.
>=20
> Worth preserving in tools/testing/selftests/ ?

Not really; it's just the following trivial program, which was faster t=
o
write than to attempt to find somewhere:

#include <pthread.h>
#include <stdio.h>

__thread unsigned x =3D 0;

void *thread_func(void *unused)
{
    unsigned *tx =3D &x;
    for (; *tx < 10; (*tx)++)
        printf("child: tx=3D%p *tx=3D%u\n", tx, *tx);
    return NULL;
}

int main(void)
{
    unsigned *tx =3D &x;
    pthread_t thread;
    pthread_create(&thread, NULL, thread_func, NULL);
    for (; *tx < 10; (*tx)++)
        printf("main: tx=3D%p *tx=3D%u\n", tx, *tx);
    pthread_join(thread, NULL);
    return 0;
}

(I didn't bother with error handling, because I ran it under strace.)

> > I tested clone4 and the new CLONE_FD call with several additional t=
est
> > programs, launching either a process or thread (in the former case =
using
> > syscall(), in the latter case by calling clone4 via assembly and re=
turning to
> > C), sleeping in parent and child to test the case of either exiting=
 first, and
> > then printing the received clone4_info structure.  Thiago also test=
ed clone4
> > with CLONE_FD with a modified version of libqt's process handling, =
which
> > includes a test suite.
> >
> > I've also included the manpages patch at the end of this series.  (=
Note that
> > the manpage documents the behavior of the future glibc wrapper as w=
ell as the
> > raw syscall.)  Here's a formatted plain-text version of the manpage=
 for
> > reference:
>=20
> FYI, I've added some comparisons with the FreeBSD equivalents below.

Thanks!

> > CLONE4(2)                  Linux Programmer's Manual               =
  CLONE4(2)
> >
> >
> >
> > NAME
> >        clone4 - create a child process
> >
> > SYNOPSIS
> >        /* Prototype for the glibc wrapper function */
> >
> >        #define _GNU_SOURCE
> >        #include <sched.h>
> >
> >        int clone4(uint64_t flags,
> >                   size_t args_size,
> >                   struct clone4_args *args,
> >                   int (*fn)(void *), void *arg);
> >
> >        /* Prototype for the raw system call */
> >
> >        int clone4(unsigned flags_high, unsigned flags_low,
> >                   unsigned long args_size,
> >                   struct clone4_args *args);
> >
> >        struct clone4_args {
> >            pid_t *ptid;
> >            pid_t *ctid;
> >            unsigned long stack_start;
> >            unsigned long stack_size;
> >            unsigned long tls;
> >        };
> >
> >
> > DESCRIPTION
> >        clone4()  creates  a  new  process,  similar  to  clone(2) a=
nd fork(2).
> >        clone4() supports additional flags that clone(2) does not, a=
nd  accepts
> >        arguments via an extensible structure.
> >
> >        args  points to a clone4_args structure, and args_size must =
contain the
> >        size of that structure, as understood by the  caller.   If  =
the  caller
> >        passes  a  shorter  structure  than  the  kernel expects, th=
e remaining
> >        fields will default to 0.  If the caller passes a larger str=
ucture than
> >        the  kernel  expects  (such  as one from a newer kernel), cl=
one4() will
> >        return EINVAL.  The clone4_args structure may gain additiona=
l fields at
> >        the  end  in  the future, and callers must only pass a size =
that encom=E2=80=90
> >        passes the number of fields they understand.  If the  caller=
  passes  0
> >        for args_size, args is ignored and may be NULL.
> >
> >        In  the clone4_args structure, ptid, ctid, stack_start, stac=
k_size, and
> >        tls have the same semantics as they do with clone(2) and clo=
ne2(2).
> >
> >        In the glibc wrapper, fn and arg have the same  semantics  a=
s  they  do
> >        with clone(2).  As with clone(2), the underlying system call=
 works more
> >        like fork(2), returning 0 in the child process; the glibc wr=
apper  sim=E2=80=90
> >        plifies  thread execution by calling fn(arg) and exiting the=
 child when
> >        that function exits.
> >
> >        The 64-bit  flags  argument  (split  into  the  32-bit  flag=
s_high  and
> >        flags_low arguments in the kernel interface) accepts all the=
 same flags
> >        as  clone(2),  with  the   exception   of   the   obsolete  =
 CLONE_PID,
> >        CLONE_DETACHED, and CLONE_STOPPED.  In addition, flags accep=
ts the fol=E2=80=90
> >        lowing flags:
> >
> >
> >        CLONE_FD
> >               Instead of returning a process ID, clone4()  with  th=
e  CLONE_FD
> >               flag  returns a file descriptor associated with the n=
ew process.
> >               When the new process exits, the kernel will not send =
a signal to
> >               the  parent process, and will not keep the new proces=
s around as
> >               a "zombie" process  until  a  call  to  waitpid(2)  o=
r  similar.
> >               Instead,  the file descriptor will become available f=
or reading,
> >               and the new process will be immediately reaped.
>=20
> Just to confirm: presumably a waitpid(-1,...) call that's already in
> progress won't return when one of these child processes exits?

I agree, I don't think it should.  Because otherwise you'd also assume
you can waitpid() on the PID itself, and that'd be a race condition
since the process autoreaps.

> >               Unlike using  signalfd(2)  for  the  SIGCHLD  signal,=
  the  file
> >               descriptor  returned  by  clone4()  with the CLONE_FD=
 flag works
> >               even with SIGCHLD unblocked in one or more threads of=
 the parent
> >               process,  and  allows the process to have different h=
andlers for
> >               different child processes, such as those created by  =
a  library,
> >               without  introducing  race conditions around process-=
wide signal
> >               handling.
> >
> >               clone4() will never return a file descriptor in the r=
ange 0-2 to
> >               the caller, to avoid ambiguity with the return of 0 i=
n the child
> >               process.  Only the  calling  process  will  have  the=
  new  file
> >               descriptor open; the child process will not.
>=20
> FreeBSD's pdfork(2) returns a PID but also takes an int *fdp argument=
 to
> return the file descriptor separately, which avoids the need for spec=
ial
> case processing for low FD values (and means that POSIX's "lowest fil=
e
> descriptor not currently open" behaviour can be preserved if desired)=
=2E

That'd be easy to implement if desired, by adding an outbound pointer t=
o
clone4_args.

The (very mild) reason I'd dropped the PID: with CLONE_FD and future
syscalls that use the fd as an identifier, PIDs can hopefully become
mostly unnecessary.  However, I'm not that attached to changing the
return value; it'd be trivial to switch to an outbound parameter
instead, and then drop the "not 0-2".

> >               Since the kernel does not send a termination signal w=
hen a child
> >               process created with CLONE_FD exits, the low byte of =
flags  does
> >               not contain a signal number.  Instead, the low byte o=
f flags can
> >               contain the following additional flags for use with C=
LONE_FD:
> >
> >
> >               CLONEFD_CLOEXEC
> >                      Set the O_CLOEXEC flag on the new open  file  =
descriptor.
> >                      See  the description of the O_CLOEXEC flag in =
open(2) for
> >                      reasons why this may be useful.
> >
> >
> >               CLONEFD_NONBLOCK
> >                      Set the O_NONBLOCK flag on the new open file  =
descriptor.
> >                      Using  this flag saves extra calls to fcntl(2)=
 to achieve
> >                      the same result.
> >
> >
> >               clone4() with the CLONE_FD flag returns a file  descr=
iptor  that
> >               supports the following operations:
> >
> >               read(2) (and similar)
> >                      When  the  new  process  exits,  reading  from=
  the  file
> >                      descriptor produces a single clonefd_info stru=
cture:
> >
> >                      struct clonefd_info {
> >                          uint32_t code;   /* Signal code */
> >                          uint32_t status; /* Exit status or signal =
*/
> >                          uint64_t utime;  /* User CPU time */
> >                          uint64_t stime;  /* System CPU time */
> >                      };
>=20
> Presumably there is no way to get full rusage information for the exi=
ted
> process?

I focused on the information available via SIGCHLD.  Even utime and
stime are unnecessary for the primary use case of CLONE_FD, but I
included them because SIGCHLD does.  I'd like to avoid sending the much
larger rusage over the file descriptor when the caller may not care.

However, given that the task_struct sticks around as long as the
CLONE_FD file descriptor does, if that information is normally still
available from a dead-but-not-waited-on process, it should be trivial t=
o
add an operation that takes the file descriptor and returns the full
rusage, if someone needs that.  I think that can be done as part of a
later patch series adding other operations for use with the file
descriptor, though.

> [FreeBSD theoretically has pdwait4(2) to do wait4-like operations on =
a
> process descriptor, including rusage retrieval.  However, I don't thi=
nk
> they actually implemented it:
>   http://fxr.watson.org/fxr/source/kern/syscalls.master#L928]

That's a pretty good argument that we don't need to either, at least no=
t
yet.

> >                      If the new process has not  yet  exited,  read=
(2)  either
> >                      blocks  until  it does, or fails with the erro=
r EAGAIN if
> >                      the file descriptor has been made nonblocking.
> >
> >                      Future kernels may extend clonefd_info by appe=
nding addi=E2=80=90
> >                      tional  fields  to  the end.  Callers should r=
ead as many
> >                      bytes as they understand; unread data will be =
 discarded,
> >                      and  subsequent  reads  after  the first will =
return 0 to
> >                      indicate end-of-file.  Callers requesting more=
 bytes than
> >                      the  kernel  provides  (such as callers expect=
ing a newer
> >                      clonefd_info structure) will receive a shorter=
  structure
> >                      from older kernels.
>=20
> FreeBSD also implements fstat(2) for its process descriptors, althoug=
h
> only a few of the fields get filled in.

I looked at what they provide, and that seems like more of a novelty
than something particularly useful (since most of the stat fields aren'=
t
meaningful), but if that's useful for compatibility then adding it seem=
s
fine.

> >               poll(2), select(2), epoll(7) (and similar)
> >                      The  file  descriptor  is readable (the select=
(2) readfds
> >                      argument; the poll(2) POLLIN flag) if the new =
process has
> >                      exited.
>=20
> FreeBSD uses POLLHUP here.

That makes sense given that they provide the information via a separate
call rather than read.  Since the CLONE_FD file descriptor uses read, i=
t
needs to provide POLLIN, but I have no objection to using *both* POLLIN
and POLLHUP if that'd be at all useful.

> >               close(2)
> >                      When  the file descriptor is no longer require=
d it should
> >                      be closed.  If no process has a file descripto=
r open  for
> >                      the new process, no process will receive any n=
otification
> >                      when the new process exits.  The new process  =
will  still
> >                      be immediately reaped.
>=20
> FreeBSD has two different behaviours for close(2), depending on a fla=
g
> value (PD_DAEMON).  With the flag set it's roughly like this, but
> without PD_DAEMON a close(2) operation on the (last open) file
> descriptor terminates the child process.
>=20
> This can be quite useful, particularly for the use case where some
> userspace library has an FD-controlled subprocess -- if the applicati=
on
> using the library terminates, the process descriptor is closed and so
> the subprocess is automatically terminated.

That's an interesting idea.  I don't think it makes sense for that to b=
e
the default behavior, but if someone wanted to add an additional flag
to implement that behavior, that seems fine.  A FreeBSD-compatible
pdfork could then use that flag when not passed PD_DAEMON and not use i=
t
when passed PD_DAEMON.

How does it kill the process when the last open descriptor closes?
SIGKILL?  SIGTERM?  The former seems unfriendly (preventing graceful
termination), and the latter blockable.  There's a reason init systems
send TERM, then wait, then KILL.

- Josh Triplett

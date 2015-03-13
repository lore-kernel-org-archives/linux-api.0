From: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/6] CLONE_FD: Task exit notification via file descriptor
Date: Fri, 13 Mar 2015 16:05:29 +0000
Message-ID: <CAHse=S9hnGm=Z8FR4f+z_TFwnrjBLkcV4wVwjDYgKuOSemdVrA@mail.gmail.com>
References: <cover.1426180120.git.josh@joshtriplett.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1426180120.git.josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Thiago Macieira <thiago.macieira-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Mar 13, 2015 at 1:40 AM, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org> =
wrote:
> This patch series introduces a new clone flag, CLONE_FD, which lets t=
he caller
> handle child process exit notification via a file descriptor rather t=
han
> SIGCHLD.  CLONE_FD makes it possible for libraries to safely launch a=
nd manage
> child processes on behalf of their caller, *without* taking over proc=
ess-wide
> SIGCHLD handling (either via signal handler or signalfd).

Hi Josh,

=46rom the overall description (i.e. I haven't looked at the code yet)
this looks very interesting.  However, it seems to cover a lot of the
same ground as the process descriptor feature that was added to FreeBSD
in 9.x/10.x:
  https://www.freebsd.org/cgi/man.cgi?query=3Dpdfork&sektion=3D2

I think it would ideally be nice for a userspace library developer to b=
e
able to do subprocess management (without SIGCHLD) in a similar way
across both platforms, without lots of complicated autoconf shenanigans=
=2E

So could we look at the overlap and seeing if we can come up with
something that covers your requirements and also allows for something
that looks like FreeBSD's process descriptors?

(I've actually got some rough patches to add process descriptor
functionality on Linux, so I can look at how the two approaches compare
and contrast.)

> Note that signalfd for SIGCHLD does not suffice here, because that st=
ill
> receives notification for all child processes, and interferes with pr=
ocess-wide
> signal handling.
>
> The CLONE_FD file descriptor uniquely identifies a process on the sys=
tem in a
> race-free way, by holding a reference to the task_struct.  In the fut=
ure, we
> may introduce APIs that support using process file descriptors instea=
d of PIDs.

=46reeBSD has pdkill(2) and (theoretically) pdwait4(2) along these line=
s.
I suspect we need either need pdkill(2) or a way to retrieve a PID from
a process file descriptor, so that there's a way to send signals to the
child.

> Introducing CLONE_FD required two additional bits of yak shaving: Sin=
ce clone
> has no more usable flags (with the three currently unused flags unusa=
ble
> because old kernels ignore them without EINVAL), also introduce a new=
 clone4
> system call with more flag bits and an extensible argument structure.=
  And
> since the magic pt_regs-based syscall argument processing for clone's=
 tls
> argument would otherwise prevent introducing a sane clone4 system cal=
l, fix
> that too.
>
> I tested the CLONE_SETTLS changes with a thread-local storage test pr=
ogram (two
> threads independently reading and writing a __thread variable), on bo=
th 32-bit
> and 64-bit, and I observed no issues there.

Worth preserving in tools/testing/selftests/ ?

> I tested clone4 and the new CLONE_FD call with several additional tes=
t
> programs, launching either a process or thread (in the former case us=
ing
> syscall(), in the latter case by calling clone4 via assembly and retu=
rning to
> C), sleeping in parent and child to test the case of either exiting f=
irst, and
> then printing the received clone4_info structure.  Thiago also tested=
 clone4
> with CLONE_FD with a modified version of libqt's process handling, wh=
ich
> includes a test suite.
>
> I've also included the manpages patch at the end of this series.  (No=
te that
> the manpage documents the behavior of the future glibc wrapper as wel=
l as the
> raw syscall.)  Here's a formatted plain-text version of the manpage f=
or
> reference:

=46YI, I've added some comparisons with the FreeBSD equivalents below.

>
> CLONE4(2)                  Linux Programmer's Manual                 =
CLONE4(2)
>
>
>
> NAME
>        clone4 - create a child process
>
> SYNOPSIS
>        /* Prototype for the glibc wrapper function */
>
>        #define _GNU_SOURCE
>        #include <sched.h>
>
>        int clone4(uint64_t flags,
>                   size_t args_size,
>                   struct clone4_args *args,
>                   int (*fn)(void *), void *arg);
>
>        /* Prototype for the raw system call */
>
>        int clone4(unsigned flags_high, unsigned flags_low,
>                   unsigned long args_size,
>                   struct clone4_args *args);
>
>        struct clone4_args {
>            pid_t *ptid;
>            pid_t *ctid;
>            unsigned long stack_start;
>            unsigned long stack_size;
>            unsigned long tls;
>        };
>
>
> DESCRIPTION
>        clone4()  creates  a  new  process,  similar  to  clone(2) and=
 fork(2).
>        clone4() supports additional flags that clone(2) does not, and=
  accepts
>        arguments via an extensible structure.
>
>        args  points to a clone4_args structure, and args_size must co=
ntain the
>        size of that structure, as understood by the  caller.   If  th=
e  caller
>        passes  a  shorter  structure  than  the  kernel expects, the =
remaining
>        fields will default to 0.  If the caller passes a larger struc=
ture than
>        the  kernel  expects  (such  as one from a newer kernel), clon=
e4() will
>        return EINVAL.  The clone4_args structure may gain additional =
fields at
>        the  end  in  the future, and callers must only pass a size th=
at encom=E2=80=90
>        passes the number of fields they understand.  If the  caller  =
passes  0
>        for args_size, args is ignored and may be NULL.
>
>        In  the clone4_args structure, ptid, ctid, stack_start, stack_=
size, and
>        tls have the same semantics as they do with clone(2) and clone=
2(2).
>
>        In the glibc wrapper, fn and arg have the same  semantics  as =
 they  do
>        with clone(2).  As with clone(2), the underlying system call w=
orks more
>        like fork(2), returning 0 in the child process; the glibc wrap=
per  sim=E2=80=90
>        plifies  thread execution by calling fn(arg) and exiting the c=
hild when
>        that function exits.
>
>        The 64-bit  flags  argument  (split  into  the  32-bit  flags_=
high  and
>        flags_low arguments in the kernel interface) accepts all the s=
ame flags
>        as  clone(2),  with  the   exception   of   the   obsolete   C=
LONE_PID,
>        CLONE_DETACHED, and CLONE_STOPPED.  In addition, flags accepts=
 the fol=E2=80=90
>        lowing flags:
>
>
>        CLONE_FD
>               Instead of returning a process ID, clone4()  with  the =
 CLONE_FD
>               flag  returns a file descriptor associated with the new=
 process.
>               When the new process exits, the kernel will not send a =
signal to
>               the  parent process, and will not keep the new process =
around as
>               a "zombie" process  until  a  call  to  waitpid(2)  or =
 similar.
>               Instead,  the file descriptor will become available for=
 reading,
>               and the new process will be immediately reaped.

Just to confirm: presumably a waitpid(-1,...) call that's already in
progress won't return when one of these child processes exits?

>
>               Unlike using  signalfd(2)  for  the  SIGCHLD  signal,  =
the  file
>               descriptor  returned  by  clone4()  with the CLONE_FD f=
lag works
>               even with SIGCHLD unblocked in one or more threads of t=
he parent
>               process,  and  allows the process to have different han=
dlers for
>               different child processes, such as those created by  a =
 library,
>               without  introducing  race conditions around process-wi=
de signal
>               handling.
>
>               clone4() will never return a file descriptor in the ran=
ge 0-2 to
>               the caller, to avoid ambiguity with the return of 0 in =
the child
>               process.  Only the  calling  process  will  have  the  =
new  file
>               descriptor open; the child process will not.

=46reeBSD's pdfork(2) returns a PID but also takes an int *fdp argument=
 to
return the file descriptor separately, which avoids the need for specia=
l
case processing for low FD values (and means that POSIX's "lowest file
descriptor not currently open" behaviour can be preserved if desired).

>               Since the kernel does not send a termination signal whe=
n a child
>               process created with CLONE_FD exits, the low byte of fl=
ags  does
>               not contain a signal number.  Instead, the low byte of =
flags can
>               contain the following additional flags for use with CLO=
NE_FD:
>
>
>               CLONEFD_CLOEXEC
>                      Set the O_CLOEXEC flag on the new open  file  de=
scriptor.
>                      See  the description of the O_CLOEXEC flag in op=
en(2) for
>                      reasons why this may be useful.
>
>
>               CLONEFD_NONBLOCK
>                      Set the O_NONBLOCK flag on the new open file  de=
scriptor.
>                      Using  this flag saves extra calls to fcntl(2) t=
o achieve
>                      the same result.
>
>
>               clone4() with the CLONE_FD flag returns a file  descrip=
tor  that
>               supports the following operations:
>
>               read(2) (and similar)
>                      When  the  new  process  exits,  reading  from  =
the  file
>                      descriptor produces a single clonefd_info struct=
ure:
>
>                      struct clonefd_info {
>                          uint32_t code;   /* Signal code */
>                          uint32_t status; /* Exit status or signal */
>                          uint64_t utime;  /* User CPU time */
>                          uint64_t stime;  /* System CPU time */
>                      };

Presumably there is no way to get full rusage information for the exite=
d
process?

[FreeBSD theoretically has pdwait4(2) to do wait4-like operations on a
process descriptor, including rusage retrieval.  However, I don't think
they actually implemented it:
  http://fxr.watson.org/fxr/source/kern/syscalls.master#L928]

>
>                      If the new process has not  yet  exited,  read(2=
)  either
>                      blocks  until  it does, or fails with the error =
EAGAIN if
>                      the file descriptor has been made nonblocking.
>
>                      Future kernels may extend clonefd_info by append=
ing addi=E2=80=90
>                      tional  fields  to  the end.  Callers should rea=
d as many
>                      bytes as they understand; unread data will be  d=
iscarded,
>                      and  subsequent  reads  after  the first will re=
turn 0 to
>                      indicate end-of-file.  Callers requesting more b=
ytes than
>                      the  kernel  provides  (such as callers expectin=
g a newer
>                      clonefd_info structure) will receive a shorter  =
structure
>                      from older kernels.

=46reeBSD also implements fstat(2) for its process descriptors, althoug=
h
only a few of the fields get filled in.

>               poll(2), select(2), epoll(7) (and similar)
>                      The  file  descriptor  is readable (the select(2=
) readfds
>                      argument; the poll(2) POLLIN flag) if the new pr=
ocess has
>                      exited.

=46reeBSD uses POLLHUP here.

>               close(2)
>                      When  the file descriptor is no longer required =
it should
>                      be closed.  If no process has a file descriptor =
open  for
>                      the new process, no process will receive any not=
ification
>                      when the new process exits.  The new process  wi=
ll  still
>                      be immediately reaped.

=46reeBSD has two different behaviours for close(2), depending on a fla=
g
value (PD_DAEMON).  With the flag set it's roughly like this, but
without PD_DAEMON a close(2) operation on the (last open) file
descriptor terminates the child process.

This can be quite useful, particularly for the use case where some
userspace library has an FD-controlled subprocess -- if the application
using the library terminates, the process descriptor is closed and so
the subprocess is automatically terminated.

>
>    C library/kernel ABI differences
>        As with clone(2), the raw clone4() system call corresponds mor=
e closely
>        to fork(2) in that execution in the child continues from the  =
point  of
>        the call.
>
>        Unlike  clone(2),  the  raw  system call interface for clone4(=
) accepts
>        arguments in the same order on all architectures.
>
>        The raw system call accepts flags as two 32-bit  arguments,  f=
lags_high
>        and  flags_low, to simplify portability across 32-bit and 64-b=
it archi=E2=80=90
>        tectures and calling conventions.  The glibc wrapper accepts f=
lags as a
>        single 64-bit argument for convenience.
>
>
> RETURN VALUE
>        For the glibc wrapper, on success, clone4() returns the file d=
escriptor
>        (with CLONE_FD) or new process ID (without  CLONE_FD),  and  t=
he  child
>        process begins running at the specified function.
>
>        For  the  raw syscall, on success, clone4() returns the file d=
escriptor
>        or new process ID to the calling process, and  returns  0  in =
 the  new
>        child process.
>
>        On failure, clone4() returns -1 and sets errno accordingly.
>
>
> ERRORS
>        clone4()  can  return any error from clone(2), as well as the =
following
>        additional errors:
>
>        EINVAL flags contained an unknown flag.
>
>        EINVAL flags included CLONE_FD, but the kernel configuration  =
does  not
>               have the CONFIG_CLONEFD option enabled.
>
>        EMFILE flags  included  CLONE_FD,  but  the  new  file descrip=
tor would
>               exceed the process limit on open file descriptors.
>
>        ENFILE flags included CLONE_FD,  but  the  new  file  descript=
or  would
>               exceed the system-wide limit on open file descriptors.
>
>        ENODEV flags  included  CLONE_FD,  but  clone4()  could  not  =
mount the
>               (internal) anonymous inode device.
>
>
> CONFORMING TO
>        clone4() is Linux-specific and should not be used in programs =
 intended
>        to be portable.
>
>
> SEE ALSO
>        clone(2), epoll(7), poll(2), pthreads(7), read(2), select(2)
>
>
>
> Linux                             2015-03-01                         =
CLONE4(2)

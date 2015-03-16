From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v2 0/7] CLONE_FD: Task exit notification via file descriptor
Date: Mon, 16 Mar 2015 14:44:20 -0700
Message-ID: <CAGXu5jLmLLgVNCP=cyUiXuiszVXsS88SNUK2iBqArbA2V6vdHA@mail.gmail.com>
References: <cover.1426376419.git.josh@joshtriplett.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <cover.1426376419.git.josh@joshtriplett.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Josh Triplett <josh@joshtriplett.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>, Oleg Nesterov <oleg@redhat.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>, Rik van Riel <riel@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk <mtk.manpages@gmail.com>, Thiago Macieira <thiago.macieira@intel.com>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>
List-Id: linux-api@vger.kernel.org

On Sun, Mar 15, 2015 at 12:59 AM, Josh Triplett <josh@joshtriplett.org>=
 wrote:
> This patch series introduces a new clone flag, CLONE_FD, which lets t=
he caller
> receive child process exit notification via a file descriptor rather =
than
> SIGCHLD.  CLONE_FD makes it possible for libraries to safely launch a=
nd manage
> child processes on behalf of their caller, *without* taking over proc=
ess-wide
> SIGCHLD handling (either via signal handler or signalfd).
>
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
>
> This patch series also introduces a clone flag CLONE_AUTOREAP, which =
causes the
> kernel to automatically reap the child process when it exits, just as=
 it does
> for processes using SIGCHLD when the parent has SIGCHLD ignored or ma=
rked as
> SA_NOCLDSTOP.
>
> Taken together, a library can launch a process with CLONE_FD, CLONE_A=
UTOREAP,
> and no exit signal, and completely avoid affecting either process-wid=
e signal
> handling or an existing child wait loop.
>
> Introducing CLONE_FD and CLONE_AUTOREAP required two additional bits =
of yak
> shaving: Since clone has no more usable flags (with the three current=
ly unused
> flags unusable because old kernels ignore them without EINVAL), also =
introduce
> a new clone4 system call with more flag bits and an extensible argume=
nt
> structure.  And since the magic pt_regs-based syscall argument proces=
sing for
> clone's tls argument would otherwise prevent introducing a sane clone=
4 system
> call, fix that too.
>
> I tested the CLONE_SETTLS changes with a thread-local storage test pr=
ogram (two
> threads independently reading and writing a __thread variable), on bo=
th 32-bit
> and 64-bit, and I observed no issues there.
>
> I tested clone4 and the new flags with several additional test progra=
ms,
> launching either a process or thread (in the former case using syscal=
l(), in
> the latter case by calling clone4 via assembly and returning to C), s=
leeping in
> parent and child to test the case of either exiting first, and then p=
rinting
> the received clone4_info structure.
>
> Changes in v2:
> - Split out autoreaping into a separate CLONE_AUTOREAP.  CLONE_FD no =
longer
>   implies autoreaping and no exit signal, and CLONE_AUTOREAP does not=
 affect
>   ptracers or signal handling.  Thanks to Oleg Nesterov for careful
>   investigation and discussion on v1.
> - Accept O_CLOEXEC and O_NONBLOCK via a clonefd_flags parameter in cl=
one4_args.
>   Stop overloading the low byte of the main clone flags, since CLONE_=
=46D now
>   works with a non-zero signal.
> - Return the file descriptor via an out parameter in clone4_args.
> - Drop patch to export alloc_fd; CLONE_FD now uses the next available=
 file
>   descriptor, even if that's 0-2, since clone4 no longer needs to avo=
id
>   ambiguity with the 0 return indicating the child process.
> - Make poll on a CLONE_FD for an exited task also return POLLHUP, for
>   compatibility with FreeBSD's pdfork.  Thanks to David Drysdale for =
calling
>   attention to pdfork.

I think POLLHUP should be mentioned in the manpage (now it only
mentions POLLIN).

> - Fix typo in squelch_clone_flags.
> - Pass arguments to _do_fork and copy_process as a structure.
> - Construct the 64-bit flags in a separate variable, rather than inli=
ne in the
>   call to do_fork.
> - Fix error return for copy_from_user faults.
> - Add the new syscall to asm-generic.
> - Add ack from Andy Lutomirski to patches 1 and 2.
>
> I've included the manpages patch at the end of this series.  (Note th=
at the
> manpage documents the behavior of the future glibc wrapper as well as=
 the raw
> syscall.)  Here's a formatted plain-text version of the manpage for r=
eference:
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
>            int *clonefd;
>            unsigned clonefd_flags;
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
>        flags_low  arguments  in  the  kernel  interface for portabili=
ty across
>        architectures) accepts all the same flags as clone(2), with th=
e  excep=E2=80=90
>        tion  of the obsolete CLONE_PID, CLONE_DETACHED, and CLONE_STO=
PPED.  In
>        addition, flags accepts the following flags:
>
>
>        CLONE_AUTOREAP
>               When the new process exits, immediately  reap  it,  rat=
her  than
>               keeping  it  around  as a "zombie" until a call to wait=
pid(2) or
>               similar.  Without this flag, the kernel will automatica=
lly  reap
>               a  process if its exit signal is set to SIGCHLD, and if=
 the par=E2=80=90
>               ent process has SIGCHLD set to SIG_IGN or has a SIGCHLD=
  handler
>               installed  with SA_NOCLDWAIT (see sigaction(2)).  CLONE=
_AUTOREAP
>               allows the calling process to enable automatic reaping =
 with  an
>               exit  signal other than SIGCHLD (including 0 to disable=
 the exit
>               signal), and does not depend on the  configuration  of =
 process-
>               wide signal handling.
>
>
>        CLONE_FD
>               Return  a file descriptor associated with the new proce=
ss, stor=E2=80=90
>               ing it in location clonefd in the parent's address spac=
e.   When
>               the new process exits, the file descriptor will become =
available
>               for reading.
>
>               Unlike using  signalfd(2)  for  the  SIGCHLD  signal,  =
the  file
>               descriptor  returned  by  clone4()  with the CLONE_FD f=
lag works
>               even with SIGCHLD unblocked in one or more threads of t=
he parent
>               process,  allowing  the  process  to have different han=
dlers for
>               different child processes, such as those created by  a =
 library,
>               without  introducing  race conditions around process-wi=
de signal
>               handling.
>
>               clonefd_flags may contain the following additional flag=
s for use
>               with CLONE_FD:
>
>
>               O_CLOEXEC
>                      Set  the  close-on-exec  flag on the new file de=
scriptor.
>                      See the description of the O_CLOEXEC flag in ope=
n(2)  for
>                      reasons why this may be useful.

This begs the question: what happens when all CLONE_FD fds for a
process are closed? Will the parent get SIGCHLD instead, will it
auto-reap, or will it be un-wait-able (I assume not this...)

>
>
>               O_NONBLOCK
>                      Set  the  O_NONBLOCK  flag  on  the  new file de=
scriptor.
>                      Using this flag saves extra calls to fcntl(2) to=
  achieve
>                      the same result.
>
>
>               The returned file descriptor supports the following ope=
rations:
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
>
>
>                      If the new process has not  yet  exited,  read(2=
)  either
>                      blocks  until  it does, or fails with the error =
EAGAIN if
>                      the file descriptor has O_NONBLOCK set.
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
>
>               poll(2), select(2), epoll(7) (and similar)
>                      The  file  descriptor  is readable (the select(2=
) readfds
>                      argument; the poll(2) POLLIN flag) if the new pr=
ocess has
>                      exited.
>
>               close(2)
>                      When  the file descriptor is no longer required =
it should
>                      be closed.
>
>
>    C library/kernel ABI differences
>        As with clone(2), the raw clone4() system call corresponds mor=
e closely
>        to  fork(2)  in that execution in the child continues from the=
 point of
>        the call.
>
>        Unlike clone(2), the raw system call  interface  for  clone4()=
  accepts
>        arguments in the same order on all architectures.
>
>        The  raw  system call accepts flags as two 32-bit arguments, f=
lags_high
>        and flags_low, to simplify portability across 32-bit and 64-bi=
t  archi=E2=80=90
>        tectures and calling conventions.  The glibc wrapper accepts f=
lags as a
>        single 64-bit argument for convenience.
>
>
> RETURN VALUE
>        For the glibc wrapper, on success, clone4() returns the new pr=
ocess  ID
>        to the calling process, and the new process begins running at =
the spec=E2=80=90
>        ified function.
>
>        For the raw syscall, on success, clone4() returns the new proc=
ess ID to
>        the calling process, and returns 0 in the new process.
>
>        On failure, clone4() returns -1 and sets errno accordingly.
>
>
> ERRORS
>        clone4()  can  return any error from clone(2), as well as the =
following
>        additional errors:
>
>        EFAULT args is outside your accessible address space.
>
>        EINVAL flags contained an unknown flag.
>
>        EINVAL flags included CLONE_FD and clonefd_flags contained  an=
  unknown
>               flag.
>
>        EINVAL flags  included  CLONE_FD, but the kernel configuration=
 does not
>               have the CONFIG_CLONEFD option enabled.
>
>        EMFILE flags included CLONE_FD,  but  the  new  file  descript=
or  would
>               exceed the process limit on open file descriptors.
>
>        ENFILE flags  included  CLONE_FD,  but  the  new  file descrip=
tor would
>               exceed the system-wide limit on open file descriptors.
>
>        ENODEV flags included  CLONE_FD,  but  clone4()  could  not  m=
ount  the
>               (internal) anonymous inode device.
>
>
> CONFORMING TO
>        clone4()  is Linux-specific and should not be used in programs=
 intended
>        to be portable.
>
>
> SEE ALSO
>        clone(2), epoll(7), poll(2), pthreads(7), read(2), select(2)
>
>
>
> Linux                             2015-03-14                         =
CLONE4(2)
>
>
> Josh Triplett and Thiago Macieira (7):
>   clone: Support passing tls argument via C rather than pt_regs magic
>   x86: Opt into HAVE_COPY_THREAD_TLS, for both 32-bit and 64-bit
>   Introduce a new clone4 syscall with more flag bits and extensible a=
rguments
>   kernel/fork.c: Pass arguments to _do_fork and copy_process using cl=
one4_args
>   clone4: Add a CLONE_AUTOREAP flag to automatically reap the child p=
rocess
>   signal: Factor out a helper function to process task_struct exit_co=
de
>   clone4: Add a CLONE_FD flag to get task exit notification via fd
>
>  arch/Kconfig                      |   7 ++
>  arch/x86/Kconfig                  |   1 +
>  arch/x86/ia32/ia32entry.S         |   3 +-
>  arch/x86/kernel/entry_64.S        |   1 +
>  arch/x86/kernel/process_32.c      |   6 +-
>  arch/x86/kernel/process_64.c      |   8 +--
>  arch/x86/syscalls/syscall_32.tbl  |   1 +
>  arch/x86/syscalls/syscall_64.tbl  |   2 +
>  include/linux/compat.h            |  14 ++++
>  include/linux/sched.h             |  22 ++++++
>  include/linux/syscalls.h          |   6 +-
>  include/uapi/asm-generic/unistd.h |   4 +-
>  include/uapi/linux/sched.h        |  55 ++++++++++++++-
>  init/Kconfig                      |  21 ++++++
>  kernel/Makefile                   |   1 +
>  kernel/clonefd.c                  | 121 ++++++++++++++++++++++++++++=
++++
>  kernel/clonefd.h                  |  32 +++++++++
>  kernel/exit.c                     |   4 ++
>  kernel/fork.c                     | 142 ++++++++++++++++++++++++++++=
++--------
>  kernel/signal.c                   |  26 ++++---
>  kernel/sys_ni.c                   |   1 +
>  21 files changed, 426 insertions(+), 52 deletions(-)
>  create mode 100644 kernel/clonefd.c
>  create mode 100644 kernel/clonefd.h
>
> --
> 2.1.4
>

Looks promising!

-Kees

--=20
Kees Cook
Chrome OS Security
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Subject: [PATCH v2 0/7] CLONE_FD: Task exit notification via file descriptor
Date: Sun, 15 Mar 2015 00:59:17 -0700
Message-ID: <cover.1426376419.git.josh@joshtriplett.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thiago Macieira <thiago.macieira-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

This patch series introduces a new clone flag, CLONE_FD, which lets the=
 caller
receive child process exit notification via a file descriptor rather th=
an
SIGCHLD.  CLONE_FD makes it possible for libraries to safely launch and=
 manage
child processes on behalf of their caller, *without* taking over proces=
s-wide
SIGCHLD handling (either via signal handler or signalfd).

Note that signalfd for SIGCHLD does not suffice here, because that stil=
l
receives notification for all child processes, and interferes with proc=
ess-wide
signal handling.

The CLONE_FD file descriptor uniquely identifies a process on the syste=
m in a
race-free way, by holding a reference to the task_struct.  In the futur=
e, we
may introduce APIs that support using process file descriptors instead =
of PIDs.

This patch series also introduces a clone flag CLONE_AUTOREAP, which ca=
uses the
kernel to automatically reap the child process when it exits, just as i=
t does
for processes using SIGCHLD when the parent has SIGCHLD ignored or mark=
ed as
SA_NOCLDSTOP.

Taken together, a library can launch a process with CLONE_FD, CLONE_AUT=
OREAP,
and no exit signal, and completely avoid affecting either process-wide =
signal
handling or an existing child wait loop.

Introducing CLONE_FD and CLONE_AUTOREAP required two additional bits of=
 yak
shaving: Since clone has no more usable flags (with the three currently=
 unused
flags unusable because old kernels ignore them without EINVAL), also in=
troduce
a new clone4 system call with more flag bits and an extensible argument
structure.  And since the magic pt_regs-based syscall argument processi=
ng for
clone's tls argument would otherwise prevent introducing a sane clone4 =
system
call, fix that too.

I tested the CLONE_SETTLS changes with a thread-local storage test prog=
ram (two
threads independently reading and writing a __thread variable), on both=
 32-bit
and 64-bit, and I observed no issues there.

I tested clone4 and the new flags with several additional test programs=
,
launching either a process or thread (in the former case using syscall(=
), in
the latter case by calling clone4 via assembly and returning to C), sle=
eping in
parent and child to test the case of either exiting first, and then pri=
nting
the received clone4_info structure.

Changes in v2:
- Split out autoreaping into a separate CLONE_AUTOREAP.  CLONE_FD no lo=
nger
  implies autoreaping and no exit signal, and CLONE_AUTOREAP does not a=
ffect
  ptracers or signal handling.  Thanks to Oleg Nesterov for careful
  investigation and discussion on v1.
- Accept O_CLOEXEC and O_NONBLOCK via a clonefd_flags parameter in clon=
e4_args.
  Stop overloading the low byte of the main clone flags, since CLONE_FD=
 now
  works with a non-zero signal.
- Return the file descriptor via an out parameter in clone4_args.
- Drop patch to export alloc_fd; CLONE_FD now uses the next available f=
ile
  descriptor, even if that's 0-2, since clone4 no longer needs to avoid
  ambiguity with the 0 return indicating the child process.
- Make poll on a CLONE_FD for an exited task also return POLLHUP, for
  compatibility with FreeBSD's pdfork.  Thanks to David Drysdale for ca=
lling
  attention to pdfork.
- Fix typo in squelch_clone_flags.
- Pass arguments to _do_fork and copy_process as a structure.
- Construct the 64-bit flags in a separate variable, rather than inline=
 in the
  call to do_fork.
- Fix error return for copy_from_user faults.
- Add the new syscall to asm-generic.
- Add ack from Andy Lutomirski to patches 1 and 2.

I've included the manpages patch at the end of this series.  (Note that=
 the
manpage documents the behavior of the future glibc wrapper as well as t=
he raw
syscall.)  Here's a formatted plain-text version of the manpage for ref=
erence:

CLONE4(2)                  Linux Programmer's Manual                 CL=
ONE4(2)



NAME
       clone4 - create a child process

SYNOPSIS
       /* Prototype for the glibc wrapper function */

       #define _GNU_SOURCE
       #include <sched.h>

       int clone4(uint64_t flags,
                  size_t args_size,
                  struct clone4_args *args,
                  int (*fn)(void *), void *arg);

       /* Prototype for the raw system call */

       int clone4(unsigned flags_high, unsigned flags_low,
                  unsigned long args_size,
                  struct clone4_args *args);

       struct clone4_args {
           pid_t *ptid;
           pid_t *ctid;
           unsigned long stack_start;
           unsigned long stack_size;
           unsigned long tls;
           int *clonefd;
           unsigned clonefd_flags;
       };


DESCRIPTION
       clone4()  creates  a  new  process,  similar  to  clone(2) and f=
ork(2).
       clone4() supports additional flags that clone(2) does not, and  =
accepts
       arguments via an extensible structure.

       args  points to a clone4_args structure, and args_size must cont=
ain the
       size of that structure, as understood by the  caller.   If  the =
 caller
       passes  a  shorter  structure  than  the  kernel expects, the re=
maining
       fields will default to 0.  If the caller passes a larger structu=
re than
       the  kernel  expects  (such  as one from a newer kernel), clone4=
() will
       return EINVAL.  The clone4_args structure may gain additional fi=
elds at
       the  end  in  the future, and callers must only pass a size that=
 encom=E2=80=90
       passes the number of fields they understand.  If the  caller  pa=
sses  0
       for args_size, args is ignored and may be NULL.

       In  the clone4_args structure, ptid, ctid, stack_start, stack_si=
ze, and
       tls have the same semantics as they do with clone(2) and clone2(=
2).

       In the glibc wrapper, fn and arg have the same  semantics  as  t=
hey  do
       with clone(2).  As with clone(2), the underlying system call wor=
ks more
       like fork(2), returning 0 in the child process; the glibc wrappe=
r  sim=E2=80=90
       plifies  thread execution by calling fn(arg) and exiting the chi=
ld when
       that function exits.

       The 64-bit  flags  argument  (split  into  the  32-bit  flags_hi=
gh  and
       flags_low  arguments  in  the  kernel  interface for portability=
 across
       architectures) accepts all the same flags as clone(2), with the =
 excep=E2=80=90
       tion  of the obsolete CLONE_PID, CLONE_DETACHED, and CLONE_STOPP=
ED.  In
       addition, flags accepts the following flags:


       CLONE_AUTOREAP
              When the new process exits, immediately  reap  it,  rathe=
r  than
              keeping  it  around  as a "zombie" until a call to waitpi=
d(2) or
              similar.  Without this flag, the kernel will automaticall=
y  reap
              a  process if its exit signal is set to SIGCHLD, and if t=
he par=E2=80=90
              ent process has SIGCHLD set to SIG_IGN or has a SIGCHLD  =
handler
              installed  with SA_NOCLDWAIT (see sigaction(2)).  CLONE_A=
UTOREAP
              allows the calling process to enable automatic reaping  w=
ith  an
              exit  signal other than SIGCHLD (including 0 to disable t=
he exit
              signal), and does not depend on the  configuration  of  p=
rocess-
              wide signal handling.


       CLONE_FD
              Return  a file descriptor associated with the new process=
, stor=E2=80=90
              ing it in location clonefd in the parent's address space.=
   When
              the new process exits, the file descriptor will become av=
ailable
              for reading.

              Unlike using  signalfd(2)  for  the  SIGCHLD  signal,  th=
e  file
              descriptor  returned  by  clone4()  with the CLONE_FD fla=
g works
              even with SIGCHLD unblocked in one or more threads of the=
 parent
              process,  allowing  the  process  to have different handl=
ers for
              different child processes, such as those created by  a  l=
ibrary,
              without  introducing  race conditions around process-wide=
 signal
              handling.

              clonefd_flags may contain the following additional flags =
for use
              with CLONE_FD:


              O_CLOEXEC
                     Set  the  close-on-exec  flag on the new file desc=
riptor.
                     See the description of the O_CLOEXEC flag in open(=
2)  for
                     reasons why this may be useful.


              O_NONBLOCK
                     Set  the  O_NONBLOCK  flag  on  the  new file desc=
riptor.
                     Using this flag saves extra calls to fcntl(2) to  =
achieve
                     the same result.


              The returned file descriptor supports the following opera=
tions:

              read(2) (and similar)
                     When  the  new  process  exits,  reading  from  th=
e  file
                     descriptor produces a single clonefd_info structur=
e:

                     struct clonefd_info {
                         uint32_t code;   /* Signal code */
                         uint32_t status; /* Exit status or signal */
                         uint64_t utime;  /* User CPU time */
                         uint64_t stime;  /* System CPU time */
                     };


                     If the new process has not  yet  exited,  read(2) =
 either
                     blocks  until  it does, or fails with the error EA=
GAIN if
                     the file descriptor has O_NONBLOCK set.

                     Future kernels may extend clonefd_info by appendin=
g addi=E2=80=90
                     tional  fields  to  the end.  Callers should read =
as many
                     bytes as they understand; unread data will be  dis=
carded,
                     and  subsequent  reads  after  the first will retu=
rn 0 to
                     indicate end-of-file.  Callers requesting more byt=
es than
                     the  kernel  provides  (such as callers expecting =
a newer
                     clonefd_info structure) will receive a shorter  st=
ructure
                     from older kernels.

              poll(2), select(2), epoll(7) (and similar)
                     The  file  descriptor  is readable (the select(2) =
readfds
                     argument; the poll(2) POLLIN flag) if the new proc=
ess has
                     exited.

              close(2)
                     When  the file descriptor is no longer required it=
 should
                     be closed.


   C library/kernel ABI differences
       As with clone(2), the raw clone4() system call corresponds more =
closely
       to  fork(2)  in that execution in the child continues from the p=
oint of
       the call.

       Unlike clone(2), the raw system call  interface  for  clone4()  =
accepts
       arguments in the same order on all architectures.

       The  raw  system call accepts flags as two 32-bit arguments, fla=
gs_high
       and flags_low, to simplify portability across 32-bit and 64-bit =
 archi=E2=80=90
       tectures and calling conventions.  The glibc wrapper accepts fla=
gs as a
       single 64-bit argument for convenience.


RETURN VALUE
       For the glibc wrapper, on success, clone4() returns the new proc=
ess  ID
       to the calling process, and the new process begins running at th=
e spec=E2=80=90
       ified function.

       For the raw syscall, on success, clone4() returns the new proces=
s ID to
       the calling process, and returns 0 in the new process.

       On failure, clone4() returns -1 and sets errno accordingly.


ERRORS
       clone4()  can  return any error from clone(2), as well as the fo=
llowing
       additional errors:

       EFAULT args is outside your accessible address space.

       EINVAL flags contained an unknown flag.

       EINVAL flags included CLONE_FD and clonefd_flags contained  an  =
unknown
              flag.

       EINVAL flags  included  CLONE_FD, but the kernel configuration d=
oes not
              have the CONFIG_CLONEFD option enabled.

       EMFILE flags included CLONE_FD,  but  the  new  file  descriptor=
  would
              exceed the process limit on open file descriptors.

       ENFILE flags  included  CLONE_FD,  but  the  new  file descripto=
r would
              exceed the system-wide limit on open file descriptors.

       ENODEV flags included  CLONE_FD,  but  clone4()  could  not  mou=
nt  the
              (internal) anonymous inode device.


CONFORMING TO
       clone4()  is Linux-specific and should not be used in programs i=
ntended
       to be portable.


SEE ALSO
       clone(2), epoll(7), poll(2), pthreads(7), read(2), select(2)



Linux                             2015-03-14                         CL=
ONE4(2)


Josh Triplett and Thiago Macieira (7):
  clone: Support passing tls argument via C rather than pt_regs magic
  x86: Opt into HAVE_COPY_THREAD_TLS, for both 32-bit and 64-bit
  Introduce a new clone4 syscall with more flag bits and extensible arg=
uments
  kernel/fork.c: Pass arguments to _do_fork and copy_process using clon=
e4_args
  clone4: Add a CLONE_AUTOREAP flag to automatically reap the child pro=
cess
  signal: Factor out a helper function to process task_struct exit_code
  clone4: Add a CLONE_FD flag to get task exit notification via fd

 arch/Kconfig                      |   7 ++
 arch/x86/Kconfig                  |   1 +
 arch/x86/ia32/ia32entry.S         |   3 +-
 arch/x86/kernel/entry_64.S        |   1 +
 arch/x86/kernel/process_32.c      |   6 +-
 arch/x86/kernel/process_64.c      |   8 +--
 arch/x86/syscalls/syscall_32.tbl  |   1 +
 arch/x86/syscalls/syscall_64.tbl  |   2 +
 include/linux/compat.h            |  14 ++++
 include/linux/sched.h             |  22 ++++++
 include/linux/syscalls.h          |   6 +-
 include/uapi/asm-generic/unistd.h |   4 +-
 include/uapi/linux/sched.h        |  55 ++++++++++++++-
 init/Kconfig                      |  21 ++++++
 kernel/Makefile                   |   1 +
 kernel/clonefd.c                  | 121 ++++++++++++++++++++++++++++++=
++
 kernel/clonefd.h                  |  32 +++++++++
 kernel/exit.c                     |   4 ++
 kernel/fork.c                     | 142 ++++++++++++++++++++++++++++++=
--------
 kernel/signal.c                   |  26 ++++---
 kernel/sys_ni.c                   |   1 +
 21 files changed, 426 insertions(+), 52 deletions(-)
 create mode 100644 kernel/clonefd.c
 create mode 100644 kernel/clonefd.h

--=20
2.1.4

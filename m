From: Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH 0/6] CLONE_FD: Task exit notification via file descriptor
Date: Thu, 12 Mar 2015 18:40:03 -0700
Message-ID: <cover.1426180120.git.josh@joshtriplett.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>, Oleg Nesterov <oleg@redhat.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>, Rik van Riel <riel@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Thiago Macieira <thiago.macieira@intel.com>, Michael Kerrisk <mtk.manpages@gmail.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

This patch series introduces a new clone flag, CLONE_FD, which lets the=
 caller
handle child process exit notification via a file descriptor rather tha=
n
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

Introducing CLONE_FD required two additional bits of yak shaving: Since=
 clone
has no more usable flags (with the three currently unused flags unusabl=
e
because old kernels ignore them without EINVAL), also introduce a new c=
lone4
system call with more flag bits and an extensible argument structure.  =
And
since the magic pt_regs-based syscall argument processing for clone's t=
ls
argument would otherwise prevent introducing a sane clone4 system call,=
 fix
that too.

I tested the CLONE_SETTLS changes with a thread-local storage test prog=
ram (two
threads independently reading and writing a __thread variable), on both=
 32-bit
and 64-bit, and I observed no issues there.

I tested clone4 and the new CLONE_FD call with several additional test
programs, launching either a process or thread (in the former case usin=
g
syscall(), in the latter case by calling clone4 via assembly and return=
ing to
C), sleeping in parent and child to test the case of either exiting fir=
st, and
then printing the received clone4_info structure.  Thiago also tested c=
lone4
with CLONE_FD with a modified version of libqt's process handling, whic=
h
includes a test suite.

I've also included the manpages patch at the end of this series.  (Note=
 that
the manpage documents the behavior of the future glibc wrapper as well =
as the
raw syscall.)  Here's a formatted plain-text version of the manpage for
reference:

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
       flags_low arguments in the kernel interface) accepts all the sam=
e flags
       as  clone(2),  with  the   exception   of   the   obsolete   CLO=
NE_PID,
       CLONE_DETACHED, and CLONE_STOPPED.  In addition, flags accepts t=
he fol=E2=80=90
       lowing flags:


       CLONE_FD
              Instead of returning a process ID, clone4()  with  the  C=
LONE_FD
              flag  returns a file descriptor associated with the new p=
rocess.
              When the new process exits, the kernel will not send a si=
gnal to
              the  parent process, and will not keep the new process ar=
ound as
              a "zombie" process  until  a  call  to  waitpid(2)  or  s=
imilar.
              Instead,  the file descriptor will become available for r=
eading,
              and the new process will be immediately reaped.

              Unlike using  signalfd(2)  for  the  SIGCHLD  signal,  th=
e  file
              descriptor  returned  by  clone4()  with the CLONE_FD fla=
g works
              even with SIGCHLD unblocked in one or more threads of the=
 parent
              process,  and  allows the process to have different handl=
ers for
              different child processes, such as those created by  a  l=
ibrary,
              without  introducing  race conditions around process-wide=
 signal
              handling.

              clone4() will never return a file descriptor in the range=
 0-2 to
              the caller, to avoid ambiguity with the return of 0 in th=
e child
              process.  Only the  calling  process  will  have  the  ne=
w  file
              descriptor open; the child process will not.

              Since the kernel does not send a termination signal when =
a child
              process created with CLONE_FD exits, the low byte of flag=
s  does
              not contain a signal number.  Instead, the low byte of fl=
ags can
              contain the following additional flags for use with CLONE=
_FD:


              CLONEFD_CLOEXEC
                     Set the O_CLOEXEC flag on the new open  file  desc=
riptor.
                     See  the description of the O_CLOEXEC flag in open=
(2) for
                     reasons why this may be useful.


              CLONEFD_NONBLOCK
                     Set the O_NONBLOCK flag on the new open file  desc=
riptor.
                     Using  this flag saves extra calls to fcntl(2) to =
achieve
                     the same result.


              clone4() with the CLONE_FD flag returns a file  descripto=
r  that
              supports the following operations:

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
                     the file descriptor has been made nonblocking.

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
                     be closed.  If no process has a file descriptor op=
en  for
                     the new process, no process will receive any notif=
ication
                     when the new process exits.  The new process  will=
  still
                     be immediately reaped.


   C library/kernel ABI differences
       As with clone(2), the raw clone4() system call corresponds more =
closely
       to fork(2) in that execution in the child continues from the  po=
int  of
       the call.

       Unlike  clone(2),  the  raw  system call interface for clone4() =
accepts
       arguments in the same order on all architectures.

       The raw system call accepts flags as two 32-bit  arguments,  fla=
gs_high
       and  flags_low, to simplify portability across 32-bit and 64-bit=
 archi=E2=80=90
       tectures and calling conventions.  The glibc wrapper accepts fla=
gs as a
       single 64-bit argument for convenience.


RETURN VALUE
       For the glibc wrapper, on success, clone4() returns the file des=
criptor
       (with CLONE_FD) or new process ID (without  CLONE_FD),  and  the=
  child
       process begins running at the specified function.

       For  the  raw syscall, on success, clone4() returns the file des=
criptor
       or new process ID to the calling process, and  returns  0  in  t=
he  new
       child process.

       On failure, clone4() returns -1 and sets errno accordingly.


ERRORS
       clone4()  can  return any error from clone(2), as well as the fo=
llowing
       additional errors:

       EINVAL flags contained an unknown flag.

       EINVAL flags included CLONE_FD, but the kernel configuration  do=
es  not
              have the CONFIG_CLONEFD option enabled.

       EMFILE flags  included  CLONE_FD,  but  the  new  file descripto=
r would
              exceed the process limit on open file descriptors.

       ENFILE flags included CLONE_FD,  but  the  new  file  descriptor=
  would
              exceed the system-wide limit on open file descriptors.

       ENODEV flags  included  CLONE_FD,  but  clone4()  could  not  mo=
unt the
              (internal) anonymous inode device.


CONFORMING TO
       clone4() is Linux-specific and should not be used in programs  i=
ntended
       to be portable.


SEE ALSO
       clone(2), epoll(7), poll(2), pthreads(7), read(2), select(2)



Linux                             2015-03-01                         CL=
ONE4(2)


Josh Triplett and Thiago Macieira (6):
  clone: Support passing tls argument via C rather than pt_regs magic
  x86: Opt into HAVE_COPY_THREAD_TLS, for both 32-bit and 64-bit
  Introduce a new clone4 syscall with more flag bits and extensible arg=
uments
  signal: Factor out a helper function to process task_struct exit_code
  fs: Make alloc_fd non-private
  clone4: Introduce new CLONE_FD flag to get task exit notification via=
 fd

 arch/Kconfig                     |   7 ++
 arch/x86/Kconfig                 |   1 +
 arch/x86/ia32/ia32entry.S        |   3 +-
 arch/x86/kernel/entry_64.S       |   1 +
 arch/x86/kernel/process_32.c     |   6 +-
 arch/x86/kernel/process_64.c     |   8 +--
 arch/x86/syscalls/syscall_32.tbl |   1 +
 arch/x86/syscalls/syscall_64.tbl |   2 +
 fs/file.c                        |   2 +-
 include/linux/compat.h           |  12 ++++
 include/linux/file.h             |   1 +
 include/linux/sched.h            |  20 ++++++
 include/linux/syscalls.h         |   6 +-
 include/uapi/linux/sched.h       |  54 ++++++++++++++-
 init/Kconfig                     |  21 ++++++
 kernel/Makefile                  |   1 +
 kernel/clonefd.c                 | 123 +++++++++++++++++++++++++++++++=
++
 kernel/clonefd.h                 |  27 ++++++++
 kernel/exit.c                    |  10 ++-
 kernel/fork.c                    | 143 +++++++++++++++++++++++++++++++=
+-------
 kernel/signal.c                  |  24 ++++---
 kernel/sys_ni.c                  |   1 +
 22 files changed, 425 insertions(+), 49 deletions(-)
 create mode 100644 kernel/clonefd.c
 create mode 100644 kernel/clonefd.h

--=20
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

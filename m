From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH v18 for v4.1-rc2 1/3] sys_membarrier(): system-wide
 memory barrier (generic, x86)
Date: Wed, 6 May 2015 20:27:19 +0000 (UTC)
Message-ID: <371299002.44925.1430944039395.JavaMail.zimbra@efficios.com>
References: <1430940068-4326-1-git-send-email-mathieu.desnoyers@efficios.com> <1430940068-4326-2-git-send-email-mathieu.desnoyers@efficios.com> <20150506202120.GA23011@cloud>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150506202120.GA23011@cloud>
Sender: linux-kernel-owner@vger.kernel.org
To: josh@joshtriplett.org
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>, Nicholas Miell <nmiell@comcast.net>, Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Lai Jiangshan <laijs@cn.fujitsu.com>, Stephen Hemminger <stephen@networkplumber.org>, Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>, David Howells <dhowells@redhat.com>, Pranith Kumar <bobby.prani@gmail.com>, Michael Kerrisk <mtk.manpages@gmail.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

----- Original Message -----
> On Wed, May 06, 2015 at 03:21:06PM -0400, Mathieu Desnoyers wrote:
> > Here is an implementation of a new system call, sys_membarrier(), w=
hich
> > executes a memory barrier on all threads running on the system. It =
is
> > implemented by calling synchronize_sched(). It can be used to distr=
ibute
> > the cost of user-space memory barriers asymmetrically by transformi=
ng
> > pairs of memory barriers into pairs consisting of sys_membarrier() =
and a
> > compiler barrier. For synchronization primitives that distinguish
> > between read-side and write-side (e.g. userspace RCU [1], rwlocks),=
 the
> > read-side can be accelerated significantly by moving the bulk of th=
e
> > memory barrier overhead to the write-side.
> >=20
> > It is based on kernel v4.1-rc2.
> >=20
> > To explain the benefit of this scheme, let's introduce two example =
threads:
> >=20
> > Thread A (non-frequent, e.g. executing liburcu synchronize_rcu())
> > Thread B (frequent, e.g. executing liburcu
> > rcu_read_lock()/rcu_read_unlock())
> >=20
> > In a scheme where all smp_mb() in thread A are ordering memory acce=
sses
> > with respect to smp_mb() present in Thread B, we can change each
> > smp_mb() within Thread A into calls to sys_membarrier() and each
> > smp_mb() within Thread B into compiler barriers "barrier()".
> >=20
> > Before the change, we had, for each smp_mb() pairs:
> >=20
> > Thread A                    Thread B
> > previous mem accesses       previous mem accesses
> > smp_mb()                    smp_mb()
> > following mem accesses      following mem accesses
> >=20
> > After the change, these pairs become:
> >=20
> > Thread A                    Thread B
> > prev mem accesses           prev mem accesses
> > sys_membarrier()            barrier()
> > follow mem accesses         follow mem accesses
> >=20
> > As we can see, there are two possible scenarios: either Thread B me=
mory
> > accesses do not happen concurrently with Thread A accesses (1), or =
they
> > do (2).
> >=20
> > 1) Non-concurrent Thread A vs Thread B accesses:
> >=20
> > Thread A                    Thread B
> > prev mem accesses
> > sys_membarrier()
> > follow mem accesses
> >                             prev mem accesses
> >                             barrier()
> >                             follow mem accesses
> >=20
> > In this case, thread B accesses will be weakly ordered. This is OK,
> > because at that point, thread A is not particularly interested in
> > ordering them with respect to its own accesses.
> >=20
> > 2) Concurrent Thread A vs Thread B accesses
> >=20
> > Thread A                    Thread B
> > prev mem accesses           prev mem accesses
> > sys_membarrier()            barrier()
> > follow mem accesses         follow mem accesses
> >=20
> > In this case, thread B accesses, which are ensured to be in program
> > order thanks to the compiler barrier, will be "upgraded" to full
> > smp_mb() by synchronize_sched().
> >=20
> > * Benchmarks
> >=20
> > On Intel Xeon E5405 (8 cores)
> > (one thread is calling sys_membarrier, the other 7 threads are busy
> > looping)
> >=20
> > 1000 non-expedited sys_membarrier calls in 33s =3D 33 milliseconds/=
call.
> >=20
> > * User-space user of this system call: Userspace RCU library
> >=20
> > Both the signal-based and the sys_membarrier userspace RCU schemes
> > permit us to remove the memory barrier from the userspace RCU
> > rcu_read_lock() and rcu_read_unlock() primitives, thus significantl=
y
> > accelerating them. These memory barriers are replaced by compiler
> > barriers on the read-side, and all matching memory barriers on the
> > write-side are turned into an invocation of a memory barrier on all
> > active threads in the process. By letting the kernel perform this
> > synchronization rather than dumbly sending a signal to every proces=
s
> > threads (as we currently do), we diminish the number of unnecessary=
 wake
> > ups and only issue the memory barriers on active threads. Non-runni=
ng
> > threads do not need to execute such barrier anyway, because these a=
re
> > implied by the scheduler context switches.
> >=20
> > Results in liburcu:
> >=20
> > Operations in 10s, 6 readers, 2 writers:
> >=20
> > memory barriers in reader:    1701557485 reads, 2202847 writes
> > signal-based scheme:          9830061167 reads,    6700 writes
> > sys_membarrier:               9952759104 reads,     425 writes
> > sys_membarrier (dyn. check):  7970328887 reads,     425 writes
> >=20
> > The dynamic sys_membarrier availability check adds some overhead to
> > the read-side compared to the signal-based scheme, but besides that=
,
> > sys_membarrier slightly outperforms the signal-based scheme. Howeve=
r,
> > this non-expedited sys_membarrier implementation has a much slower =
grace
> > period than signal and memory barrier schemes.
> >=20
> > Besides diminishing the number of wake-ups, one major advantage of =
the
> > membarrier system call over the signal-based scheme is that it does=
 not
> > need to reserve a signal. This plays much more nicely with librarie=
s,
> > and with processes injected into for tracing purposes, for which we
> > cannot expect that signals will be unused by the application.
> >=20
> > An expedited version of this system call can be added later on to s=
peed
> > up the grace period. Its implementation will likely depend on readi=
ng
> > the cpu_curr()->mm without holding each CPU's rq lock.
> >=20
> > This patch adds the system call to x86 and to asm-generic.
> >=20
> > membarrier(2) man page:
> > --------------- snip -------------------
> > MEMBARRIER(2)              Linux Programmer's Manual
> > MEMBARRIER(2)
> >=20
> > NAME
> >        membarrier - issue memory barriers on a set of threads
> >=20
> > SYNOPSIS
> >        #include <linux/membarrier.h>
> >=20
> >        int membarrier(int cmd, int flags);
> >=20
> > DESCRIPTION
> >        The cmd argument is one of the following:
> >=20
> >        MEMBARRIER_CMD_QUERY
> >               Query  the  set  of  supported commands. It returns a=
 bitmask
> >               of
> >               supported commands.
> >=20
> >        MEMBARRIER_CMD_SHARED
> >               Execute a memory barrier on all threads running on  t=
he
> >               system.
> >               Upon  return from system call, the caller thread is e=
nsured
> >               that
> >               all running threads have passed through a state where=
 all
> >               memory
> >               accesses  to  user-space  addresses  match program or=
der
> >               between
> >               entry to and return from the system  call  (non-runni=
ng
> >               threads
> >               are de facto in such a state). This covers threads fr=
om all
> >               pro=E2=80=90
> >               cesses running on the system.  This command returns 0=
=2E
> >=20
> >        The flags argument needs to be 0. For future extensions.
> >=20
> >        All memory accesses performed  in  program  order  from  eac=
h
> >        targeted
> >        thread is guaranteed to be ordered with respect to sys_memba=
rrier().
> >        If
> >        we use the semantic "barrier()" to represent a compiler barr=
ier
> >        forcing
> >        memory  accesses  to  be performed in program order across t=
he
> >        barrier,
> >        and smp_mb() to represent explicit memory barriers forcing f=
ull
> >        memory
> >        ordering  across  the barrier, we have the following orderin=
g table
> >        for
> >        each pair of barrier(), sys_membarrier() and smp_mb():
> >=20
> >        The pair ordering is detailed as (O: ordered, X: not ordered=
):
> >=20
> >                               barrier()   smp_mb() sys_membarrier()
> >               barrier()          X           X            O
> >               smp_mb()           X           O            O
> >               sys_membarrier()   O           O            O
> >=20
> > RETURN VALUE
> >        On success, these system calls return zero.  On error, -1 is
> >        returned,
> >        and errno is set appropriately. For a given command, with fl=
ags
> >        argument set to 0, this system call is guaranteed to always =
return
> >        the
> >        same value until reboot.
> >=20
> > ERRORS
> >        ENOSYS System call is not implemented.
> >=20
> >        EINVAL Invalid arguments.
> >=20
> > Linux                             2015-04-15
> > MEMBARRIER(2)
> > --------------- snip -------------------
> >=20
> > [1] http://urcu.so
> >=20
> > Changes since v17:
> > - Update commit message.
> >=20
> > Changes since v16:
> > - Update documentation.
> > - Add man page to changelog.
> > - Build sys_membarrier on !CONFIG_SMP. It allows userspace applicat=
ions
> >   to not care about the number of processors on the system.  Based =
on
> >   recommendations from Stephen Hemminger and Steven Rostedt.
> > - Check that flags argument is 0, update documentation to require i=
t.
> >=20
> > Changes since v15:
> > - Add flags argument in addition to cmd.
> > - Update documentation.
> >=20
> > Changes since v14:
> > - Take care of Thomas Gleixner's comments.
> >=20
> > Changes since v13:
> > - Move to kernel/membarrier.c.
> > - Remove MEMBARRIER_PRIVATE flag.
> > - Add MAINTAINERS file entry.
> >=20
> > Changes since v12:
> > - Remove _FLAG suffix from uapi flags.
> > - Add Expert menuconfig option CONFIG_MEMBARRIER (default=3Dy).
> > - Remove EXPEDITED mode. Only implement non-expedited for now, unti=
l
> >   reading the cpu_curr()->mm can be done without holding the CPU's =
rq
> >   lock.
> >=20
> > Changes since v11:
> > - 5 years have passed.
> > - Rebase on v3.19 kernel.
> > - Add futex-alike PRIVATE vs SHARED semantic: private for per-proce=
ss
> >   barriers, non-private for memory mappings shared between processe=
s.
> > - Simplify user API.
> > - Code refactoring.
> >=20
> > Changes since v10:
> > - Apply Randy's comments.
> > - Rebase on 2.6.34-rc4 -tip.
> >=20
> > Changes since v9:
> > - Clean up #ifdef CONFIG_SMP.
> >=20
> > Changes since v8:
> > - Go back to rq spin locks taken by sys_membarrier() rather than ad=
ding
> >   memory barriers to the scheduler. It implies a potential RoS
> >   (reduction of service) if sys_membarrier() is executed in a busy-=
loop
> >   by a user, but nothing more than what is already possible with ot=
her
> >   existing system calls, but saves memory barriers in the scheduler=
 fast
> >   path.
> > - re-add the memory barrier comments to x86 switch_mm() as an examp=
le to
> >   other architectures.
> > - Update documentation of the memory barriers in sys_membarrier and
> >   switch_mm().
> > - Append execution scenarios to the changelog showing the purpose o=
f
> >   each memory barrier.
> >=20
> > Changes since v7:
> > - Move spinlock-mb and scheduler related changes to separate patche=
s.
> > - Add support for sys_membarrier on x86_32.
> > - Only x86 32/64 system calls are reserved in this patch. It is pla=
nned
> >   to incrementally reserve syscall IDs on other architectures as th=
ese
> >   are tested.
> >=20
> > Changes since v6:
> > - Remove some unlikely() not so unlikely.
> > - Add the proper scheduler memory barriers needed to only use the R=
CU
> >   read lock in sys_membarrier rather than take each runqueue spinlo=
ck:
> > - Move memory barriers from per-architecture switch_mm() to schedul=
e()
> >   and finish_lock_switch(), where they clearly document that all da=
ta
> >   protected by the rq lock is guaranteed to have memory barriers is=
sued
> >   between the scheduler update and the task execution. Replacing th=
e
> >   spin lock acquire/release barriers with these memory barriers imp=
ly
> >   either no overhead (x86 spinlock atomic instruction already impli=
es a
> >   full mb) or some hopefully small overhead caused by the upgrade o=
f the
> >   spinlock acquire/release barriers to more heavyweight smp_mb().
> > - The "generic" version of spinlock-mb.h declares both a mapping to
> >   standard spinlocks and full memory barriers. Each architecture ca=
n
> >   specialize this header following their own need and declare
> >   CONFIG_HAVE_SPINLOCK_MB to use their own spinlock-mb.h.
> > - Note: benchmarks of scheduler overhead with specialized spinlock-=
mb.h
> >   implementations on a wide range of architecture would be welcome.
> >=20
> > Changes since v5:
> > - Plan ahead for extensibility by introducing mandatory/optional ma=
sks
> >   to the "flags" system call parameter. Past experience with accept=
4(),
> >   signalfd4(), eventfd2(), epoll_create1(), dup3(), pipe2(), and
> >   inotify_init1() indicates that this is the kind of thing we want =
to
> >   plan for. Return -EINVAL if the mandatory flags received are unkn=
own.
> > - Create include/linux/membarrier.h to define these flags.
> > - Add MEMBARRIER_QUERY optional flag.
> >=20
> > Changes since v4:
> > - Add "int expedited" parameter, use synchronize_sched() in the
> >   non-expedited case. Thanks to Lai Jiangshan for making us conside=
r
> >   seriously using synchronize_sched() to provide the low-overhead
> >   membarrier scheme.
> > - Check num_online_cpus() =3D=3D 1, quickly return without doing no=
thing.
> >=20
> > Changes since v3a:
> > - Confirm that each CPU indeed runs the current task's ->mm before
> >   sending an IPI. Ensures that we do not disturb RT tasks in the
> >   presence of lazy TLB shootdown.
> > - Document memory barriers needed in switch_mm().
> > - Surround helper functions with #ifdef CONFIG_SMP.
> >=20
> > Changes since v2:
> > - simply send-to-many to the mm_cpumask. It contains the list of
> >   processors we have to IPI to (which use the mm), and this mask is
> >   updated atomically.
> >=20
> > Changes since v1:
> > - Only perform the IPI in CONFIG_SMP.
> > - Only perform the IPI if the process has more than one thread.
> > - Only send IPIs to CPUs involved with threads belonging to our pro=
cess.
> > - Adaptative IPI scheme (single vs many IPI with threshold).
> > - Issue smp_mb() at the beginning and end of the system call.
> >=20
> > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > CC: Josh Triplett <josh@joshtriplett.org>
>=20
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
>=20

Thanks!

> But also, the "snip" and "changes since" should not be in the commit =
message,
> while this list of signoffs and CCs should be.
>=20

Is there a typical way to handle this while keeping
it attached to a commit locally in my git branch ?

Thanks,

Mathieu


> - Josh Triplett
>=20
> > CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > CC: Steven Rostedt <rostedt@goodmis.org>
> > CC: Nicholas Miell <nmiell@comcast.net>
> > CC: Linus Torvalds <torvalds@linux-foundation.org>
> > CC: Ingo Molnar <mingo@redhat.com>
> > CC: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
> > CC: Lai Jiangshan <laijs@cn.fujitsu.com>
> > CC: Stephen Hemminger <stephen@networkplumber.org>
> > CC: Andrew Morton <akpm@linux-foundation.org>
> > CC: Thomas Gleixner <tglx@linutronix.de>
> > CC: Peter Zijlstra <peterz@infradead.org>
> > CC: David Howells <dhowells@redhat.com>
> > CC: Pranith Kumar <bobby.prani@gmail.com>
> > CC: Michael Kerrisk <mtk.manpages@gmail.com>
> > CC: linux-api@vger.kernel.org
> > ---
> >  MAINTAINERS                       |    8 ++++
> >  arch/x86/syscalls/syscall_32.tbl  |    1 +
> >  arch/x86/syscalls/syscall_64.tbl  |    1 +
> >  include/linux/syscalls.h          |    2 +
> >  include/uapi/asm-generic/unistd.h |    4 ++-
> >  include/uapi/linux/Kbuild         |    1 +
> >  include/uapi/linux/membarrier.h   |   53 +++++++++++++++++++++++++=
++++
> >  init/Kconfig                      |   12 +++++++
> >  kernel/Makefile                   |    1 +
> >  kernel/membarrier.c               |   66
> >  +++++++++++++++++++++++++++++++++++++
> >  kernel/sys_ni.c                   |    3 ++
> >  11 files changed, 151 insertions(+), 1 deletions(-)
> >  create mode 100644 include/uapi/linux/membarrier.h
> >  create mode 100644 kernel/membarrier.c
> >=20
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 781e099..fcb63d4 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -6370,6 +6370,14 @@ W:	http://www.mellanox.com
> >  Q:	http://patchwork.ozlabs.org/project/netdev/list/
> >  F:	drivers/net/ethernet/mellanox/mlx4/en_*
> > =20
> > +MEMBARRIER SUPPORT
> > +M:	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > +M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > +L:	linux-kernel@vger.kernel.org
> > +S:	Supported
> > +F:	kernel/membarrier.c
> > +F:	include/uapi/linux/membarrier.h
> > +
> >  MEMORY MANAGEMENT
> >  L:	linux-mm@kvack.org
> >  W:	http://www.linux-mm.org
> > diff --git a/arch/x86/syscalls/syscall_32.tbl
> > b/arch/x86/syscalls/syscall_32.tbl
> > index ef8187f..e63ad61 100644
> > --- a/arch/x86/syscalls/syscall_32.tbl
> > +++ b/arch/x86/syscalls/syscall_32.tbl
> > @@ -365,3 +365,4 @@
> >  356	i386	memfd_create		sys_memfd_create
> >  357	i386	bpf			sys_bpf
> >  358	i386	execveat		sys_execveat			stub32_execveat
> > +359	i386	membarrier		sys_membarrier
> > diff --git a/arch/x86/syscalls/syscall_64.tbl
> > b/arch/x86/syscalls/syscall_64.tbl
> > index 9ef32d5..87f3cd6 100644
> > --- a/arch/x86/syscalls/syscall_64.tbl
> > +++ b/arch/x86/syscalls/syscall_64.tbl
> > @@ -329,6 +329,7 @@
> >  320	common	kexec_file_load		sys_kexec_file_load
> >  321	common	bpf			sys_bpf
> >  322	64	execveat		stub_execveat
> > +323	common	membarrier		sys_membarrier
> > =20
> >  #
> >  # x32-specific system call numbers start at 512 to avoid cache imp=
act
> > diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> > index 76d1e38..51a9054 100644
> > --- a/include/linux/syscalls.h
> > +++ b/include/linux/syscalls.h
> > @@ -884,4 +884,6 @@ asmlinkage long sys_execveat(int dfd, const cha=
r __user
> > *filename,
> >  			const char __user *const __user *argv,
> >  			const char __user *const __user *envp, int flags);
> > =20
> > +asmlinkage long sys_membarrier(int cmd, int flags);
> > +
> >  #endif
> > diff --git a/include/uapi/asm-generic/unistd.h
> > b/include/uapi/asm-generic/unistd.h
> > index e016bd9..8da542a 100644
> > --- a/include/uapi/asm-generic/unistd.h
> > +++ b/include/uapi/asm-generic/unistd.h
> > @@ -709,9 +709,11 @@ __SYSCALL(__NR_memfd_create, sys_memfd_create)
> >  __SYSCALL(__NR_bpf, sys_bpf)
> >  #define __NR_execveat 281
> >  __SC_COMP(__NR_execveat, sys_execveat, compat_sys_execveat)
> > +#define __NR_membarrier 282
> > +__SYSCALL(__NR_membarrier, sys_membarrier)
> > =20
> >  #undef __NR_syscalls
> > -#define __NR_syscalls 282
> > +#define __NR_syscalls 283
> > =20
> >  /*
> >   * All syscalls below here should go away really,
> > diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
> > index 1a0006a..7bcc827 100644
> > --- a/include/uapi/linux/Kbuild
> > +++ b/include/uapi/linux/Kbuild
> > @@ -250,6 +250,7 @@ header-y +=3D mdio.h
> >  header-y +=3D media.h
> >  header-y +=3D media-bus-format.h
> >  header-y +=3D mei.h
> > +header-y +=3D membarrier.h
> >  header-y +=3D memfd.h
> >  header-y +=3D mempolicy.h
> >  header-y +=3D meye.h
> > diff --git a/include/uapi/linux/membarrier.h
> > b/include/uapi/linux/membarrier.h
> > new file mode 100644
> > index 0000000..e0b108b
> > --- /dev/null
> > +++ b/include/uapi/linux/membarrier.h
> > @@ -0,0 +1,53 @@
> > +#ifndef _UAPI_LINUX_MEMBARRIER_H
> > +#define _UAPI_LINUX_MEMBARRIER_H
> > +
> > +/*
> > + * linux/membarrier.h
> > + *
> > + * membarrier system call API
> > + *
> > + * Copyright (c) 2010, 2015 Mathieu Desnoyers
> > <mathieu.desnoyers@efficios.com>
> > + *
> > + * Permission is hereby granted, free of charge, to any person obt=
aining a
> > copy
> > + * of this software and associated documentation files (the "Softw=
are"),
> > to deal
> > + * in the Software without restriction, including without limitati=
on the
> > rights
> > + * to use, copy, modify, merge, publish, distribute, sublicense, a=
nd/or
> > sell
> > + * copies of the Software, and to permit persons to whom the Softw=
are is
> > + * furnished to do so, subject to the following conditions:
> > + *
> > + * The above copyright notice and this permission notice shall be =
included
> > in
> > + * all copies or substantial portions of the Software.
> > + *
> > + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,=
 EXPRESS
> > OR
> > + * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> > MERCHANTABILITY,
> > + * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVE=
NT SHALL
> > THE
> > + * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES O=
R OTHER
> > + * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,=
 ARISING
> > FROM,
> > + * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER D=
EALINGS
> > IN THE
> > + * SOFTWARE.
> > + */
> > +
> > +/**
> > + * enum membarrier_cmd - membarrier system call command
> > + * @MEMBARRIER_CMD_QUERY:   Query the set of supported commands. I=
t
> > returns
> > + *                          a bitmask of valid commands.
> > + * @MEMBARRIER_CMD_SHARED:  Execute a memory barrier on all runnin=
g
> > threads.
> > + *                          Upon return from system call, the call=
er
> > thread
> > + *                          is ensured that all running threads ha=
ve
> > passed
> > + *                          through a state where all memory acces=
ses to
> > + *                          user-space addresses match program ord=
er
> > between
> > + *                          entry to and return from the system ca=
ll
> > + *                          (non-running threads are de facto in s=
uch a
> > + *                          state). This covers threads from all p=
rocesses
> > + *                          running on the system. This command re=
turns 0.
> > + *
> > + * Command to be passed to the membarrier system call. The command=
s need
> > to
> > + * be a single bit each, except for MEMBARRIER_CMD_QUERY which is =
assigned
> > to
> > + * the value 0.
> > + */
> > +enum membarrier_cmd {
> > +	MEMBARRIER_CMD_QUERY =3D 0,
> > +	MEMBARRIER_CMD_SHARED =3D (1 << 0),
> > +};
> > +
> > +#endif /* _UAPI_LINUX_MEMBARRIER_H */
> > diff --git a/init/Kconfig b/init/Kconfig
> > index dc24dec..307e406 100644
> > --- a/init/Kconfig
> > +++ b/init/Kconfig
> > @@ -1583,6 +1583,18 @@ config PCI_QUIRKS
> >  	  bugs/quirks. Disable this only if your target machine is
> >  	  unaffected by PCI quirks.
> > =20
> > +config MEMBARRIER
> > +	bool "Enable membarrier() system call" if EXPERT
> > +	default y
> > +	help
> > +	  Enable the membarrier() system call that allows issuing memory
> > +	  barriers across all running threads, which can be used to distr=
ibute
> > +	  the cost of user-space memory barriers asymmetrically by transf=
orming
> > +	  pairs of memory barriers into pairs consisting of membarrier() =
and a
> > +	  compiler barrier.
> > +
> > +	  If unsure, say Y.
> > +
> >  config EMBEDDED
> >  	bool "Embedded system"
> >  	option allnoconfig_y
> > diff --git a/kernel/Makefile b/kernel/Makefile
> > index 60c302c..05191fd 100644
> > --- a/kernel/Makefile
> > +++ b/kernel/Makefile
> > @@ -98,6 +98,7 @@ obj-$(CONFIG_CRASH_DUMP) +=3D crash_dump.o
> >  obj-$(CONFIG_JUMP_LABEL) +=3D jump_label.o
> >  obj-$(CONFIG_CONTEXT_TRACKING) +=3D context_tracking.o
> >  obj-$(CONFIG_TORTURE_TEST) +=3D torture.o
> > +obj-$(CONFIG_MEMBARRIER) +=3D membarrier.o
> > =20
> >  $(obj)/configs.o: $(obj)/config_data.h
> > =20
> > diff --git a/kernel/membarrier.c b/kernel/membarrier.c
> > new file mode 100644
> > index 0000000..a20b279
> > --- /dev/null
> > +++ b/kernel/membarrier.c
> > @@ -0,0 +1,66 @@
> > +/*
> > + * Copyright (C) 2010, 2015 Mathieu Desnoyers
> > <mathieu.desnoyers@efficios.com>
> > + *
> > + * membarrier system call
> > + *
> > + * This program is free software; you can redistribute it and/or m=
odify
> > + * it under the terms of the GNU General Public License as publish=
ed by
> > + * the Free Software Foundation; either version 2 of the License, =
or
> > + * (at your option) any later version.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#include <linux/syscalls.h>
> > +#include <linux/membarrier.h>
> > +
> > +/*
> > + * Bitmask made from a "or" of all commands within enum membarrier=
_cmd,
> > + * except MEMBARRIER_CMD_QUERY.
> > + */
> > +#define MEMBARRIER_CMD_BITMASK	(MEMBARRIER_CMD_SHARED)
> > +
> > +/**
> > + * sys_membarrier - issue memory barriers on a set of threads
> > + * @cmd:   Takes command values defined in enum membarrier_cmd.
> > + * @flags: Currently needs to be 0. For future extensions.
> > + *
> > + * If this system call is not implemented, -ENOSYS is returned. If=
 the
> > + * command specified does not exist, or if the command argument is
> > invalid,
> > + * this system call returns -EINVAL. For a given command, with fla=
gs
> > argument
> > + * set to 0, this system call is guaranteed to always return the s=
ame
> > value
> > + * until reboot.
> > + *
> > + * All memory accesses performed in program order from each target=
ed
> > thread
> > + * is guaranteed to be ordered with respect to sys_membarrier(). I=
f we use
> > + * the semantic "barrier()" to represent a compiler barrier forcin=
g memory
> > + * accesses to be performed in program order across the barrier, a=
nd
> > + * smp_mb() to represent explicit memory barriers forcing full mem=
ory
> > + * ordering across the barrier, we have the following ordering tab=
le for
> > + * each pair of barrier(), sys_membarrier() and smp_mb():
> > + *
> > + * The pair ordering is detailed as (O: ordered, X: not ordered):
> > + *
> > + *                        barrier()   smp_mb() sys_membarrier()
> > + *        barrier()          X           X            O
> > + *        smp_mb()           X           O            O
> > + *        sys_membarrier()   O           O            O
> > + */
> > +SYSCALL_DEFINE2(membarrier, int, cmd, int, flags)
> > +{
> > +	if (flags)
> > +		return -EINVAL;
> > +	switch (cmd) {
> > +	case MEMBARRIER_CMD_QUERY:
> > +		return MEMBARRIER_CMD_BITMASK;
> > +	case MEMBARRIER_CMD_SHARED:
> > +		if (num_online_cpus() > 1)
> > +			synchronize_sched();
> > +		return 0;
> > +	default:
> > +		return -EINVAL;
> > +	}
> > +}
> > diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
> > index 7995ef5..eb4fde0 100644
> > --- a/kernel/sys_ni.c
> > +++ b/kernel/sys_ni.c
> > @@ -243,3 +243,6 @@ cond_syscall(sys_bpf);
> > =20
> >  /* execveat */
> >  cond_syscall(sys_execveat);
> > +
> > +/* membarrier */
> > +cond_syscall(sys_membarrier);
> > --
> > 1.7.7.3
> >=20
>=20

--=20
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

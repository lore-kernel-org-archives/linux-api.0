From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 1/3 v19] sys_membarrier(): system-wide memory barrier
 (generic, x86)
Date: Sun, 13 Dec 2015 11:44:32 +0000 (UTC)
Message-ID: <348605783.237606.1450007072370.JavaMail.zimbra@efficios.com>
References: <1436561912-24365-1-git-send-email-mathieu.desnoyers@efficios.com> <1436561912-24365-2-git-send-email-mathieu.desnoyers@efficios.com> <5661B4E8.2070801@gmail.com> <1635187109.213051.1449305303824.JavaMail.zimbra@efficios.com> <566B107D.802@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <566B107D.802-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Nicholas Miell <nmiell-Wuw85uim5zDR7s880joybQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Lai Jiangshan <laijs-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Stephen Hemminger <stephen-OTpzqLSitTUnbdJkjeBofR2eb7JE58TQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pranith Kumar <bobby.prani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

----- On Dec 11, 2015, at 1:05 PM, Michael Kerrisk mtk.manpages@gmail.c=
om wrote:

> Hi Matthew,
>=20
> On 12/05/2015 09:48 AM, Mathieu Desnoyers wrote:
>> Hi Michael,
>>=20
>> Please find the membarrier man groff file attached. I re-integrated
>> some changes that went in initially only in the changelog text versi=
on
>> back onto this groff source.
>>=20
>> Please let me know if you find any issue with it.
>=20
> Thanks for the page, but there's a few issues. Could you please
> submit a new version as an inline patch, and see what can be
> done w.r.t. the following points (see man-pages(7) for some
> background on some of these points):
>=20
> * Start DESCRIPTION off with a paragraph explaining what this system
>  call is about and why one would use it.
>=20
> * Page needs VERSIONS, CONFORMING TO, and SEE ALSO sections.
>=20
> * Is its possible to add a small EXAMPLE?
>=20
> * In a NOTES section, it might be helpful to briefly explain the foll=
owing
>  concepts:  memory barrier and program order.

Sure, I'll prepare a new version including these,
as a patch over the man pages project. Some questions
below,

>=20
> Some comments on individual pieces below:
>=20
>> .TH MEMBARRIER 2 2015-04-15 "Linux" "Linux Programmer's Manual"
>> .SH NAME
>> membarrier \- issue memory barriers on a set of threads
>> .SH SYNOPSIS
>> .B #include <linux/membarrier.h>
>> .sp
>> .BI "int membarrier(int " cmd ", int " flags ");
>> .sp
>> .SH DESCRIPTION
>> The
>> .I cmd
>> argument is one of the following:
>>=20
>> .TP
>> .B MEMBARRIER_CMD_QUERY
>> Query the set of supported commands. It returns a bitmask of support=
ed
>> commands.
>=20
> Not clear here. Does this mean that the 'cmd' argument is a bit mask,
> rather than an enumeration? I think that needs to be spelled out.
> Also, the text should mention that the returned bitmask excludes
> MEMBARRIER_CMD_QUERY. (Why, actually?)

The 'cmd' arg really expects a one-hot bit of a bitmask. However,
MEMBARRIER_CMD_QUERY is a special case: 0, so it is never part
of the mask of supported commands. I'll describe this in the manpage.

>=20
>> .TP
>> .B MEMBARRIER_CMD_SHARED
>> Execute a memory barrier on all threads running on the system.
>=20
> All threads on the system?
>=20
>> Upon
>> return from system call, the caller thread is ensured that all runni=
ng
>> threads have passed through a state where all memory accesses to
>> user-space addresses match program order between entry to and return
>> from the system call (non-running threads are de facto in such a
>> state). This covers threads from all processes running on the system=
=2E

I can reword this entire paragraph like this:

Ensure that all threads from all processes on the system pass through a
state where all memory accesses to user-space addresses match program
order between entry to and return from the membarrier system call.
All threads on the system are targeted by this command.
This command returns 0.



>> This command returns 0.
>>=20
>> .PP
>> The
>> .I flags
>> argument is currently unused.
>>=20
>> .PP
>> All memory accesses performed in program order from each targeted th=
read
>=20
> What is a "targeted thread"? Some rewording is needed here.

I added a sentence to the command description above which clarifies
the notion of "targeted threads".

>=20
>> is guaranteed to be ordered with respect to sys_membarrier(). If we =
use
>> the semantic "barrier()" to represent a compiler barrier forcing mem=
ory
>> accesses to be performed in program order across the barrier, and
>> smp_mb() to represent explicit memory barriers forcing full memory
>> ordering across the barrier, we have the following ordering table fo=
r
>> each pair of barrier(), sys_membarrier() and smp_mb():
>>=20
>> The pair ordering is detailed as (O: ordered, X: not ordered):
>>=20
>>                        barrier()   smp_mb() sys_membarrier()
>>        barrier()          X           X            O
>>        smp_mb()           X           O            O
>>        sys_membarrier()   O           O            O
>>=20
>> .SH RETURN VALUE
>> On success, these system calls return zero.
>=20
> This sentence seems out of place. We have one system call.
> And the different operations described above return
> nonzero values on success.

Updated with:

On success, this system call returns zero.  On error, \-1 is returned,
and
=2EI errno
is set appropriately.


>=20
>> On error, \-1 is returned,
>> and
>> .I errno
>> is set appropriately.
>> For a given command, with flags argument set to 0, this system call =
is
>> guaranteed to always return the same value until reboot.
>=20
> I don't understand the intent of the last sentence. What idea are you
> trying to convey?

What I'm trying to say is that an executable that invokes
the membarrier system call with a query command, or executes
some other command, only needs to check the return value and
errno for errors the first time it invokes the system call, and can
assume that the kernel will always return that same value
and errno for following calls. I'm limiting this guarantee to flags
arg =3D=3D 0, since we may want to break this guarantee in the
future when specific flags are set.

This make it easy for applications and library to check what
is available within a constructor, and then not have to do
error handling in the rest of the application.

Not sure how to best express this though.

>=20
>> .SH ERRORS
>> .TP
>> .B ENOSYS
>> System call is not implemented.
>> .TP
>> .B EINVAL
>> Invalid arguments.
>=20
> Would be clearer to say here: "cmd is invalid or flags is nonezero"

Will do.

Thanks!

Mathieu

>=20
> Thanks,
>=20
> Michael
>=20
>=20
>> ----- On Dec 4, 2015, at 4:44 PM, Michael Kerrisk mtk.manpages@gmail=
=2Ecom wrote:
>>=20
>>> Hi Mathieu,
>>>
>>> In the patch below you have a man page type of text. Is that
>>> just plain text, or do you have some groff source somewhere?
>>>
>>> Thanks,
>>>
>>> Michael
>>>
>>>
>>> On 07/10/2015 10:58 PM, Mathieu Desnoyers wrote:
>>>> Here is an implementation of a new system call, sys_membarrier(), =
which
>>>> executes a memory barrier on all threads running on the system. It=
 is
>>>> implemented by calling synchronize_sched(). It can be used to dist=
ribute
>>>> the cost of user-space memory barriers asymmetrically by transform=
ing
>>>> pairs of memory barriers into pairs consisting of sys_membarrier()=
 and a
>>>> compiler barrier. For synchronization primitives that distinguish
>>>> between read-side and write-side (e.g. userspace RCU [1], rwlocks)=
, the
>>>> read-side can be accelerated significantly by moving the bulk of t=
he
>>>> memory barrier overhead to the write-side.
>>>>
>>>> The existing applications of which I am aware that would be improv=
ed by this
>>>> system call are as follows:
>>>>
>>>> * Through Userspace RCU library (http://urcu.so)
>>>>   - DNS server (Knot DNS) https://www.knot-dns.cz/
>>>>   - Network sniffer (http://netsniff-ng.org/)
>>>>   - Distributed object storage (https://sheepdog.github.io/sheepdo=
g/)
>>>>   - User-space tracing (http://lttng.org)
>>>>   - Network storage system (https://www.gluster.org/)
>>>>   - Virtual routers
>>>>   (https://events.linuxfoundation.org/sites/events/files/slides/DP=
DK_RCU_0MQ.pdf)
>>>>   - Financial software (https://lkml.org/lkml/2015/3/23/189)
>>>>
>>>> Those projects use RCU in userspace to increase read-side speed an=
d
>>>> scalability compared to locking. Especially in the case of RCU use=
d
>>>> by libraries, sys_membarrier can speed up the read-side by moving =
the
>>>> bulk of the memory barrier cost to synchronize_rcu().
>>>>
>>>> * Direct users of sys_membarrier
>>>>   - core dotnet garbage collector (https://github.com/dotnet/corec=
lr/issues/198)
>>>>
>>>> Microsoft core dotnet GC developers are planning to use the mprote=
ct()
>>>> side-effect of issuing memory barriers through IPIs as a way to im=
plement
>>>> Windows FlushProcessWriteBuffers() on Linux. They are referring to
>>>> sys_membarrier in their github thread, specifically stating that
>>>> sys_membarrier() is what they are looking for.
>>>>
>>>> This implementation is based on kernel v4.1-rc8.
>>>>
>>>> To explain the benefit of this scheme, let's introduce two example=
 threads:
>>>>
>>>> Thread A (non-frequent, e.g. executing liburcu synchronize_rcu())
>>>> Thread B (frequent, e.g. executing liburcu
>>>> rcu_read_lock()/rcu_read_unlock())
>>>>
>>>> In a scheme where all smp_mb() in thread A are ordering memory acc=
esses
>>>> with respect to smp_mb() present in Thread B, we can change each
>>>> smp_mb() within Thread A into calls to sys_membarrier() and each
>>>> smp_mb() within Thread B into compiler barriers "barrier()".
>>>>
>>>> Before the change, we had, for each smp_mb() pairs:
>>>>
>>>> Thread A                    Thread B
>>>> previous mem accesses       previous mem accesses
>>>> smp_mb()                    smp_mb()
>>>> following mem accesses      following mem accesses
>>>>
>>>> After the change, these pairs become:
>>>>
>>>> Thread A                    Thread B
>>>> prev mem accesses           prev mem accesses
>>>> sys_membarrier()            barrier()
>>>> follow mem accesses         follow mem accesses
>>>>
>>>> As we can see, there are two possible scenarios: either Thread B m=
emory
>>>> accesses do not happen concurrently with Thread A accesses (1), or=
 they
>>>> do (2).
>>>>
>>>> 1) Non-concurrent Thread A vs Thread B accesses:
>>>>
>>>> Thread A                    Thread B
>>>> prev mem accesses
>>>> sys_membarrier()
>>>> follow mem accesses
>>>>                             prev mem accesses
>>>>                             barrier()
>>>>                             follow mem accesses
>>>>
>>>> In this case, thread B accesses will be weakly ordered. This is OK=
,
>>>> because at that point, thread A is not particularly interested in
>>>> ordering them with respect to its own accesses.
>>>>
>>>> 2) Concurrent Thread A vs Thread B accesses
>>>>
>>>> Thread A                    Thread B
>>>> prev mem accesses           prev mem accesses
>>>> sys_membarrier()            barrier()
>>>> follow mem accesses         follow mem accesses
>>>>
>>>> In this case, thread B accesses, which are ensured to be in progra=
m
>>>> order thanks to the compiler barrier, will be "upgraded" to full
>>>> smp_mb() by synchronize_sched().
>>>>
>>>> * Benchmarks
>>>>
>>>> On Intel Xeon E5405 (8 cores)
>>>> (one thread is calling sys_membarrier, the other 7 threads are bus=
y
>>>> looping)
>>>>
>>>> 1000 non-expedited sys_membarrier calls in 33s =3D 33 milliseconds=
/call.
>>>>
>>>> * User-space user of this system call: Userspace RCU library
>>>>
>>>> Both the signal-based and the sys_membarrier userspace RCU schemes
>>>> permit us to remove the memory barrier from the userspace RCU
>>>> rcu_read_lock() and rcu_read_unlock() primitives, thus significant=
ly
>>>> accelerating them. These memory barriers are replaced by compiler
>>>> barriers on the read-side, and all matching memory barriers on the
>>>> write-side are turned into an invocation of a memory barrier on al=
l
>>>> active threads in the process. By letting the kernel perform this
>>>> synchronization rather than dumbly sending a signal to every proce=
ss
>>>> threads (as we currently do), we diminish the number of unnecessar=
y wake
>>>> ups and only issue the memory barriers on active threads. Non-runn=
ing
>>>> threads do not need to execute such barrier anyway, because these =
are
>>>> implied by the scheduler context switches.
>>>>
>>>> Results in liburcu:
>>>>
>>>> Operations in 10s, 6 readers, 2 writers:
>>>>
>>>> memory barriers in reader:    1701557485 reads, 2202847 writes
>>>> signal-based scheme:          9830061167 reads,    6700 writes
>>>> sys_membarrier:               9952759104 reads,     425 writes
>>>> sys_membarrier (dyn. check):  7970328887 reads,     425 writes
>>>>
>>>> The dynamic sys_membarrier availability check adds some overhead t=
o
>>>> the read-side compared to the signal-based scheme, but besides tha=
t,
>>>> sys_membarrier slightly outperforms the signal-based scheme. Howev=
er,
>>>> this non-expedited sys_membarrier implementation has a much slower=
 grace
>>>> period than signal and memory barrier schemes.
>>>>
>>>> Besides diminishing the number of wake-ups, one major advantage of=
 the
>>>> membarrier system call over the signal-based scheme is that it doe=
s not
>>>> need to reserve a signal. This plays much more nicely with librari=
es,
>>>> and with processes injected into for tracing purposes, for which w=
e
>>>> cannot expect that signals will be unused by the application.
>>>>
>>>> An expedited version of this system call can be added later on to =
speed
>>>> up the grace period. Its implementation will likely depend on read=
ing
>>>> the cpu_curr()->mm without holding each CPU's rq lock.
>>>>
>>>> This patch adds the system call to x86 and to asm-generic.
>>>>
>>>> [1] http://urcu.so
>>>>
>>>> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
>>>> Reviewed-by: Paul E. McKenney <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>>>> Reviewed-by: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
>>>> CC: KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
>>>> CC: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
>>>> CC: Nicholas Miell <nmiell-Wuw85uim5zDR7s880joybQ@public.gmane.org>
>>>> CC: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
>>>> CC: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>>> CC: Alan Cox <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
>>>> CC: Lai Jiangshan <laijs-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
>>>> CC: Stephen Hemminger <stephen-OTpzqLSitTUnbdJkjeBofR2eb7JE58TQ@public.gmane.org>
>>>> CC: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
>>>> CC: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
>>>> CC: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
>>>> CC: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>>> CC: Pranith Kumar <bobby.prani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>>> CC: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>>> CC: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>>
>>>> ---
>>>>
>>>> membarrier(2) man page:
>>>> --------------- snip -------------------
>>>> MEMBARRIER(2)              Linux Programmer's Manual             M=
EMBARRIER(2)
>>>>
>>>> NAME
>>>>        membarrier - issue memory barriers on a set of threads
>>>>
>>>> SYNOPSIS
>>>>        #include <linux/membarrier.h>
>>>>
>>>>        int membarrier(int cmd, int flags);
>>>>
>>>> DESCRIPTION
>>>>        The cmd argument is one of the following:
>>>>
>>>>        MEMBARRIER_CMD_QUERY
>>>>               Query  the  set  of  supported commands. It returns =
a bitmask of
>>>>               supported commands.
>>>>
>>>>        MEMBARRIER_CMD_SHARED
>>>>               Execute a memory barrier on all threads running on  =
the  system.
>>>>               Upon  return from system call, the caller thread is =
ensured that
>>>>               all running threads have passed through a state wher=
e all memory
>>>>               accesses  to  user-space  addresses  match program o=
rder between
>>>>               entry to and return from the system  call  (non-runn=
ing  threads
>>>>               are de facto in such a state). This covers threads f=
rom all pro=E2=80=90
>>>>               cesses running on the system.  This command returns =
0.
>>>>
>>>>        The flags argument needs to be 0. For future extensions.
>>>>
>>>>        All memory accesses performed  in  program  order  from  ea=
ch  targeted
>>>>        thread is guaranteed to be ordered with respect to sys_memb=
arrier(). If
>>>>        we use the semantic "barrier()" to represent a compiler bar=
rier forcing
>>>>        memory  accesses  to  be performed in program order across =
the barrier,
>>>>        and smp_mb() to represent explicit memory barriers forcing =
full  memory
>>>>        ordering  across  the barrier, we have the following orderi=
ng table for
>>>>        each pair of barrier(), sys_membarrier() and smp_mb():
>>>>
>>>>        The pair ordering is detailed as (O: ordered, X: not ordere=
d):
>>>>
>>>>                               barrier()   smp_mb() sys_membarrier(=
)
>>>>               barrier()          X           X            O
>>>>               smp_mb()           X           O            O
>>>>               sys_membarrier()   O           O            O
>>>>
>>>> RETURN VALUE
>>>>        On success, these system calls return zero.  On error, -1 i=
s  returned,
>>>>        and errno is set appropriately. For a given command, with f=
lags
>>>>        argument set to 0, this system call is guaranteed to always=
 return the
>>>>        same value until reboot.
>>>>
>>>> ERRORS
>>>>        ENOSYS System call is not implemented.
>>>>
>>>>        EINVAL Invalid arguments.
>>>>
>>>> Linux                             2015-04-15                     M=
EMBARRIER(2)
>>>> --------------- snip -------------------
>>>>
>>>> Changes since v18:
>>>> - Add unlikely() check to flags,
>>>> - Describe current users in changelog.
>>>>
>>>> Changes since v17:
>>>> - Update commit message.
>>>>
>>>> Changes since v16:
>>>> - Update documentation.
>>>> - Add man page to changelog.
>>>> - Build sys_membarrier on !CONFIG_SMP. It allows userspace applica=
tions
>>>>   to not care about the number of processors on the system.  Based=
 on
>>>>   recommendations from Stephen Hemminger and Steven Rostedt.
>>>> - Check that flags argument is 0, update documentation to require =
it.
>>>>
>>>> Changes since v15:
>>>> - Add flags argument in addition to cmd.
>>>> - Update documentation.
>>>>
>>>> Changes since v14:
>>>> - Take care of Thomas Gleixner's comments.
>>>>
>>>> Changes since v13:
>>>> - Move to kernel/membarrier.c.
>>>> - Remove MEMBARRIER_PRIVATE flag.
>>>> - Add MAINTAINERS file entry.
>>>>
>>>> Changes since v12:
>>>> - Remove _FLAG suffix from uapi flags.
>>>> - Add Expert menuconfig option CONFIG_MEMBARRIER (default=3Dy).
>>>> - Remove EXPEDITED mode. Only implement non-expedited for now, unt=
il
>>>>   reading the cpu_curr()->mm can be done without holding the CPU's=
 rq
>>>>   lock.
>>>>
>>>> Changes since v11:
>>>> - 5 years have passed.
>>>> - Rebase on v3.19 kernel.
>>>> - Add futex-alike PRIVATE vs SHARED semantic: private for per-proc=
ess
>>>>   barriers, non-private for memory mappings shared between process=
es.
>>>> - Simplify user API.
>>>> - Code refactoring.
>>>>
>>>> Changes since v10:
>>>> - Apply Randy's comments.
>>>> - Rebase on 2.6.34-rc4 -tip.
>>>>
>>>> Changes since v9:
>>>> - Clean up #ifdef CONFIG_SMP.
>>>>
>>>> Changes since v8:
>>>> - Go back to rq spin locks taken by sys_membarrier() rather than a=
dding
>>>>   memory barriers to the scheduler. It implies a potential RoS
>>>>   (reduction of service) if sys_membarrier() is executed in a busy=
-loop
>>>>   by a user, but nothing more than what is already possible with o=
ther
>>>>   existing system calls, but saves memory barriers in the schedule=
r fast
>>>>   path.
>>>> - re-add the memory barrier comments to x86 switch_mm() as an exam=
ple to
>>>>   other architectures.
>>>> - Update documentation of the memory barriers in sys_membarrier an=
d
>>>>   switch_mm().
>>>> - Append execution scenarios to the changelog showing the purpose =
of
>>>>   each memory barrier.
>>>>
>>>> Changes since v7:
>>>> - Move spinlock-mb and scheduler related changes to separate patch=
es.
>>>> - Add support for sys_membarrier on x86_32.
>>>> - Only x86 32/64 system calls are reserved in this patch. It is pl=
anned
>>>>   to incrementally reserve syscall IDs on other architectures as t=
hese
>>>>   are tested.
>>>>
>>>> Changes since v6:
>>>> - Remove some unlikely() not so unlikely.
>>>> - Add the proper scheduler memory barriers needed to only use the =
RCU
>>>>   read lock in sys_membarrier rather than take each runqueue spinl=
ock:
>>>> - Move memory barriers from per-architecture switch_mm() to schedu=
le()
>>>>   and finish_lock_switch(), where they clearly document that all d=
ata
>>>>   protected by the rq lock is guaranteed to have memory barriers i=
ssued
>>>>   between the scheduler update and the task execution. Replacing t=
he
>>>>   spin lock acquire/release barriers with these memory barriers im=
ply
>>>>   either no overhead (x86 spinlock atomic instruction already impl=
ies a
>>>>   full mb) or some hopefully small overhead caused by the upgrade =
of the
>>>>   spinlock acquire/release barriers to more heavyweight smp_mb().
>>>> - The "generic" version of spinlock-mb.h declares both a mapping t=
o
>>>>   standard spinlocks and full memory barriers. Each architecture c=
an
>>>>   specialize this header following their own need and declare
>>>>   CONFIG_HAVE_SPINLOCK_MB to use their own spinlock-mb.h.
>>>> - Note: benchmarks of scheduler overhead with specialized spinlock=
-mb.h
>>>>   implementations on a wide range of architecture would be welcome=
=2E
>>>>
>>>> Changes since v5:
>>>> - Plan ahead for extensibility by introducing mandatory/optional m=
asks
>>>>   to the "flags" system call parameter. Past experience with accep=
t4(),
>>>>   signalfd4(), eventfd2(), epoll_create1(), dup3(), pipe2(), and
>>>>   inotify_init1() indicates that this is the kind of thing we want=
 to
>>>>   plan for. Return -EINVAL if the mandatory flags received are unk=
nown.
>>>> - Create include/linux/membarrier.h to define these flags.
>>>> - Add MEMBARRIER_QUERY optional flag.
>>>>
>>>> Changes since v4:
>>>> - Add "int expedited" parameter, use synchronize_sched() in the
>>>>   non-expedited case. Thanks to Lai Jiangshan for making us consid=
er
>>>>   seriously using synchronize_sched() to provide the low-overhead
>>>>   membarrier scheme.
>>>> - Check num_online_cpus() =3D=3D 1, quickly return without doing n=
othing.
>>>>
>>>> Changes since v3a:
>>>> - Confirm that each CPU indeed runs the current task's ->mm before
>>>>   sending an IPI. Ensures that we do not disturb RT tasks in the
>>>>   presence of lazy TLB shootdown.
>>>> - Document memory barriers needed in switch_mm().
>>>> - Surround helper functions with #ifdef CONFIG_SMP.
>>>>
>>>> Changes since v2:
>>>> - simply send-to-many to the mm_cpumask. It contains the list of
>>>>   processors we have to IPI to (which use the mm), and this mask i=
s
>>>>   updated atomically.
>>>>
>>>> Changes since v1:
>>>> - Only perform the IPI in CONFIG_SMP.
>>>> - Only perform the IPI if the process has more than one thread.
>>>> - Only send IPIs to CPUs involved with threads belonging to our pr=
ocess.
>>>> - Adaptative IPI scheme (single vs many IPI with threshold).
>>>> - Issue smp_mb() at the beginning and end of the system call.
>>>> ---
>>>>  MAINTAINERS                            |  8 +++++
>>>>  arch/x86/entry/syscalls/syscall_32.tbl |  1 +
>>>>  arch/x86/entry/syscalls/syscall_64.tbl |  1 +
>>>>  include/linux/syscalls.h               |  2 ++
>>>>  include/uapi/asm-generic/unistd.h      |  4 ++-
>>>>  include/uapi/linux/Kbuild              |  1 +
>>>>  include/uapi/linux/membarrier.h        | 53 +++++++++++++++++++++=
++++++
>>>>  init/Kconfig                           | 12 +++++++
>>>>  kernel/Makefile                        |  1 +
>>>>  kernel/membarrier.c                    | 66 +++++++++++++++++++++=
+++++++++++++
>>>>  kernel/sys_ni.c                        |  3 ++
>>>>  11 files changed, 151 insertions(+), 1 deletion(-)
>>>>  create mode 100644 include/uapi/linux/membarrier.h
>>>>  create mode 100644 kernel/membarrier.c
>>>>
>>>> diff --git a/MAINTAINERS b/MAINTAINERS
>>>> index 0d70760..b560da6 100644
>>>> --- a/MAINTAINERS
>>>> +++ b/MAINTAINERS
>>>> @@ -6642,6 +6642,14 @@ W:	http://www.mellanox.com
>>>>  Q:	http://patchwork.ozlabs.org/project/netdev/list/
>>>>  F:	drivers/net/ethernet/mellanox/mlx4/en_*
>>>> =20
>>>> +MEMBARRIER SUPPORT
>>>> +M:	Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
>>>> +M:	"Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>>>> +L:	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>> +S:	Supported
>>>> +F:	kernel/membarrier.c
>>>> +F:	include/uapi/linux/membarrier.h
>>>> +
>>>>  MEMORY MANAGEMENT
>>>>  L:	linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
>>>>  W:	http://www.linux-mm.org
>>>> diff --git a/arch/x86/entry/syscalls/syscall_32.tbl
>>>> b/arch/x86/entry/syscalls/syscall_32.tbl
>>>> index ef8187f..e63ad61 100644
>>>> --- a/arch/x86/entry/syscalls/syscall_32.tbl
>>>> +++ b/arch/x86/entry/syscalls/syscall_32.tbl
>>>> @@ -365,3 +365,4 @@
>>>>  356	i386	memfd_create		sys_memfd_create
>>>>  357	i386	bpf			sys_bpf
>>>>  358	i386	execveat		sys_execveat			stub32_execveat
>>>> +359	i386	membarrier		sys_membarrier
>>>> diff --git a/arch/x86/entry/syscalls/syscall_64.tbl
>>>> b/arch/x86/entry/syscalls/syscall_64.tbl
>>>> index 9ef32d5..87f3cd6 100644
>>>> --- a/arch/x86/entry/syscalls/syscall_64.tbl
>>>> +++ b/arch/x86/entry/syscalls/syscall_64.tbl
>>>> @@ -329,6 +329,7 @@
>>>>  320	common	kexec_file_load		sys_kexec_file_load
>>>>  321	common	bpf			sys_bpf
>>>>  322	64	execveat		stub_execveat
>>>> +323	common	membarrier		sys_membarrier
>>>> =20
>>>>  #
>>>>  # x32-specific system call numbers start at 512 to avoid cache im=
pact
>>>> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
>>>> index b45c45b..d4ab99b 100644
>>>> --- a/include/linux/syscalls.h
>>>> +++ b/include/linux/syscalls.h
>>>> @@ -884,4 +884,6 @@ asmlinkage long sys_execveat(int dfd, const ch=
ar __user
>>>> *filename,
>>>>  			const char __user *const __user *argv,
>>>>  			const char __user *const __user *envp, int flags);
>>>> =20
>>>> +asmlinkage long sys_membarrier(int cmd, int flags);
>>>> +
>>>>  #endif
>>>> diff --git a/include/uapi/asm-generic/unistd.h
>>>> b/include/uapi/asm-generic/unistd.h
>>>> index e016bd9..8da542a 100644
>>>> --- a/include/uapi/asm-generic/unistd.h
>>>> +++ b/include/uapi/asm-generic/unistd.h
>>>> @@ -709,9 +709,11 @@ __SYSCALL(__NR_memfd_create, sys_memfd_create=
)
>>>>  __SYSCALL(__NR_bpf, sys_bpf)
>>>>  #define __NR_execveat 281
>>>>  __SC_COMP(__NR_execveat, sys_execveat, compat_sys_execveat)
>>>> +#define __NR_membarrier 282
>>>> +__SYSCALL(__NR_membarrier, sys_membarrier)
>>>> =20
>>>>  #undef __NR_syscalls
>>>> -#define __NR_syscalls 282
>>>> +#define __NR_syscalls 283
>>>> =20
>>>>  /*
>>>>   * All syscalls below here should go away really,
>>>> diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
>>>> index 1ff9942..e6f229a 100644
>>>> --- a/include/uapi/linux/Kbuild
>>>> +++ b/include/uapi/linux/Kbuild
>>>> @@ -251,6 +251,7 @@ header-y +=3D mdio.h
>>>>  header-y +=3D media.h
>>>>  header-y +=3D media-bus-format.h
>>>>  header-y +=3D mei.h
>>>> +header-y +=3D membarrier.h
>>>>  header-y +=3D memfd.h
>>>>  header-y +=3D mempolicy.h
>>>>  header-y +=3D meye.h
>>>> diff --git a/include/uapi/linux/membarrier.h b/include/uapi/linux/=
membarrier.h
>>>> new file mode 100644
>>>> index 0000000..e0b108b
>>>> --- /dev/null
>>>> +++ b/include/uapi/linux/membarrier.h
>>>> @@ -0,0 +1,53 @@
>>>> +#ifndef _UAPI_LINUX_MEMBARRIER_H
>>>> +#define _UAPI_LINUX_MEMBARRIER_H
>>>> +
>>>> +/*
>>>> + * linux/membarrier.h
>>>> + *
>>>> + * membarrier system call API
>>>> + *
>>>> + * Copyright (c) 2010, 2015 Mathieu Desnoyers <mathieu.desnoyers@=
efficios.com>
>>>> + *
>>>> + * Permission is hereby granted, free of charge, to any person ob=
taining a copy
>>>> + * of this software and associated documentation files (the "Soft=
ware"), to
>>>> deal
>>>> + * in the Software without restriction, including without limitat=
ion the rights
>>>> + * to use, copy, modify, merge, publish, distribute, sublicense, =
and/or sell
>>>> + * copies of the Software, and to permit persons to whom the Soft=
ware is
>>>> + * furnished to do so, subject to the following conditions:
>>>> + *
>>>> + * The above copyright notice and this permission notice shall be=
 included in
>>>> + * all copies or substantial portions of the Software.
>>>> + *
>>>> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND=
, EXPRESS OR
>>>> + * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHA=
NTABILITY,
>>>> + * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EV=
ENT SHALL THE
>>>> + * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES =
OR OTHER
>>>> + * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE=
, ARISING
>>>> FROM,
>>>> + * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER =
DEALINGS IN
>>>> THE
>>>> + * SOFTWARE.
>>>> + */
>>>> +
>>>> +/**
>>>> + * enum membarrier_cmd - membarrier system call command
>>>> + * @MEMBARRIER_CMD_QUERY:   Query the set of supported commands. =
It returns
>>>> + *                          a bitmask of valid commands.
>>>> + * @MEMBARRIER_CMD_SHARED:  Execute a memory barrier on all runni=
ng threads.
>>>> + *                          Upon return from system call, the cal=
ler thread
>>>> + *                          is ensured that all running threads h=
ave passed
>>>> + *                          through a state where all memory acce=
sses to
>>>> + *                          user-space addresses match program or=
der between
>>>> + *                          entry to and return from the system c=
all
>>>> + *                          (non-running threads are de facto in =
such a
>>>> + *                          state). This covers threads from all =
processes
>>>> + *                          running on the system. This command r=
eturns 0.
>>>> + *
>>>> + * Command to be passed to the membarrier system call. The comman=
ds need to
>>>> + * be a single bit each, except for MEMBARRIER_CMD_QUERY which is=
 assigned to
>>>> + * the value 0.
>>>> + */
>>>> +enum membarrier_cmd {
>>>> +	MEMBARRIER_CMD_QUERY =3D 0,
>>>> +	MEMBARRIER_CMD_SHARED =3D (1 << 0),
>>>> +};
>>>> +
>>>> +#endif /* _UAPI_LINUX_MEMBARRIER_H */
>>>> diff --git a/init/Kconfig b/init/Kconfig
>>>> index af09b4f..4bba60f 100644
>>>> --- a/init/Kconfig
>>>> +++ b/init/Kconfig
>>>> @@ -1577,6 +1577,18 @@ config PCI_QUIRKS
>>>>  	  bugs/quirks. Disable this only if your target machine is
>>>>  	  unaffected by PCI quirks.
>>>> =20
>>>> +config MEMBARRIER
>>>> +	bool "Enable membarrier() system call" if EXPERT
>>>> +	default y
>>>> +	help
>>>> +	  Enable the membarrier() system call that allows issuing memory
>>>> +	  barriers across all running threads, which can be used to dist=
ribute
>>>> +	  the cost of user-space memory barriers asymmetrically by trans=
forming
>>>> +	  pairs of memory barriers into pairs consisting of membarrier()=
 and a
>>>> +	  compiler barrier.
>>>> +
>>>> +	  If unsure, say Y.
>>>> +
>>>>  config EMBEDDED
>>>>  	bool "Embedded system"
>>>>  	option allnoconfig_y
>>>> diff --git a/kernel/Makefile b/kernel/Makefile
>>>> index 43c4c92..92a481b 100644
>>>> --- a/kernel/Makefile
>>>> +++ b/kernel/Makefile
>>>> @@ -98,6 +98,7 @@ obj-$(CONFIG_CRASH_DUMP) +=3D crash_dump.o
>>>>  obj-$(CONFIG_JUMP_LABEL) +=3D jump_label.o
>>>>  obj-$(CONFIG_CONTEXT_TRACKING) +=3D context_tracking.o
>>>>  obj-$(CONFIG_TORTURE_TEST) +=3D torture.o
>>>> +obj-$(CONFIG_MEMBARRIER) +=3D membarrier.o
>>>> =20
>>>>  $(obj)/configs.o: $(obj)/config_data.h
>>>> =20
>>>> diff --git a/kernel/membarrier.c b/kernel/membarrier.c
>>>> new file mode 100644
>>>> index 0000000..536c727
>>>> --- /dev/null
>>>> +++ b/kernel/membarrier.c
>>>> @@ -0,0 +1,66 @@
>>>> +/*
>>>> + * Copyright (C) 2010, 2015 Mathieu Desnoyers <mathieu.desnoyers@=
efficios.com>
>>>> + *
>>>> + * membarrier system call
>>>> + *
>>>> + * This program is free software; you can redistribute it and/or =
modify
>>>> + * it under the terms of the GNU General Public License as publis=
hed by
>>>> + * the Free Software Foundation; either version 2 of the License,=
 or
>>>> + * (at your option) any later version.
>>>> + *
>>>> + * This program is distributed in the hope that it will be useful=
,
>>>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>>>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>>> + * GNU General Public License for more details.
>>>> + */
>>>> +
>>>> +#include <linux/syscalls.h>
>>>> +#include <linux/membarrier.h>
>>>> +
>>>> +/*
>>>> + * Bitmask made from a "or" of all commands within enum membarrie=
r_cmd,
>>>> + * except MEMBARRIER_CMD_QUERY.
>>>> + */
>>>> +#define MEMBARRIER_CMD_BITMASK	(MEMBARRIER_CMD_SHARED)
>>>> +
>>>> +/**
>>>> + * sys_membarrier - issue memory barriers on a set of threads
>>>> + * @cmd:   Takes command values defined in enum membarrier_cmd.
>>>> + * @flags: Currently needs to be 0. For future extensions.
>>>> + *
>>>> + * If this system call is not implemented, -ENOSYS is returned. I=
f the
>>>> + * command specified does not exist, or if the command argument i=
s invalid,
>>>> + * this system call returns -EINVAL. For a given command, with fl=
ags argument
>>>> + * set to 0, this system call is guaranteed to always return the =
same value
>>>> + * until reboot.
>>>> + *
>>>> + * All memory accesses performed in program order from each targe=
ted thread
>>>> + * is guaranteed to be ordered with respect to sys_membarrier(). =
If we use
>>>> + * the semantic "barrier()" to represent a compiler barrier forci=
ng memory
>>>> + * accesses to be performed in program order across the barrier, =
and
>>>> + * smp_mb() to represent explicit memory barriers forcing full me=
mory
>>>> + * ordering across the barrier, we have the following ordering ta=
ble for
>>>> + * each pair of barrier(), sys_membarrier() and smp_mb():
>>>> + *
>>>> + * The pair ordering is detailed as (O: ordered, X: not ordered):
>>>> + *
>>>> + *                        barrier()   smp_mb() sys_membarrier()
>>>> + *        barrier()          X           X            O
>>>> + *        smp_mb()           X           O            O
>>>> + *        sys_membarrier()   O           O            O
>>>> + */
>>>> +SYSCALL_DEFINE2(membarrier, int, cmd, int, flags)
>>>> +{
>>>> +	if (unlikely(flags))
>>>> +		return -EINVAL;
>>>> +	switch (cmd) {
>>>> +	case MEMBARRIER_CMD_QUERY:
>>>> +		return MEMBARRIER_CMD_BITMASK;
>>>> +	case MEMBARRIER_CMD_SHARED:
>>>> +		if (num_online_cpus() > 1)
>>>> +			synchronize_sched();
>>>> +		return 0;
>>>> +	default:
>>>> +		return -EINVAL;
>>>> +	}
>>>> +}
>>>> diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
>>>> index 7995ef5..eb4fde0 100644
>>>> --- a/kernel/sys_ni.c
>>>> +++ b/kernel/sys_ni.c
>>>> @@ -243,3 +243,6 @@ cond_syscall(sys_bpf);
>>>> =20
>>>>  /* execveat */
>>>>  cond_syscall(sys_execveat);
>>>> +
>>>> +/* membarrier */
>>>> +cond_syscall(sys_membarrier);
>>>>
>>>
>>>
>>> --
>>> Michael Kerrisk
>>> Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
>>> Linux/UNIX System Programming Training: http://man7.org/training/
>>=20
>=20
>=20
> --
> Michael Kerrisk
> Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
> Linux/UNIX System Programming Training: http://man7.org/training/

--=20
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

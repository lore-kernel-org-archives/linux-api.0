From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 1/3 v19] sys_membarrier(): system-wide memory barrier
 (generic, x86)
Date: Sat, 5 Dec 2015 08:48:23 +0000 (UTC)
Message-ID: <1635187109.213051.1449305303824.JavaMail.zimbra@efficios.com>
References: <1436561912-24365-1-git-send-email-mathieu.desnoyers@efficios.com> <1436561912-24365-2-git-send-email-mathieu.desnoyers@efficios.com> <5661B4E8.2070801@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_213049_751666799.1449305303821"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5661B4E8.2070801-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Nicholas Miell <nmiell-Wuw85uim5zDR7s880joybQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Lai Jiangshan <laijs-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Stephen Hemminger <stephen-OTpzqLSitTUnbdJkjeBofR2eb7JE58TQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pranith Kumar <bobby.prani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

------=_Part_213049_751666799.1449305303821
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Michael,

Please find the membarrier man groff file attached. I re-integrated
some changes that went in initially only in the changelog text version
back onto this groff source.

Please let me know if you find any issue with it.

Mathieu

----- On Dec 4, 2015, at 4:44 PM, Michael Kerrisk mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wr=
ote:

> Hi Mathieu,
>=20
> In the patch below you have a man page type of text. Is that
> just plain text, or do you have some groff source somewhere?
>=20
> Thanks,
>=20
> Michael
>=20
>=20
> On 07/10/2015 10:58 PM, Mathieu Desnoyers wrote:
>> Here is an implementation of a new system call, sys_membarrier(), which
>> executes a memory barrier on all threads running on the system. It is
>> implemented by calling synchronize_sched(). It can be used to distribute
>> the cost of user-space memory barriers asymmetrically by transforming
>> pairs of memory barriers into pairs consisting of sys_membarrier() and a
>> compiler barrier. For synchronization primitives that distinguish
>> between read-side and write-side (e.g. userspace RCU [1], rwlocks), the
>> read-side can be accelerated significantly by moving the bulk of the
>> memory barrier overhead to the write-side.
>>=20
>> The existing applications of which I am aware that would be improved by =
this
>> system call are as follows:
>>=20
>> * Through Userspace RCU library (http://urcu.so)
>>   - DNS server (Knot DNS) https://www.knot-dns.cz/
>>   - Network sniffer (http://netsniff-ng.org/)
>>   - Distributed object storage (https://sheepdog.github.io/sheepdog/)
>>   - User-space tracing (http://lttng.org)
>>   - Network storage system (https://www.gluster.org/)
>>   - Virtual routers
>>   (https://events.linuxfoundation.org/sites/events/files/slides/DPDK_RCU=
_0MQ.pdf)
>>   - Financial software (https://lkml.org/lkml/2015/3/23/189)
>>=20
>> Those projects use RCU in userspace to increase read-side speed and
>> scalability compared to locking. Especially in the case of RCU used
>> by libraries, sys_membarrier can speed up the read-side by moving the
>> bulk of the memory barrier cost to synchronize_rcu().
>>=20
>> * Direct users of sys_membarrier
>>   - core dotnet garbage collector (https://github.com/dotnet/coreclr/iss=
ues/198)
>>=20
>> Microsoft core dotnet GC developers are planning to use the mprotect()
>> side-effect of issuing memory barriers through IPIs as a way to implemen=
t
>> Windows FlushProcessWriteBuffers() on Linux. They are referring to
>> sys_membarrier in their github thread, specifically stating that
>> sys_membarrier() is what they are looking for.
>>=20
>> This implementation is based on kernel v4.1-rc8.
>>=20
>> To explain the benefit of this scheme, let's introduce two example threa=
ds:
>>=20
>> Thread A (non-frequent, e.g. executing liburcu synchronize_rcu())
>> Thread B (frequent, e.g. executing liburcu
>> rcu_read_lock()/rcu_read_unlock())
>>=20
>> In a scheme where all smp_mb() in thread A are ordering memory accesses
>> with respect to smp_mb() present in Thread B, we can change each
>> smp_mb() within Thread A into calls to sys_membarrier() and each
>> smp_mb() within Thread B into compiler barriers "barrier()".
>>=20
>> Before the change, we had, for each smp_mb() pairs:
>>=20
>> Thread A                    Thread B
>> previous mem accesses       previous mem accesses
>> smp_mb()                    smp_mb()
>> following mem accesses      following mem accesses
>>=20
>> After the change, these pairs become:
>>=20
>> Thread A                    Thread B
>> prev mem accesses           prev mem accesses
>> sys_membarrier()            barrier()
>> follow mem accesses         follow mem accesses
>>=20
>> As we can see, there are two possible scenarios: either Thread B memory
>> accesses do not happen concurrently with Thread A accesses (1), or they
>> do (2).
>>=20
>> 1) Non-concurrent Thread A vs Thread B accesses:
>>=20
>> Thread A                    Thread B
>> prev mem accesses
>> sys_membarrier()
>> follow mem accesses
>>                             prev mem accesses
>>                             barrier()
>>                             follow mem accesses
>>=20
>> In this case, thread B accesses will be weakly ordered. This is OK,
>> because at that point, thread A is not particularly interested in
>> ordering them with respect to its own accesses.
>>=20
>> 2) Concurrent Thread A vs Thread B accesses
>>=20
>> Thread A                    Thread B
>> prev mem accesses           prev mem accesses
>> sys_membarrier()            barrier()
>> follow mem accesses         follow mem accesses
>>=20
>> In this case, thread B accesses, which are ensured to be in program
>> order thanks to the compiler barrier, will be "upgraded" to full
>> smp_mb() by synchronize_sched().
>>=20
>> * Benchmarks
>>=20
>> On Intel Xeon E5405 (8 cores)
>> (one thread is calling sys_membarrier, the other 7 threads are busy
>> looping)
>>=20
>> 1000 non-expedited sys_membarrier calls in 33s =3D 33 milliseconds/call.
>>=20
>> * User-space user of this system call: Userspace RCU library
>>=20
>> Both the signal-based and the sys_membarrier userspace RCU schemes
>> permit us to remove the memory barrier from the userspace RCU
>> rcu_read_lock() and rcu_read_unlock() primitives, thus significantly
>> accelerating them. These memory barriers are replaced by compiler
>> barriers on the read-side, and all matching memory barriers on the
>> write-side are turned into an invocation of a memory barrier on all
>> active threads in the process. By letting the kernel perform this
>> synchronization rather than dumbly sending a signal to every process
>> threads (as we currently do), we diminish the number of unnecessary wake
>> ups and only issue the memory barriers on active threads. Non-running
>> threads do not need to execute such barrier anyway, because these are
>> implied by the scheduler context switches.
>>=20
>> Results in liburcu:
>>=20
>> Operations in 10s, 6 readers, 2 writers:
>>=20
>> memory barriers in reader:    1701557485 reads, 2202847 writes
>> signal-based scheme:          9830061167 reads,    6700 writes
>> sys_membarrier:               9952759104 reads,     425 writes
>> sys_membarrier (dyn. check):  7970328887 reads,     425 writes
>>=20
>> The dynamic sys_membarrier availability check adds some overhead to
>> the read-side compared to the signal-based scheme, but besides that,
>> sys_membarrier slightly outperforms the signal-based scheme. However,
>> this non-expedited sys_membarrier implementation has a much slower grace
>> period than signal and memory barrier schemes.
>>=20
>> Besides diminishing the number of wake-ups, one major advantage of the
>> membarrier system call over the signal-based scheme is that it does not
>> need to reserve a signal. This plays much more nicely with libraries,
>> and with processes injected into for tracing purposes, for which we
>> cannot expect that signals will be unused by the application.
>>=20
>> An expedited version of this system call can be added later on to speed
>> up the grace period. Its implementation will likely depend on reading
>> the cpu_curr()->mm without holding each CPU's rq lock.
>>=20
>> This patch adds the system call to x86 and to asm-generic.
>>=20
>> [1] http://urcu.so
>>=20
>> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
>> Reviewed-by: Paul E. McKenney <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>> Reviewed-by: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
>> CC: KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
>> CC: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
>> CC: Nicholas Miell <nmiell-Wuw85uim5zDR7s880joybQ@public.gmane.org>
>> CC: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
>> CC: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> CC: Alan Cox <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
>> CC: Lai Jiangshan <laijs-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
>> CC: Stephen Hemminger <stephen-OTpzqLSitTUnbdJkjeBofR2eb7JE58TQ@public.gmane.org>
>> CC: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
>> CC: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
>> CC: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
>> CC: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> CC: Pranith Kumar <bobby.prani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> CC: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> CC: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>=20
>> ---
>>=20
>> membarrier(2) man page:
>> --------------- snip -------------------
>> MEMBARRIER(2)              Linux Programmer's Manual             MEMBARR=
IER(2)
>>=20
>> NAME
>>        membarrier - issue memory barriers on a set of threads
>>=20
>> SYNOPSIS
>>        #include <linux/membarrier.h>
>>=20
>>        int membarrier(int cmd, int flags);
>>=20
>> DESCRIPTION
>>        The cmd argument is one of the following:
>>=20
>>        MEMBARRIER_CMD_QUERY
>>               Query  the  set  of  supported commands. It returns a bitm=
ask of
>>               supported commands.
>>=20
>>        MEMBARRIER_CMD_SHARED
>>               Execute a memory barrier on all threads running on  the  s=
ystem.
>>               Upon  return from system call, the caller thread is ensure=
d that
>>               all running threads have passed through a state where all =
memory
>>               accesses  to  user-space  addresses  match program order b=
etween
>>               entry to and return from the system  call  (non-running  t=
hreads
>>               are de facto in such a state). This covers threads from al=
l pro=E2=80=90
>>               cesses running on the system.  This command returns 0.
>>=20
>>        The flags argument needs to be 0. For future extensions.
>>=20
>>        All memory accesses performed  in  program  order  from  each  ta=
rgeted
>>        thread is guaranteed to be ordered with respect to sys_membarrier=
(). If
>>        we use the semantic "barrier()" to represent a compiler barrier f=
orcing
>>        memory  accesses  to  be performed in program order across the ba=
rrier,
>>        and smp_mb() to represent explicit memory barriers forcing full  =
memory
>>        ordering  across  the barrier, we have the following ordering tab=
le for
>>        each pair of barrier(), sys_membarrier() and smp_mb():
>>=20
>>        The pair ordering is detailed as (O: ordered, X: not ordered):
>>=20
>>                               barrier()   smp_mb() sys_membarrier()
>>               barrier()          X           X            O
>>               smp_mb()           X           O            O
>>               sys_membarrier()   O           O            O
>>=20
>> RETURN VALUE
>>        On success, these system calls return zero.  On error, -1 is  ret=
urned,
>>        and errno is set appropriately. For a given command, with flags
>>        argument set to 0, this system call is guaranteed to always retur=
n the
>>        same value until reboot.
>>=20
>> ERRORS
>>        ENOSYS System call is not implemented.
>>=20
>>        EINVAL Invalid arguments.
>>=20
>> Linux                             2015-04-15                     MEMBARR=
IER(2)
>> --------------- snip -------------------
>>=20
>> Changes since v18:
>> - Add unlikely() check to flags,
>> - Describe current users in changelog.
>>=20
>> Changes since v17:
>> - Update commit message.
>>=20
>> Changes since v16:
>> - Update documentation.
>> - Add man page to changelog.
>> - Build sys_membarrier on !CONFIG_SMP. It allows userspace applications
>>   to not care about the number of processors on the system.  Based on
>>   recommendations from Stephen Hemminger and Steven Rostedt.
>> - Check that flags argument is 0, update documentation to require it.
>>=20
>> Changes since v15:
>> - Add flags argument in addition to cmd.
>> - Update documentation.
>>=20
>> Changes since v14:
>> - Take care of Thomas Gleixner's comments.
>>=20
>> Changes since v13:
>> - Move to kernel/membarrier.c.
>> - Remove MEMBARRIER_PRIVATE flag.
>> - Add MAINTAINERS file entry.
>>=20
>> Changes since v12:
>> - Remove _FLAG suffix from uapi flags.
>> - Add Expert menuconfig option CONFIG_MEMBARRIER (default=3Dy).
>> - Remove EXPEDITED mode. Only implement non-expedited for now, until
>>   reading the cpu_curr()->mm can be done without holding the CPU's rq
>>   lock.
>>=20
>> Changes since v11:
>> - 5 years have passed.
>> - Rebase on v3.19 kernel.
>> - Add futex-alike PRIVATE vs SHARED semantic: private for per-process
>>   barriers, non-private for memory mappings shared between processes.
>> - Simplify user API.
>> - Code refactoring.
>>=20
>> Changes since v10:
>> - Apply Randy's comments.
>> - Rebase on 2.6.34-rc4 -tip.
>>=20
>> Changes since v9:
>> - Clean up #ifdef CONFIG_SMP.
>>=20
>> Changes since v8:
>> - Go back to rq spin locks taken by sys_membarrier() rather than adding
>>   memory barriers to the scheduler. It implies a potential RoS
>>   (reduction of service) if sys_membarrier() is executed in a busy-loop
>>   by a user, but nothing more than what is already possible with other
>>   existing system calls, but saves memory barriers in the scheduler fast
>>   path.
>> - re-add the memory barrier comments to x86 switch_mm() as an example to
>>   other architectures.
>> - Update documentation of the memory barriers in sys_membarrier and
>>   switch_mm().
>> - Append execution scenarios to the changelog showing the purpose of
>>   each memory barrier.
>>=20
>> Changes since v7:
>> - Move spinlock-mb and scheduler related changes to separate patches.
>> - Add support for sys_membarrier on x86_32.
>> - Only x86 32/64 system calls are reserved in this patch. It is planned
>>   to incrementally reserve syscall IDs on other architectures as these
>>   are tested.
>>=20
>> Changes since v6:
>> - Remove some unlikely() not so unlikely.
>> - Add the proper scheduler memory barriers needed to only use the RCU
>>   read lock in sys_membarrier rather than take each runqueue spinlock:
>> - Move memory barriers from per-architecture switch_mm() to schedule()
>>   and finish_lock_switch(), where they clearly document that all data
>>   protected by the rq lock is guaranteed to have memory barriers issued
>>   between the scheduler update and the task execution. Replacing the
>>   spin lock acquire/release barriers with these memory barriers imply
>>   either no overhead (x86 spinlock atomic instruction already implies a
>>   full mb) or some hopefully small overhead caused by the upgrade of the
>>   spinlock acquire/release barriers to more heavyweight smp_mb().
>> - The "generic" version of spinlock-mb.h declares both a mapping to
>>   standard spinlocks and full memory barriers. Each architecture can
>>   specialize this header following their own need and declare
>>   CONFIG_HAVE_SPINLOCK_MB to use their own spinlock-mb.h.
>> - Note: benchmarks of scheduler overhead with specialized spinlock-mb.h
>>   implementations on a wide range of architecture would be welcome.
>>=20
>> Changes since v5:
>> - Plan ahead for extensibility by introducing mandatory/optional masks
>>   to the "flags" system call parameter. Past experience with accept4(),
>>   signalfd4(), eventfd2(), epoll_create1(), dup3(), pipe2(), and
>>   inotify_init1() indicates that this is the kind of thing we want to
>>   plan for. Return -EINVAL if the mandatory flags received are unknown.
>> - Create include/linux/membarrier.h to define these flags.
>> - Add MEMBARRIER_QUERY optional flag.
>>=20
>> Changes since v4:
>> - Add "int expedited" parameter, use synchronize_sched() in the
>>   non-expedited case. Thanks to Lai Jiangshan for making us consider
>>   seriously using synchronize_sched() to provide the low-overhead
>>   membarrier scheme.
>> - Check num_online_cpus() =3D=3D 1, quickly return without doing nothing=
.
>>=20
>> Changes since v3a:
>> - Confirm that each CPU indeed runs the current task's ->mm before
>>   sending an IPI. Ensures that we do not disturb RT tasks in the
>>   presence of lazy TLB shootdown.
>> - Document memory barriers needed in switch_mm().
>> - Surround helper functions with #ifdef CONFIG_SMP.
>>=20
>> Changes since v2:
>> - simply send-to-many to the mm_cpumask. It contains the list of
>>   processors we have to IPI to (which use the mm), and this mask is
>>   updated atomically.
>>=20
>> Changes since v1:
>> - Only perform the IPI in CONFIG_SMP.
>> - Only perform the IPI if the process has more than one thread.
>> - Only send IPIs to CPUs involved with threads belonging to our process.
>> - Adaptative IPI scheme (single vs many IPI with threshold).
>> - Issue smp_mb() at the beginning and end of the system call.
>> ---
>>  MAINTAINERS                            |  8 +++++
>>  arch/x86/entry/syscalls/syscall_32.tbl |  1 +
>>  arch/x86/entry/syscalls/syscall_64.tbl |  1 +
>>  include/linux/syscalls.h               |  2 ++
>>  include/uapi/asm-generic/unistd.h      |  4 ++-
>>  include/uapi/linux/Kbuild              |  1 +
>>  include/uapi/linux/membarrier.h        | 53 +++++++++++++++++++++++++++
>>  init/Kconfig                           | 12 +++++++
>>  kernel/Makefile                        |  1 +
>>  kernel/membarrier.c                    | 66 +++++++++++++++++++++++++++=
+++++++
>>  kernel/sys_ni.c                        |  3 ++
>>  11 files changed, 151 insertions(+), 1 deletion(-)
>>  create mode 100644 include/uapi/linux/membarrier.h
>>  create mode 100644 kernel/membarrier.c
>>=20
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 0d70760..b560da6 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -6642,6 +6642,14 @@ W:=09http://www.mellanox.com
>>  Q:=09http://patchwork.ozlabs.org/project/netdev/list/
>>  F:=09drivers/net/ethernet/mellanox/mlx4/en_*
>> =20
>> +MEMBARRIER SUPPORT
>> +M:=09Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
>> +M:=09"Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>> +L:=09linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> +S:=09Supported
>> +F:=09kernel/membarrier.c
>> +F:=09include/uapi/linux/membarrier.h
>> +
>>  MEMORY MANAGEMENT
>>  L:=09linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
>>  W:=09http://www.linux-mm.org
>> diff --git a/arch/x86/entry/syscalls/syscall_32.tbl
>> b/arch/x86/entry/syscalls/syscall_32.tbl
>> index ef8187f..e63ad61 100644
>> --- a/arch/x86/entry/syscalls/syscall_32.tbl
>> +++ b/arch/x86/entry/syscalls/syscall_32.tbl
>> @@ -365,3 +365,4 @@
>>  356=09i386=09memfd_create=09=09sys_memfd_create
>>  357=09i386=09bpf=09=09=09sys_bpf
>>  358=09i386=09execveat=09=09sys_execveat=09=09=09stub32_execveat
>> +359=09i386=09membarrier=09=09sys_membarrier
>> diff --git a/arch/x86/entry/syscalls/syscall_64.tbl
>> b/arch/x86/entry/syscalls/syscall_64.tbl
>> index 9ef32d5..87f3cd6 100644
>> --- a/arch/x86/entry/syscalls/syscall_64.tbl
>> +++ b/arch/x86/entry/syscalls/syscall_64.tbl
>> @@ -329,6 +329,7 @@
>>  320=09common=09kexec_file_load=09=09sys_kexec_file_load
>>  321=09common=09bpf=09=09=09sys_bpf
>>  322=0964=09execveat=09=09stub_execveat
>> +323=09common=09membarrier=09=09sys_membarrier
>> =20
>>  #
>>  # x32-specific system call numbers start at 512 to avoid cache impact
>> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
>> index b45c45b..d4ab99b 100644
>> --- a/include/linux/syscalls.h
>> +++ b/include/linux/syscalls.h
>> @@ -884,4 +884,6 @@ asmlinkage long sys_execveat(int dfd, const char __u=
ser
>> *filename,
>>  =09=09=09const char __user *const __user *argv,
>>  =09=09=09const char __user *const __user *envp, int flags);
>> =20
>> +asmlinkage long sys_membarrier(int cmd, int flags);
>> +
>>  #endif
>> diff --git a/include/uapi/asm-generic/unistd.h
>> b/include/uapi/asm-generic/unistd.h
>> index e016bd9..8da542a 100644
>> --- a/include/uapi/asm-generic/unistd.h
>> +++ b/include/uapi/asm-generic/unistd.h
>> @@ -709,9 +709,11 @@ __SYSCALL(__NR_memfd_create, sys_memfd_create)
>>  __SYSCALL(__NR_bpf, sys_bpf)
>>  #define __NR_execveat 281
>>  __SC_COMP(__NR_execveat, sys_execveat, compat_sys_execveat)
>> +#define __NR_membarrier 282
>> +__SYSCALL(__NR_membarrier, sys_membarrier)
>> =20
>>  #undef __NR_syscalls
>> -#define __NR_syscalls 282
>> +#define __NR_syscalls 283
>> =20
>>  /*
>>   * All syscalls below here should go away really,
>> diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
>> index 1ff9942..e6f229a 100644
>> --- a/include/uapi/linux/Kbuild
>> +++ b/include/uapi/linux/Kbuild
>> @@ -251,6 +251,7 @@ header-y +=3D mdio.h
>>  header-y +=3D media.h
>>  header-y +=3D media-bus-format.h
>>  header-y +=3D mei.h
>> +header-y +=3D membarrier.h
>>  header-y +=3D memfd.h
>>  header-y +=3D mempolicy.h
>>  header-y +=3D meye.h
>> diff --git a/include/uapi/linux/membarrier.h b/include/uapi/linux/membar=
rier.h
>> new file mode 100644
>> index 0000000..e0b108b
>> --- /dev/null
>> +++ b/include/uapi/linux/membarrier.h
>> @@ -0,0 +1,53 @@
>> +#ifndef _UAPI_LINUX_MEMBARRIER_H
>> +#define _UAPI_LINUX_MEMBARRIER_H
>> +
>> +/*
>> + * linux/membarrier.h
>> + *
>> + * membarrier system call API
>> + *
>> + * Copyright (c) 2010, 2015 Mathieu Desnoyers <mathieu.desnoyers@effici=
os.com>
>> + *
>> + * Permission is hereby granted, free of charge, to any person obtainin=
g a copy
>> + * of this software and associated documentation files (the "Software")=
, to
>> deal
>> + * in the Software without restriction, including without limitation th=
e rights
>> + * to use, copy, modify, merge, publish, distribute, sublicense, and/or=
 sell
>> + * copies of the Software, and to permit persons to whom the Software i=
s
>> + * furnished to do so, subject to the following conditions:
>> + *
>> + * The above copyright notice and this permission notice shall be inclu=
ded in
>> + * all copies or substantial portions of the Software.
>> + *
>> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPR=
ESS OR
>> + * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABIL=
ITY,
>> + * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SH=
ALL THE
>> + * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTH=
ER
>> + * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARIS=
ING
>> FROM,
>> + * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALIN=
GS IN
>> THE
>> + * SOFTWARE.
>> + */
>> +
>> +/**
>> + * enum membarrier_cmd - membarrier system call command
>> + * @MEMBARRIER_CMD_QUERY:   Query the set of supported commands. It ret=
urns
>> + *                          a bitmask of valid commands.
>> + * @MEMBARRIER_CMD_SHARED:  Execute a memory barrier on all running thr=
eads.
>> + *                          Upon return from system call, the caller th=
read
>> + *                          is ensured that all running threads have pa=
ssed
>> + *                          through a state where all memory accesses t=
o
>> + *                          user-space addresses match program order be=
tween
>> + *                          entry to and return from the system call
>> + *                          (non-running threads are de facto in such a
>> + *                          state). This covers threads from all proces=
ses
>> + *                          running on the system. This command returns=
 0.
>> + *
>> + * Command to be passed to the membarrier system call. The commands nee=
d to
>> + * be a single bit each, except for MEMBARRIER_CMD_QUERY which is assig=
ned to
>> + * the value 0.
>> + */
>> +enum membarrier_cmd {
>> +=09MEMBARRIER_CMD_QUERY =3D 0,
>> +=09MEMBARRIER_CMD_SHARED =3D (1 << 0),
>> +};
>> +
>> +#endif /* _UAPI_LINUX_MEMBARRIER_H */
>> diff --git a/init/Kconfig b/init/Kconfig
>> index af09b4f..4bba60f 100644
>> --- a/init/Kconfig
>> +++ b/init/Kconfig
>> @@ -1577,6 +1577,18 @@ config PCI_QUIRKS
>>  =09  bugs/quirks. Disable this only if your target machine is
>>  =09  unaffected by PCI quirks.
>> =20
>> +config MEMBARRIER
>> +=09bool "Enable membarrier() system call" if EXPERT
>> +=09default y
>> +=09help
>> +=09  Enable the membarrier() system call that allows issuing memory
>> +=09  barriers across all running threads, which can be used to distribu=
te
>> +=09  the cost of user-space memory barriers asymmetrically by transform=
ing
>> +=09  pairs of memory barriers into pairs consisting of membarrier() and=
 a
>> +=09  compiler barrier.
>> +
>> +=09  If unsure, say Y.
>> +
>>  config EMBEDDED
>>  =09bool "Embedded system"
>>  =09option allnoconfig_y
>> diff --git a/kernel/Makefile b/kernel/Makefile
>> index 43c4c92..92a481b 100644
>> --- a/kernel/Makefile
>> +++ b/kernel/Makefile
>> @@ -98,6 +98,7 @@ obj-$(CONFIG_CRASH_DUMP) +=3D crash_dump.o
>>  obj-$(CONFIG_JUMP_LABEL) +=3D jump_label.o
>>  obj-$(CONFIG_CONTEXT_TRACKING) +=3D context_tracking.o
>>  obj-$(CONFIG_TORTURE_TEST) +=3D torture.o
>> +obj-$(CONFIG_MEMBARRIER) +=3D membarrier.o
>> =20
>>  $(obj)/configs.o: $(obj)/config_data.h
>> =20
>> diff --git a/kernel/membarrier.c b/kernel/membarrier.c
>> new file mode 100644
>> index 0000000..536c727
>> --- /dev/null
>> +++ b/kernel/membarrier.c
>> @@ -0,0 +1,66 @@
>> +/*
>> + * Copyright (C) 2010, 2015 Mathieu Desnoyers <mathieu.desnoyers@effici=
os.com>
>> + *
>> + * membarrier system call
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#include <linux/syscalls.h>
>> +#include <linux/membarrier.h>
>> +
>> +/*
>> + * Bitmask made from a "or" of all commands within enum membarrier_cmd,
>> + * except MEMBARRIER_CMD_QUERY.
>> + */
>> +#define MEMBARRIER_CMD_BITMASK=09(MEMBARRIER_CMD_SHARED)
>> +
>> +/**
>> + * sys_membarrier - issue memory barriers on a set of threads
>> + * @cmd:   Takes command values defined in enum membarrier_cmd.
>> + * @flags: Currently needs to be 0. For future extensions.
>> + *
>> + * If this system call is not implemented, -ENOSYS is returned. If the
>> + * command specified does not exist, or if the command argument is inva=
lid,
>> + * this system call returns -EINVAL. For a given command, with flags ar=
gument
>> + * set to 0, this system call is guaranteed to always return the same v=
alue
>> + * until reboot.
>> + *
>> + * All memory accesses performed in program order from each targeted th=
read
>> + * is guaranteed to be ordered with respect to sys_membarrier(). If we =
use
>> + * the semantic "barrier()" to represent a compiler barrier forcing mem=
ory
>> + * accesses to be performed in program order across the barrier, and
>> + * smp_mb() to represent explicit memory barriers forcing full memory
>> + * ordering across the barrier, we have the following ordering table fo=
r
>> + * each pair of barrier(), sys_membarrier() and smp_mb():
>> + *
>> + * The pair ordering is detailed as (O: ordered, X: not ordered):
>> + *
>> + *                        barrier()   smp_mb() sys_membarrier()
>> + *        barrier()          X           X            O
>> + *        smp_mb()           X           O            O
>> + *        sys_membarrier()   O           O            O
>> + */
>> +SYSCALL_DEFINE2(membarrier, int, cmd, int, flags)
>> +{
>> +=09if (unlikely(flags))
>> +=09=09return -EINVAL;
>> +=09switch (cmd) {
>> +=09case MEMBARRIER_CMD_QUERY:
>> +=09=09return MEMBARRIER_CMD_BITMASK;
>> +=09case MEMBARRIER_CMD_SHARED:
>> +=09=09if (num_online_cpus() > 1)
>> +=09=09=09synchronize_sched();
>> +=09=09return 0;
>> +=09default:
>> +=09=09return -EINVAL;
>> +=09}
>> +}
>> diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
>> index 7995ef5..eb4fde0 100644
>> --- a/kernel/sys_ni.c
>> +++ b/kernel/sys_ni.c
>> @@ -243,3 +243,6 @@ cond_syscall(sys_bpf);
>> =20
>>  /* execveat */
>>  cond_syscall(sys_execveat);
>> +
>> +/* membarrier */
>> +cond_syscall(sys_membarrier);
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

------=_Part_213049_751666799.1449305303821
Content-Type: text/troff; name=membarrier.2
Content-Disposition: attachment; filename=membarrier.2
Content-Transfer-Encoding: base64

LlwiIENvcHlyaWdodCAyMDE1IE1hdGhpZXUgRGVzbm95ZXJzIDxtYXRoaWV1LmRlc25veWVyc0Bl
ZmZpY2lvcy5jb20+Ci5cIgouXCIgJSUlTElDRU5TRV9TVEFSVChWRVJCQVRJTSkKLlwiIFBlcm1p
c3Npb24gaXMgZ3JhbnRlZCB0byBtYWtlIGFuZCBkaXN0cmlidXRlIHZlcmJhdGltIGNvcGllcyBv
ZiB0aGlzCi5cIiBtYW51YWwgcHJvdmlkZWQgdGhlIGNvcHlyaWdodCBub3RpY2UgYW5kIHRoaXMg
cGVybWlzc2lvbiBub3RpY2UgYXJlCi5cIiBwcmVzZXJ2ZWQgb24gYWxsIGNvcGllcy4KLlwiCi5c
IiBQZXJtaXNzaW9uIGlzIGdyYW50ZWQgdG8gY29weSBhbmQgZGlzdHJpYnV0ZSBtb2RpZmllZCB2
ZXJzaW9ucyBvZiB0aGlzCi5cIiBtYW51YWwgdW5kZXIgdGhlIGNvbmRpdGlvbnMgZm9yIHZlcmJh
dGltIGNvcHlpbmcsIHByb3ZpZGVkIHRoYXQgdGhlCi5cIiBlbnRpcmUgcmVzdWx0aW5nIGRlcml2
ZWQgd29yayBpcyBkaXN0cmlidXRlZCB1bmRlciB0aGUgdGVybXMgb2YgYQouXCIgcGVybWlzc2lv
biBub3RpY2UgaWRlbnRpY2FsIHRvIHRoaXMgb25lLgouXCIKLlwiIFNpbmNlIHRoZSBMaW51eCBr
ZXJuZWwgYW5kIGxpYnJhcmllcyBhcmUgY29uc3RhbnRseSBjaGFuZ2luZywgdGhpcwouXCIgbWFu
dWFsIHBhZ2UgbWF5IGJlIGluY29ycmVjdCBvciBvdXQtb2YtZGF0ZS4gIFRoZSBhdXRob3Iocykg
YXNzdW1lIG5vCi5cIiByZXNwb25zaWJpbGl0eSBmb3IgZXJyb3JzIG9yIG9taXNzaW9ucywgb3Ig
Zm9yIGRhbWFnZXMgcmVzdWx0aW5nIGZyb20KLlwiIHRoZSB1c2Ugb2YgdGhlIGluZm9ybWF0aW9u
IGNvbnRhaW5lZCBoZXJlaW4uICBUaGUgYXV0aG9yKHMpIG1heSBub3QKLlwiIGhhdmUgdGFrZW4g
dGhlIHNhbWUgbGV2ZWwgb2YgY2FyZSBpbiB0aGUgcHJvZHVjdGlvbiBvZiB0aGlzIG1hbnVhbCwK
LlwiIHdoaWNoIGlzIGxpY2Vuc2VkIGZyZWUgb2YgY2hhcmdlLCBhcyB0aGV5IG1pZ2h0IHdoZW4g
d29ya2luZwouXCIgcHJvZmVzc2lvbmFsbHkuCi5cIgouXCIgRm9ybWF0dGVkIG9yIHByb2Nlc3Nl
ZCB2ZXJzaW9ucyBvZiB0aGlzIG1hbnVhbCwgaWYgdW5hY2NvbXBhbmllZCBieQouXCIgdGhlIHNv
dXJjZSwgbXVzdCBhY2tub3dsZWRnZSB0aGUgY29weXJpZ2h0IGFuZCBhdXRob3JzIG9mIHRoaXMg
d29yay4KLlwiICUlJUxJQ0VOU0VfRU5ECi5cIgouVEggTUVNQkFSUklFUiAyIDIwMTUtMDQtMTUg
IkxpbnV4IiAiTGludXggUHJvZ3JhbW1lcidzIE1hbnVhbCIKLlNIIE5BTUUKbWVtYmFycmllciBc
LSBpc3N1ZSBtZW1vcnkgYmFycmllcnMgb24gYSBzZXQgb2YgdGhyZWFkcwouU0ggU1lOT1BTSVMK
LkIgI2luY2x1ZGUgPGxpbnV4L21lbWJhcnJpZXIuaD4KLnNwCi5CSSAiaW50IG1lbWJhcnJpZXIo
aW50ICIgY21kICIsIGludCAiIGZsYWdzICIpOwouc3AKLlNIIERFU0NSSVBUSU9OClRoZQouSSBj
bWQKYXJndW1lbnQgaXMgb25lIG9mIHRoZSBmb2xsb3dpbmc6CgouVFAKLkIgTUVNQkFSUklFUl9D
TURfUVVFUlkKUXVlcnkgdGhlIHNldCBvZiBzdXBwb3J0ZWQgY29tbWFuZHMuIEl0IHJldHVybnMg
YSBiaXRtYXNrIG9mIHN1cHBvcnRlZApjb21tYW5kcy4KLlRQCi5CIE1FTUJBUlJJRVJfQ01EX1NI
QVJFRApFeGVjdXRlIGEgbWVtb3J5IGJhcnJpZXIgb24gYWxsIHRocmVhZHMgcnVubmluZyBvbiB0
aGUgc3lzdGVtLiBVcG9uCnJldHVybiBmcm9tIHN5c3RlbSBjYWxsLCB0aGUgY2FsbGVyIHRocmVh
ZCBpcyBlbnN1cmVkIHRoYXQgYWxsIHJ1bm5pbmcKdGhyZWFkcyBoYXZlIHBhc3NlZCB0aHJvdWdo
IGEgc3RhdGUgd2hlcmUgYWxsIG1lbW9yeSBhY2Nlc3NlcyB0bwp1c2VyLXNwYWNlIGFkZHJlc3Nl
cyBtYXRjaCBwcm9ncmFtIG9yZGVyIGJldHdlZW4gZW50cnkgdG8gYW5kIHJldHVybgpmcm9tIHRo
ZSBzeXN0ZW0gY2FsbCAobm9uLXJ1bm5pbmcgdGhyZWFkcyBhcmUgZGUgZmFjdG8gaW4gc3VjaCBh
CnN0YXRlKS4gVGhpcyBjb3ZlcnMgdGhyZWFkcyBmcm9tIGFsbCBwcm9jZXNzZXMgcnVubmluZyBv
biB0aGUgc3lzdGVtLgpUaGlzIGNvbW1hbmQgcmV0dXJucyAwLgoKLlBQClRoZQouSSBmbGFncwph
cmd1bWVudCBpcyBjdXJyZW50bHkgdW51c2VkLgoKLlBQCkFsbCBtZW1vcnkgYWNjZXNzZXMgcGVy
Zm9ybWVkIGluIHByb2dyYW0gb3JkZXIgZnJvbSBlYWNoIHRhcmdldGVkIHRocmVhZAppcyBndWFy
YW50ZWVkIHRvIGJlIG9yZGVyZWQgd2l0aCByZXNwZWN0IHRvIHN5c19tZW1iYXJyaWVyKCkuIElm
IHdlIHVzZQp0aGUgc2VtYW50aWMgImJhcnJpZXIoKSIgdG8gcmVwcmVzZW50IGEgY29tcGlsZXIg
YmFycmllciBmb3JjaW5nIG1lbW9yeQphY2Nlc3NlcyB0byBiZSBwZXJmb3JtZWQgaW4gcHJvZ3Jh
bSBvcmRlciBhY3Jvc3MgdGhlIGJhcnJpZXIsIGFuZApzbXBfbWIoKSB0byByZXByZXNlbnQgZXhw
bGljaXQgbWVtb3J5IGJhcnJpZXJzIGZvcmNpbmcgZnVsbCBtZW1vcnkKb3JkZXJpbmcgYWNyb3Nz
IHRoZSBiYXJyaWVyLCB3ZSBoYXZlIHRoZSBmb2xsb3dpbmcgb3JkZXJpbmcgdGFibGUgZm9yCmVh
Y2ggcGFpciBvZiBiYXJyaWVyKCksIHN5c19tZW1iYXJyaWVyKCkgYW5kIHNtcF9tYigpOgoKVGhl
IHBhaXIgb3JkZXJpbmcgaXMgZGV0YWlsZWQgYXMgKE86IG9yZGVyZWQsIFg6IG5vdCBvcmRlcmVk
KToKCiAgICAgICAgICAgICAgICAgICAgICAgYmFycmllcigpICAgc21wX21iKCkgc3lzX21lbWJh
cnJpZXIoKQogICAgICAgYmFycmllcigpICAgICAgICAgIFggICAgICAgICAgIFggICAgICAgICAg
ICBPCiAgICAgICBzbXBfbWIoKSAgICAgICAgICAgWCAgICAgICAgICAgTyAgICAgICAgICAgIE8K
ICAgICAgIHN5c19tZW1iYXJyaWVyKCkgICBPICAgICAgICAgICBPICAgICAgICAgICAgTwoKLlNI
IFJFVFVSTiBWQUxVRQpPbiBzdWNjZXNzLCB0aGVzZSBzeXN0ZW0gY2FsbHMgcmV0dXJuIHplcm8u
ICBPbiBlcnJvciwgXC0xIGlzIHJldHVybmVkLAphbmQKLkkgZXJybm8KaXMgc2V0IGFwcHJvcHJp
YXRlbHkuCkZvciBhIGdpdmVuIGNvbW1hbmQsIHdpdGggZmxhZ3MgYXJndW1lbnQgc2V0IHRvIDAs
IHRoaXMgc3lzdGVtIGNhbGwgaXMKZ3VhcmFudGVlZCB0byBhbHdheXMgcmV0dXJuIHRoZSBzYW1l
IHZhbHVlIHVudGlsIHJlYm9vdC4KLlNIIEVSUk9SUwouVFAKLkIgRU5PU1lTClN5c3RlbSBjYWxs
IGlzIG5vdCBpbXBsZW1lbnRlZC4KLlRQCi5CIEVJTlZBTApJbnZhbGlkIGFyZ3VtZW50cy4K
------=_Part_213049_751666799.1449305303821--

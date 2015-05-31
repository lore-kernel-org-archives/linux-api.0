From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for v4.2 v18 1/3] sys_membarrier(): system-wide memory
 barrier (generic, x86)
Date: Sun, 31 May 2015 12:53:05 +0000 (UTC)
Message-ID: <1260710044.536.1433076785629.JavaMail.zimbra@efficios.com>
References: <1431820100-17040-1-git-send-email-mathieu.desnoyers@efficios.com> <1431820100-17040-2-git-send-email-mathieu.desnoyers@efficios.com> <20150529154036.9695b6c153ed37aed3343f3b@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150529154036.9695b6c153ed37aed3343f3b-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Nicholas Miell <nmiell-Wuw85uim5zDR7s880joybQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Lai Jiangshan <laijs-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Stephen Hemminger <stephen-OTpzqLSitTUnbdJkjeBofR2eb7JE58TQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pranith Kumar <bobby.prani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

----- On May 30, 2015, at 12:40 AM, Andrew Morton akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org wrote:

> On Sat, 16 May 2015 19:48:18 -0400 Mathieu Desnoyers
> <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> wrote:
> 
>> Here is an implementation of a new system call, sys_membarrier(), which
>> executes a memory barrier on all threads running on the system. It is
>> implemented by calling synchronize_sched(). It can be used to distribute
>> the cost of user-space memory barriers asymmetrically by transforming
>> pairs of memory barriers into pairs consisting of sys_membarrier() and a
>> compiler barrier. For synchronization primitives that distinguish
>> between read-side and write-side (e.g. userspace RCU [1], rwlocks), the
>> read-side can be accelerated significantly by moving the bulk of the
>> memory barrier overhead to the write-side.
>>
>> ...
>>
> 
> It would be nice to hear about the real world value of this syscall to
> our users.  I'm seeing test results for a microbenchmark but so what.
> What actual applications or application classes are calling for this and
> what results can they expect to see?

AFAIK, the existing open source applications that would be improved by this
system call are as follows:

* Through Userspace RCU library (http://urcu.so)
  - DNS server (Knot DNS) https://www.knot-dns.cz/
  - Network sniffer (http://netsniff-ng.org/)
  - Distributed object storage (https://sheepdog.github.io/sheepdog/)
  - User-space tracing (http://lttng.org)
  - Network storage system (https://www.gluster.org/)

Those projects use RCU in userspace to increase read-side speed and
scalability compared to locking. Especially in the case of RCU used
by libraries, sys_membarrier can speed up the read-side by moving the
bulk of the memory barrier cost to synchronize_rcu().

* Direct users of sys_membarrier
  - core dotnet garbage collector (https://github.com/dotnet/coreclr/issues/198)

Microsoft core dotnet GC developers are planning to use the mprotect()
side-effect of issuing memory barriers through IPIs as a way to implement Windows
FlushProcessWriteBuffers() on Linux. They are referring to sys_membarrier in their
github thread, specifically stating that sys_membarrier() is what they are looking
for.

> 
>> 
>> membarrier(2) man page:
>> --------------- snip -------------------
>> MEMBARRIER(2)              Linux Programmer's Manual             MEMBARRIER(2)
>> 
>> NAME
>>        membarrier - issue memory barriers on a set of threads
>> 
>> SYNOPSIS
>>        #include <linux/membarrier.h>
>> 
>>        int membarrier(int cmd, int flags);
>> 
>> DESCRIPTION
>>        The cmd argument is one of the following:
>> 
>>        MEMBARRIER_CMD_QUERY
>>               Query  the  set  of  supported commands. It returns a bitmask of
>>               supported commands.
>> 
>>        MEMBARRIER_CMD_SHARED
>>               Execute a memory barrier on all threads running on  the  system.
>>               Upon  return from system call, the caller thread is ensured that
>>               all running threads have passed through a state where all memory
>>               accesses  to  user-space  addresses  match program order between
>>               entry to and return from the system  call  (non-running  threads
>>               are de facto in such a state). This covers threads from all pro___
>>               cesses running on the system.  This command returns 0.
>> 
>>        The flags argument needs to be 0. For future extensions.
>> 
>>        All memory accesses performed  in  program  order  from  each  targeted
>>        thread is guaranteed to be ordered with respect to sys_membarrier(). If
>>        we use the semantic "barrier()" to represent a compiler barrier forcing
>>        memory  accesses  to  be performed in program order across the barrier,
>>        and smp_mb() to represent explicit memory barriers forcing full  memory
>>        ordering  across  the barrier, we have the following ordering table for
>>        each pair of barrier(), sys_membarrier() and smp_mb():
>> 
>>        The pair ordering is detailed as (O: ordered, X: not ordered):
>> 
>>                               barrier()   smp_mb() sys_membarrier()
>>               barrier()          X           X            O
>>               smp_mb()           X           O            O
>>               sys_membarrier()   O           O            O
>> 
>> RETURN VALUE
>>        On success, these system calls return zero.  On error, -1 is  returned,
>>        and errno is set appropriately. For a given command, with flags
>>        argument set to 0, this system call is guaranteed to always return the
>>        same value until reboot.
> 
> I suggest "with flags argument set to MEMBARRIER_CMD_QUERY" here.

No, the enum is for the "cmd" argument (see above) not the flags argument. We
really mean flags = 0 (the value) here.

> 
>> 
>> ERRORS
>>        ENOSYS System call is not implemented.
>> 
>>        EINVAL Invalid arguments.
>> 
>> ...
>>
>> +SYSCALL_DEFINE2(membarrier, int, cmd, int, flags)
>> +{
>> +	if (flags)
>> +		return -EINVAL;
> 
> I'm not a huge fan of this "add a flags arg to syscalls" rule.  Is
> there any realistic expectation that we'll ever *use* this thing?  If
> not, why add it?

I can see this system call evolve in a few ways in the future, such as
having an expedited version (using IPIs), targeting the local thread
group, and targeting all threads mapping a specific shared memory mapping.
I guess that the cmd argument should be enough to cover that, but
in doubt, it might be better to keep a flags argument there for future
needs we might be overlooking right now, so we never end up needing a
sys_membarrier2 system call.

> 
> You may as well put an unlikely() in there btw.

Will do.

Thanks!

Mathieu

> 
>> +	switch (cmd) {
>> +	case MEMBARRIER_CMD_QUERY:
>> +		return MEMBARRIER_CMD_BITMASK;
>> +	case MEMBARRIER_CMD_SHARED:
>> +		if (num_online_cpus() > 1)
>> +			synchronize_sched();
>> +		return 0;
>> +	default:
>> +		return -EINVAL;
>> +	}
> > +}

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

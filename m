From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH 1/3] getcpu_cache system call: cache CPU number of
 running thread
Date: Tue, 5 Jan 2016 17:31:45 +0000 (UTC)
Message-ID: <1079064730.338115.1452015105259.JavaMail.zimbra@efficios.com>
References: <1451977320-4886-1-git-send-email-mathieu.desnoyers@efficios.com> <1451977320-4886-2-git-send-email-mathieu.desnoyers@efficios.com> <20160105120400.GD10705@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160105120400.GD10705@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org, linux-api <linux-api@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Andi Kleen <andi@firstfloor.org>, Dave Watson <davejwatson@fb.com>, Chris Lameter <cl@linux.com>, Ingo Molnar <mingo@redhat.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

----- On Jan 5, 2016, at 7:04 AM, Will Deacon will.deacon@arm.com wrote:

> Hi Mathieu,
> 
> On Tue, Jan 05, 2016 at 02:01:58AM -0500, Mathieu Desnoyers wrote:
>> Expose a new system call allowing threads to register userspace memory
>> areas where to store the CPU number on which the calling thread is
>> running. Scheduler migration sets the TIF_NOTIFY_RESUME flag on the
>> current thread. Upon return to user-space, a notify-resume handler
>> updates the current CPU value within each registered user-space memory
>> area. User-space can then read the current CPU number directly from
>> memory.
> 
> What guarantees do you provide if a thread other than the one which
> registered the cache tries to access the value? Obviously, there's a
> potential data race here with the kernel issuing a parallel update, but
> are you intending to have single-copy atomicity semantics (like relaxed
> atomics in C11) or is this simply going to give you junk?
> 
> I ask because, in the absence of alignment checks on the cache pointer,
> we can't guarantee single-copy atomicity on ARM when the kernel writes
> the current CPU value.

Hi Will,

This is an excellent question. My initial thinking was that only the
thread registering the cache would read it, but now that you ask,
there might be use-cases where other threads would be interested in
reading each other's current CPU number.

For instance, an application could create a linked list or hash map
of thread control structures, which could contain the current CPU
number of each thread. A dispatch thread could then traverse or
lookup this structure to see on which CPU each thread is running and
do work queue dispatch or scheduling decisions accordingly.

This use-case would imply ensuring that reading the current CPU value
from another CPU will never result in reading a garbage value.

If we indeed intend to enable this use-case, we should:

1) Add an alignment check on the cpu_cache pointer. Should we
   return -EINVAL if unaligned ?
2) Document this alignment requirement in the man page, and the
   atomicity guarantees it provides,

The tiny downside of having this alignment requirement is that
it would not be possible to put the cpu_cache into a packed
structure. I don't think anyone would care though.

Thanks!

Mathieu


> 
> Cheers,
> 
> Will

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

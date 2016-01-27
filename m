From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH v2 1/3] getcpu_cache system call: cache CPU number
 of running thread
Date: Wed, 27 Jan 2016 21:02:44 +0000 (UTC)
Message-ID: <2037701859.6303.1453928564519.JavaMail.zimbra@efficios.com>
References: <1453913683-28915-1-git-send-email-mathieu.desnoyers@efficios.com> <1453913683-28915-2-git-send-email-mathieu.desnoyers@efficios.com> <20160127172044.GA7514@cloud> <alpine.DEB.2.11.1601271822190.3886@nanos> <2049061625.6140.1453916208296.JavaMail.zimbra@efficios.com> <20160127180353.GB7514@cloud> <604294939.6161.1453920216268.JavaMail.zimbra@efficios.com> <20160127191645.GA8045@cloud>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160127191645.GA8045@cloud>
Sender: linux-kernel-owner@vger.kernel.org
To: Josh Triplett <josh@joshtriplett.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org, linux-api <linux-api@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Andi Kleen <andi@firstfloor.org>, Dave Watson <davejwatson@fb.com>, Chris Lameter <cl@linux.com>, Ingo Molnar <mingo@redhat.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

----- On Jan 27, 2016, at 2:16 PM, Josh Triplett josh@joshtriplett.org wrote:

> On Wed, Jan 27, 2016 at 06:43:36PM +0000, Mathieu Desnoyers wrote:
>> ----- On Jan 27, 2016, at 1:03 PM, Josh Triplett josh@joshtriplett.org wrote:
>> 
>> > On Wed, Jan 27, 2016 at 05:36:48PM +0000, Mathieu Desnoyers wrote:
>> >> ----- On Jan 27, 2016, at 12:24 PM, Thomas Gleixner tglx@linutronix.de wrote:
>> >> > On Wed, 27 Jan 2016, Josh Triplett wrote:
>> >> >> With the dynamic allocation removed, this seems sensible to me.  One
>> >> >> minor nit: s/int32_t/uint32_t/g, since a location intended to hold a CPU
>> >> >> number should never need to hold a negative number.
>> >> > 
>> >> > You try to block the future of computing: https://lwn.net/Articles/638673/
>> >> 
>> >> Besides impossible architectures, there is actually a use-case for
>> >> signedness here. It makes it possible to initialize the cpu number
>> >> cache to a negative value, e.g. -1, in userspace. Then, a check for
>> >> value < 0 can be used to figure out cases where the getcpu_cache
>> >> system call is not implemented, and where a fallback (vdso or getcpu
>> >> syscall) needs to be used.
>> >> 
>> >> This is why I have chosen a signed type for the cpu cache so far.
>> > 
>> > If getcpu_cache doesn't exist, you'll get ENOSYS.  If getcpu_cache
>> > returns 0, then you can assume the kernel will give you a valid CPU
>> > number.
>> 
>> I'm referring to the code path that read the content of the cache.
>> This code don't call the getcpu_cache system call each time (this
>> would defeat the entire purpose of this cache), but still has to
>> know whether it can rely on the cache content to contain the current
>> CPU number. Seeing a "-1" there is a nice way to tell the fast path
>> that it needs to go through a fallback.
>> 
>> Or perhaps you have another mechanism in mind for that ? How do
>> you intend to communicate the ENOSYS from the kernel to all
>> eventual readers of the cache, without adding extra function
>> call overhead on the fast path ?
> 
> Have the fast path assume the cache, without even checking for -1; only
> use that fast path if getcpu_cache exists.  If you don't have
> getcpu_cache, don't even attempt to use the fast path; substitute in a
> fallback implementation.  Don't have a conditional in either version;
> just decide which version to use based on system capabilities.

I'm under the impression that we are talking past each other, because
I still don't get how your proposal works in practice without relying on
dynamic code patching.

Let's consider the following scenario:

Let's suppose getcpu_cache syscall gets a number assigned on ARM for kernel
4.6. We build an application against those kernel headers, so the application
will attempt to perform the getcpu_cache syscall to register the cache for
each thread.

However, said application is deployed on an older kernel, for which getcpu_cache
returns -1, errno=ENOSYS.

Within the fast-path, in our scenario, it would be a load instruction
fetching the cache within an inline assembly. How are we supposed to
turn that instruction into something else without dynamically patching
userspace code ?

One important aspect here is that we are not doing a function call to
get to the fast-path: the fast-path is inlined within the application
code.

> 
> Alternatively, use the implementation you have with a placeholder value,
> and just use 0xFFFFFFFF as the placeholder; that seems no more or
> less valid.

If we expect this comparison to be performed at every fast-path, it
would appear to produce slightly more compact code to compare against
0 (< 0) than to compare != 0xFFFFFFFF (even though cmp and test have
the same instruction throughput and latency based on Intel optimization
manuals).

e.g. on x86-64:

if (a < 0)

  400536:       85 c0                   test   %eax,%eax
  400538:       78 06                   js     400540 <fct+0x10>

-> 4 bytes


if (a != 0xFFFFFFFF)

  400536:       83 f8 ff                cmp    $0xffffffff,%eax
  400539:       74 15                   je     400550 <fct+0x20>

-> 5 bytes

I don't have a strong opinion there, but I wonder what is
the upside of having an unsigned value for the cpu number,
given that it makes the userspace code a bit more awkward
than with a signed value. If the goal is to support number
of CPUs higher than 2^31, then we should clearly think about
using a "long" type rather than int32_t for the CPU cache.

Thoughts ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

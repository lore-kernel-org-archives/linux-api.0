From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH for 4.18 12/23] cpu_opv: Provide cpu_opv system call
 (v7)
Date: Fri, 4 May 2018 10:32:53 -0400 (EDT)
Message-ID: <1883133260.11283.1525444373208.JavaMail.zimbra@efficios.com>
References: <20180412192800.15708-1-mathieu.desnoyers@efficios.com> <CA+55aFxcJ2V_1BoW0Cct=Kkp7REkgiU_BTimGdmoFmWHaWaZ-g@mail.gmail.com> <CALCETrVvaMWUJKx+bxXdEm3oVBzn2r5RuJ4JcXNzOPSgJAC5PA@mail.gmail.com> <542721578.11358.1523903708510.JavaMail.zimbra@efficios.com> <CA+55aFzZtY5ELKc+TGf9BA6px300BNzedadm_yNXzODTKN=HgQ@mail.gmail.com> <435471300.11403.1523906479091.JavaMail.zimbra@efficios.com> <CA+55aFxtZXi05UNLmtbKcZ=2N_ROE5pLnu9+v6FaXiuK=VbErA@mail.gmail.com> <1248652824.11527.1523912317964.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1248652824.11527.1523912317964.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Dave Watson <davejwatson@fb.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@a>
List-Id: linux-api@vger.kernel.org

----- On Apr 16, 2018, at 4:58 PM, Mathieu Desnoyers mathieu.desnoyers@efficios.com wrote:

> ----- On Apr 16, 2018, at 3:26 PM, Linus Torvalds torvalds@linux-foundation.org
> wrote:
> 
>> On Mon, Apr 16, 2018 at 12:21 PM, Mathieu Desnoyers
>> <mathieu.desnoyers@efficios.com> wrote:
>>>
>>> And I try very hard to avoid being told I'm the one breaking
>>> user-space. ;-)
>> 
>> You *can't* be breaking user space. User space doesn't use this yet.
>> 
>> That's actually why I'd like to start with the minimal set - to make
>> sure we don't introduce features that will come back to bite us later.
>> 
>> The one compelling use case I saw was a memory allocator that used
>> this for getting per-CPU (vs per-thread) memory scaling.
>> 
>> That code didn't need the cpu_opv system call at all.
>> 
>> And if somebody does a ldload of a malloc library, and then wants to
>> analyze the behavior of a program, maybe they should ldload their own
>> malloc routines first? That's pretty much par for the course for those
>> kinds of projects.
>> 
>> So I'd much rather we first merge the non-contentious parts that
>> actually have some numbers for "this improves performance and makes a
>> nice fancy malloc possible".
>> 
>> As it is, the cpu_opv seems to be all about theory, not about actual need.
> 
> I fully get your point about getting the minimal feature in. So let's focus
> on rseq only.
> 
> I will rework the patchset so the rseq selftests don't depend on cpu_opv,
> and remove the cpu_opv stuff. I think it would be a good start for the
> Facebook guys (jemalloc), given that just rseq seems to be enough for them
> for now. It should be enough for the arm64 performance counters as well.
> 
> Then we'll figure out what is needed to make other projects use it based on
> their needs (e.g. lttng-ust, liburcu, glibc malloc), and whether jemalloc
> end up requiring cpu_opv for memory migration between per-cpu pools after all.

So, having done this, I find myself in need of advice regarding smoothly
transitioning existing user-space programs/libraries to rseq. Let's consider
a situation where only rseq (without cpu_opv) eventually gets merged into
4.18.

The proposed rseq implementation presents the following constraints:

- Only a single rseq TLS can be registered per thread, therefore rseq needs
  to be "owned" by a single library (let's say it's librseq.so),
- User-space rseq critical sections need to be inlined into applications and
  libraries for performance reasons (extra branches and calls significantly
  degrade performance of those fast-paths).

I have a ring buffer "space reservation" use-case in my user-space tracer
which requires both rseq and cpu_opv.

My original plan to transition this fast-path to rseq was to test the
@cpu_id field value from the rseq TLS and use a fallback based on
atomic instructions if it is negative. rseq is already designed to ensure
we can compare @cpu_id against @cpu_id_start and detect both migration
(cpu id differs) and rseq ENOSYS with a single branch in the fast path.

Once rseq gets merged and deployed into kernels, this means librseq.so
will actually populate the rseq TLS, and this @cpu_id field will be >= 0.
If kernels are released with rseq but without cpu_opv, then I cannot use
this @cpu_id field to detect whether *both* rseq and cpu_opv are available.

I see a few possible ways to handle this, none of which are particularly
great:

1) Duplicate the entire implementation of the user-space functions where
   the rseq critical sections are inlined, and dynamically detect whether
   cpu_opv is available, and select the right function at runtime. If those
   functions are relatively small this could be acceptable,

2) Code patching based on asm goto. There is no user-space library for
   this at the moment AFAIK, and patching user-space code triggers COW,
   which is bad for TLB and cache locality,

3) Add an extra branch in the rseq fast-path. I would like to avoid this
   especially on arm32, where the cost of an extra branch is significant
   enough to outweigh the benefit of rseq compared to ll/sc.

So far, only option (1) seems relatively acceptable from my perspective,
but that's only because my functions using rseq are relatively small.
If this code bloat is not seen as acceptable, then we should revisit
merging both rseq and cpu_opv at the same time, and make sure CONFIG_RSEQ
selects CONFIG_CPU_OPV.

Thoughts ?

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

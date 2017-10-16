From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH v9 for 4.15 01/14] Restartable sequences system call
Date: Mon, 16 Oct 2017 22:17:43 +0000 (UTC)
Message-ID: <21865534.42661.1508192263844.JavaMail.zimbra@efficios.com>
References: <20171012230326.19984-1-mathieu.desnoyers@efficios.com> <DM5PR15MB1690DA99E4AA74FBE54CF7F9CF480@DM5PR15MB1690.namprd15.prod.outlook.com> <CA+55aFzPBES0JOYuZhuNM7NKN+G9ytZQT2daueFPw0j9HGpdGQ@mail.gmail.com> <20171013205418.GM3521@linux.vnet.ibm.com> <CA+55aFwvNS95ByZJTh1yG25QfaD0K0ZByK3iXeeRU8LafFiGFQ@mail.gmail.com> <135399003.40850.1507930608890.JavaMail.zimbra@efficios.com> <165916d7-2f86-445a-9c84-f6444b5e753b@redhat.com> <20171016164600.GO2482@two.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171016164600.GO2482@two.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: carlos <carlos@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Ben Maurer <bmaurer@fb.com>, David Goldblatt <davidgoldblatt@fb.com>, Qi Wang <qiwang@fb.com>, Boqun Feng <boqun.feng@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Josh Triplett <josh@joshtriplett.org>, Will Deacon <will.deacon@arm.com>, linux-kernel <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Chris Lameter <cl@linux.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, rostedt <rostedt@goodmis.org>, Andrew Morton <akpm@linux-foundation.org>, Russ
List-Id: linux-api@vger.kernel.org

----- On Oct 16, 2017, at 12:46 PM, Andi Kleen andi@firstfloor.org wrote:

>> How you collect, summarize, and analyze that overwhelming evidence
>> is up to you, specific to each change, and difficult to do accurately
>> and with any large measure of statistical confidence. The reviewer
>> has to basically trust you to some degree :-)
> 
> I think Linus' just asked for some working "real world, not micro" code that
> demonstrates use.
> 
> A prototype type implementation of the glibc malloc cache using this may
> be good enough.
> 
> Even if the API still changes slightly later in review I would assume
> the basic concepts will stay the same, so it would be likely not
> too difficult to convert that prototype to the later final API.

In that respect, I have working prototypes of two non-trivial library
projects using rseq within the same process.

Those can be considered as being "early adopters" of rseq, before it
becomes available in glibc.

- liburcu per-cpu flavor prototype [1]
  Interesting bits at
  https://github.com/compudj/userspace-rcu-dev/blob/urcu-percpu/include/urcu/static/urcu-percpu.h
  https://github.com/compudj/userspace-rcu-dev/blob/urcu-percpu/src/urcu-percpu.c
  (it also has its own copy of rseq and cpu-opv helper libraries)

- lttng-ust tracer rseq prototype [2, 3]
  Interesting bits at
  https://github.com/compudj/lttng-ust-dev/blob/rseq-integration-oct-2017/libringbuffer/getcpu.h#L85
  https://github.com/compudj/lttng-ust-dev/blob/rseq-integration-oct-2017/libringbuffer/vatomic.h#L60
  (it also has its own copy of rseq and cpu-opv helper libraries)

They use a slightly updated version of the rseq patchset, which I
plan to push into a new "rseq" tree on kernel.org soon. It takes care
of the comments I received in the past few days.

They end up sharing the "__rseq_abi" TLS weak symbol (initial state of
cpu_id = -1). They lazy-detect whether rseq needs to be registered for
the current thread by checking if the cpu_id read from the rseq TLS
is < 0. If rseq registration fails, they set its value to -2 and won't
try to register again (will use their fallback). When they successfully
register, they setup a pthread_key so rseq is unregistered when the
thread exits.

So far the restrictions I see for libraries using this symbol are:
- They should never be unloaded,
- They should never be loaded with dlopen RTLD_LOCAL flag.

If those are considered acceptable limitations, then we can stick to
the "single rseq TLS per thread" rule, and we don't have to implement
a linked-list of rseq TLS per thread.

When glibc eventually adds support for rseq, I expect it to deal with
rseq TLS registration and unregistration at thread creation/exit.
Therefore, the checks for negative cpu_id performed by lttng-ust and
liburcu will figure out that rseq is already registered, and skip
registration altogether when it's already performed by glibc.

Thoughts ?

Thanks,

Mathieu

[1] https://github.com/compudj/userspace-rcu-dev/tree/urcu-percpu
[2] https://github.com/compudj/lttng-ust-dev/tree/rseq-integration-oct-2017
[3] https://github.com/compudj/lttng-tools-dev/tree/urcu-percpu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

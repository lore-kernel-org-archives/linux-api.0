From: Paul Turner <pjt@google.com>
Subject: [RFC PATCH 0/3] restartable sequences: fast user-space percpu
 critical sections
Date: Wed, 24 Jun 2015 15:26:09 -0700
Message-ID: <20150624222609.6116.86035.stgit@kitami.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Lai Jiangshan <laijs@cn.fujitsu.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, Linus Torvalds <torvalds@linux-foundation.org>, Chris Lameter <cl@linux.com>
List-Id: linux-api@vger.kernel.org

This is a fairly small series demonstrating a feature we've found to be quite
powerful in practice, "restartable sequences".

Most simply: these sequences comprise small snippets of user-code that are
guaranteed to be (effectively) executed serially, with support for restart (or
other handling) in the event of preemption or interruption.

This (when combined with an in-memory cpu-id; potentially optional on some
architectures) can be used to implement extremely fast per-cpu operations that
do not rely on the use of actual processor atomics.  We've used this to back
performance critical code such as our malloc implementation with good results.

We previously discussed this feature at LPC:
  http://www.linuxplumbersconf.org/2013/ocw/system/presentations/1695/original/LPC%20-%20PerCpu%20Atomics.pdf

Mathieu Desnoyers posted an alternate implementation based on the ideas above
at:
  https://lkml.org/lkml/2015/5/21/472

This RFC is based on the approach we currently use internally.  However, I'll
likely posit that neither this approach, nor the one posted above, is what we
should ultimately adopt (provided sufficient interest exists).

The implementation in this series can be summarized as follows:
- We allow a single (per-address) space critical section (and associated
  handler) to be defined.
- When a thread with RSEQ configured (via new syscall) is interrupted within
  a critical section, we modify its return address.  Either within signal
  delivery, or the notify-resume path.  The scheduler touchpoint is only a
  preempt_notifier which (potentially, dependent on config) examines the
  kernel copy of pt_regs.

There are a few core requirements which motivate the approach taken here:
1) We must not interfere with regular scheduling.  Unlike preemption protection
   (or similar), there are no special considerations for code running within a
   critical region beyond that we must move to the restart handler if
   interrupted.
2) The code executing in scheduler context must be tightly constrained, both in
   terms of overhead and that it must not require access to user memory.
3) The fast-path must be fast.  That is, user entry/execution/exit of a
   non-interrupted critical section is the most important case.  The restart
   handler is a 'slow' path that should only happen comparatively infrequently.
   We're strongly motivated here by high-performance, low-level primitives:
   think malloc, or rcu_read_lock.

While the contained implementation performs well under these constraints, it
has some notable limitations which we should consider for more general usage:

1) The definition of a single region works well for statically linked binaries
   but can be challenging when shared-libraries want to use this feature.  This
   is partially mitigated in our experience that a library of primitives is
   generally more useful than a myriad of custom sequences, but it's still a
   major concern.
2) Due to the nature of restart and explicit location requirements it's only
   really reasonable to write this critical section in assembly; which makes
   porting and maintenance less convenient.  (One of the included tests shows a
   reasonable example of what this looks like.)
3) TLS spreads the entrails of its implementation all over compile _and_ link.
   This makes properly handling it within the critical section cumbersome in
   the shared binary case.

We've been thinking about how to address these issues and are considering some
alternate ABIs that still satisfy (1)-(3), but have a more convenient
programming model.  I'll send this as a follow-up, but wanted to first share
the approach we've used to date.

Thanks,

- Paul

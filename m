From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH for 4.18 0/3] rseq: minor fixes, cleanup
Date: Tue, 19 Jun 2018 09:32:27 -0400
Message-ID: <20180619133230.4087-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@g>
List-Id: linux-api@vger.kernel.org

Hi Thomas,

Those are 2 small fixes, and a cleanup to the rseq feature, targeting
4.18.

The first fix takes care of an issue that arose in the integration of
the rseq patchset (executable bit on run_param_test.sh was lost). The
second fix aligns struct rseq_cs on 32 bytes on arm32, following the
rseq.h alignment requirements.

The last patch is a cleanup: given that we have decided that system
calls were not allowed in rseq critical sections, fork/clone cannot
be done in a rseq c.s.. Therefore, there is no need to abort a rseq
critical section within the child on fork of a new process.

Thanks,

Mathieu


Mathieu Desnoyers (3):
  rseq/selftests: run_param_test.sh should be executable
  rseq/selftests: arm: align struct rseq_cs on 32 bytes
  rseq: cleanup: no need to abort rseq c.s. in child on fork

 include/linux/sched.h                          | 5 +----
 tools/testing/selftests/rseq/rseq-arm.h        | 1 +
 tools/testing/selftests/rseq/run_param_test.sh | 0
 3 files changed, 2 insertions(+), 4 deletions(-)
 mode change 100644 => 100755 tools/testing/selftests/rseq/run_param_test.sh

-- 
2.11.0

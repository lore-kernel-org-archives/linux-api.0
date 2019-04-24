From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH for 5.2 00/10] Restartable Sequences selftests updates
Date: Wed, 24 Apr 2019 11:24:52 -0400
Message-ID: <20190424152502.14246-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Joel Fernandes <joelaf@google.com>, Shuah Khan <shuah@kernel.org>
List-Id: linux-api@vger.kernel.org

Those rseq selftests updates are hereby submitted for feedback.

They change the per-architecture pre-abort signatures to ensure those
are valid trap instructions.

The way exit points are presented to debuggers is enhanced, ensuring
all exit points are present, so debuggers don't have to disassemble
rseq critical section to properly skip over them.

Also, discussions with the glibc community is reaching a concensus
of exposing a __rseq_handled symbol from glibc to coexist with
rseq early adopters. Update the rseq selftest code to use this
symbol.

Feedback is welcome.

Thanks,

Mathieu

Martin Schwidefsky (1):
  rseq/selftests: s390: use trap4 for RSEQ_SIG

Mathieu Desnoyers (9):
  rseq/selftests: Add __rseq_exit_point_array section for debuggers
  rseq/selftests: Introduce __rseq_cs_ptr_array, rename __rseq_table to
    __rseq_cs
  rseq/selftests: Use __rseq_handled symbol to coexist with glibc
  rseq/selftests: s390: use jg instruction for jumps outside of the asm
  rseq/selftests: x86: use ud1 instruction as RSEQ_SIG opcode
  rseq/selftests: arm: use udf instruction for RSEQ_SIG
  rseq/selftests: aarch64 code signature: handle big-endian environment
  rseq/selftests: powerpc code signature: generate valid instructions
  rseq/selftests: mips: use break instruction for RSEQ_SIG

 tools/testing/selftests/rseq/rseq-arm.h   | 132 ++++++++++++++++++++++++++----
 tools/testing/selftests/rseq/rseq-arm64.h |  74 ++++++++++++++++-
 tools/testing/selftests/rseq/rseq-mips.h  |  87 +++++++++++++++++---
 tools/testing/selftests/rseq/rseq-ppc.h   |  90 ++++++++++++++++++--
 tools/testing/selftests/rseq/rseq-s390.h  |  78 ++++++++++++++++--
 tools/testing/selftests/rseq/rseq-x86.h   | 120 +++++++++++++++++++++++++--
 tools/testing/selftests/rseq/rseq.c       |  55 +++++++++++--
 tools/testing/selftests/rseq/rseq.h       |   1 +
 8 files changed, 583 insertions(+), 54 deletions(-)

-- 
2.11.0

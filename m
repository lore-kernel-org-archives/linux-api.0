From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH 0/2] rseq/selftests: debugger single-stepping helper sections
Date: Thu, 14 Mar 2019 15:03:44 -0400
Message-ID: <20190314190346.24744-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@g>
List-Id: linux-api@vger.kernel.org

Hi,

Those RFC patches improves the rseq selftests to properly expose data
sections helping debuggers to step over rseq critical sections.

* Add a new __rseq_exit_point_array section describing all rseq critical
  section exit points so debuggers can properly step over those. This is
  based on discussions with gdb and DynamoRIO developers.

* The __rseq_table section contains structures that are aligned on 32
  bytes, and in some cases the entries may not be aligned with the
  beginning of the section. Rename this section to __rseq_cs, and create
  a new __rseq_cs_ptr_array section containing packed 64-bit pointers to
  those __rseq_cs entries.

Thanks,

Mathieu


Mathieu Desnoyers (2):
  rseq/selftests: Add __rseq_exit_point_array section for debuggers
  rseq/selftests: Introduce __rseq_cs_ptr_array, rename __rseq_table to
    __rseq_cs

 tools/testing/selftests/rseq/rseq-arm.h   |  80 +++++++++++++++++++----
 tools/testing/selftests/rseq/rseq-arm64.h |  57 +++++++++++++++-
 tools/testing/selftests/rseq/rseq-mips.h  |  81 +++++++++++++++++++----
 tools/testing/selftests/rseq/rseq-ppc.h   |  80 +++++++++++++++++++++--
 tools/testing/selftests/rseq/rseq-s390.h  |  65 +++++++++++++++++-
 tools/testing/selftests/rseq/rseq-x86.h   | 105 +++++++++++++++++++++++++++++-
 6 files changed, 435 insertions(+), 33 deletions(-)

-- 
2.11.0

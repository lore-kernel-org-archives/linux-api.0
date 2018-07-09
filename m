From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH v2 for 4.18 0/6] Restartable Sequences updates
Date: Mon,  9 Jul 2018 15:51:49 -0400
Message-ID: <20180709195155.7654-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@g>
List-Id: linux-api@vger.kernel.org

Following the recent discussion thread [1] about rseq uapi, here is
a set of updates submitted for integration into 4.18. Those change all
rseq __get_user/__put_user for get_user/put_user as discussed, and
use copy_from_user()/clear_user() to load and clear the rseq_cs __u64.

Thanks,

Mathieu

[1] https://lkml.kernel.org/r/20180702223143.4663-1-mathieu.desnoyers@efficios.com

Mathieu Desnoyers (6):
  rseq: use __u64 for rseq_cs fields, validate user inputs
  rseq: use get_user/put_user rather than __get_user/__put_user
  rseq: uapi: update uapi comments
  rseq: uapi: declare rseq_cs field as union, update includes
  rseq: remove unused types_32_64.h uapi header
  rseq/selftests: cleanup: update comment above rseq_prepare_unload

 include/uapi/linux/rseq.h           | 102 ++++++++++++++++++++----------------
 include/uapi/linux/types_32_64.h    |  50 ------------------
 kernel/rseq.c                       |  41 +++++++++------
 tools/testing/selftests/rseq/rseq.h |  24 ++++++---
 4 files changed, 100 insertions(+), 117 deletions(-)
 delete mode 100644 include/uapi/linux/types_32_64.h

-- 
2.11.0

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH for 5.4 0/3] Restartable Sequences Fixes
Date: Tue, 17 Sep 2019 14:29:56 -0400
Message-ID: <20190917182959.16333-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, "H . Peter Anvin" <hpa@zytor.com>, Paul Turner <pjt@google.com>, linux-api@vger.kernel.org, stable@vger.kernel.org, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
List-Id: linux-api@vger.kernel.org

Hi,

Here is a small set of rseq fixes aiming Linux 5.4. Those should be
backported to stable kernels >= 4.18.

Thanks,

Mathieu

Mathieu Desnoyers (3):
  rseq: Fix: Reject unknown flags on rseq unregister
  rseq: Fix: Unregister rseq for clone CLONE_VM
  rseq/selftests: Fix: Namespace gettid() for compatibility with glibc
    2.30

 include/linux/sched.h                     |  4 ++--
 kernel/rseq.c                             |  2 ++
 tools/testing/selftests/rseq/param_test.c | 18 ++++++++++--------
 3 files changed, 14 insertions(+), 10 deletions(-)

-- 
2.17.1

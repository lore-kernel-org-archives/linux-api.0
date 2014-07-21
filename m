From: Waiman Long <Waiman.Long@hp.com>
Subject: [RFC PATCH 5/5] futex, doc: add a document on how to use the spinning futexes
Date: Mon, 21 Jul 2014 11:24:31 -0400
Message-ID: <1405956271-34339-6-git-send-email-Waiman.Long@hp.com>
References: <1405956271-34339-1-git-send-email-Waiman.Long@hp.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1405956271-34339-1-git-send-email-Waiman.Long@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Darren Hart <dvhart@linux.intel.com>, Davidlohr Bueso <davidlohr@hp.com>, Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, Jason Low <jason.low2@hp.com>, Scott J Norton <scott.norton@hp.com>, Waiman Long <Waiman.Long@hp.com>
List-Id: linux-api@vger.kernel.org

This patch adds a new document file on how to use the spinning futexes.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 Documentation/spinning-futex.txt |  109 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 109 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/spinning-futex.txt

diff --git a/Documentation/spinning-futex.txt b/Documentation/spinning-futex.txt
new file mode 100644
index 0000000..e3cb5a2
--- /dev/null
+++ b/Documentation/spinning-futex.txt
@@ -0,0 +1,109 @@
+Started by: Waiman Long <waiman.long@hp.com>
+
+Spinning Futex
+--------------
+
+There are two main problems for a wait-wake futex (FUTEX_WAIT and
+FUTEX_WAKE) when used for creating user-space lock primitives:
+
+ 1) With a wait-wake futex, tasks waiting for a lock are put to sleep
+    in the futex queue to be woken up by the lock owner when it is done
+    with the lock. Waking up a sleeping task, however, introduces some
+    additional latency which can be large especially if the critical
+    section protected by the lock is relatively short. This may cause
+    a performance bottleneck on large systems with many CPUs running
+    applications that need a lot of inter-thread synchronization.
+
+ 2) The performance of the wait-wake futex is currently
+    spinlock-constrained.  When many threads are contending for a
+    futex in a large system with many CPUs, it is not unusual to have
+    spinlock contention accounting for more than 90% of the total
+    CPU cycles consumed at various points in time.
+
+Spinning futex is a solution to both the wakeup latency and spinlock
+contention problems by optimistically spinning on a locked futex
+when the lock owner is running within the kernel until the lock is
+free. This is the same optimistic spinning mechanism used by the kernel
+mutex and rw semaphore implementations to improve performance. The
+optimistic spinning was done without taking any lock.
+
+Implementation
+--------------
+
+Like the PI and robust futexes, a lock acquirer has to atomically
+put its thread ID (TID) into the lower 30 bits of the 32-bit futex
+which should has an original value of 0. If it succeeds, it will be
+the owner of the futex. Otherwise, it has to call into the kernel
+using the new FUTEX_SPIN_LOCK futex(2) syscall.
+
+The kernel will use the setting of the most significant bit
+(FUTEX_WAITERS) in the futex value to indicate one or more waiters
+are sleeping and need to be woken up later on.
+
+When it is time to unlock, the lock owner has to atomically clear
+the TID portion of the futex value. If the FUTEX_WAITERS bit is set,
+it has to issue a FUTEX_SPIN_UNLOCK futex system call to wake up the
+sleeping task.
+
+A return value of 1 from the FUTEX_SPIN_UNLOCK futex(2) syscall
+indicates a task has been woken up. The syscall returns 0 if no
+sleeping task is found or spinners are present to take the lock.
+
+The error number returned by a FUTEX_SPIN_UNLOCK call on an empty
+futex can be used to decide if the spinning futex functionality is
+implemented in the kernel. If it is present, the returned error number
+should be ESRCH. Otherwise it will be ENOSYS.
+
+Currently, only the first and the second arguments (the futex address
+and the opcode) of the futex(2) syscall is used. All the other
+arguments must be set to 0 or NULL to avoid forward compatibility
+problem.
+
+The spinning futex requires the kernel to have support for the cmpxchg
+functionality. For architectures that don't support cmpxchg, spinning
+futex will not be supported as well.
+
+Usage Scenario
+--------------
+
+A spinning futex can be used as an exclusive lock to guard a critical
+section which are unlikely to go to sleep in the kernel. The spinners
+in a spinning futex, however, will fall back to sleep in a wait queue
+if the lock owner isn't running. Therefore, it can also be used when
+the critical section is long and prone to sleeping. However, it may
+not have the performance benefit when compared with a wait-wake futex
+in this case.
+
+Sample Code
+-----------
+
+The following are sample code to implement a simple lock and unlock
+function.
+
+__thread int tid;	/* Thread ID */
+
+void mutex_lock(int *faddr)
+{
+	if (cmpxchg(faddr, 0, tid) == 0)
+		return;
+	for (;;)
+		if (futex(faddr, FUTEX_SPIN_LOCK, ...) == 0)
+			break;
+}
+
+void mutex_unlock(int *faddr)
+{
+	int old, fval;
+
+	if ((fval = cmpxchg(faddr, tid, 0)) == tid)
+		return;
+	/* Clear only the TID portion of the futex */
+	for (;;) {
+		old  = fval;
+		fval = cmpxchg(faddr, old, old & ~FUTEX_TID_MASK);
+		if (fval == old)
+			break;
+	}
+	if (fval & FUTEX_WAITERS)
+		futex(faddr, FUTEX_SPIN_UNLOCK, ...);
+}
-- 
1.7.1

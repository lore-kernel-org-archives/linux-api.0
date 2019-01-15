From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH glibc 2/4] glibc: sched_getcpu(): use rseq cpu_id TLS on Linux
Date: Mon, 14 Jan 2019 20:51:46 -0500
Message-ID: <20190115015148.32155-2-mathieu.desnoyers@efficios.com>
References: <20190115015148.32155-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190115015148.32155-1-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Carlos O'Donell <carlos@redhat.com>
Cc: Florian Weimer <fweimer@redhat.com>, Joseph Myers <joseph@codesourcery.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha@sourceware.org, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

When available, use the cpu_id field from __rseq_abi on Linux to
implement sched_getcpu(). Fall-back on the vgetcpu vDSO if unavailable.

Benchmarks:

x86-64: Intel E5-2630 v3@2.40GHz, 16-core, hyperthreading

glibc sched_getcpu():                     13.7 ns (baseline)
glibc sched_getcpu() using rseq:           2.5 ns (speedup:  5.5x)
inline load cpuid from __rseq_abi TLS:     0.8 ns (speedup: 17.1x)

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Carlos O'Donell <carlos@redhat.com>
CC: Florian Weimer <fweimer@redhat.com>
CC: Joseph Myers <joseph@codesourcery.com>
CC: Szabolcs Nagy <szabolcs.nagy@arm.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ben Maurer <bmaurer@fb.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: Boqun Feng <boqun.feng@gmail.com>
CC: Will Deacon <will.deacon@arm.com>
CC: Dave Watson <davejwatson@fb.com>
CC: Paul Turner <pjt@google.com>
CC: libc-alpha@sourceware.org
CC: linux-kernel@vger.kernel.org
CC: linux-api@vger.kernel.org
---
 sysdeps/unix/sysv/linux/sched_getcpu.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/sysdeps/unix/sysv/linux/sched_getcpu.c b/sysdeps/unix/sysv/linux/sched_getcpu.c
index b69eeda15c..37fda59d36 100644
--- a/sysdeps/unix/sysv/linux/sched_getcpu.c
+++ b/sysdeps/unix/sysv/linux/sched_getcpu.c
@@ -24,8 +24,8 @@
 #endif
 #include <sysdep-vdso.h>
 
-int
-sched_getcpu (void)
+static int
+vsyscall_sched_getcpu (void)
 {
 #ifdef __NR_getcpu
   unsigned int cpu;
@@ -37,3 +37,24 @@ sched_getcpu (void)
   return -1;
 #endif
 }
+
+#ifdef __NR_rseq
+#include <linux/rseq.h>
+
+extern __attribute__ ((tls_model ("initial-exec")))
+__thread volatile struct rseq __rseq_abi;
+
+int
+sched_getcpu (void)
+{
+  int cpu_id = __rseq_abi.cpu_id;
+
+  return cpu_id >= 0 ? cpu_id : vsyscall_sched_getcpu ();
+}
+#else
+int
+sched_getcpu (void)
+{
+  return vsyscall_sched_getcpu ();
+}
+#endif
-- 
2.17.1

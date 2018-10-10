From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH for 4.21 13/16] cpu-opv/selftests: Provide percpu_op API
Date: Wed, 10 Oct 2018 15:19:33 -0400
Message-ID: <20181010191936.7495-14-mathieu.desnoyers@efficios.com>
References: <20181010191936.7495-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181010191936.7495-1-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Joel Fernandes <joelaf@google.com>, Mathieu Desnoyers <mathieu.desnoyers@ef>
List-Id: linux-api@vger.kernel.org

Introduce percpu-op.h API. It uses rseq internally as fast-path if
invoked from the right CPU, else cpu_opv as slow-path if called
from the wrong CPU or if rseq fails.

This allows acting on per-cpu data from various CPUs transparently from
user-space: cpu_opv will take care of migrating the thread to the
requested CPU. Use-cases such as rebalancing memory across per-cpu
memory pools, or migrating tasks for a user-space scheduler, are thus
facilitated. This also handles debugger single-stepping.

The use from userspace is, e.g. for a counter increment:

    int cpu, ret;

    cpu = percpu_current_cpu();
    ret = percpu_addv(&data->c[cpu].count, 1, cpu);
    if (unlikely(ret)) {
         perror("percpu_addv");
         return -1;
    }
    return 0;

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Shuah Khan <shuah@kernel.org>
CC: Russell King <linux@arm.linux.org.uk>
CC: Catalin Marinas <catalin.marinas@arm.com>
CC: Will Deacon <will.deacon@arm.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Paul Turner <pjt@google.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Andy Lutomirski <luto@amacapital.net>
CC: Andi Kleen <andi@firstfloor.org>
CC: Dave Watson <davejwatson@fb.com>
CC: Chris Lameter <cl@linux.com>
CC: Ingo Molnar <mingo@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Ben Maurer <bmaurer@fb.com>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: Josh Triplett <josh@joshtriplett.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Boqun Feng <boqun.feng@gmail.com>
CC: linux-kselftest@vger.kernel.org
CC: linux-api@vger.kernel.org
---
 tools/testing/selftests/cpu-opv/percpu-op.h | 151 ++++++++++++++++++++++++++++
 1 file changed, 151 insertions(+)
 create mode 100644 tools/testing/selftests/cpu-opv/percpu-op.h

diff --git a/tools/testing/selftests/cpu-opv/percpu-op.h b/tools/testing/selftests/cpu-opv/percpu-op.h
new file mode 100644
index 000000000000..ffc64b268fd3
--- /dev/null
+++ b/tools/testing/selftests/cpu-opv/percpu-op.h
@@ -0,0 +1,151 @@
+/* SPDX-License-Identifier: LGPL-2.1 OR MIT */
+/*
+ * percpu-op.h
+ *
+ * (C) Copyright 2017-2018 - Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+ */
+
+#ifndef PERCPU_OP_H
+#define PERCPU_OP_H
+
+#include <stdint.h>
+#include <stdbool.h>
+#include <errno.h>
+#include <stdlib.h>
+#include "rseq.h"
+#include "cpu-op.h"
+
+static inline uint32_t percpu_current_cpu(void)
+{
+	return rseq_current_cpu();
+}
+
+static inline __attribute__((always_inline))
+int percpu_cmpeqv_storev(intptr_t *v, intptr_t expect, intptr_t newv,
+			 int cpu)
+{
+	int ret;
+
+	ret = rseq_cmpeqv_storev(v, expect, newv, cpu);
+	if (rseq_unlikely(ret)) {
+		if (ret > 0)
+			return ret;
+		return cpu_op_cmpeqv_storev(v, expect, newv, cpu);
+	}
+	return 0;
+}
+
+static inline __attribute__((always_inline))
+int percpu_cmpnev_storeoffp_load(intptr_t *v, intptr_t expectnot,
+			       off_t voffp, intptr_t *load, int cpu)
+{
+	int ret;
+
+	ret = rseq_cmpnev_storeoffp_load(v, expectnot, voffp, load, cpu);
+	if (rseq_unlikely(ret)) {
+		if (ret > 0)
+			return ret;
+		return cpu_op_cmpnev_storeoffp_load(v, expectnot, voffp,
+						    load, cpu);
+	}
+	return 0;
+}
+
+static inline __attribute__((always_inline))
+int percpu_addv(intptr_t *v, intptr_t count, int cpu)
+{
+	if (rseq_unlikely(rseq_addv(v, count, cpu)))
+		return cpu_op_addv(v, count, cpu);
+	return 0;
+}
+
+static inline __attribute__((always_inline))
+int percpu_cmpeqv_storev_storev(intptr_t *v, intptr_t expect,
+				intptr_t *v2, intptr_t newv2,
+				intptr_t newv, int cpu)
+{
+	int ret;
+
+	ret = rseq_cmpeqv_trystorev_storev(v, expect, v2, newv2,
+					   newv, cpu);
+	if (rseq_unlikely(ret)) {
+		if (ret > 0)
+			return ret;
+		return cpu_op_cmpeqv_storev_storev(v, expect, v2, newv2,
+						   newv, cpu);
+	}
+	return 0;
+}
+
+static inline __attribute__((always_inline))
+int percpu_cmpeqv_storev_storev_release(intptr_t *v, intptr_t expect,
+					intptr_t *v2, intptr_t newv2,
+					intptr_t newv, int cpu)
+{
+	int ret;
+
+	ret = rseq_cmpeqv_trystorev_storev_release(v, expect, v2, newv2,
+						   newv, cpu);
+	if (rseq_unlikely(ret)) {
+		if (ret > 0)
+			return ret;
+		return cpu_op_cmpeqv_storev_mb_storev(v, expect, v2, newv2,
+						      newv, cpu);
+	}
+	return 0;
+}
+
+static inline __attribute__((always_inline))
+int percpu_cmpeqv_cmpeqv_storev(intptr_t *v, intptr_t expect,
+				intptr_t *v2, intptr_t expect2,
+				intptr_t newv, int cpu)
+{
+	int ret;
+
+	ret = rseq_cmpeqv_cmpeqv_storev(v, expect, v2, expect2, newv, cpu);
+	if (rseq_unlikely(ret)) {
+		if (ret > 0)
+			return ret;
+		return cpu_op_cmpeqv_cmpeqv_storev(v, expect, v2, expect2,
+						   newv, cpu);
+	}
+	return 0;
+}
+
+static inline __attribute__((always_inline))
+int percpu_cmpeqv_memcpy_storev(intptr_t *v, intptr_t expect,
+				void *dst, void *src, size_t len,
+				intptr_t newv, int cpu)
+{
+	int ret;
+
+	ret = rseq_cmpeqv_trymemcpy_storev(v, expect, dst, src, len,
+					   newv, cpu);
+	if (rseq_unlikely(ret)) {
+		if (ret > 0)
+			return ret;
+		return cpu_op_cmpeqv_memcpy_storev(v, expect, dst, src, len,
+						   newv, cpu);
+	}
+	return 0;
+}
+
+static inline __attribute__((always_inline))
+int percpu_cmpeqv_memcpy_storev_release(intptr_t *v, intptr_t expect,
+					void *dst, void *src, size_t len,
+					intptr_t newv, int cpu)
+{
+	int ret;
+
+	ret = rseq_cmpeqv_trymemcpy_storev_release(v, expect, dst, src, len,
+						   newv, cpu);
+	if (rseq_unlikely(ret)) {
+		if (ret > 0)
+			return ret;
+		return cpu_op_cmpeqv_memcpy_mb_storev(v, expect, dst, src, len,
+						      newv, cpu);
+	}
+	return 0;
+}
+
+#endif  /* PERCPU_OP_H_ */
-- 
2.11.0

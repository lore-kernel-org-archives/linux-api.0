From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH for 4.21 11/16] cpu-opv/selftests: Provide cpu-op library
Date: Thu,  1 Nov 2018 10:58:39 +0100
Message-ID: <20181101095844.24462-12-mathieu.desnoyers@efficios.com>
References: <20181101095844.24462-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181101095844.24462-1-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Joel Fernandes <joelaf@google.com>, Mathieu Desnoyers <mathieu.desnoyers@ef>
List-Id: linux-api@vger.kernel.org

This cpu-op helper library provides a user-space API to the cpu_opv()
system call.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Joel Fernandes <joelaf@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Watson <davejwatson@fb.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: linux-kselftest@vger.kernel.org
Cc: "H . Peter Anvin" <hpa@zytor.com>
Cc: Chris Lameter <cl@linux.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Paul Turner <pjt@google.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ben Maurer <bmaurer@fb.com>
Cc: linux-api@vger.kernel.org
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
 tools/testing/selftests/cpu-opv/cpu-op.c | 362 +++++++++++++++++++++++++++++++
 tools/testing/selftests/cpu-opv/cpu-op.h |  43 ++++
 2 files changed, 405 insertions(+)
 create mode 100644 tools/testing/selftests/cpu-opv/cpu-op.c
 create mode 100644 tools/testing/selftests/cpu-opv/cpu-op.h

diff --git a/tools/testing/selftests/cpu-opv/cpu-op.c b/tools/testing/selftests/cpu-opv/cpu-op.c
new file mode 100644
index 000000000000..0cdc39bffbbf
--- /dev/null
+++ b/tools/testing/selftests/cpu-opv/cpu-op.c
@@ -0,0 +1,362 @@
+// SPDX-License-Identifier: LGPL-2.1
+/*
+ * cpu-op.c
+ *
+ * Copyright (C) 2017 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+ *
+ * This library is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU Lesser General Public
+ * License as published by the Free Software Foundation; only
+ * version 2.1 of the License.
+ *
+ * This library is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * Lesser General Public License for more details.
+ */
+
+#define _GNU_SOURCE
+#include <errno.h>
+#include <sched.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <syscall.h>
+#include <assert.h>
+#include <signal.h>
+
+#include "cpu-op.h"
+
+#define ARRAY_SIZE(arr)	(sizeof(arr) / sizeof((arr)[0]))
+
+#define ACCESS_ONCE(x)		(*(__volatile__  __typeof__(x) *)&(x))
+#define WRITE_ONCE(x, v)	__extension__ ({ ACCESS_ONCE(x) = (v); })
+#define READ_ONCE(x)		ACCESS_ONCE(x)
+
+int cpu_opv(struct cpu_op *cpu_opv, int cpuopcnt, int cpu, int flags)
+{
+	return syscall(__NR_cpu_opv, cpu_opv, cpuopcnt, cpu, flags);
+}
+
+int cpu_op_get_current_cpu(void)
+{
+	int cpu;
+
+	cpu = sched_getcpu();
+	if (cpu < 0) {
+		perror("sched_getcpu()");
+		abort();
+	}
+	return cpu;
+}
+
+int cpu_op_cmpxchg(void *v, void *expect, void *old, void *n, size_t len,
+		   int cpu)
+{
+	struct cpu_op opvec[] = {
+		[0] = {
+			.op = CPU_MEMCPY_OP,
+			.len = len,
+			.u.memcpy_op.dst = (unsigned long)old,
+			.u.memcpy_op.src = (unsigned long)v,
+			.u.memcpy_op.expect_fault_dst = 0,
+			.u.memcpy_op.expect_fault_src = 0,
+		},
+		[1] = {
+			.op = CPU_COMPARE_EQ_OP,
+			.len = len,
+			.u.compare_op.a = (unsigned long)v,
+			.u.compare_op.b = (unsigned long)expect,
+			.u.compare_op.expect_fault_a = 0,
+			.u.compare_op.expect_fault_b = 0,
+		},
+		[2] = {
+			.op = CPU_MEMCPY_OP,
+			.len = len,
+			.u.memcpy_op.dst = (unsigned long)v,
+			.u.memcpy_op.src = (unsigned long)n,
+			.u.memcpy_op.expect_fault_dst = 0,
+			.u.memcpy_op.expect_fault_src = 0,
+		},
+	};
+
+	return cpu_opv(opvec, ARRAY_SIZE(opvec), cpu, 0);
+}
+
+int cpu_op_add(void *v, int64_t count, size_t len, int cpu)
+{
+	struct cpu_op opvec[] = {
+		[0] = {
+			.op = CPU_ADD_OP,
+			.len = len,
+			.u.arithmetic_op.p = (unsigned long)v,
+			.u.arithmetic_op.count = count,
+			.u.arithmetic_op.expect_fault_p = 0,
+		},
+	};
+
+	return cpu_opv(opvec, ARRAY_SIZE(opvec), cpu, 0);
+}
+
+int cpu_op_add_release(void *v, int64_t count, size_t len, int cpu)
+{
+	struct cpu_op opvec[] = {
+		[0] = {
+			.op = CPU_ADD_RELEASE_OP,
+			.len = len,
+			.u.arithmetic_op.p = (unsigned long)v,
+			.u.arithmetic_op.count = count,
+			.u.arithmetic_op.expect_fault_p = 0,
+		},
+	};
+
+	return cpu_opv(opvec, ARRAY_SIZE(opvec), cpu, 0);
+}
+
+int cpu_op_cmpeqv_storev(intptr_t *v, intptr_t expect, intptr_t newv,
+			 int cpu)
+{
+	struct cpu_op opvec[] = {
+		[0] = {
+			.op = CPU_COMPARE_EQ_OP,
+			.len = sizeof(intptr_t),
+			.u.compare_op.a = (unsigned long)v,
+			.u.compare_op.b = (unsigned long)&expect,
+			.u.compare_op.expect_fault_a = 0,
+			.u.compare_op.expect_fault_b = 0,
+		},
+		[1] = {
+			.op = CPU_MEMCPY_OP,
+			.len = sizeof(intptr_t),
+			.u.memcpy_op.dst = (unsigned long)v,
+			.u.memcpy_op.src = (unsigned long)&newv,
+			.u.memcpy_op.expect_fault_dst = 0,
+			.u.memcpy_op.expect_fault_src = 0,
+		},
+	};
+
+	return cpu_opv(opvec, ARRAY_SIZE(opvec), cpu, 0);
+}
+
+static int cpu_op_cmpeqv_storep_expect_fault(intptr_t *v, intptr_t expect,
+					     intptr_t *newp, int cpu)
+{
+	struct cpu_op opvec[] = {
+		[0] = {
+			.op = CPU_COMPARE_EQ_OP,
+			.len = sizeof(intptr_t),
+			.u.compare_op.a = (unsigned long)v,
+			.u.compare_op.b = (unsigned long)&expect,
+			.u.compare_op.expect_fault_a = 0,
+			.u.compare_op.expect_fault_b = 0,
+		},
+		[1] = {
+			.op = CPU_MEMCPY_OP,
+			.len = sizeof(intptr_t),
+			.u.memcpy_op.dst = (unsigned long)v,
+			.u.memcpy_op.src = (unsigned long)newp,
+			.u.memcpy_op.expect_fault_dst = 0,
+			/* Return EAGAIN on src fault. */
+			.u.memcpy_op.expect_fault_src = 1,
+		},
+	};
+
+	return cpu_opv(opvec, ARRAY_SIZE(opvec), cpu, 0);
+}
+
+int cpu_op_cmpnev_storeoffp_load(intptr_t *v, intptr_t expectnot,
+				 off_t voffp, intptr_t *load, int cpu)
+{
+	int ret;
+
+	do {
+		intptr_t oldv = READ_ONCE(*v);
+		intptr_t *newp = (intptr_t *)(oldv + voffp);
+
+		if (oldv == expectnot)
+			return 1;
+		ret = cpu_op_cmpeqv_storep_expect_fault(v, oldv, newp, cpu);
+		if (!ret) {
+			*load = oldv;
+			return 0;
+		}
+	} while (ret > 0);
+
+	return -1;
+}
+
+int cpu_op_cmpeqv_storev_storev(intptr_t *v, intptr_t expect,
+				intptr_t *v2, intptr_t newv2,
+				intptr_t newv, int cpu)
+{
+	struct cpu_op opvec[] = {
+		[0] = {
+			.op = CPU_COMPARE_EQ_OP,
+			.len = sizeof(intptr_t),
+			.u.compare_op.a = (unsigned long)v,
+			.u.compare_op.b = (unsigned long)&expect,
+			.u.compare_op.expect_fault_a = 0,
+			.u.compare_op.expect_fault_b = 0,
+		},
+		[1] = {
+			.op = CPU_MEMCPY_OP,
+			.len = sizeof(intptr_t),
+			.u.memcpy_op.dst = (unsigned long)v2,
+			.u.memcpy_op.src = (unsigned long)&newv2,
+			.u.memcpy_op.expect_fault_dst = 0,
+			.u.memcpy_op.expect_fault_src = 0,
+		},
+		[2] = {
+			.op = CPU_MEMCPY_OP,
+			.len = sizeof(intptr_t),
+			.u.memcpy_op.dst = (unsigned long)v,
+			.u.memcpy_op.src = (unsigned long)&newv,
+			.u.memcpy_op.expect_fault_dst = 0,
+			.u.memcpy_op.expect_fault_src = 0,
+		},
+	};
+
+	return cpu_opv(opvec, ARRAY_SIZE(opvec), cpu, 0);
+}
+
+int cpu_op_cmpeqv_storev_storev_release(intptr_t *v, intptr_t expect,
+				   intptr_t *v2, intptr_t newv2,
+				   intptr_t newv, int cpu)
+{
+	struct cpu_op opvec[] = {
+		[0] = {
+			.op = CPU_COMPARE_EQ_OP,
+			.len = sizeof(intptr_t),
+			.u.compare_op.a = (unsigned long)v,
+			.u.compare_op.b = (unsigned long)&expect,
+			.u.compare_op.expect_fault_a = 0,
+			.u.compare_op.expect_fault_b = 0,
+		},
+		[1] = {
+			.op = CPU_MEMCPY_OP,
+			.len = sizeof(intptr_t),
+			.u.memcpy_op.dst = (unsigned long)v2,
+			.u.memcpy_op.src = (unsigned long)&newv2,
+			.u.memcpy_op.expect_fault_dst = 0,
+			.u.memcpy_op.expect_fault_src = 0,
+		},
+		[2] = {
+			.op = CPU_MEMCPY_RELEASE_OP,
+			.len = sizeof(intptr_t),
+			.u.memcpy_op.dst = (unsigned long)v,
+			.u.memcpy_op.src = (unsigned long)&newv,
+			.u.memcpy_op.expect_fault_dst = 0,
+			.u.memcpy_op.expect_fault_src = 0,
+		},
+	};
+
+	return cpu_opv(opvec, ARRAY_SIZE(opvec), cpu, 0);
+}
+
+int cpu_op_cmpeqv_cmpeqv_storev(intptr_t *v, intptr_t expect,
+				intptr_t *v2, intptr_t expect2,
+				intptr_t newv, int cpu)
+{
+	struct cpu_op opvec[] = {
+		[0] = {
+			.op = CPU_COMPARE_EQ_OP,
+			.len = sizeof(intptr_t),
+			.u.compare_op.a = (unsigned long)v,
+			.u.compare_op.b = (unsigned long)&expect,
+			.u.compare_op.expect_fault_a = 0,
+			.u.compare_op.expect_fault_b = 0,
+		},
+		[1] = {
+			.op = CPU_COMPARE_EQ_OP,
+			.len = sizeof(intptr_t),
+			.u.compare_op.a = (unsigned long)v2,
+			.u.compare_op.b = (unsigned long)&expect2,
+			.u.compare_op.expect_fault_a = 0,
+			.u.compare_op.expect_fault_b = 0,
+		},
+		[2] = {
+			.op = CPU_MEMCPY_OP,
+			.len = sizeof(intptr_t),
+			.u.memcpy_op.dst = (unsigned long)v,
+			.u.memcpy_op.src = (unsigned long)&newv,
+			.u.memcpy_op.expect_fault_dst = 0,
+			.u.memcpy_op.expect_fault_src = 0,
+		},
+	};
+
+	return cpu_opv(opvec, ARRAY_SIZE(opvec), cpu, 0);
+}
+
+int cpu_op_cmpeqv_memcpy_storev(intptr_t *v, intptr_t expect,
+				void *dst, void *src, size_t len,
+				intptr_t newv, int cpu)
+{
+	struct cpu_op opvec[] = {
+		[0] = {
+			.op = CPU_COMPARE_EQ_OP,
+			.len = sizeof(intptr_t),
+			.u.compare_op.a = (unsigned long)v,
+			.u.compare_op.b = (unsigned long)&expect,
+			.u.compare_op.expect_fault_a = 0,
+			.u.compare_op.expect_fault_b = 0,
+		},
+		[1] = {
+			.op = CPU_MEMCPY_OP,
+			.len = len,
+			.u.memcpy_op.dst = (unsigned long)dst,
+			.u.memcpy_op.src = (unsigned long)src,
+			.u.memcpy_op.expect_fault_dst = 0,
+			.u.memcpy_op.expect_fault_src = 0,
+		},
+		[2] = {
+			.op = CPU_MEMCPY_OP,
+			.len = sizeof(intptr_t),
+			.u.memcpy_op.dst = (unsigned long)v,
+			.u.memcpy_op.src = (unsigned long)&newv,
+			.u.memcpy_op.expect_fault_dst = 0,
+			.u.memcpy_op.expect_fault_src = 0,
+		},
+	};
+
+	return cpu_opv(opvec, ARRAY_SIZE(opvec), cpu, 0);
+}
+
+int cpu_op_cmpeqv_memcpy_storev_release(intptr_t *v, intptr_t expect,
+				   void *dst, void *src, size_t len,
+				   intptr_t newv, int cpu)
+{
+	struct cpu_op opvec[] = {
+		[0] = {
+			.op = CPU_COMPARE_EQ_OP,
+			.len = sizeof(intptr_t),
+			.u.compare_op.a = (unsigned long)v,
+			.u.compare_op.b = (unsigned long)&expect,
+			.u.compare_op.expect_fault_a = 0,
+			.u.compare_op.expect_fault_b = 0,
+		},
+		[1] = {
+			.op = CPU_MEMCPY_OP,
+			.len = len,
+			.u.memcpy_op.dst = (unsigned long)dst,
+			.u.memcpy_op.src = (unsigned long)src,
+			.u.memcpy_op.expect_fault_dst = 0,
+			.u.memcpy_op.expect_fault_src = 0,
+		},
+		[2] = {
+			.op = CPU_MEMCPY_RELEASE_OP,
+			.len = sizeof(intptr_t),
+			.u.memcpy_op.dst = (unsigned long)v,
+			.u.memcpy_op.src = (unsigned long)&newv,
+			.u.memcpy_op.expect_fault_dst = 0,
+			.u.memcpy_op.expect_fault_src = 0,
+		},
+	};
+
+	return cpu_opv(opvec, ARRAY_SIZE(opvec), cpu, 0);
+}
+
+int cpu_op_addv(intptr_t *v, int64_t count, int cpu)
+{
+	return cpu_op_add(v, count, sizeof(intptr_t), cpu);
+}
diff --git a/tools/testing/selftests/cpu-opv/cpu-op.h b/tools/testing/selftests/cpu-opv/cpu-op.h
new file mode 100644
index 000000000000..853fcb302516
--- /dev/null
+++ b/tools/testing/selftests/cpu-opv/cpu-op.h
@@ -0,0 +1,43 @@
+/* SPDX-License-Identifier: LGPL-2.1 OR MIT */
+/*
+ * cpu-op.h
+ *
+ * (C) Copyright 2017-2018 - Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+ */
+
+#ifndef CPU_OPV_H
+#define CPU_OPV_H
+
+#include <stdlib.h>
+#include <stdint.h>
+#include <linux/cpu_opv.h>
+
+int cpu_opv(struct cpu_op *cpuopv, int cpuopcnt, int cpu, int flags);
+int cpu_op_get_current_cpu(void);
+
+int cpu_op_cmpxchg(void *v, void *expect, void *old, void *_new, size_t len,
+		   int cpu);
+int cpu_op_add(void *v, int64_t count, size_t len, int cpu);
+int cpu_op_add_release(void *v, int64_t count, size_t len, int cpu);
+
+int cpu_op_cmpeqv_storev(intptr_t *v, intptr_t expect, intptr_t newv, int cpu);
+int cpu_op_cmpnev_storeoffp_load(intptr_t *v, intptr_t expectnot,
+				 off_t voffp, intptr_t *load, int cpu);
+int cpu_op_cmpeqv_storev_storev(intptr_t *v, intptr_t expect,
+				intptr_t *v2, intptr_t newv2,
+				intptr_t newv, int cpu);
+int cpu_op_cmpeqv_storev_storev_release(intptr_t *v, intptr_t expect,
+				   intptr_t *v2, intptr_t newv2,
+				   intptr_t newv, int cpu);
+int cpu_op_cmpeqv_cmpeqv_storev(intptr_t *v, intptr_t expect,
+				intptr_t *v2, intptr_t expect2,
+				intptr_t newv, int cpu);
+int cpu_op_cmpeqv_memcpy_storev(intptr_t *v, intptr_t expect,
+				void *dst, void *src, size_t len,
+				intptr_t newv, int cpu);
+int cpu_op_cmpeqv_memcpy_storev_release(intptr_t *v, intptr_t expect,
+				   void *dst, void *src, size_t len,
+				   intptr_t newv, int cpu);
+int cpu_op_addv(intptr_t *v, int64_t count, int cpu);
+
+#endif  /* CPU_OPV_H_ */
-- 
2.11.0

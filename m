From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: [RFC PATCH for 4.16 17/21] rseq: selftests: Provide percpu_op API
Date: Thu, 14 Dec 2017 11:13:59 -0500
Message-ID: <20171214161403.30643-18-mathieu.desnoyers@efficios.com>
References: <20171214161403.30643-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171214161403.30643-1-mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Paul E . McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, linux-kselftest-u79uwXL29TZNg+MwTxZMZA@public.gmane.org
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

    cpu = rseq_cpu_start();
    ret = percpu_addv(&data->c[cpu].count, 1, cpu);
    if (unlikely(ret)) {
         perror("percpu_addv");
         return -1;
    }
    return 0;

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
CC: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
CC: Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>
CC: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
CC: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
CC: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
CC: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
CC: Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
CC: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
CC: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
CC: Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>
CC: Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>
CC: Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
CC: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
CC: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
CC: Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>
CC: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
CC: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
CC: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
CC: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
CC: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
CC: Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
CC: linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
CC: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 tools/testing/selftests/rseq/percpu-op.h | 163 +++++++++++++++++++++++++++++++
 1 file changed, 163 insertions(+)
 create mode 100644 tools/testing/selftests/rseq/percpu-op.h

diff --git a/tools/testing/selftests/rseq/percpu-op.h b/tools/testing/selftests/rseq/percpu-op.h
new file mode 100644
index 000000000000..c17d165438a6
--- /dev/null
+++ b/tools/testing/selftests/rseq/percpu-op.h
@@ -0,0 +1,163 @@
+/*
+ * percpu-op.h
+ *
+ * (C) Copyright 2017 - Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a copy
+ * of this software and associated documentation files (the "Software"), to deal
+ * in the Software without restriction, including without limitation the rights
+ * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
+ * copies of the Software, and to permit persons to whom the Software is
+ * furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
+ * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
+ * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
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

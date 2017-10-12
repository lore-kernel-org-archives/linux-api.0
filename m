From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH for 4.15 09/14] Provide cpu_opv system call
Date: Thu, 12 Oct 2017 19:03:21 -0400
Message-ID: <20171012230326.19984-10-mathieu.desnoyers@efficios.com>
References: <20171012230326.19984-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171012230326.19984-1-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Josh Triplett <josh@joshtriplett.org>, Will Deacon <will.deacon@arm.com>
Cc: linux-kernel@vger.kernel.org, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This new cpu_opv system call executes a vector of operations on behalf
of user-space on a specific CPU with preemption disabled. It is inspired
from readv() and writev() system calls which take a "struct iovec" array
as argument.

The operations available are: comparison, memcpy, add, or, and, xor,
left shift, and right shift. The system call receives a CPU number from
user-space as argument, which is the CPU on which those operations need
to be performed. All preparation steps such as loading pointers, and
applying offsets to arrays, need to be performed by user-space before
invoking the system call. The "comparison" operation can be used to
check that the data used in the preparation step did not change between
preparation of system call inputs and operation execution within the
preempt-off critical section.

The reason why we require all pointer offsets to be calculated by
user-space beforehand is because we need to use get_user_pages_fast() to
first pin all pages touched by each operation. This takes care of
faulting-in the pages. Then, preemption is disabled, and the operations
are performed atomically with respect to other thread execution on that
CPU, without generating any page fault.

A maximum limit of 16 operations per cpu_opv syscall invocation is
enforced, so user-space cannot generate a too long preempt-off critical
section. Each operation is also limited a length of PAGE_SIZE bytes,
meaning that an operation can touch a maximum of 4 pages (memcpy: 2
pages for source, 2 pages for destination if addresses are not aligned
on page boundaries).

If the thread is not running on the requested CPU, a new
push_task_to_cpu() is invoked to migrate the task to the requested CPU.
If the requested CPU is not part of the cpus allowed mask of the thread,
the system call fails with EINVAL. After the migration has been
performed, preemption is disabled, and the current CPU number is checked
again and compared to the requested CPU number. If it still differs, it
means the scheduler migrated us away from that CPU. Return EAGAIN to
user-space in that case, and let user-space retry (either requesting the
same CPU number, or a different one, depending on the user-space
algorithm constraints).

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Paul Turner <pjt@google.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Andrew Hunter <ahh@google.com>
CC: Andy Lutomirski <luto@amacapital.net>
CC: Andi Kleen <andi@firstfloor.org>
CC: Dave Watson <davejwatson@fb.com>
CC: Chris Lameter <cl@linux.com>
CC: Ingo Molnar <mingo@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Ben Maurer <bmaurer@fb.com>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Josh Triplett <josh@joshtriplett.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Russell King <linux@arm.linux.org.uk>
CC: Catalin Marinas <catalin.marinas@arm.com>
CC: Will Deacon <will.deacon@arm.com>
CC: Michael Kerrisk <mtk.manpages@gmail.com>
CC: Boqun Feng <boqun.feng@gmail.com>
CC: linux-api@vger.kernel.org
---
 MAINTAINERS                  |    7 +
 include/uapi/linux/cpu_opv.h |   93 ++++
 init/Kconfig                 |   14 +
 kernel/Makefile              |    1 +
 kernel/cpu_opv.c             | 1000 ++++++++++++++++++++++++++++++++++++++++++
 kernel/sched/core.c          |   37 ++
 kernel/sched/sched.h         |    2 +
 kernel/sys_ni.c              |    1 +
 8 files changed, 1155 insertions(+)
 create mode 100644 include/uapi/linux/cpu_opv.h
 create mode 100644 kernel/cpu_opv.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 9d6a830a8c32..6a5f3afb2ea4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3611,6 +3611,13 @@ B:	https://bugzilla.kernel.org
 F:	drivers/cpuidle/*
 F:	include/linux/cpuidle.h
 
+CPU NON-PREEMPTIBLE OPERATION VECTOR SUPPORT
+M:	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+L:	linux-kernel@vger.kernel.org
+S:	Supported
+F:	kernel/cpu_opv.c
+F:	include/uapi/linux/cpu_opv.h
+
 CRAMFS FILESYSTEM
 W:	http://sourceforge.net/projects/cramfs/
 S:	Orphan / Obsolete
diff --git a/include/uapi/linux/cpu_opv.h b/include/uapi/linux/cpu_opv.h
new file mode 100644
index 000000000000..a3fcdebd063b
--- /dev/null
+++ b/include/uapi/linux/cpu_opv.h
@@ -0,0 +1,93 @@
+#ifndef _UAPI_LINUX_CPU_OPV_H
+#define _UAPI_LINUX_CPU_OPV_H
+
+/*
+ * linux/cpu_opv.h
+ *
+ * CPU preempt-off operation vector system call API
+ *
+ * Copyright (c) 2017 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
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
+#ifdef __KERNEL__
+# include <linux/types.h>
+#else	/* #ifdef __KERNEL__ */
+# include <stdint.h>
+#endif	/* #else #ifdef __KERNEL__ */
+
+#include <asm/byteorder.h>
+
+#ifdef __LP64__
+# define CPU_OP_FIELD_u32_u64(field)	uint64_t field
+#elif defined(__BYTE_ORDER) ? \
+	__BYTE_ORDER == __BIG_ENDIAN : defined(__BIG_ENDIAN)
+# define CPU_OP_FIELD_u32_u64(field)	uint32_t _padding ## field, field
+#else
+# define CPU_OP_FIELD_u32_u64(field)	uint32_t field, _padding ## field
+#endif
+
+#define CPU_OP_VEC_LEN_MAX		16
+#define CPU_OP_ARG_LEN_MAX		24
+#define CPU_OP_DATA_LEN_MAX		PAGE_SIZE
+#define CPU_OP_MAX_PAGES		4	/* Max. pages per op. */
+
+enum cpu_op_type {
+	CPU_COMPARE_EQ_OP,	/* compare */
+	CPU_COMPARE_NE_OP,	/* compare */
+	CPU_MEMCPY_OP,		/* memcpy */
+	CPU_ADD_OP,		/* arithmetic */
+	CPU_OR_OP,		/* bitwise */
+	CPU_AND_OP,		/* bitwise */
+	CPU_XOR_OP,		/* bitwise */
+	CPU_LSHIFT_OP,		/* shift */
+	CPU_RSHIFT_OP,		/* shift */
+};
+
+/* Vector of operations to perform. Limited to 16. */
+struct cpu_op {
+	int32_t op;	/* enum cpu_op_type. */
+	uint32_t len;	/* data length, in bytes. */
+	union {
+		struct {
+			CPU_OP_FIELD_u32_u64(a);
+			CPU_OP_FIELD_u32_u64(b);
+		} compare_op;
+		struct {
+			CPU_OP_FIELD_u32_u64(dst);
+			CPU_OP_FIELD_u32_u64(src);
+		} memcpy_op;
+		struct {
+			CPU_OP_FIELD_u32_u64(p);
+			int64_t count;
+		} arithmetic_op;
+		struct {
+			CPU_OP_FIELD_u32_u64(p);
+			uint64_t mask;
+		} bitwise_op;
+		struct {
+			CPU_OP_FIELD_u32_u64(p);
+			uint32_t bits;
+		} shift_op;
+		char __padding[CPU_OP_ARG_LEN_MAX];
+	} u;
+};
+
+#endif /* _UAPI_LINUX_CPU_OPV_H */
diff --git a/init/Kconfig b/init/Kconfig
index b8aa41bd4f4f..98b79eb9020e 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1399,6 +1399,7 @@ config RSEQ
 	bool "Enable rseq() system call" if EXPERT
 	default y
 	depends on HAVE_RSEQ
+	select CPU_OPV
 	help
 	  Enable the restartable sequences system call. It provides a
 	  user-space cache for the current CPU number value, which
@@ -1408,6 +1409,19 @@ config RSEQ
 
 	  If unsure, say Y.
 
+config CPU_OPV
+	bool "Enable cpu_opv() system call" if EXPERT
+	default y
+	help
+	  Enable the CPU preempt-off operation vector system call.
+	  It allows user-space to perform a sequence of operations on
+	  per-cpu data with preemption disabled. Useful as
+	  single-stepping fall-back for restartable sequences, and for
+	  performing more complex operations on per-cpu data that would
+	  not be otherwise possible to do with restartable sequences.
+
+	  If unsure, say Y.
+
 config EMBEDDED
 	bool "Embedded system"
 	option allnoconfig_y
diff --git a/kernel/Makefile b/kernel/Makefile
index 5c09592b3b9f..8301e454c2a8 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -112,6 +112,7 @@ obj-$(CONFIG_MEMBARRIER) += membarrier.o
 
 obj-$(CONFIG_HAS_IOMEM) += memremap.o
 obj-$(CONFIG_RSEQ) += rseq.o
+obj-$(CONFIG_CPU_OPV) += cpu_opv.o
 
 $(obj)/configs.o: $(obj)/config_data.h
 
diff --git a/kernel/cpu_opv.c b/kernel/cpu_opv.c
new file mode 100644
index 000000000000..2e615612acb1
--- /dev/null
+++ b/kernel/cpu_opv.c
@@ -0,0 +1,1000 @@
+/*
+ * CPU preempt-off operation vector system call
+ *
+ * It allows user-space to perform a sequence of operations on per-cpu
+ * data with preemption disabled. Useful as single-stepping fall-back
+ * for restartable sequences, and for performing more complex operations
+ * on per-cpu data that would not be otherwise possible to do with
+ * restartable sequences.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * Copyright (C) 2017, EfficiOS Inc.,
+ * Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+ */
+
+#include <linux/sched.h>
+#include <linux/uaccess.h>
+#include <linux/syscalls.h>
+#include <linux/cpu_opv.h>
+#include <linux/types.h>
+#include <asm/ptrace.h>
+#include <asm/byteorder.h>
+
+#include "sched/sched.h"
+
+#define TMP_BUFLEN			64
+#define NR_PINNED_PAGES_ON_STACK	8
+
+/*
+ * The cpu_opv system call executes a vector of operations on behalf of
+ * user-space on a specific CPU with preemption disabled. It is inspired
+ * from readv() and writev() system calls which take a "struct iovec"
+ * array as argument.
+ * 
+ * The operations available are: comparison, memcpy, add, or, and, xor,
+ * left shift, and right shift. The system call receives a CPU number
+ * from user-space as argument, which is the CPU on which those
+ * operations need to be performed. All preparation steps such as
+ * loading pointers, and applying offsets to arrays, need to be
+ * performed by user-space before invoking the system call. The
+ * "comparison" operation can be used to check that the data used in the
+ * preparation step did not change between preparation of system call
+ * inputs and operation execution within the preempt-off critical
+ * section.
+ * 
+ * The reason why we require all pointer offsets to be calculated by
+ * user-space beforehand is because we need to use get_user_pages_fast()
+ * to first pin all pages touched by each operation. This takes care of
+ * faulting-in the pages. Then, preemption is disabled, and the
+ * operations are performed atomically with respect to other thread
+ * execution on that CPU, without generating any page fault.
+ * 
+ * A maximum limit of 16 operations per cpu_opv syscall invocation is
+ * enforced, so user-space cannot generate a too long preempt-off
+ * critical section. Each operation is also limited a length of
+ * PAGE_SIZE bytes, meaning that an operation can touch a maximum of 4
+ * pages (memcpy: 2 pages for source, 2 pages for destination if
+ * addresses are not aligned on page boundaries).
+ * 
+ * If the thread is not running on the requested CPU, a new
+ * push_task_to_cpu() is invoked to migrate the task to the requested
+ * CPU.  If the requested CPU is not part of the cpus allowed mask of
+ * the thread, the system call fails with EINVAL. After the migration
+ * has been performed, preemption is disabled, and the current CPU
+ * number is checked again and compared to the requested CPU number. If
+ * it still differs, it means the scheduler migrated us away from that
+ * CPU. Return EAGAIN to user-space in that case, and let user-space
+ * retry (either requesting the same CPU number, or a different one,
+ * depending on the user-space algorithm constraints).
+ */
+
+/*
+ * Check operation types and length parameters.
+ */
+static int cpu_opv_check(struct cpu_op *cpuop, int cpuopcnt)
+{
+	int i;
+
+	for (i = 0; i < cpuopcnt; i++) {
+		struct cpu_op *op = &cpuop[i];
+
+		switch (op->op) {
+		case CPU_COMPARE_EQ_OP:
+		case CPU_COMPARE_NE_OP:
+		case CPU_MEMCPY_OP:
+			if (op->len > CPU_OP_DATA_LEN_MAX)
+				return -EINVAL;
+			break;
+		case CPU_ADD_OP:
+		case CPU_OR_OP:
+		case CPU_AND_OP:
+		case CPU_XOR_OP:
+			switch (op->len) {
+			case 1:
+			case 2:
+			case 4:
+			case 8:
+				break;
+			default:
+				return -EINVAL;
+			}
+			break;
+		case CPU_LSHIFT_OP:
+		case CPU_RSHIFT_OP:
+			switch (op->len) {
+			case 1:
+				if (op->u.shift_op.bits > 7)
+					return -EINVAL;
+				break;
+			case 2:
+				if (op->u.shift_op.bits > 15)
+					return -EINVAL;
+				break;
+			case 4:
+				if (op->u.shift_op.bits > 31)
+					return -EINVAL;
+				break;
+			case 8:
+				if (op->u.shift_op.bits > 63)
+					return -EINVAL;
+				break;
+			default:
+				return -EINVAL;
+			}
+			break;
+		default:
+			return -EINVAL;
+		}
+	}
+	return 0;
+}
+
+static unsigned long cpu_op_range_nr_pages(unsigned long addr,
+		unsigned long len)
+{
+	return ((addr + len - 1) >> PAGE_SHIFT) - (addr >> PAGE_SHIFT) + 1;
+}
+
+static int cpu_op_pin_pages(unsigned long addr, unsigned long len,
+		struct page ***pinned_pages_ptr, size_t *nr_pinned)
+{
+	unsigned long nr_pages;
+	struct page *pages[2];
+	int ret;
+
+	if (!len)
+		return 0;
+	nr_pages = cpu_op_range_nr_pages(addr, len);
+	BUG_ON(nr_pages > 2);
+	if (*nr_pinned + nr_pages > NR_PINNED_PAGES_ON_STACK) {
+		struct page **pinned_pages =
+			kzalloc(CPU_OP_VEC_LEN_MAX * CPU_OP_MAX_PAGES
+				* sizeof(struct page *), GFP_KERNEL);
+		if (!pinned_pages)
+			return -ENOMEM;
+		memcpy(pinned_pages, *pinned_pages_ptr,
+			*nr_pinned * sizeof(struct page *));
+		*pinned_pages_ptr = pinned_pages;
+	}
+	ret = get_user_pages_fast(addr, nr_pages, 0, pages);
+	if (ret < nr_pages) {
+		if (ret > 0)
+			put_page(pages[0]);
+		return -EFAULT;
+	}
+	(*pinned_pages_ptr)[(*nr_pinned)++] = pages[0];
+	if (nr_pages > 1)
+		(*pinned_pages_ptr)[(*nr_pinned)++] = pages[1];
+	return 0;
+}
+
+static int cpu_opv_pin_pages(struct cpu_op *cpuop, int cpuopcnt,
+		struct page ***pinned_pages_ptr, size_t *nr_pinned)
+{
+	int ret, i;
+
+	/* Check access, pin pages. */
+	for (i = 0; i < cpuopcnt; i++) {
+		struct cpu_op *op = &cpuop[i];
+
+		switch (op->op) {
+		case CPU_COMPARE_EQ_OP:
+		case CPU_COMPARE_NE_OP:
+			if (!access_ok(VERIFY_READ, op->u.compare_op.a,
+					op->len))
+				goto error;
+			ret = cpu_op_pin_pages(
+					(unsigned long)op->u.compare_op.a,
+					op->len, pinned_pages_ptr, nr_pinned);
+			if (ret)
+				goto error;
+			if (!access_ok(VERIFY_READ, op->u.compare_op.b,
+					op->len))
+				goto error;
+			ret = cpu_op_pin_pages(
+					(unsigned long)op->u.compare_op.b,
+					op->len, pinned_pages_ptr, nr_pinned);
+			if (ret)
+				goto error;
+			break;
+		case CPU_MEMCPY_OP:
+			if (!access_ok(VERIFY_WRITE, op->u.memcpy_op.dst,
+					op->len))
+				goto error;
+			ret = cpu_op_pin_pages(
+					(unsigned long)op->u.memcpy_op.dst,
+					op->len, pinned_pages_ptr, nr_pinned);
+			if (ret)
+				goto error;
+			if (!access_ok(VERIFY_READ, op->u.memcpy_op.src,
+					op->len))
+				goto error;
+			ret = cpu_op_pin_pages(
+					(unsigned long)op->u.memcpy_op.src,
+					op->len, pinned_pages_ptr, nr_pinned);
+			if (ret)
+				goto error;
+			break;
+		case CPU_ADD_OP:
+			if (!access_ok(VERIFY_WRITE, op->u.arithmetic_op.p,
+					op->len))
+				goto error;
+			ret = cpu_op_pin_pages(
+					(unsigned long)op->u.arithmetic_op.p,
+					op->len, pinned_pages_ptr, nr_pinned);
+			if (ret)
+				goto error;
+			break;
+		case CPU_OR_OP:
+		case CPU_AND_OP:
+		case CPU_XOR_OP:
+			if (!access_ok(VERIFY_WRITE, op->u.bitwise_op.p,
+					op->len))
+				goto error;
+			ret = cpu_op_pin_pages(
+					(unsigned long)op->u.bitwise_op.p,
+					op->len, pinned_pages_ptr, nr_pinned);
+			if (ret)
+				goto error;
+			break;
+		case CPU_LSHIFT_OP:
+		case CPU_RSHIFT_OP:
+			if (!access_ok(VERIFY_WRITE, op->u.shift_op.p,
+					op->len))
+				goto error;
+			ret = cpu_op_pin_pages(
+					(unsigned long)op->u.shift_op.p,
+					op->len, pinned_pages_ptr, nr_pinned);
+			if (ret)
+				goto error;
+			break;
+		default:
+			return -EINVAL;
+		}
+	}
+	return 0;
+
+error:
+	for (i = 0; i < *nr_pinned; i++)
+		put_page((*pinned_pages_ptr)[i]);
+	*nr_pinned = 0;
+	return ret;
+}
+
+/* Return 0 if same, > 0 if different, < 0 on error. */
+static int do_cpu_op_compare_iter(void __user *a, void __user *b, uint32_t len)
+{
+	char bufa[TMP_BUFLEN], bufb[TMP_BUFLEN];
+	uint32_t compared = 0;
+
+	while (compared != len) {
+		unsigned long to_compare;
+
+		to_compare = min_t(uint32_t, TMP_BUFLEN, len - compared);
+		if (__copy_from_user_inatomic(bufa, a + compared, to_compare))
+			return -EFAULT;
+		if (__copy_from_user_inatomic(bufb, b + compared, to_compare))
+			return -EFAULT;
+		if (memcmp(bufa, bufb, to_compare))
+			return 1;	/* different */
+		compared += to_compare;
+	}
+	return 0;	/* same */
+}
+
+/* Return 0 if same, > 0 if different, < 0 on error. */
+static int do_cpu_op_compare(void __user *a, void __user *b, uint32_t len)
+{
+	int ret = -EFAULT;
+	union {
+		uint8_t _u8;
+		uint16_t _u16;
+		uint32_t _u32;
+		uint64_t _u64;
+#if (BITS_PER_LONG < 64)
+		uint32_t _u64_split[2];
+#endif
+	} tmp[2];
+
+	pagefault_disable();
+	switch (len) {
+	case 1:
+		if (__get_user(tmp[0]._u8, (uint8_t __user *)a))
+			goto end;
+		if (__get_user(tmp[1]._u8, (uint8_t __user *)b))
+			goto end;
+		ret = !!(tmp[0]._u8 != tmp[1]._u8);
+		break;
+	case 2:
+		if (__get_user(tmp[0]._u16, (uint16_t __user *)a))
+			goto end;
+		if (__get_user(tmp[1]._u16, (uint16_t __user *)b))
+			goto end;
+		ret = !!(tmp[0]._u16 != tmp[1]._u16);
+		break;
+	case 4:
+		if (__get_user(tmp[0]._u32, (uint32_t __user *)a))
+			goto end;
+		if (__get_user(tmp[1]._u32, (uint32_t __user *)b))
+			goto end;
+		ret = !!(tmp[0]._u32 != tmp[1]._u32);
+		break;
+	case 8:
+#if (BITS_PER_LONG >= 64)
+		if (__get_user(tmp[0]._u64, (uint64_t __user *)a))
+			goto end;
+		if (__get_user(tmp[1]._u64, (uint64_t __user *)b))
+			goto end;
+#else
+		if (__get_user(tmp[0]._u64_split[0], (uint32_t __user *)a))
+			goto end;
+		if (__get_user(tmp[0]._u64_split[1], (uint32_t __user *)a + 1))
+			goto end;
+		if (__get_user(tmp[1]._u64_split[0], (uint32_t __user *)b))
+			goto end;
+		if (__get_user(tmp[1]._u64_split[1], (uint32_t __user *)b + 1))
+			goto end;
+#endif
+		ret = !!(tmp[0]._u64 != tmp[1]._u64);
+		break;
+	default:
+		pagefault_enable();
+		return do_cpu_op_compare_iter(a, b, len);
+	}
+end:
+	pagefault_enable();
+	return ret;
+}
+
+/* Return 0 on success, < 0 on error. */
+static int do_cpu_op_memcpy_iter(void __user *dst, void __user *src,
+		uint32_t len)
+{
+	char buf[TMP_BUFLEN];
+	uint32_t copied = 0;
+
+	while (copied != len) {
+		unsigned long to_copy;
+
+		to_copy = min_t(uint32_t, TMP_BUFLEN, len - copied);
+		if (__copy_from_user_inatomic(buf, src + copied, to_copy))
+			return -EFAULT;
+		if (__copy_to_user_inatomic(dst + copied, buf, to_copy))
+			return -EFAULT;
+		copied += to_copy;
+	}
+	return 0;
+}
+
+/* Return 0 on success, < 0 on error. */
+static int do_cpu_op_memcpy(void __user *dst, void __user *src, uint32_t len)
+{
+	int ret = -EFAULT;
+	union {
+		uint8_t _u8;
+		uint16_t _u16;
+		uint32_t _u32;
+		uint64_t _u64;
+#if (BITS_PER_LONG < 64)
+		uint32_t _u64_split[2];
+#endif
+	} tmp;
+
+	pagefault_disable();
+	switch (len) {
+	case 1:
+		if (__get_user(tmp._u8, (uint8_t __user *)src))
+			goto end;
+		if (__put_user(tmp._u8, (uint8_t __user *)dst))
+			goto end;
+		break;
+	case 2:
+		if (__get_user(tmp._u16, (uint16_t __user *)src))
+			goto end;
+		if (__put_user(tmp._u16, (uint16_t __user *)dst))
+			goto end;
+		break;
+	case 4:
+		if (__get_user(tmp._u32, (uint32_t __user *)src))
+			goto end;
+		if (__put_user(tmp._u32, (uint32_t __user *)dst))
+			goto end;
+		break;
+	case 8:
+#if (BITS_PER_LONG >= 64)
+		if (__get_user(tmp._u64, (uint64_t __user *)src))
+			goto end;
+		if (__put_user(tmp._u64, (uint64_t __user *)dst))
+			goto end;
+#else
+		if (__get_user(tmp._u64_split[0], (uint32_t __user *)src))
+			goto end;
+		if (__get_user(tmp._u64_split[1], (uint32_t __user *)src + 1))
+			goto end;
+		if (__put_user(tmp._u64_split[0], (uint32_t __user *)dst))
+			goto end;
+		if (__put_user(tmp._u64_split[1], (uint32_t __user *)dst + 1))
+			goto end;
+#endif
+		break;
+	default:
+		pagefault_enable();
+		return do_cpu_op_memcpy_iter(dst, src, len);
+	}
+	ret = 0;
+end:
+	pagefault_enable();
+	return ret;
+}
+
+/* Return 0 on success, < 0 on error. */
+static int do_cpu_op_add(void __user *p, int64_t count, uint32_t len)
+{
+	int ret = -EFAULT;
+	union {
+		uint8_t _u8;
+		uint16_t _u16;
+		uint32_t _u32;
+		uint64_t _u64;
+#if (BITS_PER_LONG < 64)
+		uint32_t _u64_split[2];
+#endif
+	} tmp;
+
+	pagefault_disable();
+	switch (len) {
+	case 1:
+		if (__get_user(tmp._u8, (uint8_t __user *)p))
+			goto end;
+		tmp._u8 += (uint8_t)count;
+		if (__put_user(tmp._u8, (uint8_t __user *)p))
+			goto end;
+		break;
+	case 2:
+		if (__get_user(tmp._u16, (uint16_t __user *)p))
+			goto end;
+		tmp._u16 += (uint16_t)count;
+		if (__put_user(tmp._u16, (uint16_t __user *)p))
+			goto end;
+		break;
+	case 4:
+		if (__get_user(tmp._u32, (uint32_t __user *)p))
+			goto end;
+		tmp._u32 += (uint32_t)count;
+		if (__put_user(tmp._u32, (uint32_t __user *)p))
+			goto end;
+		break;
+	case 8:
+#if (BITS_PER_LONG >= 64)
+		if (__get_user(tmp._u64, (uint64_t __user *)p))
+			goto end;
+#else
+		if (__get_user(tmp._u64_split[0], (uint32_t __user *)p))
+			goto end;
+		if (__get_user(tmp._u64_split[1], (uint32_t __user *)p + 1))
+			goto end;
+#endif
+		tmp._u64 += (uint64_t)count;
+#if (BITS_PER_LONG >= 64)
+		if (__put_user(tmp._u64, (uint64_t __user *)p))
+			goto end;
+#else
+		if (__put_user(tmp._u64_split[0], (uint32_t __user *)p))
+			goto end;
+		if (__put_user(tmp._u64_split[1], (uint32_t __user *)p + 1))
+			goto end;
+#endif
+		break;
+	default:
+		ret = -EINVAL;
+		goto end;
+	}
+	ret = 0;
+end:
+	pagefault_enable();
+	return ret;
+}
+
+/* Return 0 on success, < 0 on error. */
+static int do_cpu_op_or(void __user *p, uint64_t mask, uint32_t len)
+{
+	int ret = -EFAULT;
+	union {
+		uint8_t _u8;
+		uint16_t _u16;
+		uint32_t _u32;
+		uint64_t _u64;
+#if (BITS_PER_LONG < 64)
+		uint32_t _u64_split[2];
+#endif
+	} tmp;
+
+	pagefault_disable();
+	switch (len) {
+	case 1:
+		if (__get_user(tmp._u8, (uint8_t __user *)p))
+			goto end;
+		tmp._u8 |= (uint8_t)mask;
+		if (__put_user(tmp._u8, (uint8_t __user *)p))
+			goto end;
+		break;
+	case 2:
+		if (__get_user(tmp._u16, (uint16_t __user *)p))
+			goto end;
+		tmp._u16 |= (uint16_t)mask;
+		if (__put_user(tmp._u16, (uint16_t __user *)p))
+			goto end;
+		break;
+	case 4:
+		if (__get_user(tmp._u32, (uint32_t __user *)p))
+			goto end;
+		tmp._u32 |= (uint32_t)mask;
+		if (__put_user(tmp._u32, (uint32_t __user *)p))
+			goto end;
+		break;
+	case 8:
+#if (BITS_PER_LONG >= 64)
+		if (__get_user(tmp._u64, (uint64_t __user *)p))
+			goto end;
+#else
+		if (__get_user(tmp._u64_split[0], (uint32_t __user *)p))
+			goto end;
+		if (__get_user(tmp._u64_split[1], (uint32_t __user *)p + 1))
+			goto end;
+#endif
+		tmp._u64 |= (uint64_t)mask;
+#if (BITS_PER_LONG >= 64)
+		if (__put_user(tmp._u64, (uint64_t __user *)p))
+			goto end;
+#else
+		if (__put_user(tmp._u64_split[0], (uint32_t __user *)p))
+			goto end;
+		if (__put_user(tmp._u64_split[1], (uint32_t __user *)p + 1))
+			goto end;
+#endif
+		break;
+	default:
+		ret = -EINVAL;
+		goto end;
+	}
+	ret = 0;
+end:
+	pagefault_enable();
+	return ret;
+}
+
+/* Return 0 on success, < 0 on error. */
+static int do_cpu_op_and(void __user *p, uint64_t mask, uint32_t len)
+{
+	int ret = -EFAULT;
+	union {
+		uint8_t _u8;
+		uint16_t _u16;
+		uint32_t _u32;
+		uint64_t _u64;
+#if (BITS_PER_LONG < 64)
+		uint32_t _u64_split[2];
+#endif
+	} tmp;
+
+	pagefault_disable();
+	switch (len) {
+	case 1:
+		if (__get_user(tmp._u8, (uint8_t __user *)p))
+			goto end;
+		tmp._u8 &= (uint8_t)mask;
+		if (__put_user(tmp._u8, (uint8_t __user *)p))
+			goto end;
+		break;
+	case 2:
+		if (__get_user(tmp._u16, (uint16_t __user *)p))
+			goto end;
+		tmp._u16 &= (uint16_t)mask;
+		if (__put_user(tmp._u16, (uint16_t __user *)p))
+			goto end;
+		break;
+	case 4:
+		if (__get_user(tmp._u32, (uint32_t __user *)p))
+			goto end;
+		tmp._u32 &= (uint32_t)mask;
+		if (__put_user(tmp._u32, (uint32_t __user *)p))
+			goto end;
+		break;
+	case 8:
+#if (BITS_PER_LONG >= 64)
+		if (__get_user(tmp._u64, (uint64_t __user *)p))
+			goto end;
+#else
+		if (__get_user(tmp._u64_split[0], (uint32_t __user *)p))
+			goto end;
+		if (__get_user(tmp._u64_split[1], (uint32_t __user *)p + 1))
+			goto end;
+#endif
+		tmp._u64 &= (uint64_t)mask;
+#if (BITS_PER_LONG >= 64)
+		if (__put_user(tmp._u64, (uint64_t __user *)p))
+			goto end;
+#else
+		if (__put_user(tmp._u64_split[0], (uint32_t __user *)p))
+			goto end;
+		if (__put_user(tmp._u64_split[1], (uint32_t __user *)p + 1))
+			goto end;
+#endif
+		break;
+	default:
+		ret = -EINVAL;
+		goto end;
+	}
+	ret = 0;
+end:
+	pagefault_enable();
+	return ret;
+}
+
+/* Return 0 on success, < 0 on error. */
+static int do_cpu_op_xor(void __user *p, uint64_t mask, uint32_t len)
+{
+	int ret = -EFAULT;
+	union {
+		uint8_t _u8;
+		uint16_t _u16;
+		uint32_t _u32;
+		uint64_t _u64;
+#if (BITS_PER_LONG < 64)
+		uint32_t _u64_split[2];
+#endif
+	} tmp;
+
+	pagefault_disable();
+	switch (len) {
+	case 1:
+		if (__get_user(tmp._u8, (uint8_t __user *)p))
+			goto end;
+		tmp._u8 ^= (uint8_t)mask;
+		if (__put_user(tmp._u8, (uint8_t __user *)p))
+			goto end;
+		break;
+	case 2:
+		if (__get_user(tmp._u16, (uint16_t __user *)p))
+			goto end;
+		tmp._u16 ^= (uint16_t)mask;
+		if (__put_user(tmp._u16, (uint16_t __user *)p))
+			goto end;
+		break;
+	case 4:
+		if (__get_user(tmp._u32, (uint32_t __user *)p))
+			goto end;
+		tmp._u32 ^= (uint32_t)mask;
+		if (__put_user(tmp._u32, (uint32_t __user *)p))
+			goto end;
+		break;
+	case 8:
+#if (BITS_PER_LONG >= 64)
+		if (__get_user(tmp._u64, (uint64_t __user *)p))
+			goto end;
+#else
+		if (__get_user(tmp._u64_split[0], (uint32_t __user *)p))
+			goto end;
+		if (__get_user(tmp._u64_split[1], (uint32_t __user *)p + 1))
+			goto end;
+#endif
+		tmp._u64 ^= (uint64_t)mask;
+#if (BITS_PER_LONG >= 64)
+		if (__put_user(tmp._u64, (uint64_t __user *)p))
+			goto end;
+#else
+		if (__put_user(tmp._u64_split[0], (uint32_t __user *)p))
+			goto end;
+		if (__put_user(tmp._u64_split[1], (uint32_t __user *)p + 1))
+			goto end;
+#endif
+		break;
+	default:
+		ret = -EINVAL;
+		goto end;
+	}
+	ret = 0;
+end:
+	pagefault_enable();
+	return ret;
+}
+
+/* Return 0 on success, < 0 on error. */
+static int do_cpu_op_lshift(void __user *p, uint32_t bits, uint32_t len)
+{
+	int ret = -EFAULT;
+	union {
+		uint8_t _u8;
+		uint16_t _u16;
+		uint32_t _u32;
+		uint64_t _u64;
+#if (BITS_PER_LONG < 64)
+		uint32_t _u64_split[2];
+#endif
+	} tmp;
+
+	pagefault_disable();
+	switch (len) {
+	case 1:
+		if (__get_user(tmp._u8, (uint8_t __user *)p))
+			goto end;
+		tmp._u8 <<= bits;
+		if (__put_user(tmp._u8, (uint8_t __user *)p))
+			goto end;
+		break;
+	case 2:
+		if (__get_user(tmp._u16, (uint16_t __user *)p))
+			goto end;
+		tmp._u16 <<= bits;
+		if (__put_user(tmp._u16, (uint16_t __user *)p))
+			goto end;
+		break;
+	case 4:
+		if (__get_user(tmp._u32, (uint32_t __user *)p))
+			goto end;
+		tmp._u32 <<= bits;
+		if (__put_user(tmp._u32, (uint32_t __user *)p))
+			goto end;
+		break;
+	case 8:
+#if (BITS_PER_LONG >= 64)
+		if (__get_user(tmp._u64, (uint64_t __user *)p))
+			goto end;
+#else
+		if (__get_user(tmp._u64_split[0], (uint32_t __user *)p))
+			goto end;
+		if (__get_user(tmp._u64_split[1], (uint32_t __user *)p + 1))
+			goto end;
+#endif
+		tmp._u64 <<= bits;
+#if (BITS_PER_LONG >= 64)
+		if (__put_user(tmp._u64, (uint64_t __user *)p))
+			goto end;
+#else
+		if (__put_user(tmp._u64_split[0], (uint32_t __user *)p))
+			goto end;
+		if (__put_user(tmp._u64_split[1], (uint32_t __user *)p + 1))
+			goto end;
+#endif
+		break;
+	default:
+		ret = -EINVAL;
+		goto end;
+	}
+	ret = 0;
+end:
+	pagefault_enable();
+	return ret;
+}
+
+/* Return 0 on success, < 0 on error. */
+static int do_cpu_op_rshift(void __user *p, uint32_t bits, uint32_t len)
+{
+	int ret = -EFAULT;
+	union {
+		uint8_t _u8;
+		uint16_t _u16;
+		uint32_t _u32;
+		uint64_t _u64;
+#if (BITS_PER_LONG < 64)
+		uint32_t _u64_split[2];
+#endif
+	} tmp;
+
+	pagefault_disable();
+	switch (len) {
+	case 1:
+		if (__get_user(tmp._u8, (uint8_t __user *)p))
+			goto end;
+		tmp._u8 >>= bits;
+		if (__put_user(tmp._u8, (uint8_t __user *)p))
+			goto end;
+		break;
+	case 2:
+		if (__get_user(tmp._u16, (uint16_t __user *)p))
+			goto end;
+		tmp._u16 >>= bits;
+		if (__put_user(tmp._u16, (uint16_t __user *)p))
+			goto end;
+		break;
+	case 4:
+		if (__get_user(tmp._u32, (uint32_t __user *)p))
+			goto end;
+		tmp._u32 >>= bits;
+		if (__put_user(tmp._u32, (uint32_t __user *)p))
+			goto end;
+		break;
+	case 8:
+#if (BITS_PER_LONG >= 64)
+		if (__get_user(tmp._u64, (uint64_t __user *)p))
+			goto end;
+#else
+		if (__get_user(tmp._u64_split[0], (uint32_t __user *)p))
+			goto end;
+		if (__get_user(tmp._u64_split[1], (uint32_t __user *)p + 1))
+			goto end;
+#endif
+		tmp._u64 >>= bits;
+#if (BITS_PER_LONG >= 64)
+		if (__put_user(tmp._u64, (uint64_t __user *)p))
+			goto end;
+#else
+		if (__put_user(tmp._u64_split[0], (uint32_t __user *)p))
+			goto end;
+		if (__put_user(tmp._u64_split[1], (uint32_t __user *)p + 1))
+			goto end;
+#endif
+		break;
+	default:
+		ret = -EINVAL;
+		goto end;
+	}
+	ret = 0;
+end:
+	pagefault_enable();
+	return ret;
+}
+
+static int __do_cpu_opv(struct cpu_op *cpuop, int cpuopcnt)
+{
+	int i, ret;
+
+	for (i = 0; i < cpuopcnt; i++) {
+		struct cpu_op *op = &cpuop[i];
+
+		switch (op->op) {
+		case CPU_COMPARE_EQ_OP:
+			ret = do_cpu_op_compare(
+					(void __user *)op->u.compare_op.a,
+					(void __user *)op->u.compare_op.b,
+					op->len);
+			/* Stop execution on error. */
+			if (ret < 0)
+				return ret;
+			/*
+			 * Stop execution, return op index + 1 if comparison
+			 * differs.
+			 */
+			if (ret > 0)
+				return i + 1;
+			break;
+		case CPU_COMPARE_NE_OP:
+			ret = do_cpu_op_compare(
+					(void __user *)op->u.compare_op.a,
+					(void __user *)op->u.compare_op.b,
+					op->len);
+			/* Stop execution on error. */
+			if (ret < 0)
+				return ret;
+			/*
+			 * Stop execution, return op index + 1 if comparison
+			 * is identical.
+			 */
+			if (ret == 0)
+				return i + 1;
+			break;
+		case CPU_MEMCPY_OP:
+			ret = do_cpu_op_memcpy(
+					(void __user *)op->u.memcpy_op.dst,
+					(void __user *)op->u.memcpy_op.src,
+					op->len);
+			/* Stop execution on error. */
+			if (ret)
+				return ret;
+			break;
+		case CPU_ADD_OP:
+			ret = do_cpu_op_add((void __user *)op->u.arithmetic_op.p,
+					op->u.arithmetic_op.count, op->len);
+			/* Stop execution on error. */
+			if (ret)
+				return ret;
+			break;
+		case CPU_OR_OP:
+			ret = do_cpu_op_or((void __user *)op->u.bitwise_op.p,
+					op->u.bitwise_op.mask, op->len);
+			/* Stop execution on error. */
+			if (ret)
+				return ret;
+			break;
+		case CPU_AND_OP:
+			ret = do_cpu_op_and((void __user *)op->u.bitwise_op.p,
+					op->u.bitwise_op.mask, op->len);
+			/* Stop execution on error. */
+			if (ret)
+				return ret;
+			break;
+		case CPU_XOR_OP:
+			ret = do_cpu_op_xor((void __user *)op->u.bitwise_op.p,
+					op->u.bitwise_op.mask, op->len);
+			/* Stop execution on error. */
+			if (ret)
+				return ret;
+			break;
+		case CPU_LSHIFT_OP:
+			ret = do_cpu_op_lshift((void __user *)op->u.shift_op.p,
+					op->u.shift_op.bits, op->len);
+			/* Stop execution on error. */
+			if (ret)
+				return ret;
+			break;
+		case CPU_RSHIFT_OP:
+			ret = do_cpu_op_rshift((void __user *)op->u.shift_op.p,
+					op->u.shift_op.bits, op->len);
+			/* Stop execution on error. */
+			if (ret)
+				return ret;
+			break;
+		default:
+			return -EINVAL;
+		}
+	}
+	return 0;
+}
+
+static int do_cpu_opv(struct cpu_op *cpuop, int cpuopcnt, int cpu)
+{
+	int ret;
+
+	if (cpu != raw_smp_processor_id()) {
+		ret = push_task_to_cpu(current, cpu);
+		if (ret)
+			return ret;
+	}
+	preempt_disable();
+	if (cpu != smp_processor_id()) {
+		ret = -EAGAIN;
+		goto end;
+	}
+	ret = __do_cpu_opv(cpuop, cpuopcnt);
+end:
+	preempt_enable();
+	return ret;
+}
+
+/*
+ * cpu_opv - execute operation vector on a given CPU with preempt off.
+ *
+ * Userspace should pass current CPU number as parameter. May fail with
+ * -EAGAIN if currently executing on the wrong CPU.
+ */
+SYSCALL_DEFINE4(cpu_opv, struct cpu_op __user *, ucpuopv, int, cpuopcnt,
+		int, cpu, int, flags)
+{
+	struct cpu_op cpuopv[CPU_OP_VEC_LEN_MAX];
+	struct page *pinned_pages_on_stack[NR_PINNED_PAGES_ON_STACK];
+	struct page **pinned_pages = pinned_pages_on_stack;
+	int ret, i;
+	size_t nr_pinned = 0;
+
+	if (unlikely(flags))
+		return -EINVAL;
+	if (unlikely(cpu < 0))
+		return -EINVAL;
+	if (cpuopcnt < 0 || cpuopcnt > CPU_OP_VEC_LEN_MAX)
+		return -EINVAL;
+	if (copy_from_user(cpuopv, ucpuopv, cpuopcnt * sizeof(struct cpu_op)))
+		return -EFAULT;
+	ret = cpu_opv_check(cpuopv, cpuopcnt);
+	if (ret)
+		return ret;
+	ret = cpu_opv_pin_pages(cpuopv, cpuopcnt,
+				&pinned_pages, &nr_pinned);
+	if (ret)
+		goto end;
+	ret = do_cpu_opv(cpuopv, cpuopcnt, cpu);
+	for (i = 0; i < nr_pinned; i++)
+		put_page(pinned_pages[i]);
+end:
+	if (pinned_pages != pinned_pages_on_stack)
+		kfree(pinned_pages);
+	return ret;
+}
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 12da0f771d73..db50984f7535 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1047,6 +1047,43 @@ void do_set_cpus_allowed(struct task_struct *p, const struct cpumask *new_mask)
 		set_curr_task(rq, p);
 }
 
+int push_task_to_cpu(struct task_struct *p, unsigned int dest_cpu)
+{
+	struct rq_flags rf;
+	struct rq *rq;
+	int ret = 0;
+
+	rq = task_rq_lock(p, &rf);
+	update_rq_clock(rq);
+
+	if (!cpumask_test_cpu(dest_cpu, &p->cpus_allowed)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (task_cpu(p) == dest_cpu)
+		goto out;
+
+	if (task_running(rq, p) || p->state == TASK_WAKING) {
+		struct migration_arg arg = { p, dest_cpu };
+		/* Need help from migration thread: drop lock and wait. */
+		task_rq_unlock(rq, p, &rf);
+		stop_one_cpu(cpu_of(rq), migration_cpu_stop, &arg);
+		tlb_migrate_finish(p->mm);
+		return 0;
+	} else if (task_on_rq_queued(p)) {
+		/*
+		 * OK, since we're going to drop the lock immediately
+		 * afterwards anyway.
+		 */
+		rq = move_queued_task(rq, &rf, p, dest_cpu);
+	}
+out:
+	task_rq_unlock(rq, p, &rf);
+
+	return ret;
+}
+
 /*
  * Change a given task's CPU affinity. Migrate the thread to a
  * proper CPU and schedule it away if the CPU it's executing on
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index eeef1a3086d1..a1c0e60006f8 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1207,6 +1207,8 @@ static inline void __set_task_cpu(struct task_struct *p, unsigned int cpu)
 #endif
 }
 
+int push_task_to_cpu(struct task_struct *p, unsigned int dest_cpu);
+
 /*
  * Tunables that become constants when CONFIG_SCHED_DEBUG is off:
  */
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index c7b366ccf39c..044808ac8197 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -261,3 +261,4 @@ cond_syscall(sys_pkey_free);
 
 /* restartable sequence */
 cond_syscall(sys_rseq);
+cond_syscall(sys_cpu_opv);
-- 
2.11.0

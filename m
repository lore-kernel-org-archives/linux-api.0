From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH for 4.18 01/23] uapi headers: Provide types_32_64.h (v2)
Date: Thu, 12 Apr 2018 15:27:38 -0400
Message-ID: <20180412192800.15708-2-mathieu.desnoyers@efficios.com>
References: <20180412192800.15708-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180412192800.15708-1-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
List-Id: linux-api@vger.kernel.org

Provide helper macros for fields which represent pointers in
kernel-userspace ABI. This facilitates handling of 32-bit
user-space by 64-bit kernels by defining those fields as
32-bit 0-padding and 32-bit integer on 32-bit architectures,
which allows the kernel to treat those as 64-bit integers.
The order of padding and 32-bit integer depends on the
endianness.

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

Changes since v1:
- Public uapi headers use __u32 and __u64 rather than uint32_t and
  uint64_t.
---
 include/uapi/linux/types_32_64.h | 67 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 67 insertions(+)
 create mode 100644 include/uapi/linux/types_32_64.h

diff --git a/include/uapi/linux/types_32_64.h b/include/uapi/linux/types_32_64.h
new file mode 100644
index 000000000000..fc9602c318cd
--- /dev/null
+++ b/include/uapi/linux/types_32_64.h
@@ -0,0 +1,67 @@
+#ifndef _UAPI_LINUX_TYPES_32_64_H
+#define _UAPI_LINUX_TYPES_32_64_H
+
+/*
+ * linux/types_32_64.h
+ *
+ * Integer type declaration for pointers across 32-bit and 64-bit systems.
+ *
+ * Copyright (c) 2015-2017 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
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
+#else
+# include <stdint.h>
+#endif
+
+#include <asm/byteorder.h>
+
+#ifdef __BYTE_ORDER
+# if (__BYTE_ORDER == __BIG_ENDIAN)
+#  define LINUX_BYTE_ORDER_BIG_ENDIAN
+# else
+#  define LINUX_BYTE_ORDER_LITTLE_ENDIAN
+# endif
+#else
+# ifdef __BIG_ENDIAN
+#  define LINUX_BYTE_ORDER_BIG_ENDIAN
+# else
+#  define LINUX_BYTE_ORDER_LITTLE_ENDIAN
+# endif
+#endif
+
+#ifdef __LP64__
+# define LINUX_FIELD_u32_u64(field)			__u64 field
+# define LINUX_FIELD_u32_u64_INIT_ONSTACK(field, v)	field = (intptr_t)v
+#else
+# ifdef LINUX_BYTE_ORDER_BIG_ENDIAN
+#  define LINUX_FIELD_u32_u64(field)	__u32 field ## _padding, field
+#  define LINUX_FIELD_u32_u64_INIT_ONSTACK(field, v)	\
+	field ## _padding = 0, field = (intptr_t)v
+# else
+#  define LINUX_FIELD_u32_u64(field)	__u32 field, field ## _padding
+#  define LINUX_FIELD_u32_u64_INIT_ONSTACK(field, v)	\
+	field = (intptr_t)v, field ## _padding = 0
+# endif
+#endif
+
+#endif /* _UAPI_LINUX_TYPES_32_64_H */
-- 
2.11.0

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH for 4.18 4/5] rseq: remove unused types_32_64.h uapi header
Date: Thu,  5 Jul 2018 14:06:00 -0400
Message-ID: <20180705180601.18423-5-mathieu.desnoyers@efficios.com>
References: <20180705180601.18423-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180705180601.18423-1-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@g>
List-Id: linux-api@vger.kernel.org

This header was introduced in the 4.18 merge window, and rseq does
not need it anymore. Nuke it before the final release.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Paul Turner <pjt@google.com>
CC: Thomas Gleixner <tglx@linutronix.de>
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
 include/uapi/linux/types_32_64.h | 50 ----------------------------------------
 1 file changed, 50 deletions(-)
 delete mode 100644 include/uapi/linux/types_32_64.h

diff --git a/include/uapi/linux/types_32_64.h b/include/uapi/linux/types_32_64.h
deleted file mode 100644
index 0a87ace34a57..000000000000
--- a/include/uapi/linux/types_32_64.h
+++ /dev/null
@@ -1,50 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
-#ifndef _UAPI_LINUX_TYPES_32_64_H
-#define _UAPI_LINUX_TYPES_32_64_H
-
-/*
- * linux/types_32_64.h
- *
- * Integer type declaration for pointers across 32-bit and 64-bit systems.
- *
- * Copyright (c) 2015-2018 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
- */
-
-#ifdef __KERNEL__
-# include <linux/types.h>
-#else
-# include <stdint.h>
-#endif
-
-#include <asm/byteorder.h>
-
-#ifdef __BYTE_ORDER
-# if (__BYTE_ORDER == __BIG_ENDIAN)
-#  define LINUX_BYTE_ORDER_BIG_ENDIAN
-# else
-#  define LINUX_BYTE_ORDER_LITTLE_ENDIAN
-# endif
-#else
-# ifdef __BIG_ENDIAN
-#  define LINUX_BYTE_ORDER_BIG_ENDIAN
-# else
-#  define LINUX_BYTE_ORDER_LITTLE_ENDIAN
-# endif
-#endif
-
-#ifdef __LP64__
-# define LINUX_FIELD_u32_u64(field)			__u64 field
-# define LINUX_FIELD_u32_u64_INIT_ONSTACK(field, v)	field = (intptr_t)v
-#else
-# ifdef LINUX_BYTE_ORDER_BIG_ENDIAN
-#  define LINUX_FIELD_u32_u64(field)	__u32 field ## _padding, field
-#  define LINUX_FIELD_u32_u64_INIT_ONSTACK(field, v)	\
-	field ## _padding = 0, field = (intptr_t)v
-# else
-#  define LINUX_FIELD_u32_u64(field)	__u32 field, field ## _padding
-#  define LINUX_FIELD_u32_u64_INIT_ONSTACK(field, v)	\
-	field = (intptr_t)v, field ## _padding = 0
-# endif
-#endif
-
-#endif /* _UAPI_LINUX_TYPES_32_64_H */
-- 
2.11.0

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH 1/5] glibc: Perform rseq(2) registration at C startup
 and thread creation (v8)
Date: Wed, 17 Apr 2019 11:59:29 -0400 (EDT)
Message-ID: <364803063.586.1555516769056.JavaMail.zimbra@efficios.com>
References: <20190416173216.9028-1-mathieu.desnoyers@efficios.com> <20190416173216.9028-2-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190416173216.9028-2-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: carlos <carlos@redhat.com>, Will Deacon <will.deacon@arm.com>
Cc: Florian Weimer <fweimer@redhat.com>, Joseph Myers <joseph@codesourcery.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Rich Felker <dalias@libc.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

----- On Apr 16, 2019, at 1:32 PM, Mathieu Desnoyers mathieu.desnoyers@efficios.com wrote:

[...]
> diff --git a/sysdeps/unix/sysv/linux/aarch64/bits/rseq.h
> b/sysdeps/unix/sysv/linux/aarch64/bits/rseq.h
> new file mode 100644
> index 0000000000..b02471a89a
> --- /dev/null
> +++ b/sysdeps/unix/sysv/linux/aarch64/bits/rseq.h
> @@ -0,0 +1,32 @@
> +/* Restartable Sequences Linux aarch64 architecture header.
> +
> +   Copyright (C) 2019 Free Software Foundation, Inc.
> +
> +   The GNU C Library is free software; you can redistribute it and/or
> +   modify it under the terms of the GNU Lesser General Public
> +   License as published by the Free Software Foundation; either
> +   version 2.1 of the License, or (at your option) any later version.
> +
> +   The GNU C Library is distributed in the hope that it will be useful,
> +   but WITHOUT ANY WARRANTY; without even the implied warranty of
> +   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> +   Lesser General Public License for more details.
> +
> +   You should have received a copy of the GNU Lesser General Public
> +   License along with the GNU C Library; if not, see
> +   <http://www.gnu.org/licenses/>.  */
> +
> +#ifndef _SYS_RSEQ_H
> +# error "Never use <bits/rseq.h> directly; include <sys/rseq.h> instead."
> +#endif
> +
> +/* RSEQ_SIG is a signature required before each abort handler code.
> +
> +   It is a 32-bit value that maps to actual architecture code compiled
> +   into applications and libraries. It needs to be defined for each
> +   architecture. When choosing this value, it needs to be taken into
> +   account that generating invalid instructions may have ill effects on
> +   tools like objdump, and may also have impact on the CPU speculative
> +   execution efficiency in some cases.  */
> +
> +#define RSEQ_SIG 0xd428bc00	/* BRK #0x45E0.  */

After further investigation, we should probably do the following
to handle compiling with -mbig-endian on aarch64, which generates
binaries with mixed code vs data endianness (little endian code,
big endian data):

#ifdef __ARM_BIG_ENDIAN
#define RSEQ_SIG 0x00bc28d4	/* BRK #0x45E0.  */
#else
#define RSEQ_SIG 0xd428bc00	/* BRK #0x45E0.  */
#endif

Else mismatch between code endianness for the generated
signatures and data endianness for the RSEQ_SIG parameter
passed to the rseq registration will trigger application
segmentation faults when the kernel try to abort rseq
critical sections.

For ARM32, the situation is a bit more complex. Only armv6+
generates mixed-endianness code vs data with -mbig-endian.
Prior to armv6, the code and data endianness matches. Therefore,
I plan to #ifdef the reversed endianness handling with:

#if __ARM_ARCH >= 6 && __ARM_BIG_ENDIAN

on arm32.

Thoughts ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

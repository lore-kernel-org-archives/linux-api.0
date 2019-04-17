From: Joseph Myers <joseph@codesourcery.com>
Subject: Re: [PATCH 1/5] glibc: Perform rseq(2) registration at C startup
 and thread creation (v8)
Date: Wed, 17 Apr 2019 16:17:17 +0000
Message-ID: <alpine.DEB.2.21.1904171601540.32123@digraph.polyomino.org.uk>
References: <20190416173216.9028-1-mathieu.desnoyers@efficios.com> <20190416173216.9028-2-mathieu.desnoyers@efficios.com> <364803063.586.1555516769056.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <364803063.586.1555516769056.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: carlos <carlos@redhat.com>, Will Deacon <will.deacon@arm.com>, Florian Weimer <fweimer@redhat.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Rich Felker <dalias@libc.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, 17 Apr 2019, Mathieu Desnoyers wrote:

> > +/* RSEQ_SIG is a signature required before each abort handler code.
> > +
> > +   It is a 32-bit value that maps to actual architecture code compiled
> > +   into applications and libraries. It needs to be defined for each
> > +   architecture. When choosing this value, it needs to be taken into
> > +   account that generating invalid instructions may have ill effects on
> > +   tools like objdump, and may also have impact on the CPU speculative
> > +   execution efficiency in some cases.  */
> > +
> > +#define RSEQ_SIG 0xd428bc00	/* BRK #0x45E0.  */
> 
> After further investigation, we should probably do the following
> to handle compiling with -mbig-endian on aarch64, which generates
> binaries with mixed code vs data endianness (little endian code,
> big endian data):

First, the comment on RSEQ_SIG should specify whether it is to be 
interpreted in the code or the data endianness.

> For ARM32, the situation is a bit more complex. Only armv6+
> generates mixed-endianness code vs data with -mbig-endian.
> Prior to armv6, the code and data endianness matches. Therefore,
> I plan to #ifdef the reversed endianness handling with:
> 
> #if __ARM_ARCH >= 6 && __ARM_BIG_ENDIAN
> 
> on arm32.

That doesn't work well because BE code (.o files) can be built for v5te 
(for example) and used on a range of different architecture variants with 
both BE32 and BE8 - the choice between BE32 and BE8 is a link-time choice, 
not a compile-time choice.  So if the value for Arm is a compile-time 
constant, it should also work for both BE32 and BE8.

In turn, that suggests to me that RSEQ_SIG should be defined to be a value 
that is always in the code endianness (and whatever corresponding kernel 
code handles RSEQ_SIG values should act accordingly on architectures where 
the two endiannesses can differ).  If the kernel ABI is already fixed in a 
way that prevents such a definition of RSEQ_SIG semantics as using code 
endianness, a value should be chosen for Arm that works for both 
endiannesses.

(Also, installed glibc headers are supposed to work with older compilers, 
and support for __ARM_ARCH was only added in GCC 4.8.  Before that you 
need to test lots of separate macros for different architecture variants 
to determine a version number.)

-- 
Joseph S. Myers
joseph@codesourcery.com

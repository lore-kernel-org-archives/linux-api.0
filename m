From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH glibc 1/4] glibc: Perform rseq(2) registration at C
 startup and thread creation (v6)
Date: Tue, 29 Jan 2019 20:39:19 -0500 (EST)
Message-ID: <596949707.3888.1548812359874.JavaMail.zimbra@efficios.com>
References: <20190121213530.23803-1-mathieu.desnoyers@efficios.com> <632671842.3079.1548781059601.JavaMail.zimbra@efficios.com> <alpine.DEB.2.21.1901292153190.24454@digraph.polyomino.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1901292153190.24454@digraph.polyomino.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Joseph Myers <joseph@codesourcery.com>
Cc: carlos <carlos@redhat.com>, Florian Weimer <fweimer@redhat.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Rich Felker <dalias@libc.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

----- On Jan 29, 2019, at 4:56 PM, Joseph Myers joseph@codesourcery.com wrote:

> On Tue, 29 Jan 2019, Mathieu Desnoyers wrote:
> 
>> I recalled that aarch64 defines RSEQ_SIG to a different value which maps to
>> a valid trap instruction. So I plan to move the RSEQ_SIG define to per-arch
>> headers like this:
>> 
>>  sysdeps/unix/sysv/linux/aarch64/bits/rseq.h                  |   24 ++
>>  sysdeps/unix/sysv/linux/arm/bits/rseq.h                      |   24 ++
>>  sysdeps/unix/sysv/linux/bits/rseq.h                          |   23 ++
>>  sysdeps/unix/sysv/linux/mips/bits/rseq.h                     |   24 ++
>>  sysdeps/unix/sysv/linux/powerpc/bits/rseq.h                  |   24 ++
>>  sysdeps/unix/sysv/linux/s390/bits/rseq.h                     |   24 ++
>>  sysdeps/unix/sysv/linux/x86/bits/rseq.h                      |   24 ++
>> 
>> where "bits/rseq.h" contains a #error:
>> 
>> # error "Architecture does not define RSEQ_SIG.
>> 
>> sys/rseq.h will now include <bits/rseq.h>.
> 
> We're trying to reduce the number of cases where most or all new glibc
> architecture ports need to provide a bits/ header, by making the generic
> headers handle the common case.  So a generic header with a #error, and
> lots of architecture-specific headers mostly with the same value for
> RSEQ_SIG, seems unfortunate.  I'd hope the generic header could use a
> generic value, with architecture-specific variants only for architectures
> with some reason for a different value.

The issue here is that it would require us to decide right away what RSEQ_SIG
is appropriate for all other Linux architectures supported by glibc. There are
a few reasons for which an architecture can be required to specify its own
RSEQ_SIG. For instance, it may need to map to an instruction defined in the
instruction set, thus ensuring objdump does not get confused, and in other
cases that the processor speculative execution happening just before the
RSEQ_SIG really stops at the signature (hence the trap instruction on aarch64).

I'm worried that if we introduce a "default" RSEQ_SIG value for architectures
currently not supported by RSEQ and we then introduce an architecture-specific
signature value in the future, some applications will try to build with
wrong signatures, and when the rseq system call gets eventually implemented for
those architecture and a end-user upgrades his kernel, those signatures won't
match between glibc rseq registration and the application rseq abort handlers,
thus leading to hard-to-reproduce segmentation faults delivered by the kernel
checking those signatures upon rseq abort.

This upgrade story is far from ideal.

My thinking was to put the #error in the generic header, so architectures that
are not supported yet cannot build against rseq.h at all, so we don't end up
in a broken upgrade scenario. I'm open to alternative ways to do it though, as
long as we don't let not-yet-supported architectures build broken code.

Thoughts ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

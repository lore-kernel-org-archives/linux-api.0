From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH glibc 1/4] glibc: Perform rseq(2) registration at C
 startup and thread creation (v6)
Date: Wed, 30 Jan 2019 13:03:46 -0500 (EST)
Message-ID: <1832200535.4162.1548871426959.JavaMail.zimbra@efficios.com>
References: <20190121213530.23803-1-mathieu.desnoyers@efficios.com> <632671842.3079.1548781059601.JavaMail.zimbra@efficios.com> <alpine.DEB.2.21.1901292153190.24454@digraph.polyomino.org.uk> <596949707.3888.1548812359874.JavaMail.zimbra@efficios.com> <alpine.DEB.2.21.1901300231210.24454@digraph.polyomino.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1901300231210.24454@digraph.polyomino.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Joseph Myers <joseph@codesourcery.com>
Cc: carlos <carlos@redhat.com>, Florian Weimer <fweimer@redhat.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Rich Felker <dalias@libc.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

----- On Jan 29, 2019, at 9:40 PM, Joseph Myers joseph@codesourcery.com wrote:

> On Tue, 29 Jan 2019, Mathieu Desnoyers wrote:
> 
>> My thinking was to put the #error in the generic header, so architectures that
>> are not supported yet cannot build against rseq.h at all, so we don't end up
>> in a broken upgrade scenario. I'm open to alternative ways to do it though, as
>> long as we don't let not-yet-supported architectures build broken code.
> 
> Any case with #error in installed glibc headers needs special-casing in
> check-installed-headers.sh (and, thus, such errors are to be discouraged).

One alternative to #error would be to have an empty generic bits/rseq.h
that does _not_ define RSEQ_SIG. This way, it would be possible to
include sys/rseq.h from an architecture that does not define RSEQ_SIG
yet, but it would not cause any build failure. It's only if the code
try to use RSEQ_SIG that it would fail to compile because undefined.

> Cases where architectures commonly need their own bits/ headers,
> especially where those are likely to need updating for new kernel
> versions, are also discouraged.

The per-arch bits/rseq.h headers, once they define a specific value for
RSEQ_SIG, should never ever change that value.

> Furthermore, a normal check for glibc
> headers updates needed for a new kernel version would only involve
> examining uapi headers (and the non-uapi linux/socket.h for new address
> families, an unfortunate existing wart in this area).  As far as I can
> see, this value isn't defined in any uapi header, which makes it
> especially likely to be missed in such a check.  Furthermore, I'm hoping
> to add more glibc tests for consistency of such constants between glibc
> and the kernel, to ensure any such updates missing are caught
> automatically through test failures - but that doesn't work if the
> constants in question aren't in a uapi header.
> 
> If this constant were in a uapi header, the glibc header could just
> include that - is the issue that it's not actually an interface between
> glibc and the kernel at all, but some kind of purely-userspace interface?

The rseq uapi headers do not enforce the value of RSEQ_SIG. The role of the
kernel wrt signature is to receive it as sys_rseq argument, and then validate
that abort targets are prefixed with the signature before moving the
instruction pointer there.

Therefore, it's up to user-space to agree on the RSEQ_SIG value across
all code using rseq within a process. Since glibc will be registering
rseq and exposing public headers, it appears that glibc would be the
appropriate project to define the RSEQ_SIG value for each architecture.

> 
> We very definitely wish to keep to a minimum the cases where updates need
> to be done separately in glibc by each architecture maintainer (that's
> just a recipe for some updates getting missed accidentally) - meaning that
> there needs to be a clear way in which someone can tell, globally for all
> architectures, whether the set of such architecture-specific headers for
> this constant in glibc is complete and current, and when it needs updating
> (and this should be as similar to possible to such checks for any other
> header constant).

Currently, I use #ifdef __NR_rseq from uapi unistd.h to check whether the
kernel headers implement the rseq system call for the target architecture.

With the approach of having an empty bits/rseq.h for architecture not yet
supporting rseq in glibc, one way to check that glibc implements RSEQ_SIG
for all architectures that have the rseq system call wired up in uapi would
be:

#include <unistd.h>
#include <sys/rseq.h>

#if defined (__NR_rseq) && !defined (RSEQ_SIG)
# error "UAPI headers support rseq system call, but glibc does not define RSEQ_SIG."
#endif

Would that take care of your concerns ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

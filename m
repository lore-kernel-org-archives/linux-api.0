From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH] glibc: Perform rseq(2) registration at nptl init
 and thread creation
Date: Thu, 20 Sep 2018 16:14:17 -0400 (EDT)
Message-ID: <1619649568.9014.1537474457166.JavaMail.zimbra@efficios.com>
References: <20180919144438.1066-1-mathieu.desnoyers@efficios.com> <alpine.DEB.2.21.1809191630260.26757@digraph.polyomino.org.uk> <67473000.8399.1537375994645.JavaMail.zimbra@efficios.com> <alpine.DEB.2.21.1809191706090.26757@digraph.polyomino.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1809191706090.26757@digraph.polyomino.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Joseph Myers <joseph@codesourcery.com>
Cc: carlos <carlos@redhat.com>, Florian Weimer <fweimer@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, libc-alpha <libc-alpha@sourceware.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

----- On Sep 19, 2018, at 1:10 PM, Joseph Myers joseph@codesourcery.com wrote:

> On Wed, 19 Sep 2018, Mathieu Desnoyers wrote:
> 
>> > This looks like it's coming from the Linux kernel.  Can't the relevant
>> > uapi header just be used directly without copying into glibc (with due
>> > care to ensure that glibc still builds if the kernel headers used for the
>> > build are too old - you need such conditionals anyway if they don't define
>> > the relevant syscall number)?
>> 
>> This is indeed in the list of "things to consider" I've put in the patch
>> commit message. If the usual practice is to build against uapi kernel headers
>> outside of the glibc tree, I'm fine with that.
> 
> We build with, currently, 3.2 or later headers (since 3.2 is EOL there's a
> case for updating the minimum in glibc for both compile time and runtime,
> but I haven't proposed that since there isn't much cleanup that would
> enable and there's the open question of Carlos's proposal to eliminate the
> runtime check on the kernel version and just let things try to run anyway
> even if it's older than the configured minimum).

Are you saying glibc has an explicit check for the kernel version visible
from /proc before using specific features ? If so, how can this work with
the variety of feature backports we find in the distribution kernels out
there ?

Checking whether specific system calls return ENOSYS errors seems more
flexible.

> Functions depending on
> new syscalls may return ENOSYS errors if the headers used to build glibc
> were too old.  Since this patch is providing a data interface rather than
> functions that can set errno to ENOSYS, presumably you have some other way
> of signalling unavailability which would apply both with a too-old kernel
> at runtime and too-old headers at compile time.

For too-old kernel at runtime, having rseq registration return ENOSYS
leaves the the content of __rseq_abi->cpu_id at its initial value
(RSEQ_CPU_ID_UNINITIALIZED = -1).

For too-old headers at compile time, one possibility is that we don't event
expose the __rseq_abi TLS symbol. OTOH, if we need to keep exposing it anyway
for ABI consistency purposes, then we'd leave its cpu_id field at the initial
value (-1). But that would require that we copy linux/rseq.h into the glibc
source tree.

Thoughts ?

Thanks,

Mathieu

> 
> --
> Joseph S. Myers
> joseph@codesourcery.com

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

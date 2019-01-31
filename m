From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH glibc 1/4] glibc: Perform rseq(2) registration at C
 startup and thread creation (v6)
Date: Thu, 31 Jan 2019 11:37:08 -0500 (EST)
Message-ID: <19276261.499.1548952628477.JavaMail.zimbra@efficios.com>
References: <20190121213530.23803-1-mathieu.desnoyers@efficios.com> <632671842.3079.1548781059601.JavaMail.zimbra@efficios.com> <alpine.DEB.2.21.1901292153190.24454@digraph.polyomino.org.uk> <596949707.3888.1548812359874.JavaMail.zimbra@efficios.com> <alpine.DEB.2.21.1901300231210.24454@digraph.polyomino.org.uk> <1832200535.4162.1548871426959.JavaMail.zimbra@efficios.com> <alpine.DEB.2.21.1901302104360.16754@digraph.polyomino.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1901302104360.16754@digraph.polyomino.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Joseph Myers <joseph@codesourcery.com>
Cc: carlos <carlos@redhat.com>, Florian Weimer <fweimer@redhat.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Rich Felker <dalias@libc.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

----- On Jan 30, 2019, at 4:10 PM, Joseph Myers joseph@codesourcery.com wrote:

> On Wed, 30 Jan 2019, Mathieu Desnoyers wrote:
> 
>> #if defined (__NR_rseq) && !defined (RSEQ_SIG)
>> # error "UAPI headers support rseq system call, but glibc does not define
>> RSEQ_SIG."
>> #endif
>> 
>> Would that take care of your concerns ?
> 
> That would of course need appropriate conditionals based on the most
> recent kernel version for which a given glibc version has been updated, so
> that using new kernel headers with an existing glibc release does not make
> the build fail (cf. the test of syscall-names.list).

The test I hint at above would not be for the glibc build per se. It would
be for a check that glibc implements support for all the system calls
available in the kernel headers (if such a test target currently exists).

> And being able to
> write such a test only solves one half of the problem - it needs to be
> easy to determine what value to put in that header in glibc for an
> architecture that's newly gained support in the kernel, *without* needing
> any architecture expertise.

I'm afraid this requirement is incompatible with the nature of the RSEQ
signature. This signature may be required to be a specific trap instruction
by the architecture, so deciding on its value without architecture expertise
is not possible.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

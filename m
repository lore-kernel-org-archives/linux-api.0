From: Carlos O'Donell <carlos@redhat.com>
Subject: Re: [RFC PATCH v9 for 4.15 01/14] Restartable sequences system call
Date: Mon, 16 Oct 2017 09:04:34 -0700
Message-ID: <165916d7-2f86-445a-9c84-f6444b5e753b@redhat.com>
References: <20171012230326.19984-1-mathieu.desnoyers@efficios.com>
 <20171012230326.19984-2-mathieu.desnoyers@efficios.com>
 <CA+55aFy54Sk63VkS3HFnd4MPiSbgV6==NaYwr+D9sjG6KZGmHQ@mail.gmail.com>
 <DM5PR15MB1690DA99E4AA74FBE54CF7F9CF480@DM5PR15MB1690.namprd15.prod.outlook.com>
 <CA+55aFzPBES0JOYuZhuNM7NKN+G9ytZQT2daueFPw0j9HGpdGQ@mail.gmail.com>
 <20171013205418.GM3521@linux.vnet.ibm.com>
 <CA+55aFwvNS95ByZJTh1yG25QfaD0K0ZByK3iXeeRU8LafFiGFQ@mail.gmail.com>
 <135399003.40850.1507930608890.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <135399003.40850.1507930608890.JavaMail.zimbra@efficios.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Ben Maurer <bmaurer@fb.com>, David Goldblatt <davidgoldblatt@fb.com>, Qi Wang <qiwang@fb.com>, Boqun Feng <boqun.feng@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Josh Triplett <josh@joshtriplett.org>, Will Deacon <will.deacon@arm.com>, linux-kernel <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, rostedt <rostedt@goodmis.org>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Catalin
List-Id: linux-api@vger.kernel.org

On 10/13/2017 02:36 PM, Mathieu Desnoyers wrote:
> I also spoke to Carlos O'Donell from glibc about it, and he was very
> excited about the possible use of rseq for malloc speedup/memory usage
> improvement. But again, I don't see a project like glibc starting to
> use a system call for which the number will have to be bumped every
> now and then.
> 
> I would *not* want this merged before we gather significant user feedback.
> The question is: how can we best gather that feedback ?
> 
> Perhaps one approach could be to reserve system call numbers for
> sys_rseq and sys_cpu_opv, but leave them unimplemented for now
> (ENOSYS). This would lessen the amount of pain user-space would have
> to go through to adapt to system call number changes, and we could
> provide the implementation of those system calls in a -rseq tree, which
> I'd be happy to maintain in order to gather feedback. If it ends up that
> it's not the right approach after all, all we would have lost is two
> unwired system call numbers per architecture.
> 
> Thoughts ?

We have similar problems in glibc with API/ABI issues, and there 
isn't really any way around this except to present a reviewer with
an overwhelming amount of evidence that use cases exist and work.

How you collect, summarize, and analyze that overwhelming evidence
is up to you, specific to each change, and difficult to do accurately
and with any large measure of statistical confidence. The reviewer
has to basically trust you to some degree :-)

We should probably be working together to present the case to Linus
that glibc is immediately ready to use restartable sequences and
provide the use cases we have in mind with a public branch showing
the work and the results. This would at least convince people that
if we turned this on, every application would get benefit from a
GNU system running glibc (which is less than the number of people
running Linux on phones these days so YMMV).

As always, glibc can use any new kernel features immediately,
and only needs to detect presence at startup.

My only concrete suggestion would be to add a level of indirection,
some way to fetch the new syscalls dynamically at program startup,
then I could construct a way to call them, mark it RO, and use that
e.g. a userspace syscall table populated dynamically for experimental
syscalls (semantic changes would require changes in the name used for
lookup). It's just an expansion of the number of bits used to identify
the syscall. Obviously such a patch is only for downstream testing
in order to gather consensus for upstream patches.

-- 
Cheers,
Carlos.

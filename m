From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH for 4.18 12/23] cpu_opv: Provide cpu_opv system call
 (v7)
Date: Mon, 16 Apr 2018 12:28:14 -0400 (EDT)
Message-ID: <751033048.11156.1523896094938.JavaMail.zimbra@efficios.com>
References: <20180412192800.15708-1-mathieu.desnoyers@efficios.com> <20180412192800.15708-13-mathieu.desnoyers@efficios.com> <CA+55aFxcJ2V_1BoW0Cct=Kkp7REkgiU_BTimGdmoFmWHaWaZ-g@mail.gmail.com> <20180412202302.xnw5jdl3upl46ywt@two.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180412202302.xnw5jdl3upl46ywt@two.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Catalin Marinas <catalin.marinas@arm.com>, Will
List-Id: linux-api@vger.kernel.org

----- On Apr 12, 2018, at 4:23 PM, Andi Kleen andi@firstfloor.org wrote:

>> Can we plan on merging just the plain rseq parts *without* this all
>> first, and then see the cpu_opv thing as a "maybe future expansion"
>> part.
> 
> That would be the right way to go. I doubt anybody really needs cpu_opv.
> We already have other code (e.g. vgettimeofday) which cannot
> be single stepped, and so far it never was a problem.

Single-stepping is only a subset of the rseq limitations addressed
by cpu_opv. Anoher major limitation is algorithms requiring data
migration between per-cpu data structures safely against CPU hotplug,
and without having to change the cpu affinity mask. This is the case
for memory allocators and userspace task schedulers which require
cpu_opv for migration between per-cpu memory pools and scheduler
runqueues.

About the vgettimeofday and general handling of vDSO by gdb, gdb's
approach only takes care of line-by-line single-stepping by hiding
Linux' vdso mapping so users cannot target source code lines within
that shared object. However, it breaks instruction-level single-stepping.
I reported this issue to you back in Nov. 2017:
https://lkml.org/lkml/2017/11/20/803

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

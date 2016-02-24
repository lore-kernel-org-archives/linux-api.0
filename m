From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH v4 0/5] getcpu_cache system call for 4.6
Date: Wed, 24 Feb 2016 04:09:23 +0000 (UTC)
Message-ID: <1452699925.6549.1456286963485.JavaMail.zimbra@efficios.com>
References: <1456270120-7560-1-git-send-email-mathieu.desnoyers@efficios.com> <56CD091A.4060009@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <56CD091A.4060009@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Peter Zijlstra <peterz@infradead.org>, Andy Lutomirski <luto@amacapital.net>, Andi Kleen <andi@firstfloor.org>, Dave Watson <davejwatson@fb.com>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

----- On Feb 23, 2016, at 8:36 PM, H. Peter Anvin hpa@zytor.com wrote:

> On 02/23/2016 03:28 PM, Mathieu Desnoyers wrote:
>> Hi,
>> 
>> Here is a patchset implementing a cache for the CPU number of the
>> currently running thread in user-space.
>> 
>> Benchmarks comparing this approach to a getcpu based on system call on
>> ARM show a 44x speedup. They show a 14x speedup on x86-64 compared to
>> executing lsl from a vDSO through glibc.
>> 
>> I'm added a man page in the changelog of patch 1/3, which shows an
>> example usage of this new system call.
>> 
>> This series is based on v4.5-rc5, submitted for Linux 4.6.
>> 
>> Feedback is welcome,
>> 
> 
> What is the resulting context switch overhead?

The getcpu_cache only adds code to the thread migration path,
and to the resume notifier. The context switch path per se is
untouched. I would therefore expect the overhead on context
switch to be within the noise, except if stuff like hackbench
would be so sensitive to the size of struct task_struct that
a single extra pointer added at the end of struct task_struct
would throw off the benchmarks.

Is that what you are concerned about ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

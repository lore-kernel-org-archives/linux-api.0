From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH for 4.17 02/21] rseq: Introduce restartable
 sequences system call (v12)
Date: Wed, 28 Mar 2018 10:31:39 -0400 (EDT)
Message-ID: <991996685.2091.1522247499415.JavaMail.zimbra@efficios.com>
References: <20180327160542.28457-1-mathieu.desnoyers@efficios.com> <20180327160542.28457-3-mathieu.desnoyers@efficios.com> <20180328064703.56hsuicmikejg7np@tardis> <777590253.2016.1522245960189.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <777590253.2016.1522245960189.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boqun Feng <boqun.feng@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>
List-Id: linux-api@vger.kernel.org

----- On Mar 28, 2018, at 10:06 AM, Mathieu Desnoyers mathieu.desnoyers@efficios.com wrote:

> ----- On Mar 28, 2018, at 2:47 AM, Boqun Feng boqun.feng@gmail.com wrote:
> 
>> On Tue, Mar 27, 2018 at 12:05:23PM -0400, Mathieu Desnoyers wrote:
>> [...]
>>> Changes since v11:
>>> 
>>> - Replace task struct rseq_preempt, rseq_signal, and rseq_migrate
>>>   bool by u32 rseq_event_mask.
>> [...]
>>> @@ -979,6 +980,17 @@ struct task_struct {
>>>  	unsigned long			numa_pages_migrated;
>>>  #endif /* CONFIG_NUMA_BALANCING */
>>>  
>>> +#ifdef CONFIG_RSEQ
>>> +	struct rseq __user *rseq;
>>> +	u32 rseq_len;
>>> +	u32 rseq_sig;
>>> +	/*
>>> +	 * RmW on rseq_event_mask must be performed atomically
>>> +	 * with respect to preemption.
>>> +	 */
>>> +	unsigned long rseq_event_mask;
>> 
>> s/unsigned long/u32
> 
> good point, fixed.
> 

Actually, by having a u32 instead of unsigned long here, it triggers those
warnings:

In file included from ./include/linux/bitops.h:38:0,
                 from ./include/linux/kernel.h:11,
                 from certs/system_keyring.c:13:
./arch/x86/include/asm/bitops.h:73:1: note: expected ‘volatile long unsigned int *’ but argument is of type ‘u32 *’
 set_bit(long nr, volatile unsigned long *addr)
 ^

I suspect that casting the u32 * to a unsigned long * is not a safe approach, because
the code can generate a load/store on unallocated memory (kasan might complain).

Thoughts ?

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

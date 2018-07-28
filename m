From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH for 4.18 00/16] Restartable Sequences
Date: Sat, 28 Jul 2018 09:49:04 -0400 (EDT)
Message-ID: <1210024721.6363.1532785744879.JavaMail.zimbra@efficios.com>
References: <20180602124408.8430-1-mathieu.desnoyers@efficios.com> <20180727220115.GA18879@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180727220115.GA18879@amd>
Sender: linux-kernel-owner@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>, Carlos O'Donell <carlos@redhat.com>, Florian Weimer <fweimer@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <cata>
List-Id: linux-api@vger.kernel.org

----- On Jul 27, 2018, at 6:01 PM, Pavel Machek pavel@ucw.cz wrote:

> Hi!
> 
>> So for instance, this turns:
>> 
>>   int cpu = rseq_per_cpu_lock(lock, target_cpu);
>>   [...]
>>   rseq_per_cpu_unlock(lock, cpu);
>> 
>> into
>> 
>>   int cpu = rseq_this_cpu_lock(lock);
>>   [...]
>>   rseq_per_cpu_unlock(lock, cpu);
>> 
>> and:
>> 
>>   per_cpu_list_push(list, node, target_cpu);
>>   [...]
>>   per_cpu_list_pop(list, node, target_cpu);
>> 
>> into
>> 
>>   this_cpu_list_push(list, node, &cpu);  /* cpu is an output parameter. */
>>   [...]
>>   node = this_cpu_list_pop(list, &cpu);  /* cpu is an output parameter. */
>> 
>> Eventually integrating cpu_opv or some alternative will allow passing
>> the cpu number as parameter rather than requiring the algorithm to work
>> on the current CPU.
>> 
>> The second effect of not having the cpu_opv fallback is that
>> line and instruction single-stepping with a debugger transforms rseq
>> critical sections based on retry loops into never-ending loops.
>> Debuggers need to use the __rseq_table section to skip those critical
>> sections in order to correctly behave when single-stepping a thread
>> which uses rseq in a retry loop. However, applications which use an
>> alternative fallback method rather than retrying on rseq fast-path abort
>> won't be affected by this kind of single-stepping issue.
>> 
>> Thanks for your feedback!
> 
> Would it make sense to include Documentation/ patch? I guess at least
> manpage describing the syscall will be needed....

Hi Pavel,

Documentation-wise, I have posted a rseq man page rfc here:

https://lkml.kernel.org/r/20180616195803.29877-1-mathieu.desnoyers@efficios.com

comments are welcome!

It does not include any details about user-space library APIs though, as
this is not the purpose of the syscall documentation.

We're currently discussing integration of rseq thread registration into
glibc.

Once this is settled, I plan to provide a librseq which will contain headers
and documentation on how to use rseq without having to re-create the low-level
assembly every time.

Does this plan make sense to you ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

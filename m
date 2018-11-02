From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH 1/2] glibc: Perform rseq(2) registration at nptl
 init and thread creation (v3)
Date: Fri, 2 Nov 2018 11:33:14 -0400 (EDT)
Message-ID: <1563326093.34.1541172794537.JavaMail.zimbra@efficios.com>
References: <20181102115259.11383-1-mathieu.desnoyers@efficios.com> <CALCETrWG4j7R7jzuoPW6ifYVzwuQGMEHBp7Pb_k66_2hn1wUHg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrWG4j7R7jzuoPW6ifYVzwuQGMEHBp7Pb_k66_2hn1wUHg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: libc-alpha <libc-alpha@sourceware.org>, carlos <carlos@redhat.com>, Florian Weimer <fweimer@redhat.com>, Joseph Myers <joseph@codesourcery.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

----- On Nov 2, 2018, at 4:20 PM, Andy Lutomirski luto@amacapital.net wrote:

> On Fri, Nov 2, 2018 at 4:53 AM Mathieu Desnoyers
> <mathieu.desnoyers@efficios.com> wrote:
>>
>> Here is a third round of prototype registering rseq(2) TLS for each
>> thread (including main), and unregistering for each thread (excluding
>> main). "rseq" stands for Restartable Sequences.
>>
>> Remaining open questions:
>>
>> - How early do we want to register rseq and how late do we want to
>>   unregister it ? It's important to consider if we expect rseq to
>>   be used by the memory allocator and within destructor callbacks.
>>   However, we want to be sure the TLS (__thread) area is properly
>>   allocated across its entire use by rseq.
>>
>> - We do not need an atomic increment/decrement for the refcount per
>>   se. Just being atomic with respect to the current thread (and nested
>>   signals) would be enough. What is the proper API to use there ?
>>
>> See the rseq(2) man page proposed here:
>>   https://lkml.org/lkml/2018/9/19/647
>>
> 
> Merely having rseq registered carries some small but nonzero overhead,
> right?

There is indeed a small overhead at thread creation/exit (total of 2
system calls) and one system call in nptl init. Once registered, there
is very small, infrequent, a hard to measure overhead at thread preemption
and signal delivery.

> Should this perhaps live in a librseq.so or similar (possibly
> built as part of libc) to avoid the overhead for programs that don't
> use it?

My second patch modifies sched_getcpu() to use rseq. Another use-case
glibc guys want is to use rseq for malloc(). Once that is done, there
will be pretty much no program left using glibc facilities that won't
use rseq when available.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

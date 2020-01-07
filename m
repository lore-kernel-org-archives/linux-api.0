From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH glibc 09/13] glibc: Perform rseq(2) registration at
 C startup and thread creation (v13)
Date: Tue, 7 Jan 2020 15:44:00 -0500 (EST)
Message-ID: <1968185366.4418.1578429840460.JavaMail.zimbra@efficios.com>
References: <20200106155713.397-1-mathieu.desnoyers@efficios.com> <20200106155713.397-10-mathieu.desnoyers@efficios.com> <871rsbv4io.fsf@oldenburg2.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <871rsbv4io.fsf@oldenburg2.str.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>
Cc: carlos <carlos@redhat.com>, Joseph Myers <joseph@codesourcery.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Rich Felker <dalias@libc.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org



----- On Jan 7, 2020, at 7:23 AM, Florian Weimer fweimer@redhat.com wrote:

> * Mathieu Desnoyers:
> 
>> Register rseq(2) TLS for each thread (including main), and unregister
>> for each thread (excluding main). "rseq" stands for Restartable
>> Sequences.
>>
>> See the rseq(2) man page proposed here:
>>   https://lkml.org/lkml/2018/9/19/647
>>
>> This patch is based on glibc-2.30. The rseq(2) system call was merged
>> into Linux 4.18.
> 
> This patch needs to be updated for some be/le abilist splits.
> Big-endian ABI lists for arm, microblaze, sh, appear to be missing.

done.

> This is something that can be checked with build-many-glibcs.py.

OK.

> 
>> diff --git a/manual/threads.texi b/manual/threads.texi
>> index 0858ef8f92..059f781120 100644
>> --- a/manual/threads.texi
>> +++ b/manual/threads.texi
>> @@ -881,3 +881,20 @@ Behaves like @code{pthread_timedjoin_np} except that the
>> absolute time in
>>  @c pthread_spin_unlock
>>  @c pthread_testcancel
>>  @c pthread_yield
>> +
>> +@node Restartable Sequences
>> +@section Restartable Sequences
>> +@cindex rseq
>> +
>> +This section describes the @glibcadj{} Restartable Sequences integration.
>> +
>> +The @glibcadj{} implements a __rseq_abi TLS symbol to interact with the
>   @Theglibc{}                  @code{__rseq_abi}
> 
> 
>> +Restartable Sequences system call (Linux-specific). The layout of this
>> +structure is defined by the Linux kernel rseq.h UAPI. Registration of each
>> +thread's __rseq_abi is performed by @glibcadj{} at libc initialization and
>                                       @theglibc{}
>           @code{__rseq_abi}
>> +pthread creation.
> 
>> +Each supported architecture provide a RSEQ_SIG signature in sys/rseq.h. That
>                                         @code{RSEQ_SIG}       @file{sys/rseq.h}
> 
>> +signature is expected to be present in the code before each Restartable
>> +Sequences abort handler. Failure to provide the expected signature may
>> +terminate the process with a Segmentation fault.
> 
> 
> Two spaces at the end of setences, please.

All above done.

> 
> The manual should use @deftypevar to create an index entry etc. for
> __rseq_abi.  See argp_program_version for an example of how to do this.

OK. I've added __rseq_abi as a variable and RSEQ_SIG as a macro.

> 
> I think current policy is to have documentation for at least the minimum
> functionality in the manual.  I understand that it makes it a lot of
> work to write patches which add system call wrappers.

Makes sense.

Thanks!

Mathieu

> 
> Thanks,
> Florian

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

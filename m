From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH 2/5] glibc: sched_getcpu(): use rseq cpu_id TLS on Linux
 (v2)
Date: Thu, 18 Apr 2019 11:45:25 -0400 (EDT)
Message-ID: <1072203859.1074.1555602325772.JavaMail.zimbra@efficios.com>
References: <20190416173216.9028-1-mathieu.desnoyers@efficios.com> <20190416173216.9028-3-mathieu.desnoyers@efficios.com> <c9c53d4b-ed9b-f2d9-60b0-e5e805de0324@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c9c53d4b-ed9b-f2d9-60b0-e5e805de0324@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Szabolcs Nagy <Szabolcs.Nagy@arm.com>
Cc: carlos <carlos@redhat.com>, nd <nd@arm.com>, Florian Weimer <fweimer@redhat.com>, Joseph Myers <joseph@codesourcery.com>, libc-alpha <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <Will.Deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

----- On Apr 18, 2019, at 11:33 AM, Szabolcs Nagy Szabolcs.Nagy@arm.com wrote:

> On 16/04/2019 18:32, Mathieu Desnoyers wrote:
>> --- a/sysdeps/unix/sysv/linux/sched_getcpu.c
>> +++ b/sysdeps/unix/sysv/linux/sched_getcpu.c
>> @@ -37,3 +37,26 @@ sched_getcpu (void)
>>    return -1;
>>  #endif
>>  }
>> +
>> +#ifdef __NR_rseq
>> +#include <sys/rseq.h>
>> +#endif
>> +
>> +#if defined __NR_rseq && defined RSEQ_SIG
>> +extern __attribute__ ((tls_model ("initial-exec")))
>> +__thread volatile struct rseq __rseq_abi;
> 
> i'd expect sys/rseq.h to provide this declaration.

And it actually does! Will remove this duplicate.

Thanks,

Mathieu

> 
>> +
>> +int
>> +sched_getcpu (void)
>> +{
>> +  int cpu_id = __rseq_abi.cpu_id;
>> +
>> +  return cpu_id >= 0 ? cpu_id : vsyscall_sched_getcpu ();
>> +}
>> +#else
>> +int
>> +sched_getcpu (void)
>> +{
>> +  return vsyscall_sched_getcpu ();
>> +}
>> +#endif
>> -- 2.17.1

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

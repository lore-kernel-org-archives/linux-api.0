From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH glibc 1/4] glibc: Perform rseq(2) registration at C
 startup and thread creation (v5)
Date: Mon, 21 Jan 2019 16:23:55 -0500 (EST)
Message-ID: <1189519139.464.1548105835783.JavaMail.zimbra@efficios.com>
References: <20190115015148.32155-1-mathieu.desnoyers@efficios.com> <1887968822.1146.1547833305059.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1887968822.1146.1547833305059.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: carlos <carlos@redhat.com>
Cc: Florian Weimer <fweimer@redhat.com>, Joseph Myers <joseph@codesourcery.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Rich Felker <dalias@libc.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

----- On Jan 18, 2019, at 12:41 PM, Mathieu Desnoyers mathieu.desnoyers@efficios.com wrote:

> ----- On Jan 14, 2019, at 8:51 PM, Mathieu Desnoyers
> mathieu.desnoyers@efficios.com wrote:
> 
> [...]
> 
>> diff --git a/sysdeps/unix/sysv/linux/rseq-sym.c
>> b/sysdeps/unix/sysv/linux/rseq-sym.c
>> new file mode 100644
>> index 0000000000..6856d0388a
> [...]
>> +/* volatile because fields can be read/updated by the kernel.  */
>> +__thread volatile struct rseq __rseq_abi = {
>> +  .cpu_id = RSEQ_CPU_ID_UNINITIALIZED,
>> +};
>> +
>> +/* volatile because refcount can be read/updated by signal handlers.  */
>> +__thread volatile uint32_t __rseq_refcount;
> 
> Back to the weak vs non-weak question about those two symbols. I understand
> that tagging them as weak symbols has little effect on the dynamic loader
> when it loads libc.so. However, I'm worried about that happens when
> libc is statically linked into an application, and there happens to
> be more than one instance of those symbols (e.g. libc and another library
> define the same symbols, and both are statically linked into the same
> application). Isn't it a situation where tagging those symbols as "weak"
> becomes useful ?

Testing shows that it seems fine to statically link two archives within an
executable in a scenario where each .a defines the same symbol, without
using "weak", so I won't worry about this further.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

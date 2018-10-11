From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH for 4.21 01/16] rseq/selftests: Add reference
 counter to coexist with glibc
Date: Thu, 11 Oct 2018 11:13:28 -0400 (EDT)
Message-ID: <1917048565.2402.1539270808972.JavaMail.zimbra@efficios.com>
References: <20181010191936.7495-1-mathieu.desnoyers@efficios.com> <20181010191936.7495-2-mathieu.desnoyers@efficios.com> <38596780-30f7-0763-0c17-7517dbf0bf59@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <38596780-30f7-0763-0c17-7517dbf0bf59@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Szabolcs Nagy <Szabolcs.Nagy@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, nd <nd@arm.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <Catalin.Marinas@arm.com>
List-Id: linux-api@vger.kernel.org

----- On Oct 11, 2018, at 6:37 AM, Szabolcs Nagy Szabolcs.Nagy@arm.com wrote:

> On 10/10/18 20:19, Mathieu Desnoyers wrote:
>> In order to integrate rseq into user-space applications, add a reference
>> counter field after the struct rseq TLS ABI so many rseq users can be
>> linked into the same application (e.g. librseq and glibc). The
>> reference count ensures that rseq syscall registration/unregistration
>> happens only for the most early/late user for each thread, thus ensuring
>> that rseq is registered across the lifetime of all rseq users for a
>> given thread.
> ...
>> +__attribute__((visibility("hidden"))) __thread
>> +volatile struct libc_rseq __lib_rseq_abi = {
> ...
>> +extern __attribute__((weak, alias("__lib_rseq_abi"))) __thread
>> +volatile struct rseq __rseq_abi;
> ...
>> @@ -70,7 +86,7 @@ int rseq_register_current_thread(void)
>>  	sigset_t oldset;
>>  
>>  	signal_off_save(&oldset);
>> -	if (refcount++)
>> +	if (__lib_rseq_abi.refcount++)
>>  		goto end;
>>  	rc = sys_rseq(&__rseq_abi, sizeof(struct rseq), 0, RSEQ_SIG);
> 
> why do you use a local refcounter instead of the __rseq_abi one?

There is no refcount in struct rseq (the ABI between kernel and user-space).
The registration refcount was part of an earlier version of the rseq system call,
but we decided against keeping it in the kernel.

So I'm adding one _after_ struct rseq, purely to allow interaction between
various user-space components (program/libraries).

> 
> what prevents calling rseq_register_current_thread more than 4G times?

Nothing. It would indeed be cleaner to error out if we detect that refcount is at
INT_MAX. Is that what you have in mind ?

> 
> why cant the kernel see that the same address is registered again and succeed?

It can, and it does. However, refcounting at user-level is needed to ensure
the registration "lifetime" for rseq covers its entire use. If we have two libraries
using rseq, we end up with the following scenario:

Thread 1

  libA registers rseq
  libB registers rseq
  libB unregisters rseq
  libA uses rseq -> bug! it's been unregistered by libB.
  libA unregisters rseq -> unexpected, it's already been unregistered.
 
same applies if libA unregisters rseq before libB (and libB try to use rseq
after libA has unregistered).

The refcount in user-space fixes this.

Thoughts ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

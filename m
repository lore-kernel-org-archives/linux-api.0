From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH] glibc: Perform rseq(2) registration at nptl init
 and thread creation
Date: Wed, 19 Sep 2018 17:01:26 -0400 (EDT)
Message-ID: <2052751374.8654.1537390886450.JavaMail.zimbra@efficios.com>
References: <20180919144438.1066-1-mathieu.desnoyers@efficios.com> <c58d4d6e-f22a-f5d9-e23a-5bd72cec1a86@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <libc-alpha-return-95968-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <c58d4d6e-f22a-f5d9-e23a-5bd72cec1a86@arm.com>
To: Szabolcs Nagy <szabolcs.nagy@arm.com>
Cc: carlos <carlos@redhat.com>, Florian Weimer <fweimer@redhat.com>, nd <nd@arm.com>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, libc-alpha <libc-alpha@sourceware.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

----- On Sep 19, 2018, at 1:38 PM, Szabolcs Nagy szabolcs.nagy@arm.com wrote:

> On 19/09/18 15:44, Mathieu Desnoyers wrote:
>> Things to consider:
>> 
>> - Move __rseq_refcount to an extra field at the end of __rseq_abi to
>>    eliminate one symbol. This would require to wrap struct rseq into
>>    e.g. struct rseq_lib or such, e.g.:
>> 
>> struct rseq_lib {
>>    struct rseq kabi;
>>    int refcount;
>> };
>> 
>> All libraries/programs which try to register rseq (glibc, early-adopter
>> applications, early-adopter libraries) should use the rseq refcount.
>> It becomes part of the ABI within a user-space process, but it's not
>> part of the ABI shared with the kernel per se.
>> 
>> - Restructure how this code is organized so glibc keeps building on
>>    non-Linux targets.
>> 
>> - We do not need an atomic increment/decrement for the refcount per
>>    se. Just being atomic with respect to the current thread (and nested
>>    signals) would be enough. What is the proper API to use there ?
>>    Should we expose struct rseq_lib in a public glibc header ? Should
>>    we create a rseq(3) man page ?
>> 
>> - Revisit use of "weak" symbol for __rseq_abi in glibc. Perhaps we
>>    want a non-weak symbol there ? (and let all other early user
>>    libraries use weak)
>> 
> 
> i don't think there is precedent for exposing tls symbol in glibc
> (e.g. errno is exposed via __errno_location function) so there
> might be issues with this (but i don't have immediate concerns).
> 
>> diff --git a/nptl/pthread_create.c b/nptl/pthread_create.c
>> index fe75d04113..20ee197d94 100644
>> --- a/nptl/pthread_create.c
>> +++ b/nptl/pthread_create.c
>> @@ -52,6 +52,13 @@ static struct pthread *__nptl_last_event __attribute_used__;
>>   /* Number of threads running.  */
>>   unsigned int __nptl_nthreads = 1;
>>   
>> +__attribute__((weak, tls_model("initial-exec"))) __thread
>> +volatile struct rseq __rseq_abi = {
>> +	.cpu_id = RSEQ_CPU_ID_UNINITIALIZED,
>> +};
>> +
>> +__attribute__((weak, tls_model("initial-exec"))) __thread
>> +volatile int __rseq_refcount;
>>  
> 
> note that libpthread.so is built with -ftls-model=initial-exec

Which would indeed make these annotations redundant. I'll remove
them.

> (and if it wasn't then you'd want to put the attribute on the
> declaration in the internal header file, not on the definition,
> so the actual tls accesses generate the right code)

This area is one where I'm still uneasy on my comprehension of
the details, especially that it goes in a different direction than
what you are recommending.

I've read through https://www.akkadia.org/drepper/tls.pdf Section 5
"Linker Optimizations" to try to figure it out, and I end up being
under the impression that applying the tls_model("initial-exec")
attribute to a symbol declaration in a header file does not have
much impact on the accesses that use that variable. Reading through
that section, it seems that the variable definition is the one that
matters, and then the compiler/linker/loader are tweaking the sites
that reference the TLS variable through code rewrite based on the
most efficient mechanism that each phase knows can be used at each
stage.

What am I missing ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

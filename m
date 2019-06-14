From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH 1/5] glibc: Perform rseq(2) registration at C startup
 and thread creation (v10)
Date: Fri, 14 Jun 2019 06:14:09 -0400 (EDT)
Message-ID: <1635690189.3049.1560507249693.JavaMail.zimbra@efficios.com>
References: <20190503184219.19266-1-mathieu.desnoyers@efficios.com> <87o93d4lqb.fsf@oldenburg2.str.redhat.com> <117220011.27079.1559663870037.JavaMail.zimbra@efficios.com> <87wohzorj0.fsf@oldenburg2.str.redhat.com> <c16c9785-7f8c-430b-a4df-a53e47bf1600@redhat.com> <914051741.43025.1560348011775.JavaMail.zimbra@efficios.com> <802638054.3032.1560506584705.JavaMail.zimbra@efficios.com> <87ftocwkei.fsf@oldenburg2.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87ftocwkei.fsf@oldenburg2.str.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>
Cc: carlos <carlos@redhat.com>, Joseph Myers <joseph@codesourcery.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Rich Felker <dalias@libc.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

----- On Jun 14, 2019, at 12:06 PM, Florian Weimer fweimer@redhat.com wrote:

> * Mathieu Desnoyers:
> 
>> ----- On Jun 12, 2019, at 4:00 PM, Mathieu Desnoyers
>> mathieu.desnoyers@efficios.com wrote:
>>
>>> ----- On Jun 10, 2019, at 4:43 PM, carlos carlos@redhat.com wrote:
>>> 
>>>> On 6/6/19 7:57 AM, Florian Weimer wrote:
>>>>> Let me ask the key question again: Does it matter if code observes the
>>>>> rseq area first without kernel support, and then with kernel support?
>>>>> If we don't expect any problems immediately, we do not need to worry
>>>>> much about the constructor ordering right now.  I expect that over time,
>>>>> fixing this properly will become easier.
>>>> 
>>>> I just wanted to chime in and say that splitting this into:
>>>> 
>>>> * Ownership (__rseq_handled)
>>>> 
>>>> * Initialization (__rseq_abi)
>>>> 
>>>> Makes sense to me.
>>>> 
>>>> I agree we need an answer to this question of ownership but not yet
>>>> initialized, to owned and initialized.
>>>> 
>>>> I like the idea of having __rseq_handled in ld.so.
>>> 
>>> Very good, so I'll implement this approach. Sorry for the delayed
>>> feedback, I am traveling this week.
>>
>> I had issues with cases where application or LD_PRELOAD library also
>> define the __rseq_handled symbol. They appear not to see the same
>> address as the one initialized by ld.so.
> 
> What exactly did you do?  How did you determine the addresses?  How is
> __rseq_handled defined in ld.so?

The easiest way to answer these questions is through links to my github
dev branch:

https://github.com/compudj/glibc-dev/tree/glibc-rseq

specifically this commit:
https://github.com/compudj/glibc-dev/commit/c49a286497d065a7fc00aafd846e6edce14f97fc
and this attempt at using GL():
https://github.com/compudj/glibc-dev/commit/8a02acfbb6943672bfa36b4fc6f61905ee4fa180

My test programs are:

* a.c:

#include <stdio.h>
#include <linux/rseq.h>

extern __thread struct rseq __rseq_abi
__attribute__ ((tls_model ("initial-exec")));/* = {
	.cpu_id = -1,
};*/
extern int __rseq_handled;

int main()
{
	fprintf(stderr, "__rseq_handled main: %d %p\n", __rseq_handled, &__rseq_handled);
	fprintf(stderr, "__rseq_abi.cpu_id main: %d %p\n", __rseq_abi.cpu_id, &__rseq_abi);
	return 0;
}

* s.c:

#include <stdio.h>
#include <linux/rseq.h>

#if 0
__thread struct rseq __rseq_abi
__attribute__ ((tls_model ("initial-exec"))) = {
	.cpu_id = -1,
};
int __rseq_handled;

#else
extern __thread struct rseq __rseq_abi
__attribute__ ((tls_model ("initial-exec")));
extern int __rseq_handled;
#endif

void __attribute__((constructor)) myinit(void)
{
	fprintf(stderr, "__rseq_handled s.so: %d %p\n", __rseq_handled, &__rseq_handled);
	fprintf(stderr, "__rseq_abi.cpu_id s.so: %d %p\n", __rseq_abi.cpu_id, &__rseq_abi);
}

* Makefile:

LIBCPATH=/home/efficios/glibc-test/lib
KERNEL_HEADERS=/home/efficios/git/linux-percpu-dev/usr/include
CFLAGS=-I${KERNEL_HEADERS} -L${LIBCPATH} -Wl,--rpath=${LIBCPATH} -Wl,--dynamic-linker=${LIBCPATH}/ld-linux-x86-64.so.2

all:
	gcc ${CFLAGS} -o a a.c
	gcc ${CFLAGS} -shared -fPIC -o s.so s.c

Thanks,

Mathieu

> 
> Thanks,
> Florian

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

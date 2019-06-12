From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH 1/5] glibc: Perform rseq(2) registration at C startup
 and thread creation (v10)
Date: Wed, 12 Jun 2019 10:16:02 -0400 (EDT)
Message-ID: <1329439108.43041.1560348962006.JavaMail.zimbra@efficios.com>
References: <20190503184219.19266-1-mathieu.desnoyers@efficios.com> <875zprm4jo.fsf@oldenburg2.str.redhat.com> <732661684.21584.1559314109886.JavaMail.zimbra@efficios.com> <87muj2k4ov.fsf@oldenburg2.str.redhat.com> <1528929896.22217.1559326257155.JavaMail.zimbra@efficios.com> <87o93d4lqb.fsf@oldenburg2.str.redhat.com> <117220011.27079.1559663870037.JavaMail.zimbra@efficios.com> <87wohzorj0.fsf@oldenburg2.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87wohzorj0.fsf@oldenburg2.str.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>
Cc: carlos <carlos@redhat.com>, Joseph Myers <joseph@codesourcery.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Rich Felker <dalias@libc.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

----- On Jun 6, 2019, at 1:57 PM, Florian Weimer fweimer@redhat.com wrote:

> * Mathieu Desnoyers:
> 
[...]
> 
>>> The final remaining case is static dlopen.  There is a copy of ld.so on
>>> the dynamic side, but it is completely inactive and has never run.  I do
>>> not think we need to support that because multi-threading does not work
>>> reliably in this scenario, either.  However, we should skip rseq
>>> registration in a nested libc (see the rtld_active function).
>>
>> So for SHARED, if (!rtld_active ()), we should indeed leave the state of
>> __rseq_handled as it is, because we are within a nested inactive ld.so.
> 
> I think we should add __rseq_handled initialization to ld.so, so it will
> only run once, ever.

OK

> 
> It's the registration from libc.so which needs some care.  In
> particular, we must not override an existing registration.

OK, so it could check if __rseq_abi.cpu_id is -1, and only
perform registration if it is the case. Or do you have another
approach in mind ?

For the main thread, "nested" unregistration does not appear to be a
problem, because we rely on program exit() to implicitly unregister.

Thanks,

Mathieu

> 
> Thanks,
> Florian

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

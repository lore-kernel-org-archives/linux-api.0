From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [PATCH 1/5] glibc: Perform rseq(2) registration at C startup and thread creation (v10)
Date: Fri, 14 Jun 2019 12:06:45 +0200
Message-ID: <87ftocwkei.fsf@oldenburg2.str.redhat.com>
References: <20190503184219.19266-1-mathieu.desnoyers@efficios.com>
        <87muj2k4ov.fsf@oldenburg2.str.redhat.com>
        <1528929896.22217.1559326257155.JavaMail.zimbra@efficios.com>
        <87o93d4lqb.fsf@oldenburg2.str.redhat.com>
        <117220011.27079.1559663870037.JavaMail.zimbra@efficios.com>
        <87wohzorj0.fsf@oldenburg2.str.redhat.com>
        <c16c9785-7f8c-430b-a4df-a53e47bf1600@redhat.com>
        <914051741.43025.1560348011775.JavaMail.zimbra@efficios.com>
        <802638054.3032.1560506584705.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <802638054.3032.1560506584705.JavaMail.zimbra@efficios.com>
        (Mathieu Desnoyers's message of "Fri, 14 Jun 2019 06:03:04 -0400
        (EDT)")
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: carlos <carlos@redhat.com>, Joseph Myers <joseph@codesourcery.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Rich Felker <dalias@libc.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

* Mathieu Desnoyers:

> ----- On Jun 12, 2019, at 4:00 PM, Mathieu Desnoyers mathieu.desnoyers@efficios.com wrote:
>
>> ----- On Jun 10, 2019, at 4:43 PM, carlos carlos@redhat.com wrote:
>> 
>>> On 6/6/19 7:57 AM, Florian Weimer wrote:
>>>> Let me ask the key question again: Does it matter if code observes the
>>>> rseq area first without kernel support, and then with kernel support?
>>>> If we don't expect any problems immediately, we do not need to worry
>>>> much about the constructor ordering right now.  I expect that over time,
>>>> fixing this properly will become easier.
>>> 
>>> I just wanted to chime in and say that splitting this into:
>>> 
>>> * Ownership (__rseq_handled)
>>> 
>>> * Initialization (__rseq_abi)
>>> 
>>> Makes sense to me.
>>> 
>>> I agree we need an answer to this question of ownership but not yet
>>> initialized, to owned and initialized.
>>> 
>>> I like the idea of having __rseq_handled in ld.so.
>> 
>> Very good, so I'll implement this approach. Sorry for the delayed
>> feedback, I am traveling this week.
>
> I had issues with cases where application or LD_PRELOAD library also
> define the __rseq_handled symbol. They appear not to see the same
> address as the one initialized by ld.so.

What exactly did you do?  How did you determine the addresses?  How is
__rseq_handled defined in ld.so?

Thanks,
Florian

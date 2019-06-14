From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH 1/5] glibc: Perform rseq(2) registration at C startup
 and thread creation (v10)
Date: Fri, 14 Jun 2019 09:47:13 -0400 (EDT)
Message-ID: <26171199.3391.1560520033825.JavaMail.zimbra@efficios.com>
References: <20190503184219.19266-1-mathieu.desnoyers@efficios.com> <1190407525.3131.1560516910936.JavaMail.zimbra@efficios.com> <1085273942.3137.1560517301721.JavaMail.zimbra@efficios.com> <87d0jguxdk.fsf@oldenburg2.str.redhat.com> <1779359826.3226.1560518318701.JavaMail.zimbra@efficios.com> <87wohoti47.fsf@oldenburg2.str.redhat.com> <189377747.3315.1560519247118.JavaMail.zimbra@efficios.com> <87imt8tha5.fsf@oldenburg2.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87imt8tha5.fsf@oldenburg2.str.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>
Cc: carlos <carlos@redhat.com>, Joseph Myers <joseph@codesourcery.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Rich Felker <dalias@libc.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

----- On Jun 14, 2019, at 3:42 PM, Florian Weimer fweimer@redhat.com wrote:

> * Mathieu Desnoyers:
> 
>> +  /* Publicize rseq registration ownership.  This must be performed
>> +     after rtld re-relocation, before invoking constructors of
>> +     preloaded libraries.  */
>> +  rseq_init ();
> 
> Please add a comment that IFUNC resolvers do not see the initialized
> value.  I think this is okay because we currently do not support access
> to extern variables in IFUNC resolvers.

Do IFUNC resolvers happen to observe the __rseq_handled address that
was internal to ld.so ?

If so, we could simply initialize __rseq_handled twice: early before calling
IFUNC resolvers, and after ld.so re-relocation.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

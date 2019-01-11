From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH glibc 1/4] glibc: Perform rseq(2) registration at
 nptl init and thread creation (v4)
Date: Thu, 10 Jan 2019 20:11:56 -0500 (EST)
Message-ID: <1488546469.1564.1547169116539.JavaMail.zimbra@efficios.com>
References: <20181204192141.4684-1-mathieu.desnoyers@efficios.com> <87h8fkz6qx.fsf@oldenburg2.str.redhat.com> <1681283664.1380.1547152315426.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <libc-alpha-return-99167-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <1681283664.1380.1547152315426.JavaMail.zimbra@efficios.com>
To: Florian Weimer <fweimer@redhat.com>
Cc: carlos <carlos@redhat.com>, Joseph Myers <joseph@codesourcery.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Rich Felker <dalias@libc.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

----- On Jan 10, 2019, at 12:31 PM, Mathieu Desnoyers mathieu.desnoyers@efficios.com wrote:

> ----- On Dec 11, 2018, at 2:40 AM, Florian Weimer fweimer@redhat.com wrote:
[...]
>> 
>>> diff --git a/nptl/Versions b/nptl/Versions
>>> index e7f691da7a..f7890f73fc 100644
>>> --- a/nptl/Versions
>>> +++ b/nptl/Versions
>>> @@ -277,6 +277,10 @@ libpthread {
>>>      cnd_timedwait; cnd_wait; tss_create; tss_delete; tss_get; tss_set;
>>>    }
>>>  
>>> +  GLIBC_2.29 {
>>> +    __rseq_refcount;
>>> +  }
>> 
>> Why put this into libpthread, and __rseq_abi into libc?
> 
> The __rseq_abi symbol should be available to the glibc memory allocator.
> I plan to move the __rseq_abi to sysdeps/unix/sysv/linux/Versions instead
> so it becomes Linux-specific.
> 
> The __rseq_refcount symbol only needs to be made available to applications
> and libraries linking against libpthread, because only libpthread actually
> handles the rseq registration/unregistration at thread start/exit and
> library initialization.
> 
> However, considering that we want this to be Linux-specific as well,
> I could move it to sysdeps/unix/sysv/linux/Versions too.
> 
> Then it would make sense to move the __rseq_refcount symbol defined in
> nptl/rseq.c to sysdeps/unix/sysv/linux/rseq.c as well and group
> everything together.
> 
> Therefore, both symbols will end up in sysdeps/unix/sysv/linux/Versions.

Now that I think about it, it's important to move the rseq registration
done at nptl init (in my current code) to some lower-level csu initialiation,
so applications that happen _not_ to link against libpthread also get
registered rseq for the main thread.

Does it make sense ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

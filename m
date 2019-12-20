From: Florian Weimer <fw@deneb.enyo.de>
Subject: Re: [PATCH for 5.5 1/2] rseq: Fix: Clarify rseq.h UAPI rseq_cs memory reclaim requirements
Date: Fri, 20 Dec 2019 21:57:25 +0100
Message-ID: <875zian2a2.fsf@mid.deneb.enyo.de>
References: <20191220201207.17389-1-mathieu.desnoyers@efficios.com>
        <87imman36g.fsf@mid.deneb.enyo.de>
        <173832695.14381.1576875253374.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <173832695.14381.1576875253374.JavaMail.zimbra@efficios.com>
        (Mathieu Desnoyers's message of "Fri, 20 Dec 2019 15:54:13 -0500
        (EST)")
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, paulmck <paulmck@linux.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>, Paul Turner <pjt@google.com>, linux-api <linux-api@vger.kernel.org>, stable <stable@vger.kernel.org>, Dmitry Vyukov <dvyukov@google.com>, Neel Natu <neelnatu@google.com>
List-Id: linux-api@vger.kernel.org

* Mathieu Desnoyers:

> ----- On Dec 20, 2019, at 3:37 PM, Florian Weimer fw@deneb.enyo.de wrote:
>
>> * Mathieu Desnoyers:
>> 
>>> diff --git a/include/uapi/linux/rseq.h b/include/uapi/linux/rseq.h
>>> index 9a402fdb60e9..6f26b0b148a6 100644
>>> --- a/include/uapi/linux/rseq.h
>>> +++ b/include/uapi/linux/rseq.h
>>> @@ -100,7 +100,9 @@ struct rseq {
>>>  	 * instruction sequence block, as well as when the kernel detects that
>>>  	 * it is preempting or delivering a signal outside of the range
>>>  	 * targeted by the rseq_cs. Also needs to be set to NULL by user-space
>>> -	 * before reclaiming memory that contains the targeted struct rseq_cs.
>>> +	 * before reclaiming memory that contains the targeted struct rseq_cs
>>> +	 * or reclaiming memory that contains the code refered to by the
>>> +	 * start_ip and post_commit_offset fields of struct rseq_cs.
>> 
>> Maybe mention that it's good practice to clear rseq_cs before
>> returning from a function that contains a restartable sequence?
>
> Unfortunately, clearing it is not free. Considering that rseq is meant to
> be used in very hot code paths, it would be preferable that applications
> clear it in the very infrequent case where the rseq_cs or code will
> vanish (e.g. dlclose or JIT reclaim), and not require it to be cleared
> after each critical section. I am therefore reluctant to document the
> behavior you describe as a "good practice" for rseq.

You already have to write to rseq_cs before entering the critical
section, right?  Then you've already determined the address, and the
cache line is already hot, so it really should be close to zero cost.

I mean, you can still discard the advice, but you do so ad your own
peril …

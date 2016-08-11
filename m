From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH v7 7/7] Restartable sequences: self-tests
Date: Thu, 11 Aug 2016 23:26:30 +0000 (UTC)
Message-ID: <374861479.8581.1470957990793.JavaMail.zimbra@efficios.com>
References: <1469135662-31512-1-git-send-email-mathieu.desnoyers@efficios.com> <1469135662-31512-8-git-send-email-mathieu.desnoyers@efficios.com> <CO1PR15MB09822FC140F84DCEEF2004CDDD0B0@CO1PR15MB0982.namprd15.prod.outlook.com> <1590181502.79032.1469329777708.JavaMail.zimbra@efficios.com> <CO1PR15MB09825505EBF36E0C56AA037ADD0C0@CO1PR15MB0982.namprd15.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CO1PR15MB09825505EBF36E0C56AA037ADD0C0@CO1PR15MB0982.namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Watson <davejwatson@fb.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Peter Zijlstra <peterz@infradead.org>, Andy Lutomirski <luto@amacapital.net>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Boqun Feng <boqun.feng@gmail.com>
List-Id: linux-api@vger.kernel.org

----- On Jul 24, 2016, at 2:01 PM, Dave Watson davejwatson@fb.com wrote:

>>> +static inline __attribute__((always_inline))
>>> +bool rseq_finish(struct rseq_lock *rlock,
>>> + intptr_t *p, intptr_t to_write,
>>> + struct rseq_state start_value)
> 
>>> This ABI looks like it will work fine for our use case. I don't think it
>>> has been mentioned yet, but we may still need multiple asm blocks
>>> for differing numbers of writes. For example, an array-based freelist push:
> 
>>> void push(void *obj) {
>>> if (index < maxlen) {
>>> freelist[index++] = obj;
>>> }
>>> }
> 
>>> would be more efficiently implemented with a two-write rseq_finish:
> 
>>> rseq_finish2(&freelist[index], obj, // first write
>>> &index, index + 1, // second write
>>> ...);
> 
>> Would pairing one rseq_start with two rseq_finish do the trick
>> there ?
> 
> Yes, two rseq_finish works, as long as the extra rseq management overhead
> is not substantial.

I've added a commit implementing rseq_finish2() in my rseq volatile
dev branch. You can fetch it at:

https://github.com/compudj/linux-percpu-dev/tree/rseq-fallback

I also have a separate test and benchmark tree in addition to the
kernel selftests here:

https://github.com/compudj/rseq-test

I named the first write a "speculative" write, and the second write
the "final" write.

Would you like to extend the test cases to cover your intended use-case ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

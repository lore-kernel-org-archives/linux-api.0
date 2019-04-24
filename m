From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH for 5.2 10/10] rseq/selftests: mips: use break
 instruction for RSEQ_SIG
Date: Wed, 24 Apr 2019 19:22:57 -0400 (EDT)
Message-ID: <2047127593.1305.1556148177478.JavaMail.zimbra@efficios.com>
References: <20190424152502.14246-1-mathieu.desnoyers@efficios.com> <20190424152502.14246-11-mathieu.desnoyers@efficios.com> <20190424220609.4kryfcgsv46iu3ds@pburton-laptop> <2114325810.1301.1556147523476.JavaMail.zimbra@efficios.com> <20190424231717.os4p6fq7fbx6afxa@pburton-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190424231717.os4p6fq7fbx6afxa@pburton-laptop>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Burton <paul.burton@mips.com>
Cc: Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will
List-Id: linux-api@vger.kernel.org

----- On Apr 24, 2019, at 7:17 PM, Paul Burton paul.burton@mips.com wrote:

> Hi Mathieu,
> 
> On Wed, Apr 24, 2019 at 07:12:03PM -0400, Mathieu Desnoyers wrote:
>> Does the following comment above the forest of #ifdef work for you ?
>> 
>> /*
>>  * RSEQ_SIG uses the break instruction. The instruction pattern is:
>>  *
>>  * On MIPS:
>>  *      0350000d        break     0x350
>>  *
>>  * On nanoMIPS32:
>>  *      00100350        break     0x350
>>  *
>>  * On microMIPS:
>>  *      0000d407        break     0x350
>>  *
>>  * For nanoMIPS32 and microMIPS, the instruction stream is encoded as 16-bit
>>  * halfwords, so the signature halfwords need to be swapped accordingly for
>>  * little-endian.
>>  */
> 
> I'd probably just say nanoMIPS rather than nanoMIPS32, because when we
> get nanoMIPS64 in the future it'll be a superset of nanoMIPS32 & the
> break encoding will be the same.

Done.

> 
> But otherwise it looks good to me :)

Great! I've added your "Suggested-by" tag to the patch.

Thanks,

Mathieu

> 
> Thanks,
>     Paul

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

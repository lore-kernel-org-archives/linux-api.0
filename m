From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH for 5.2 10/10] rseq/selftests: mips: use break
 instruction for RSEQ_SIG
Date: Wed, 24 Apr 2019 19:12:03 -0400 (EDT)
Message-ID: <2114325810.1301.1556147523476.JavaMail.zimbra@efficios.com>
References: <20190424152502.14246-1-mathieu.desnoyers@efficios.com> <20190424152502.14246-11-mathieu.desnoyers@efficios.com> <20190424220609.4kryfcgsv46iu3ds@pburton-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190424220609.4kryfcgsv46iu3ds@pburton-laptop>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Burton <paul.burton@mips.com>
Cc: Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will
List-Id: linux-api@vger.kernel.org

----- On Apr 24, 2019, at 6:06 PM, Paul Burton paul.burton@mips.com wrote:

> Hi Mathieu,
> 
> On Wed, Apr 24, 2019 at 11:25:02AM -0400, Mathieu Desnoyers wrote:
>> diff --git a/tools/testing/selftests/rseq/rseq-mips.h
>> b/tools/testing/selftests/rseq/rseq-mips.h
>> index fe3eabcdcbe5..eb53a6adfbbb 100644
>> --- a/tools/testing/selftests/rseq/rseq-mips.h
>> +++ b/tools/testing/selftests/rseq/rseq-mips.h
>> @@ -7,7 +7,11 @@
>>   * (C) Copyright 2016-2018 - Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
>>   */
>>  
>> -#define RSEQ_SIG	0x53053053
>> +/*
>> + * RSEQ_SIG uses the break instruction. The instruction pattern is
>> + *	0350000d        break    0x350
>> + */
>> +#define RSEQ_SIG	0x0350000d
> 
> My apologies for taking a while to get back to you on the various ISAs &
> endian issues here, but I think we'll want this to be something like:
> 
> #if defined(__nanomips__)
> # ifdef __MIPSEL__
> #  define RSEQ_SIG	0x03500010
> # else
> #  define RSEQ_SIG	0x00100350
> # endif
> #elif defined(__mips_micromips)
> # ifdef __MIPSEL__
> #  define RSEQ_SIG	0xd4070000
> # else
> #  define RSEQ_SIG	0x0000d407
> # endif
> #else
> # define RSEQ_SIG	0x0350000d
> #endif
> 
> For plain old MIPS the .word directive will be fine endian-wise, but for
> microMIPS & nanoMIPS we need to take into account that the instruction
> stream is encoded as 16b halfwords & swap those accordingly for little
> endian.

Hi Paul,

Thanks for looking into it!

Does the following comment above the forest of #ifdef work for you ?

/*
 * RSEQ_SIG uses the break instruction. The instruction pattern is:
 *
 * On MIPS:
 *      0350000d        break     0x350
 *
 * On nanoMIPS32:
 *      00100350        break     0x350
 *
 * On microMIPS:
 *      0000d407        break     0x350
 *
 * For nanoMIPS32 and microMIPS, the instruction stream is encoded as 16-bit
 * halfwords, so the signature halfwords need to be swapped accordingly for
 * little-endian.
 */

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

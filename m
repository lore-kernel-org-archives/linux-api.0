From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH for 5.2 10/10] rseq/selftests: mips: use break
 instruction for RSEQ_SIG
Date: Thu, 25 Apr 2019 10:21:32 -0400 (EDT)
Message-ID: <1183307732.352.1556202092390.JavaMail.zimbra@efficios.com>
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

Considering that we have micromips and nanomips already, I guess something
along the lines of "picomips" is not that far away...

I've tried to figure out if we could find a way to have RSEQ_SIG left undefined
if it's not on the plain mips environment, but could not find anything that
would be #defined on plain mips, but #undefined on both micromips and nanomips.

What I'd like to do is e.g.:

#if defined(__nanomips__)
# ifdef __MIPSEL__
#  define RSEQ_SIG	0x03500010
# else
#  define RSEQ_SIG	0x00100350
# endif
#elif defined(__mips_micromips)
# ifdef __MIPSEL__
#  define RSEQ_SIG	0xd4070000
# else
#  define RSEQ_SIG	0x0000d407
# endif
#elif defined(__mips__)
# define RSEQ_SIG	0x0350000d
#else
/* Leave RSEQ_SIG as is. */
#endif

The idea here is to not allow code targeting future MIPS ISA to compile
with the wrong signature.

The delta between compiling without/with -mmicromips on a gcc-8 compiler
is only:

> #define __mips_micromips 1

Some interesting delta when compiling for plain little-endian mips with
gcc-8 compared to the nanomips compiler is:

< #define __mips__ 1
< #define _mips 1
< #define MIPSEL 1

> #define __nanomips__ 1

< #define __mips_isa_rev 2
> #define __mips_isa_rev 6

So let's say we have a picomips introduced in the future, can we rely
on it not defining __mips__ like the nanomips compiler does ? If so,
my "#elif defined(__mips__)" approach would indeed leave RSEQ_SIG undefined
as expected.

Thoughts ?

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

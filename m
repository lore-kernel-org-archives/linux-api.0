From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH for 4.18 2/2] rseq: check that rseq->rseq_cs padding
 is zero
Date: Thu, 28 Jun 2018 16:55:55 -0400 (EDT)
Message-ID: <145668759.9406.1530219355192.JavaMail.zimbra@efficios.com>
References: <20180628162359.9054-1-mathieu.desnoyers@efficios.com> <20180628162359.9054-2-mathieu.desnoyers@efficios.com> <20180628165348.GE10751@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180628165348.GE10751@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Michael
List-Id: linux-api@vger.kernel.org

----- On Jun 28, 2018, at 12:53 PM, Will Deacon will.deacon@arm.com wrote:

> Hi Mathieu,
> 
> On Thu, Jun 28, 2018 at 12:23:59PM -0400, Mathieu Desnoyers wrote:
>> On 32-bit kernels, the rseq->rseq_cs_padding field is never read by the
>> kernel. However, 64-bit kernels dealing with 32-bit compat tasks read the
>> full 64-bit in its entirety, and terminates the offending process with
>> a segmentation fault if the upper 32 bits are set due to failure of
>> copy_from_user().
>> 
>> Ensure that both 32-bit and 64-bit kernels dealing with 32-bit tasks end
>> up terminating offending tasks with a segmentation fault if the upper
>> 32-bit padding bits (rseq->rseq_cs_padding) are set by adding an explicit
>> check that padding is zero on 32-bit kernels.
>> 
>> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
>> CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
>> CC: Peter Zijlstra <peterz@infradead.org>
>> CC: Paul Turner <pjt@google.com>
>> CC: Thomas Gleixner <tglx@linutronix.de>
>> CC: Andy Lutomirski <luto@amacapital.net>
>> CC: Andi Kleen <andi@firstfloor.org>
>> CC: Dave Watson <davejwatson@fb.com>
>> CC: Chris Lameter <cl@linux.com>
>> CC: Ingo Molnar <mingo@redhat.com>
>> CC: "H. Peter Anvin" <hpa@zytor.com>
>> CC: Ben Maurer <bmaurer@fb.com>
>> CC: Steven Rostedt <rostedt@goodmis.org>
>> CC: Josh Triplett <josh@joshtriplett.org>
>> CC: Linus Torvalds <torvalds@linux-foundation.org>
>> CC: Andrew Morton <akpm@linux-foundation.org>
>> CC: Russell King <linux@arm.linux.org.uk>
>> CC: Catalin Marinas <catalin.marinas@arm.com>
>> CC: Will Deacon <will.deacon@arm.com>
>> CC: Michael Kerrisk <mtk.manpages@gmail.com>
>> CC: Boqun Feng <boqun.feng@gmail.com>
>> CC: linux-api@vger.kernel.org
>> ---
>>  kernel/rseq.c | 25 +++++++++++++++++++++++++
>>  1 file changed, 25 insertions(+)
>> 
>> diff --git a/kernel/rseq.c b/kernel/rseq.c
>> index 4ba582046fcd..b038f35a60d6 100644
>> --- a/kernel/rseq.c
>> +++ b/kernel/rseq.c
>> @@ -112,6 +112,29 @@ static int rseq_reset_rseq_cpu_id(struct task_struct *t)
>>  	return 0;
>>  }
>>  
>> +#ifndef __LP64__
>> +/*
>> + * Ensure that padding is zero.
>> + */
>> +static int check_rseq_cs_padding(struct task_struct *t)
>> +{
>> +	unsigned long pad;
>> +	int ret;
>> +
>> +	ret = __get_user(pad, &t->rseq->rseq_cs_padding);
>> +	if (ret)
>> +		return ret;
>> +	if (pad)
>> +		return -EFAULT;
>> +	return 0;
>> +}
>> +#else
>> +static int check_rseq_cs_padding(struct task_struct *t)
>> +{
>> +	return 0;
>> +}
>> +#endif
> 
> I'm still not sure how this works with a 64-bit kernel and a compat (32-bit)
> task. The check_rseq_cs_padding() will return 0 regardless of the upper bits
> of the rseq_cs field, whereas a native 32-bit kernel would actually go and
> check them.
> 
> What am I missing here?

With a 64-bit kernel, we end up in the #else, which means check_rseq_cs_padding()
always returns 0.

On that 64-bit kernel, all 64 bits of rseq->rseq_cs are read, including the
padding. Therefore, all those bits are contained in the pointer passed as
argument to copy_from_user(), which will cause copy_from_user() to accurately
fail on an invalid user-space address.

Therefore, 64-bit kernels already check those padding bits by means of trying to use
that pointer to access user-space data with copy_from_user, which does an access_ok
check.

So both 32-bit and 64-bit kernels will end up killing the process with segmentation
fault if a 32-bit userland populates those padding bits with anything other than
0.

Does it seem acceptable ?

Thanks,

Mathieu

> 
> Will

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

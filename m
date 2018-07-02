From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH for 4.18] rseq: use __u64 for rseq_cs fields,
 validate user inputs
Date: Mon, 2 Jul 2018 19:00:18 -0400 (EDT)
Message-ID: <415287289.10831.1530572418907.JavaMail.zimbra@efficios.com>
References: <20180702223143.4663-1-mathieu.desnoyers@efficios.com> <CA+55aFxrX+wRoe+5HDaTrRXg1K-Qpks4jJ9Buc_OevoG8hoGFw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFxrX+wRoe+5HDaTrRXg1K-Qpks4jJ9Buc_OevoG8hoGFw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.ma>
List-Id: linux-api@vger.kernel.org

----- On Jul 2, 2018, at 6:45 PM, Linus Torvalds torvalds@linux-foundation.org wrote:

> On Mon, Jul 2, 2018 at 3:31 PM Mathieu Desnoyers
> <mathieu.desnoyers@efficios.com> wrote:
>>
>> Change the rseq ABI so rseq_cs start_ip, post_commit_offset and abort_ip
>> fields are seen as 64-bit fields by both 32-bit and 64-bit kernels rather
>> that ignoring the 32 upper bits on 32-bit kernels. This ensures we have a
>> consistent behavior for a 32-bit binary executed on 32-bit kernels and in
>> compat mode on 64-bit kernels.
> 
> Actually, now that I see this again, I react to:
> 
> 
>> +static int check_rseq_cs_padding(struct task_struct *t)
>> +{
>> +       u32 pad;
>> +       int ret;
>> +
>> +       ret = __get_user(pad, &t->rseq->rseq_cs_padding);
>> +       if (ret)
>> +               return ret;
>> +       if (pad)
>> +               return -EINVAL;
>> +       return 0;
>> +}
> 
> This is all wrong.
> 
> Just make "rseq_cs" be an __u64" too. That will clean up everything,
> and user space will have a much easier time filling it in too, since
> it's just one field. Instead of having to remember about the "let's
> fill in padding for 32-bit cases".
> 
> Then the rseq_get_rseq_cs() will be
> 
>        __u64 rseq_cs;
> 
>        ret = get_user(rseq_cs, &t->rseq->rseq_cs);
>        if (ret)
>                return ret;
>        ptr = (void *)rseq_cs;
>        if (rseq_cs != (unsigned long)ptr)
>                return -EINVAL;
> 
> and it's all good, no #ifdef's etc needed.
> 
> Hmm?

Unfortunately, that rseq->rseq_cs field needs to be updated by user-space
with single-copy atomicity. Therefore, we want 32-bit user-space to initialize
the padding with 0, and only update the low bits with single-copy atomicity.

> 
> Sorry for the bike-shedding, but this is now the last remaining user
> of that LINUX_FIELD_u32_u64, so let's just get rid of it entirely, ok?
>
> Then we can also get rid of that silly uapi/linux/types_32_64.h header
> file entirely.
> 
> That would be *lovely*. Simpler code, simpler and less error-prone
> interfaces, and one less specialized header file.

We can easily switch from LINUX_FIELD_u32_u64 to __u64 for fields within
struct rseq_cs because we have no requirement on update single-copy
atomicity. However, this is not true for the rseq->rseq_cs pointer.

Thoughts ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

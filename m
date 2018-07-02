From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [RFC PATCH for 4.18 1/2] rseq: validate rseq_cs fields are < TASK_SIZE
Date: Mon, 2 Jul 2018 12:02:18 -0700
Message-ID: <CALCETrVMhU8SrZBXOXxJerrZpQ71A_f_cRBCU=Lmj_KPV0+rRA@mail.gmail.com>
References: <20180628162359.9054-1-mathieu.desnoyers@efficios.com>
 <CA+55aFwJWxsE_LL=-8WgB7uH_mYeMSu=boWF4N5KdOW673g4hA@mail.gmail.com>
 <247789350.9741.1530288432573.JavaMail.zimbra@efficios.com>
 <CA+55aFz8KyVqFsVnp-6g+thz7vmm5nK_FSdRTPSks7gsNVNRdQ@mail.gmail.com>
 <184287091.10022.1530301738384.JavaMail.zimbra@efficios.com>
 <CALCETrXqjrCoHX1KyL0iKGBaAZSGJb1cVdNN1gNigJ8DW9LF8w@mail.gmail.com>
 <1527399163.10673.1530541966296.JavaMail.zimbra@efficios.com>
 <CALCETrVeu_V-3K8OfKv9QixrWBJs+q866yb=e96sC76SS4hxYg@mail.gmail.com> <84003252.10754.1530558015813.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <84003252.10754.1530558015813.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Catalin Marinas <catalin.marinas@arm.com>Will Deacon <w>
List-Id: linux-api@vger.kernel.org

On Mon, Jul 2, 2018 at 12:00 PM, Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
> ----- On Jul 2, 2018, at 1:11 PM, Andy Lutomirski luto@amacapital.net wrote:
>>
>> But I think that the limited solution of changing
>> instruction_pointer_set() really is a sufficient
>> architecture-dependent change to fully solve your problem.
>
> So let me recap with the changes I gather for 4.18 and 4.19:
>
> 4.18:
>
> * Change struct rseq_cs field types from LINUX_FIELD_u32_u64() to __u64 in
>   uapi/linux/rseq.h,
> * Compare rseq->rseq_cs->abort_ip with TASK_SIZE before using it. Kill offending
>   process if its value is over TASK_SIZE,
> * Explicitly check that padding of rseq->rseq_cs is zero on 32-bit kernels
>   (#ifndef __LP64__).
>
> 4.19:
>
> * Introduce instruction_pointer_set() with input validation, use it when setting
>   IP to abort_ip in rseq. This replaces the comparison of abort_ip with TASK_SIZE.
>
> Is that consistent with what you have in mind ?
>

Works for me.  Linus, any objection?

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH for 4.18 2/6] rseq: use get_user/put_user rather than
 __get_user/__put_user
Date: Tue, 10 Jul 2018 09:48:35 -0400 (EDT)
Message-ID: <1050939005.3002.1531230515472.JavaMail.zimbra@efficios.com>
References: <20180708210330.27324-1-mathieu.desnoyers@efficios.com>
 <20180708210330.27324-3-mathieu.desnoyers@efficios.com>
 <854203778.2272.1531157327328.JavaMail.zimbra@efficios.com>
 <87tvp7mx8j.fsf@concordia.ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <87tvp7mx8j.fsf@concordia.ellerman.id.au>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: Joel Fernandes <joelaf@google.com>, Peter Zijlstra <peterz@infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, Dave Watson <davejwatson@fb.com>, Will Deacon <will.deacon@arm.com>, Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>, Chris Lameter <cl@linux.com>, Russell King <linux@arm.linux.org.uk>, Andrew Hunter <ahh@google.com>, Ingo Molnar <mingo@redhat.com>, Michael Kerrisk <mtk.manpages@gmail.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Paul Turner <pjt@google.com>, Boqun Feng <boqun.feng@gmail.com>, Josh Triplett <josh@joshtriplett.org>, rostedt <rostedt@goodmis.org>, Ben Maurer <bmaurer@fb.com>, Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, linux-api <linux-api@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Andrew Morton <akpm@l>
List-Id: linux-api@vger.kernel.org

----- On Jul 10, 2018, at 2:16 AM, Michael Ellerman mpe@ellerman.id.au wrote:

> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> writes:
>> ----- On Jul 8, 2018, at 5:03 PM, Mathieu Desnoyers
>> mathieu.desnoyers@efficios.com wrote:
>>
>>> In preparation to use __u64 for the rseq_cs pointer field, 32-bit
>>> architectures need to read this 64-bit value located in user-space
>>> addresses.
>>> 
>>> __get_user is used to read this value, given that its access check has
>>> already been performed with access_ok() on rseq registration.
>>> 
>>> arm does not implement 8-byte __get_user. Rather than trying to
>>> improve __get_user on ARM, use get_user/put_user across rseq instead.
>>> 
>>> If those end up showing up in benchmarks, the proper approach would be to
>>> use user_access_begin() / unsafe_get/put_user() / user_access_end()
>>> anyway.
>>
>> So, another twist to this story: ppc32 does not implement u64 get_user().
> 
> Or __get_user() for that matter.
> 
> But we should just fix it.
> 
> We have the asm to do it, it's just the fact that __gu_val is unsigned
> long causes the size > sizeof(x) check here to fail:
> 
> #define __get_user_size(x, ptr, size, retval)			\
> do {								\
>	retval = 0;						\
>	__chk_user_ptr(ptr);					\
>	if (size > sizeof(x))					\
>		(x) = __get_user_bad();				\
> 
> 
> 
> We seem to be able to fix that with the __inttype() trick that x86 uses.
> 
> That's probably not 4.18 material though. But if you want to go with
> copy_from_user() for now you could then switch to get_user() for 4.19.

I agree. Let's use copy_from_user() for 4.18. Once get_user() ends up supporting
u64 on ppc32 for 4.19, rseq will happily move back to it.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

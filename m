From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH for 4.18 2/6] rseq: use get_user/put_user rather than __get_user/__put_user
Date: Tue, 10 Jul 2018 16:16:28 +1000
Message-ID: <87tvp7mx8j.fsf@concordia.ellerman.id.au>
References: <20180708210330.27324-1-mathieu.desnoyers@efficios.com> <20180708210330.27324-3-mathieu.desnoyers@efficios.com> <854203778.2272.1531157327328.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <854203778.2272.1531157327328.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael
List-Id: linux-api@vger.kernel.org

Mathieu Desnoyers <mathieu.desnoyers@efficios.com> writes:
> ----- On Jul 8, 2018, at 5:03 PM, Mathieu Desnoyers mathieu.desnoyers@efficios.com wrote:
>
>> In preparation to use __u64 for the rseq_cs pointer field, 32-bit
>> architectures need to read this 64-bit value located in user-space
>> addresses.
>> 
>> __get_user is used to read this value, given that its access check has
>> already been performed with access_ok() on rseq registration.
>> 
>> arm does not implement 8-byte __get_user. Rather than trying to
>> improve __get_user on ARM, use get_user/put_user across rseq instead.
>> 
>> If those end up showing up in benchmarks, the proper approach would be to
>> use user_access_begin() / unsafe_get/put_user() / user_access_end()
>> anyway.
>
> So, another twist to this story: ppc32 does not implement u64 get_user().

Or __get_user() for that matter.

But we should just fix it.

We have the asm to do it, it's just the fact that __gu_val is unsigned
long causes the size > sizeof(x) check here to fail:

#define __get_user_size(x, ptr, size, retval)			\
do {								\
	retval = 0;						\
	__chk_user_ptr(ptr);					\
	if (size > sizeof(x))					\
		(x) = __get_user_bad();				\



We seem to be able to fix that with the __inttype() trick that x86 uses.

That's probably not 4.18 material though. But if you want to go with
copy_from_user() for now you could then switch to get_user() for 4.19.

cheers

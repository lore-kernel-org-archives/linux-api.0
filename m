From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [RFC PATCH for 4.15 14/14] Restartable sequences: Provide self-tests
Date: Mon, 16 Oct 2017 22:48:11 +1100
Message-ID: <87a80rl3es.fsf@concordia.ellerman.id.au>
References: <20171012230326.19984-1-mathieu.desnoyers@efficios.com> <20171012230326.19984-15-mathieu.desnoyers@efficios.com> <87y3oblru6.fsf@concordia.ellerman.id.au> <20171016034607.xqebgopn45j3fvf2@tardis>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171016034607.xqebgopn45j3fvf2@tardis>
Sender: linux-kernel-owner@vger.kernel.org
To: Boqun Feng <boqun.feng@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Josh Triplett <josh@joshtriplett.org>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Linus Torvalds <torvalds@linux-foundation.org>Andrew Morton <a>
List-Id: linux-api@vger.kernel.org

Boqun Feng <boqun.feng@gmail.com> writes:
> On Mon, Oct 16, 2017 at 02:00:33PM +1100, Michael Ellerman wrote:
>
>> I'm having trouble testing these, I get:
...
>> 
>>   ~/linus/tools/testing/selftests/rseq$ ./basic_percpu_ops_test
>>   ./basic_percpu_ops_test: error while loading shared libraries: R_PPC64_ADDR16_HI re10d8f10a0 for symbol `' out of range
>>   ~/linus/tools/testing/selftests/rseq$ ./param_test
>>   ./param_test: error while loading shared libraries: R_PPC64_ADDR16_HI re136251b48 for symbol `' out of range
>> 
>
> I think this one is due to the same reason as:
>
> 	7998eb3dc700 ("powerpc: Fix 64 bit builds with binutils 2.24")
>
> I have made the fix before, but seems forgot to send it to Mathieu...
>
> so would this help?
> 	
> diff --git a/tools/testing/selftests/rseq/rseq-ppc.h b/tools/testing/selftests/rseq/rseq-ppc.h
> index bc78b4fd72b1..39cbabe89b0e 100644
> --- a/tools/testing/selftests/rseq/rseq-ppc.h
> +++ b/tools/testing/selftests/rseq/rseq-ppc.h
> @@ -74,7 +74,7 @@ do {									\
>  		"lis %%r17, (3b)@highest\n\t" \
>  		"ori %%r17, %%r17, (3b)@higher\n\t" \
>  		"rldicr %%r17, %%r17, 32, 31\n\t" \
> -		"oris %%r17, %%r17, (3b)@h\n\t" \
> +		"oris %%r17, %%r17, (3b)@high\n\t" \
>  		"ori %%r17, %%r17, (3b)@l\n\t" \
>  		"std %%r17, 0(%[rseq_cs])\n\t" \
>  		RSEQ_INJECT_ASM(2) \

Yes, that fixes it thanks!

cheers

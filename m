From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH for 4.15 v3 15/22] rseq: selftests: Provide
 self-tests
Date: Tue, 21 Nov 2017 21:22:20 +0000 (UTC)
Message-ID: <911090321.19621.1511299340968.JavaMail.zimbra@efficios.com>
References: <20171121141900.18471-1-mathieu.desnoyers@efficios.com> <20171121141900.18471-16-mathieu.desnoyers@efficios.com> <e5c0030c-f361-2d6b-5b92-15456a232436@kernel.org> <1823512285.19395.1511283912405.JavaMail.zimbra@efficios.com> <5b5679fc-a807-8d14-85d0-41a1dd34214e@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5b5679fc-a807-8d14-85d0-41a1dd34214e@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: shuah <shuah@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <cata>
List-Id: linux-api@vger.kernel.org

----- On Nov 21, 2017, at 12:40 PM, shuah shuah@kernel.org wrote:

> On 11/21/2017 10:05 AM, Mathieu Desnoyers wrote:
>> ----- On Nov 21, 2017, at 10:34 AM, shuah shuah@kernel.org wrote:
>> 
>> [...]
>>>> ---
>>>>  MAINTAINERS                                        |    1 +
>>>>  tools/testing/selftests/Makefile                   |    1 +
>>>>  tools/testing/selftests/rseq/.gitignore            |    4 +
>>>
>>> Thanks for the .gitignore files. It is commonly missed change, I end
>>> up adding one to clean things up after tests get in.
>> 
>> I'm used to receive patches where contributors forget to add new files
>> to gitignore within my own projects, which may contribute to my awareness
>> of this pain point. :)
>> 
>> [...]
>> 
>>>> +
>>>> +void *test_percpu_inc_thread(void *arg)
>>>> +{
>>>> +	struct inc_thread_test_data *thread_data = arg;
>>>> +	struct inc_test_data *data = thread_data->data;
>>>> +	long long i, reps;
>>>> +
>>>> +	if (!opt_disable_rseq && thread_data->reg
>>>> +			&& rseq_register_current_thread())
>>>> +		abort();
>>>> +	reps = thread_data->reps;
>>>> +	for (i = 0; i < reps; i++) {
>>>> +		int cpu, ret;
>>>> +
>>>> +#ifndef SKIP_FASTPATH
>>>> +		/* Try fast path. */
>>>> +		cpu = rseq_cpu_start();
>>>> +		ret = rseq_addv(&data->c[cpu].count, 1, cpu);
>>>> +		if (likely(!ret))
>>>> +			goto next;
>>>> +#endif
>>>
>>> So the test needs to compiled with this enabled? I think it would be better
>>> to make this an argument to be abel to select at test start time as opposed
>>> to making this compile time option. Remember that these tests get run in
>>> automated test rings. Making this a compile time otpion pertty much ensures
>>> that this path will not be tested.
>>>
>>> So I would reccommend adding a paratemer.
>>>
>>>> +	slowpath:
>>>> +		__attribute__((unused));
>>>> +		for (;;) {
>>>> +			/* Fallback on cpu_opv system call. */
>>>> +			cpu = rseq_current_cpu();
>>>> +			ret = cpu_op_addv(&data->c[cpu].count, 1, cpu);
>>>> +			if (likely(!ret))
>>>> +				break;
>>>> +			assert(ret >= 0 || errno == EAGAIN);
>>>> +		}
>>>> +	next:
>>>> +		__attribute__((unused));
>>>> +#ifndef BENCHMARK
>>>> +		if (i != 0 && !(i % (reps / 10)))
>>>> +			printf_verbose("tid %d: count %lld\n", (int) gettid(), i);
>>>> +#endif
>>>
>>> Same comment as before. Avoid compile time options.
>> 
>> The goal of those compiler define are to generate the altered code without
>> adding branches into the fast-paths.
> 
> That makes sense. You are looking to not add any overhead.
> 
>> 
>> Here is an alternative solution that should take care of your concern: I'll
>> build multiple targets for param_test.c:
>> 
>> param_test
>> param_test_skip_fastpath (built with -DSKIP_FASTPATH)
>> param_test_benchmark (build with -DBENCHMARK)
>> 
>> I'll update run_param_test.sh to run both param_test and
>> param_test_skip_fastpath.
>> 
>> Note that "param_test_benchmark" is only useful for benchmarking,
>> so I don't plan to run it from run_param_test.sh which is meant
>> to track regressions.
>> 
>> Is that approach OK with you ?
>> 
> 
> Yes. This approach addresses my concern about coverage for both paths.

fyi, the updated patches can be found here:

https://git.kernel.org/pub/scm/linux/kernel/git/rseq/linux-rseq.git/commit/?h=rseq/dev&id=a0b8eb0eb5d4d8a280969370aa1dcf51801139c6
  "selftests: lib.mk: Introduce OVERRIDE_TARGETS"

https://git.kernel.org/pub/scm/linux/kernel/git/rseq/linux-rseq.git/commit/?h=rseq/dev&id=4ef0214e19bb7415fe7aed6852859b8d66e09a45
  "cpu_opv: selftests: Implement selftests (v4)"

https://git.kernel.org/pub/scm/linux/kernel/git/rseq/linux-rseq.git/commit/?h=rseq/dev&id=7d7530b843c7ecb50bea5a136c776cf3e9155d43
  "rseq: selftests: Provide self-tests (v4)"

Thanks for the feedback!

Mathieu

> 
> thanks,
> -- Shuah

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

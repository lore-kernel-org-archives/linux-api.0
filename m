From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [RFC PATCH for 4.15 v3 15/22] rseq: selftests: Provide self-tests
Date: Tue, 21 Nov 2017 14:24:30 -0700
Message-ID: <d059d29d-83a7-f16d-dc84-05a4609a3479@osg.samsung.com>
References: <20171121141900.18471-1-mathieu.desnoyers@efficios.com>
 <20171121141900.18471-16-mathieu.desnoyers@efficios.com>
 <e5c0030c-f361-2d6b-5b92-15456a232436@kernel.org>
 <1823512285.19395.1511283912405.JavaMail.zimbra@efficios.com>
 <5b5679fc-a807-8d14-85d0-41a1dd34214e@kernel.org>
 <911090321.19621.1511299340968.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <911090321.19621.1511299340968.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, shuah <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <cata>
List-Id: linux-api@vger.kernel.org

On 11/21/2017 02:22 PM, Mathieu Desnoyers wrote:
> ----- On Nov 21, 2017, at 12:40 PM, shuah shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org wrote:
> 
>> On 11/21/2017 10:05 AM, Mathieu Desnoyers wrote:
>>> ----- On Nov 21, 2017, at 10:34 AM, shuah shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org wrote:
>>>
>>> [...]
>>>>> ---
>>>>>  MAINTAINERS                                        |    1 +
>>>>>  tools/testing/selftests/Makefile                   |    1 +
>>>>>  tools/testing/selftests/rseq/.gitignore            |    4 +
>>>>
>>>> Thanks for the .gitignore files. It is commonly missed change, I end
>>>> up adding one to clean things up after tests get in.
>>>
>>> I'm used to receive patches where contributors forget to add new files
>>> to gitignore within my own projects, which may contribute to my awareness
>>> of this pain point. :)
>>>
>>> [...]
>>>
>>>>> +
>>>>> +void *test_percpu_inc_thread(void *arg)
>>>>> +{
>>>>> +	struct inc_thread_test_data *thread_data = arg;
>>>>> +	struct inc_test_data *data = thread_data->data;
>>>>> +	long long i, reps;
>>>>> +
>>>>> +	if (!opt_disable_rseq && thread_data->reg
>>>>> +			&& rseq_register_current_thread())
>>>>> +		abort();
>>>>> +	reps = thread_data->reps;
>>>>> +	for (i = 0; i < reps; i++) {
>>>>> +		int cpu, ret;
>>>>> +
>>>>> +#ifndef SKIP_FASTPATH
>>>>> +		/* Try fast path. */
>>>>> +		cpu = rseq_cpu_start();
>>>>> +		ret = rseq_addv(&data->c[cpu].count, 1, cpu);
>>>>> +		if (likely(!ret))
>>>>> +			goto next;
>>>>> +#endif
>>>>
>>>> So the test needs to compiled with this enabled? I think it would be better
>>>> to make this an argument to be abel to select at test start time as opposed
>>>> to making this compile time option. Remember that these tests get run in
>>>> automated test rings. Making this a compile time otpion pertty much ensures
>>>> that this path will not be tested.
>>>>
>>>> So I would reccommend adding a paratemer.
>>>>
>>>>> +	slowpath:
>>>>> +		__attribute__((unused));
>>>>> +		for (;;) {
>>>>> +			/* Fallback on cpu_opv system call. */
>>>>> +			cpu = rseq_current_cpu();
>>>>> +			ret = cpu_op_addv(&data->c[cpu].count, 1, cpu);
>>>>> +			if (likely(!ret))
>>>>> +				break;
>>>>> +			assert(ret >= 0 || errno == EAGAIN);
>>>>> +		}
>>>>> +	next:
>>>>> +		__attribute__((unused));
>>>>> +#ifndef BENCHMARK
>>>>> +		if (i != 0 && !(i % (reps / 10)))
>>>>> +			printf_verbose("tid %d: count %lld\n", (int) gettid(), i);
>>>>> +#endif
>>>>
>>>> Same comment as before. Avoid compile time options.
>>>
>>> The goal of those compiler define are to generate the altered code without
>>> adding branches into the fast-paths.
>>
>> That makes sense. You are looking to not add any overhead.
>>
>>>
>>> Here is an alternative solution that should take care of your concern: I'll
>>> build multiple targets for param_test.c:
>>>
>>> param_test
>>> param_test_skip_fastpath (built with -DSKIP_FASTPATH)
>>> param_test_benchmark (build with -DBENCHMARK)
>>>
>>> I'll update run_param_test.sh to run both param_test and
>>> param_test_skip_fastpath.
>>>
>>> Note that "param_test_benchmark" is only useful for benchmarking,
>>> so I don't plan to run it from run_param_test.sh which is meant
>>> to track regressions.
>>>
>>> Is that approach OK with you ?
>>>
>>
>> Yes. This approach addresses my concern about coverage for both paths.
> 
> fyi, the updated patches can be found here:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/rseq/linux-rseq.git/commit/?h=rseq/dev&id=a0b8eb0eb5d4d8a280969370aa1dcf51801139c6
>   "selftests: lib.mk: Introduce OVERRIDE_TARGETS"
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/rseq/linux-rseq.git/commit/?h=rseq/dev&id=4ef0214e19bb7415fe7aed6852859b8d66e09a45
>   "cpu_opv: selftests: Implement selftests (v4)"
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/rseq/linux-rseq.git/commit/?h=rseq/dev&id=7d7530b843c7ecb50bea5a136c776cf3e9155d43
>   "rseq: selftests: Provide self-tests (v4)"
> 
> Thanks for the feedback!
> 

Are you going to send these to the mailing list? That way I can do a final
review and give my Ack if they look good.

thanks,
-- Shuah

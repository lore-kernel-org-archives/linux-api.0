From: Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v4 0/6] selftests: Add futex functional tests
Date: Wed, 13 May 2015 16:34:54 -0700
Message-ID: <D1792C54.CCE05%dvhart@linux.intel.com>
References: <cover.1431489408.git.dvhart@linux.intel.com>
 <5553DCAE.2010208@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5553DCAE.2010208-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, chrubis-AlSwsSmVLrQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 5/13/15, 4:22 PM, "Shuah Khan" <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org> wrote:

>On 05/12/2015 10:07 PM, Darren Hart wrote:
>> Hi Shuah,
>> 
>> This series begins the process of migrating my futextest tests into
>>kselftest.
>> I've started with only the functional tests, as the performance and
>>stress may
>> not be appropriate for kselftest as they stand.
>> 
>> I cleaned up various complaints from checkpatch, but I ignored others
>>that would
>> require significant rework of the testcases, such as not using volatile
>>and not
>> creating new typedefs.
>> 
>
>Daren,
>
>This patch series is good. kselftest run and install
>are good. I see the following results. Something you
>would expect??

Yes, that is all expected behavior if you don't run as root and your user
doesn't have the necessary capabilities added -  similar to other tests
with privileged operations.

> No Issues and I am going to get them
>into 4.2 - should show up in linux-kselftest next.

Great, thanks. Perhaps some explicit capabilities tests and clearer error
messages would make sense as a follow-on patch.

Thanks for working with me to get these into the kernel, I think it will
improve futex test exposure and hopefully encourage people to write more
tests to fill some of the gaps.

--
Darren

>
>Thanks for adding these.
>
>thanks,
>-- Shuah
>
>futex_requeue_pi: Test requeue functionality
>	Arguments: broadcast=0 locked=0 owner=0 timeout=0ns
>	ERROR: Operation not permitted: pthread_create
>	ERROR: Creating waiting thread failed
>Result: ERROR
>futex_requeue_pi: Test requeue functionality
>	Arguments: broadcast=1 locked=0 owner=0 timeout=0ns
>	ERROR: Operation not permitted: pthread_create
>	ERROR: Creating waiting thread failed
>Result: ERROR
>futex_requeue_pi: Test requeue functionality
>	Arguments: broadcast=1 locked=1 owner=0 timeout=0ns
>	ERROR: Operation not permitted: pthread_create
>	ERROR: Creating waiting thread failed
>Result: ERROR
>futex_requeue_pi: Test requeue functionality
>	Arguments: broadcast=1 locked=0 owner=1 timeout=0ns
>	ERROR: Operation not permitted: pthread_create
>	ERROR: Creating third party blocker thread failed
>Result: ERROR
>futex_requeue_pi: Test requeue functionality
>	Arguments: broadcast=0 locked=1 owner=0 timeout=0ns
>	ERROR: Operation not permitted: pthread_create
>	ERROR: Creating waiting thread failed
>Result: ERROR
>futex_requeue_pi: Test requeue functionality
>	Arguments: broadcast=0 locked=0 owner=1 timeout=0ns
>	ERROR: Operation not permitted: pthread_create
>	ERROR: Creating third party blocker thread failed
>Result: ERROR
>futex_requeue_pi: Test requeue functionality
>	Arguments: broadcast=1 locked=1 owner=0 timeout=5000ns
>	ERROR: Operation not permitted: pthread_create
>	ERROR: Creating waiting thread failed
>Result: ERROR
>futex_requeue_pi: Test requeue functionality
>	Arguments: broadcast=0 locked=1 owner=0 timeout=5000ns
>	ERROR: Operation not permitted: pthread_create
>	ERROR: Creating waiting thread failed
>Result: ERROR
>futex_requeue_pi: Test requeue functionality
>	Arguments: broadcast=1 locked=1 owner=0 timeout=500000ns
>	ERROR: Operation not permitted: pthread_create
>	ERROR: Creating waiting thread failed
>Result: ERROR
>futex_requeue_pi: Test requeue functionality
>	Arguments: broadcast=0 locked=1 owner=0 timeout=500000ns
>	ERROR: Operation not permitted: pthread_create
>	ERROR: Creating waiting thread failed
>Result: ERROR
>futex_requeue_pi: Test requeue functionality
>	Arguments: broadcast=1 locked=0 owner=0 timeout=5000ns
>	ERROR: Operation not permitted: pthread_create
>	ERROR: Creating waiting thread failed
>Result: ERROR
>futex_requeue_pi: Test requeue functionality
>	Arguments: broadcast=0 locked=0 owner=0 timeout=5000ns
>	ERROR: Operation not permitted: pthread_create
>	ERROR: Creating waiting thread failed
>Result: ERROR
>futex_requeue_pi: Test requeue functionality
>	Arguments: broadcast=1 locked=0 owner=0 timeout=500000ns
>	ERROR: Operation not permitted: pthread_create
>	ERROR: Creating waiting thread failed
>Result: ERROR
>futex_requeue_pi: Test requeue functionality
>	Arguments: broadcast=0 locked=0 owner=0 timeout=500000ns
>	ERROR: Operation not permitted: pthread_create
>	ERROR: Creating waiting thread failed
>Result: ERROR
>futex_requeue_pi: Test requeue functionality
>	Arguments: broadcast=1 locked=0 owner=1 timeout=5000ns
>	ERROR: Operation not permitted: pthread_create
>	ERROR: Creating third party blocker thread failed
>Result: ERROR
>futex_requeue_pi: Test requeue functionality
>	Arguments: broadcast=0 locked=1 owner=0 timeout=5000ns
>	ERROR: Operation not permitted: pthread_create
>	ERROR: Creating waiting thread failed
>Result: ERROR
>futex_requeue_pi: Test requeue functionality
>	Arguments: broadcast=1 locked=0 owner=1 timeout=500000ns
>	ERROR: Operation not permitted: pthread_create
>	ERROR: Creating third party blocker thread failed
>Result: ERROR
>futex_requeue_pi: Test requeue functionality
>	Arguments: broadcast=0 locked=1 owner=0 timeout=500000ns
>	ERROR: Operation not permitted: pthread_create
>	ERROR: Creating waiting thread failed
>Result: ERROR
>futex_requeue_pi: Test requeue functionality
>	Arguments: broadcast=1 locked=1 owner=0 timeout=2000000000ns
>	ERROR: Operation not permitted: pthread_create
>	ERROR: Creating waiting thread failed
>Result: ERROR
>futex_requeue_pi: Test requeue functionality
>	Arguments: broadcast=0 locked=1 owner=0 timeout=2000000000ns
>	ERROR: Operation not permitted: pthread_create
>	ERROR: Creating waiting thread failed
>Result: ERROR
>
>futex_requeue_pi_mismatched_ops: Detect mismatched requeue_pi operations
>Result:  PASS
>
>futex_requeue_pi_signal_restart: Test signal handling during requeue_pi
>	Arguments: <none>
>	ERROR: Operation not permitted: pthread_create
>	ERROR: Unknown error -1: Creating waiting thread failedResult: ERROR
>
>futex_wait_timeout: Block on a futex and wait for timeout
>	Arguments: timeout=100000ns
>Result:  PASS
>
>futex_wait_wouldblock: Test the unexpected futex value in FUTEX_WAIT
>Result:  PASS
>
>futex_wait_uninitialized_heap: Test the uninitialized futex value in
>FUTEX_WAIT
>Result:  PASS
>futex_wait_private_mapped_file: Test the futex value of private file
>mappings in FUTEX_WAIT
>Result:  PASS
>
>
>-- 
>Shuah Khan
>Sr. Linux Kernel Developer
>Open Source Innovation Group
>Samsung Research America (Silicon Valley)
>shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
>


-- 
Darren Hart
Intel Open Source Technology Center

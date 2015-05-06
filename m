From: Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 1/5] selftests: Add futex functional tests
Date: Wed, 06 May 2015 11:04:20 -0700
Message-ID: <D16FA594.CAFCF%dvhart@linux.intel.com>
References: <cover.1427493640.git.dvhart@linux.intel.com>
 <597c9eabcac5da9456d6cfd6de9117591d73385e.1427493640.git.dvhart@linux.intel.com>
 <554A4F3A.7020504@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <554A4F3A.7020504-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 5/6/15, 10:28 AM, "Shuah Khan" <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org> wrote:

>On 03/27/2015 04:17 PM, Darren Hart wrote:
>> The futextest testsuite [1] provides functional, stress, and
>> performance tests for the various futex op codes. Those tests will be of
>> more use to futex developers if they are included with the kernel
>> source.
>> 
>> Copy the core infrastructure and the functional tests into selftests.
>> Remove reference to the performance and stress tests from the
>> contributed sources.
>> 
>> Remove the Free Software Foundation address paragraph from all
>> contributed files to avoid checkpatch complaints.
>> 
>> A future effort will explore moving the performance and stress tests
>> into the kernel.
>> 
>> 1. http://git.kernel.org/cgit/linux/kernel/git/dvhart/futextest.git
>> 
>> Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
>> Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Cc: Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>
>> Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
>> Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
>> Cc: Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>
>> Cc: KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
>> Signed-off-by: Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
>
>Sorry it took so long. I am just about to apply these to linux-kselftest
>next and ran into checkpatch errors on this patch.

*GASP* How humiliating.... Of course. Something by late tonight.

-- 
Darren Hart
Intel Open Source Technology Center

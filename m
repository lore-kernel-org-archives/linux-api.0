From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH v4 0/6] selftests: Add futex functional tests
Date: Wed, 13 May 2015 18:40:32 -0600
Message-ID: <5553EF00.8080406@osg.samsung.com>
References: <cover.1431489408.git.dvhart@linux.intel.com> <5553DCAE.2010208@osg.samsung.com> <D1792C54.CCE05%dvhart@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <D1792C54.CCE05%dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, chrubis-AlSwsSmVLrQ@public.gmane.org, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 05/13/2015 05:34 PM, Darren Hart wrote:
> On 5/13/15, 4:22 PM, "Shuah Khan" <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org> wrote:
> 
>> On 05/12/2015 10:07 PM, Darren Hart wrote:
>>> Hi Shuah,
>>>
>>> This series begins the process of migrating my futextest tests into
>>> kselftest.
>>> I've started with only the functional tests, as the performance and
>>> stress may
>>> not be appropriate for kselftest as they stand.
>>>
>>> I cleaned up various complaints from checkpatch, but I ignored others
>>> that would
>>> require significant rework of the testcases, such as not using volatile
>>> and not
>>> creating new typedefs.
>>>
>>
>> Daren,
>>
>> This patch series is good. kselftest run and install
>> are good. I see the following results. Something you
>> would expect??
> 
> Yes, that is all expected behavior if you don't run as root and your user
> doesn't have the necessary capabilities added -  similar to other tests
> with privileged operations.
> 
>> No Issues and I am going to get them
>> into 4.2 - should show up in linux-kselftest next.
> 
> Great, thanks. Perhaps some explicit capabilities tests and clearer error
> messages would make sense as a follow-on patch.
> 
> Thanks for working with me to get these into the kernel, I think it will
> improve futex test exposure and hopefully encourage people to write more
> tests to fill some of the gaps.
> 

Applied to linux-kselftest next for 4.2

thanks,
-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978

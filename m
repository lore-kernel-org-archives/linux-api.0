From: Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [GIT PULL] selftest: Add futex functional tests
Date: Wed, 08 Apr 2015 22:44:11 -0700
Message-ID: <D14B5F7D.C64EC%dvhart@linux.intel.com>
References: <cover.1427493640.git.dvhart@linux.intel.com>
 <551ABE00.9050003@osg.samsung.com>
 <D14017F7.C46F0%dvhart@linux.intel.com>
 <551ACD5F.8010003@osg.samsung.com>
 <20150408041257.GC14618@fury.dvhart.com>
 <55261120.7040902@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55261120.7040902-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Darren Hart <dvhart-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 4/8/15, 10:41 PM, "Shuah Khan" <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org> wrote:

>On 04/07/2015 10:12 PM, Darren Hart wrote:
>> On Tue, Mar 31, 2015 at 10:37:51AM -0600, Shuah Khan wrote:
>>> On 03/31/2015 10:24 AM, Darren Hart wrote:
>>>> On 3/31/15, 8:32 AM, "Shuah Khan" <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org> wrote:
>>>>
>>>>> Hi Daren,
>>>>>
>>>>> On 03/27/2015 04:17 PM, Darren Hart wrote:
>>>>>> Hi Shuah,
>>>>>>
>>>>>> This series begins the process of migrating my futextest tests into
>>>>>> kselftest.
>>>>>> I've started with only the functional tests, as the performance and
>>>>>> stress may
>>>>>> not be appropriate for kselftest as they stand.
>>>>>>
>>>>>> I cleaned up various complaints from checkpatch, but I ignored
>>>>>>others
>>>>>> that would
>>>>>> require significant rework of the testcases, such as not using
>>>>>>volatile
>>>>>> and not
>>>>>> creating new typedefs.
>>>>>>
>>>>>> The patches will follow, but I'm providing a pull request for your
>>>>>> convenience
>>>>>> as well.
>>>>>
>>>>> Thanks for acting on this so quickly after we talked about it at ELC.
>>>>> Just a quick note that I am going to get to this soon once I get the
>>>>> 4.1 content wrapped up. We can plan upon getting these into 4.2.
>>>>
>>>> OK. Michael E. provided some feedback which I can either incorporate
>>>>and
>>>> respin, or I can send as a follow-on to your -next after you merge
>>>>these.
>>>> Which do you prefer?
>>>>
>> 
>> ...
>> 
>>> You can wait to re-do patches. I am planning to review the
>>> patch set later on this week. That way you can avoid re-spin
>>> just in case, I have other comments.
>> 
>> Hi Shuah,
>> 
>> Did you have any additional comments for the futex tests?
>> 
>> Thanks,
>> 
>
>
>Sorry Daren. I got called away on a family emergency. The patch
>looks good to me and I don't have any additional comments.

No problem, hope things are alright.

>
>Assume these get pulled in for 4.2 release. I will get to them
>soon once the 4.1-rc1 is out.

You had some initial comments, do you want me to tend to those and resend,
or will you pull as is and have me follow-up - either is fine, just let me
know what you prefer.

Thanks,


-- 
Darren Hart
Intel Open Source Technology Center

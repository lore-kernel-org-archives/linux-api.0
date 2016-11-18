From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH RFC 0/6] enable O and KBUILD_OUTPUT for kselftest
Date: Thu, 17 Nov 2016 17:18:23 -0700
Message-ID: <aa31a8db-a75f-8a56-8677-23166fb6988d@osg.samsung.com>
References: <1477047694-24122-1-git-send-email-bamvor.zhangjian@huawei.com>
 <56f64f51-f1f6-80a3-1aa2-11801e798555@osg.samsung.com>
 <8760nliqxj.fsf@concordia.ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8760nliqxj.fsf-W0DJWXSxmBNbyGPkN3NxC2scP1bn1w/D@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, bamvor.zhangjian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, khilman-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 11/17/2016 05:15 PM, Michael Ellerman wrote:
> Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org> writes:
> 
>> On 10/21/2016 05:01 AM, bamvor.zhangjian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org wrote:
>>> From: Bamvor Jian Zhang <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>>>
>>> Here is my first version for enabling the KBUILD_OUTPUT for kselftest.
>>> I fix and test all the TARGET in tools/testing/selftest/Makefile. For
>>> ppc, I test through fake target.
> ...
>>>
>>> The last patch introduces the KBUILD_OUTPUT and O for kselftest instead
>>> using the existing kbuild system because user may compile kselftest
>>> directly (make -C tools/testing/selftests).
>>
>> I am planning to get this into 4.10.
>>
>> Michael!
>>
>> Are okay with me taking powerpc tests through kselftest tree?
>> If so could you please give me Ack.
> 
> I already have quite a lot of selftests queued for 4.10, so this will
> conflict badly with those I suspect.

Let me know how bad it is, maybe we can wait on these until 4.11
> 
> If you put this series in a topic branch that we can both merge then
> that will probably be OK.

Once you are done with reviews, we can make a call on whether to merge
them now or later.

> 
> I'd like to review the series first too, will try and get that done
> today.
> 
> cheers
> 

Okay sounds good.

thanks,
-- Shuah

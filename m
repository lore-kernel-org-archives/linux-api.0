From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH v2 0/6] enable O and KBUILD_OUTPUT for kselftest
Date: Thu, 1 Dec 2016 12:35:01 -0700
Message-ID: <f9774902-a709-d077-3bab-00ad2da430b3@osg.samsung.com>
References: <20161129115552.8148-1-bamvor.zhangjian@huawei.com>
 <01b97008-3311-7b5b-4424-76bd3d560b40@osg.samsung.com>
 <CAFy1USRENze0J3MZUddvyTdChNBzRUAQBx2pPEfbFFiitxwtsw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFy1USRENze0J3MZUddvyTdChNBzRUAQBx2pPEfbFFiitxwtsw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bamvor Zhang Jian <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "Zhang Jian(Bamvor)" <bamvor.zhangjian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kevin Hilman <khilman-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 11/30/2016 08:32 AM, Bamvor Zhang Jian wrote:
> Hi, Shuah, Michael
> 
> On 30 November 2016 at 22:17, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org> wrote:
>> On 11/29/2016 04:55 AM, bamvor.zhangjian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org wrote:
>>> From: Bamvor Jian Zhang <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>>>
>>> Here is my second version for enabling the KBUILD_OUTPUT for kselftest.
>>> The first version could be found here[1]. I fix and test all the TARGET
>>> in tools/testing/selftest/Makefile. For ppc, I test through fake target.
>>>
>>> There are six patches in these series. And five of them clean up the
>>> existing code. I split the clean up patches into five, hope it is easy
>>> to review.
>>>
>>>   selftests: remove duplicated all and clean target
>>>   selftests: remove useless TEST_DIRS
>>> a selftests: add pattern rules
>>> A selftests: remove CROSS_COMPILE in dedicated Makefile
>>> A selftests: add EXTRA_CLEAN for clean target
>>>   selftests: enable O and KBUILD_OUTPUT
>>>
>>> Notes:
>>>   A: Ack by Michael.
>>>   a: ack by Michael. Minor update after rebase.
>>
>> Bamovar/Michael,
>>
>> Are these rebased to linux-next? Michael was concerned about
>> conflicts with powerpc tree. Would rebasing to linux-next help
>> avoiding conflicts?
> Yes. I rebase to latest linux-next. It is taged as 1128 when I rebase
> them yesterday. I fix some conflict when rebase.
> 

Hi Bemovar,

These patches don't apply to linux-kselftest next and I can't apply
them now. Looks like there are new tests that came through a netdev
tree already in linux-next. It does happen when a new feature goes
into a tree with the test.

So for now we will have to wait on these and when 4.10-rc1 comes out,
please rebase it on linux-kselftest latest. I will try to get these
into 4.10-rc1 fixes

thanks,
-- Shuah

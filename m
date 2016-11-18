From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH RFC 0/6] enable O and KBUILD_OUTPUT for kselftest
Date: Fri, 18 Nov 2016 11:15:36 +1100
Message-ID: <8760nliqxj.fsf@concordia.ellerman.id.au>
References: <1477047694-24122-1-git-send-email-bamvor.zhangjian@huawei.com> <56f64f51-f1f6-80a3-1aa2-11801e798555@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <56f64f51-f1f6-80a3-1aa2-11801e798555@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shuah Khan <shuahkh@osg.samsung.com>, bamvor.zhangjian@huawei.comShuah Khan <shuahkh@osg.samsung.com>, Shuah Khan <shuah@kernel.org>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, khilman@linaro.org, broonie@kernel.org
List-Id: linux-api@vger.kernel.org

Shuah Khan <shuahkh@osg.samsung.com> writes:

> On 10/21/2016 05:01 AM, bamvor.zhangjian@huawei.com wrote:
>> From: Bamvor Jian Zhang <bamvor.zhangjian@linaro.org>
>> 
>> Here is my first version for enabling the KBUILD_OUTPUT for kselftest.
>> I fix and test all the TARGET in tools/testing/selftest/Makefile. For
>> ppc, I test through fake target.
...
>> 
>> The last patch introduces the KBUILD_OUTPUT and O for kselftest instead
>> using the existing kbuild system because user may compile kselftest
>> directly (make -C tools/testing/selftests).
>
> I am planning to get this into 4.10.
>
> Michael!
>
> Are okay with me taking powerpc tests through kselftest tree?
> If so could you please give me Ack.

I already have quite a lot of selftests queued for 4.10, so this will
conflict badly with those I suspect.

If you put this series in a topic branch that we can both merge then
that will probably be OK.

I'd like to review the series first too, will try and get that done
today.

cheers

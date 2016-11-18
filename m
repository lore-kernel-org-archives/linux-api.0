From: "Zhangjian (Bamvor)" <bamvor.zhangjian@huawei.com>
Subject: Re: [PATCH RFC 5/6] selftests: add EXTRA_CLEAN for clean target
Date: Fri, 18 Nov 2016 20:51:19 +0800
Message-ID: <55a4ff39-ef90-6a56-d5e5-67d018b530e9@huawei.com>
References: <1477047694-24122-1-git-send-email-bamvor.zhangjian@huawei.com>
 <1477047694-24122-6-git-send-email-bamvor.zhangjian@huawei.com>
 <87bmxdgihb.fsf@concordia.ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87bmxdgihb.fsf@concordia.ellerman.id.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Ellerman <mpe@ellerman.id.au>, shuahkh@osg.samsung.com
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, khilman@linaro.org, broonie@kernel.org, Bamvor Zhang Jian <bamvor.zhangjian@linaro.org>
List-Id: linux-api@vger.kernel.org

Hi, Micheal

On 2016/11/18 19:01, Michael Ellerman wrote:
> bamvor.zhangjian@huawei.com writes:
>
>> From: Bamvor Jian Zhang <bamvor.zhangjian@linaro.org>
>>
>> Some testcases need the clean extra data after running. This patch
>> introduce the "EXTRA_CLEAN" variable to address this requirement.
>
> The idea here is fine I think. But this will need reworking if you
> follow my suggestions for patch 1.
>
>> After KOUTPUT_BUILD is enabled in later patch, it will be easy to
>> decide to if we need do the cleanup in the KOUTPUT_BUILD path, if the
>> testcase ran immediately after compiled.
>>
>> Signed-off-by: Bamvor Jian Zhang <bamvor.zhangjian@linaro.org>
>
> All of these:
>
>>  tools/testing/selftests/powerpc/benchmarks/Makefile   |  5 ++---
>>  tools/testing/selftests/powerpc/copyloops/Makefile    |  3 +--
>>  tools/testing/selftests/powerpc/dscr/Makefile         |  4 ++--
>>  tools/testing/selftests/powerpc/math/Makefile         |  5 ++---
>>  tools/testing/selftests/powerpc/primitives/Makefile   |  5 ++---
>>  tools/testing/selftests/powerpc/stringloops/Makefile  |  5 ++---
>>  tools/testing/selftests/powerpc/syscalls/Makefile     |  5 ++---
>>  tools/testing/selftests/powerpc/tm/Makefile           |  5 ++---
>
> are just cleaning *.o, and I'm pretty sure none of them need to. So for
> those you can just drop the custom clean rule.
Sorry I do not check these. Because I define the fake target for
testing for ppc. Then I could remove *.o directly in above files.

Regards

Bamvor
>
> This one does need a custom rule:
>
>>  .../testing/selftests/powerpc/switch_endian/Makefile  |  5 ++---
>
>
> cheers
>
